//
//  CardMatchingGameMove.m
//  Matchismo
//
//  Created by Matthew Evans on 2/12/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "CardMatchingGameMove.h"
#import "Card.h"

@interface CardMatchingGameMove()

@end

@implementation CardMatchingGameMove

-(id) initWithMoveKind:(MoveKindType) moveKind
  cardsThatWereFlipped:(NSArray *) cardsThatWereFlipped
 scoreDeltaForThisMove:(NSUInteger) scoreDelta
{
    self = [super init];
    
    if (self)
    {
        _scoreDeltaForThisMove = scoreDelta;
        _cardsThatWereFlipped = cardsThatWereFlipped;
        _moveKind = moveKind;
    }
    
    return self;
}

-(NSString *)descriptionOfMove
{
    NSString *description;
    
    if (self.moveKind == MoveKindFlipUp)
    {
        description=[NSString stringWithFormat:@"Flipped up the %@", [[self.cardsThatWereFlipped lastObject] contents]];
    }
    else
    {
        if (self.moveKind == MoveKindMatchForPoints)
        { // Matched J♥ & J♠ for 4 points
            description = [NSString stringWithFormat:@"Matched "];
            
            for (NSUInteger i=0; i<[self.cardsThatWereFlipped count]-1; i++)
            {
                Card *card = [self.cardsThatWereFlipped objectAtIndex:i];
                description = [description stringByAppendingString:[NSString stringWithFormat:@"%@ & ", card.contents]];
            }
            
            Card *card = [self.cardsThatWereFlipped lastObject];
            description=[description stringByAppendingString:[NSString stringWithFormat:@"%@ for %d points",  card.contents, self.scoreDeltaForThisMove]];
        }
        else if (self.moveKind==MoveKindMismatchForPenalty)
        {   //6♦ and J♣ don’t match! 2 point penalty!
            description = [[NSString alloc] init];
            
            for (NSUInteger i=0; i<[self.cardsThatWereFlipped count]-1; i++)
            {
                Card *card = [self.cardsThatWereFlipped objectAtIndex:i];
                description = [description stringByAppendingString:[NSString stringWithFormat:@"%@ and ", card.contents]];
            }
            
            description=[description stringByAppendingString:[NSString stringWithFormat:@"%@ don't match! %d point penalty!",
                                                              [[self.cardsThatWereFlipped lastObject] contents],
                                                              (self.scoreDeltaForThisMove < 0 ? -self.scoreDeltaForThisMove : self.scoreDeltaForThisMove)]];
        }
    }
    
    return description;
}
@end
