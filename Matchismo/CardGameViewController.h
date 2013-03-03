//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Matthew Evans on 1/29/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardCount; // abstract
@property (nonatomic) NSUInteger matchingNCards; // abstract
@property (nonatomic) NSUInteger flipCost; // abstract
@property (nonatomic) NSUInteger matchBonus; // abstract
@property (nonatomic) NSUInteger mismathPenalty; // abstract
@property (nonatomic) NSUInteger addCardCount; // abstract
@property (nonatomic) BOOL removeMatched; //abstract

@property (strong, nonatomic) CardMatchingGame *game;
- (Deck *) createDeck; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
           animate:(BOOL) animate; // abstract
- (NSString *)obtainCardCollectionViewReuseIdentifier; //abstract
@end
