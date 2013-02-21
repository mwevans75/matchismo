//
//  PlayingCard.m
//  Matchismo
//
//  Created by Matthew Evans on 1/29/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 0) return 0;
    
    if ([otherCards count]  == 1) {
        id otherCard = [otherCards lastObject];
        if ([otherCard isKindOfClass:[PlayingCard class]]){
            PlayingCard *otherPlayingCard = (PlayingCard *) otherCard;
            if ([otherPlayingCard.suit isEqualToString:self.suit]){
                score = 1;
            } else if (otherPlayingCard.rank == self.rank) {
                score = 4;
            }
        }
    } else if ([otherCards count]  == 2) {
        id otherCard1 = [otherCards objectAtIndex:0];
        id otherCard2 = [otherCards objectAtIndex:1];
        
        if ([otherCard1 isKindOfClass:[PlayingCard class]] && [otherCard2 isKindOfClass:[PlayingCard class]]){
            PlayingCard *otherPlayingCard1 = (PlayingCard *) otherCard1;
            PlayingCard *otherPlayingCard2 = (PlayingCard *) otherCard2;
            if ([otherPlayingCard1.suit isEqualToString:self.suit] && [otherPlayingCard2.suit isEqualToString:self.suit]){
                score = 3;
            } else if (otherPlayingCard1.rank == self.rank && otherPlayingCard2.rank == self.rank) {
                score = 12;
            }
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // becasue we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void) setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
