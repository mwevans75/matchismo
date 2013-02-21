//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Matthew Evans on 1/29/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardMatchingGameMove.h"
#import "GameResult.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISlider *flipResultHistory;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self dealCards];
}

- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (IBAction)dealCards {
    NSLog(@"Starting New Game");
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    self.flipResult.text = @"";
    [self updateUI];
}

-(GameResult *)gameResult
{
    if(!_gameResult) _gameResult = [[GameResult alloc] initWithGameName:self.tabBarItem.title];
    return _gameResult;
}

- (IBAction)getFlipResultHistory:(UISlider *)sender {
    int intValue = roundl([sender value]); // Rounds float to an integer
    static float oldIntValue = 0.0f;
    if (intValue != oldIntValue)
    {
        [self updateUI];
        oldIntValue = intValue;
    }
    
    [sender setValue:(float)intValue];
}
 
- (void) updateUI
{    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipResultHistory.maximumValue = [self.game.moveHistory count]-1;
    if (self.flipResultHistory.value == self.flipResultHistory.maximumValue || self.flipResultHistory.maximumValue == 0.0f)
    {
        [self updateResultOfLastFlipLabel:[self.game.moveHistory lastObject]];
        self.flipResult.alpha = 1.0;
    }
    else
    {
        if ([self.game.moveHistory count])
        {
            int intValue = roundl(self.flipResultHistory.value);
            
            [self updateResultOfLastFlipLabel:self.game.moveHistory[intValue]];
            self.flipResult.alpha = 0.3;
        }
    }
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction) flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipResultHistory.maximumValue = [self.game.moveHistory count]-1;
    self.flipResultHistory.value = self.flipResultHistory.maximumValue;
    self.flipCount++;
    self.gameResult.score = self.game.score;
    [self updateUI];
}

// This is the default thing to do for card matching games - just use a NSString here
// but Set Game will override it and set a NSAttributed string
- (void)updateResultOfLastFlipLabel:(CardMatchingGameMove *)move
{
    self.flipResult.text  = [move descriptionOfMove];
}

@end
