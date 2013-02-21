//
//  SetCard.m
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSLog(@"Scoring the Set Card Matching Game");
 
    
    if (otherCards.count == 2) // in this game, only 3-cards match at a time
    {
        id otherCard1 = [otherCards objectAtIndex:0];
        id otherCard2 = [otherCards objectAtIndex:1];
        if ([otherCard1 isKindOfClass:[SetCard class]] && [otherCard2 isKindOfClass:[SetCard class]]){
            SetCard *c1 = self;
            SetCard *c2 = (SetCard *) otherCard1;
            SetCard *c3 = (SetCard *) otherCard2;

        
            // we have a set exactly if:
            if (
                (  // either there are three cards all of the same number:
                 ((c1.number == c2.number) &&
                  (c2.number == c3.number) &&
                  (c1.number == c3.number))
                 ||
                 // or all three different numbers...
                 ((c1.number != c2.number) &&
                  (c2.number != c3.number) &&
                  (c1.number != c3.number)
                  )
                 )
                &&   // AND as if that wasn't hard enough we must also have
                ( // either all three of the same symbol
                 ([c1.symbol isEqualToString:c2.symbol] &&
                  [c2.symbol isEqualToString:c2.symbol] &&
                  [c3.symbol isEqualToString:c3.symbol])
                 ||
                 // or all three different symbols
                 ((![c1.symbol isEqualToString:c2.symbol]) &&
                  (![c2.symbol isEqualToString:c3.symbol]) &&
                  (![c1.symbol isEqualToString:c3.symbol])
                  )
                 )
                &&  // AND ...
                ( // all same or all different shading
                 ([c1.shading isEqualToString:c2.shading] &&
                  [c2.shading isEqualToString:c3.shading] &&
                  [c1.shading isEqualToString:c3.shading])
                 ||
                 ((![c1.shading isEqualToString:c2.shading]) &&
                  (![c2.shading isEqualToString:c3.shading]) &&
                  (![c1.shading isEqualToString:c3.shading])
                  )
                 )
                &&
                ( // AND all same or all different color!
                 ([c1.color isEqualToString:c2.color] &&
                  [c2.color isEqualToString:c3.color] &&
                  [c1.color isEqualToString:c3.color])
                 ||
                 ((![c1.color isEqualToString:c2.color]) &&
                  (![c2.color isEqualToString:c3.color]) &&
                  (![c1.color isEqualToString:c3.color])
                  )
                 )
                ) score = 1;
        }
    }
    
    return score;
}

+ (NSArray *)validSymbols
{
    return @[@"SQUIGGLE",@"OVAL",@"DIAMOND"];
}

+ (NSArray *)validColors
{
    return @[@"RED",@"PURPLE",@"GREEN"];
}

+ (NSArray *)validShadings
{
    return @[@"OPEN",@"STRIPED",@"SOLID"];
}

+ (NSUInteger)maxNumber
{
    return 3;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d-%@-%@-%@", self.number, self.color, self.shading, self.symbol];
}

- (NSString *)contents
{
    return self.description;
}
@end
