//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSString *color in [SetCard validColors]) {
                for (NSString *shading in [SetCard validShadings]) {
                    for (NSUInteger number = 1; number <=[SetCard maxNumber]; number++){
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}
    
@end