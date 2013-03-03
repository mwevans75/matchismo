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

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (weak, nonatomic) IBOutlet UISlider *flipResultHistory;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameSelector;
@property (weak, nonatomic) IBOutlet UILabel *cardsLeftLabel;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController


/********************
 *
 * Abstract Methods
 *
 *******************/
- (Deck *) createDeck
{
    return nil;
} // abstract

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL) animate
{
} // abstract

- (NSString *)obtainCardCollectionViewReuseIdentifier
{
    return nil;
} // abstract

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self translateGameType];
    [self dealCards];
}

- (IBAction)dealCards {
    NSLog(@"Starting New Game");
    self.game = nil;
    self.gameResult = nil;
    self.flipResult.text = @"";
    self.gameSelector.enabled = YES;
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) {
        
        Deck *deck = [self createDeck];
        
        NSLog(@" ");
        NSLog(@"Initializing %@ Matching Game.", self.tabBarItem.title);
        NSLog(@"Cards in Deck: %d", deck.cardCount);
        NSLog(@"Cards at Start: %d", self.startingCardCount);
        NSLog(@"Matching Cards: %d", self.matchingNCards);
        NSLog(@"Flip Cost: %d", self.flipCost);
        NSLog(@"Mismatch Penalty: %d", self.mismathPenalty);
        NSLog(@"Match Bonus: %d", self.matchBonus);
        NSLog(@"Remove Matched: %@", self.removeMatched ? @"YES" : @"NO");
        NSLog(@"-------------------------------------------");
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:deck
                                             matchingNCards:self.matchingNCards
                                              usingFlipCost:self.flipCost
                                       usingMismatchPenalty:self.mismathPenalty
                                            usingMatchBonus:self.matchBonus];
        
    }
    
    return _game;
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
    [self updateVisibleCells];
    [self updateInformationLabels];
    
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
    
    
    if (self.removeMatched) {
        [self removeCardsMatchedInCollectionView];
    }
    
}

- (void)updateVisibleCells
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
}

- (void)updateInformationLabels
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.cardsLeftLabel.text = [NSString stringWithFormat:@"Cards Left: %d", [self.game cardsLeftInDeck]];
}

/**************************************************************/


# define CARDS_IN_PLAY_SECTION 0
- (void)removeCardsMatchedInCollectionView
{
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<[self.cardCollectionView numberOfItemsInSection:CARDS_IN_PLAY_SECTION]; i++) {
        Card *card = [self.game cardAtIndex:i];
        if (card.isFaceUp && card.isUnplayable) {
            [indexes addIndex:i];
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:CARDS_IN_PLAY_SECTION]];
        } 
    }
    if ([indexes count]) {
        [self.game deleteCardsAtIndexes:indexes];
        [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

- (IBAction)addCards:(UIButton *)sender {
    NSLog(@"Adding %d Cards.", self.addCardCount);
    
    if ([self.game addCards:self.addCardCount])
    {
        [self.cardCollectionView reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForItem:[self.cardCollectionView numberOfItemsInSection:CARDS_IN_PLAY_SECTION]-1
                                                inSection:CARDS_IN_PLAY_SECTION];
        [self.cardCollectionView scrollToItemAtIndexPath:path
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
    } else {
        self.addCardsButton.enabled = NO;
        self.addCardsButton.alpha = 0.5;
    }
    
    [self updateUI];
}

/**************************************************************/

- (IBAction)changeGameType:(id)sender
{
    [self translateGameType];
    [self dealCards];
}

- (void) translateGameType
{
    if (self.gameSelector) {
        if (self.gameSelector.selectedSegmentIndex == 0){
            self.matchingNCards = 2;
        } else if (self.gameSelector.selectedSegmentIndex == 1){
            self.matchingNCards = 3;
        } else {
            self.matchingNCards = nil;
        }
    }
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath){
        [self.game flipCardAtIndex:indexPath.item];
        self.flipResultHistory.maximumValue = [self.game.moveHistory count]-1;
        self.flipResultHistory.value = self.flipResultHistory.maximumValue;
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
    self.gameSelector.enabled = NO;
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
    return [self.game cardsInPlay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self obtainCardCollectionViewReuseIdentifier]
                                                                           forIndexPath:indexPath];
    
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}


@end
