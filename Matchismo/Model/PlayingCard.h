//
//  PlayingCard.h
//  Matchismo
//
//  Created by Matthew Evans on 1/29/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
