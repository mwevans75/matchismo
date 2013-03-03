//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CardMatchingGameMove.h"

@interface CardMatchingGame()
@property (nonatomic,readwrite) int score;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic,readwrite) NSString *lastResult;
@property (nonatomic,readwrite) NSMutableArray *moveHistory;
@property (nonatomic) NSUInteger matchNCards;
@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) NSUInteger matchBonus;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (NSMutableArray *)moveHistory
{
    if (!_moveHistory) {
        _moveHistory = [[NSMutableArray alloc] init];
    }
    
    return _moveHistory;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
         matchingNCards:(NSUInteger) matchNCards
          usingFlipCost:(NSUInteger) flipCost
   usingMismatchPenalty:(NSUInteger) mismatchPenalty
        usingMatchBonus:(NSUInteger) matchBonus
{
    self = [super init];
    
    if (self) {
        self.deck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [self.deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.matchNCards = matchNCards;
        self.flipCost = flipCost;
        self.mismatchPenalty = mismatchPenalty;
        self.matchBonus = matchBonus;
        
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *otherCards =[[NSMutableArray alloc] init];
    NSMutableArray *allCardsInPlay;
    NSUInteger scoreDelta = 0;
    
    if (!card.isUnplayable) {
        CardMatchingGameMove *move = nil;
        
        if (!card.isFaceUp) {
            NSLog(@"Card Flipped: %@.",card.contents);
            
            // Add Other Flipped Cards to Array for Comparison
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                }
            }
            
            // Create Array of All Cards in Play
            allCardsInPlay = [otherCards mutableCopy];
            [allCardsInPlay addObject:card];
            
            move = [[CardMatchingGameMove alloc] initWithMoveKind:MoveKindFlipUp
                                             cardsThatWereFlipped:allCardsInPlay
                                            scoreDeltaForThisMove:scoreDelta];
            
            if (self.matchNCards == [allCardsInPlay count]) {
                int matchScore = [card match:otherCards];
                
                if (matchScore) {
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    card.unplayable = YES;
                    scoreDelta += matchScore * self.matchBonus;
                    move = [[CardMatchingGameMove alloc] initWithMoveKind:MoveKindMatchForPoints
                                                     cardsThatWereFlipped:allCardsInPlay
                                                    scoreDeltaForThisMove:scoreDelta];
                    
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    scoreDelta -= self.mismatchPenalty;
                    move = [[CardMatchingGameMove alloc] initWithMoveKind:MoveKindMismatchForPenalty
                                                     cardsThatWereFlipped:allCardsInPlay
                                                    scoreDeltaForThisMove:scoreDelta];
                }

                NSLog(@"Move Score: %d.",scoreDelta);
                
            }
            scoreDelta -= self.flipCost;
            [self.moveHistory addObject:move];
        }
        self.score += scoreDelta;
        card.faceUp = !card.isFaceUp;
    }
}
- (NSUInteger)cardsInPlay
{
    return [self.cards count];
}

- (NSUInteger)cardsLeftInDeck
{
    return self.deck.cardCount;
}

- (void)deleteCardsAtIndexes:(NSIndexSet *)indexSet
{
    [self.cards removeObjectsAtIndexes:indexSet];
}

- (BOOL)addCards:(NSUInteger)numberOfCards
{
    BOOL enoughCards = (numberOfCards<=[self.deck cardCount]);
    if (enoughCards)
        for (NSUInteger i=0; i<numberOfCards; i++) {
            Card *card = [self.deck drawRandomCard];
            [self.cards addObject:card];
        }
    return enoughCards;
}
@end
