//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCard.h"

@interface CardGameViewController()
-(void)updateUI;
- (IBAction) flipCard:(UIButton *)sender;
- (IBAction) dealCards;
@end

@interface PlayingCardMatchingGameViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelector;
@property (nonatomic) NSUInteger matchingNCards;
//@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation PlayingCardMatchingGameViewController
/*
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
*/
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
    
}

- (IBAction) flipCard:(UIButton *)sender
{
    [super flipCard:sender];
    self.gameSelector.enabled = NO;
}

- (NSUInteger) startingCardCount
{
    return 20;
}

- (Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]){
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
            
            
            if (animate){
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    playingCardView.faceUp = playingCard.isFaceUp;
                                }
                                completion:NULL];
            } else {
                playingCardView.faceUp = playingCard.isFaceUp;
            }
        }
    }
}

@end
