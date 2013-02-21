//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Matthew Evans on 1/29/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardCount; // abstract
- (Deck *) createDeck; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
           animate:(BOOL) animate; // abstract


@end
