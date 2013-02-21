//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController()
-(void)updateUI;
- (IBAction) flipCard:(UIButton *)sender;
- (IBAction) dealCards;
@end

@interface PlayingCardMatchingGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelector;
@property (nonatomic) NSUInteger matchingNCards;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation PlayingCardMatchingGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        [self translateGameType];
        NSLog(@" ");
        NSLog(@"Initializing Playing Card Matching Game.");
        NSLog(@"Cards: %d", self.cardButtons.count);
        NSLog(@"Cards to Match: %d", self.matchingNCards);
        NSLog(@"-------------------------------------------");
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                             matchingNCards:self.matchingNCards
                                              usingFlipCost:1
                                       usingMismatchPenalty:2
                                            usingMatchBonus:4];
    }
    
    return _game;
}

- (IBAction)dealCards
{
    [super dealCards];
    self.gameSelector.enabled = YES;

}

- (IBAction)changeGameType:(id)sender
{
    [self translateGameType];
    [self dealCards];
}

- (void) translateGameType
{
    if (self.gameSelector.selectedSegmentIndex == 0){
        self.matchingNCards = 2;
    } else if (self.gameSelector.selectedSegmentIndex == 1){
        self.matchingNCards = 3;
    } else {
        self.matchingNCards = 2;
    }
}

- (void) updateUI
{
    [super updateUI];
    
    for (UIButton *cardButton in self.cardButtons){
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        if (!cardButton.isSelected){
            [cardButton setImage:[UIImage imageNamed:@"cardback.jpg"] forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
}

- (IBAction) flipCard:(UIButton *)sender
{
    [super flipCard:sender];
    self.gameSelector.enabled = NO;
}

@end
