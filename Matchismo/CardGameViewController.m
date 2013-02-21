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

@interface CardGameViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISlider *flipResultHistory;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self dealCards];
}

- (IBAction)dealCards {
    NSLog(@"Starting New Game");
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    self.flipResult.text = @"";
    [self updateUI];
}

- (CardMatchingGame *)game
{
    
    if (!_game) {
        NSLog(@" ");
        NSLog(@"Initializing Generic Matching Game.");
        NSLog(@"Cards: %d", self.startingCardCount);
        NSLog(@"-------------------------------------------");
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self createDeck]];
    }
    
    return _game;
}

- (Deck *) createDeck {return nil;} // abstract

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
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]){
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES]; // NEED TO FIX THE ANIMATION HERE
    }
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
- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath){
        [self.game flipCardAtIndex:indexPath.item];
        self.flipResultHistory.maximumValue = [self.game.moveHistory count]-1;
        self.flipResultHistory.value = self.flipResultHistory.maximumValue;
        self.flipCount++;
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
}

// This is the default thing to do for card matching games - just use a NSString here
// but Set Game will override it and set a NSAttributed string
- (void)updateResultOfLastFlipLabel:(CardMatchingGameMove *)move
{
    self.flipResult.text  = [move descriptionOfMove];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount; // NEED TO CHANGE THIS!!!!
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard"
                                                                           forIndexPath:indexPath];
    
    Card *card = [self.game cardAtIndex:indexPath.item];
    
    [self updateCell:cell usingCard:card animate:NO];
    
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL) animate
{
    // abstract
}
@end
