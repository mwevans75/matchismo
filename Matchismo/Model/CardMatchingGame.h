//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (id) initWithCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck
          matchingNCards:(NSUInteger) matchNCards
           usingFlipCost:(NSUInteger) flipCost
    usingMismatchPenalty:(NSUInteger) mismatchPenalty
         usingMatchBonus:(NSUInteger) matchBonus;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)deleteCardsAtIndexes:(NSIndexSet *)indexSet;
- (BOOL)addCards:(NSUInteger)numberOfCards;
- (NSUInteger)cardsInPlay;
- (NSUInteger)cardsLeftInDeck;

@property (nonatomic,readonly) int score;
@property (nonatomic,readonly) NSString *lastResult;
@property (nonatomic,readonly) NSMutableArray *moveHistory;

@end
