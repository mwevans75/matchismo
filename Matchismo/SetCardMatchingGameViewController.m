//
//  SetCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Matthew Evans on 2/8/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "SetCardMatchingGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "CardMatchingGameMove.h"

@interface CardGameViewController ()
-(void)updateUI;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@end

@interface SetCardMatchingGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetCardMatchingGameViewController

/*
- (CardMatchingGame *)game
{
    NSUInteger matchNCards = 3;
    
    if (!_game) {
        NSLog(@" ");
        NSLog(@"Initializing Set Card Matching Game.");
        NSLog(@"Cards: %d", self.cardButtons.count);
        NSLog(@"Cards to Match: %d", matchNCards);
        NSLog(@"-------------------------------------------");
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[SetCardDeck alloc] init]
                                             matchingNCards:matchNCards
                                              usingFlipCost:0
                                       usingMismatchPenalty:3
                                            usingMatchBonus:4];
    }
    
    return _game;
}
*/
- (void) updateUI
{
    [super updateUI];
    
}

/*
+(NSMutableAttributedString *)attributedStringDescriptionOfCard:(SetCard *)card
{
    NSString *symbolString;  // the plain text string we will attribute
    // for the card.symbol
    if ([card.symbol isEqualToString:@"DIAMOND"]) {
        symbolString=@"▲";
    } else if ([card.symbol isEqualToString:@"SQUIGGLE"]) {
        symbolString=@"●";
    } else if ([card.symbol isEqualToString:@"OVAL"]) {
        symbolString=@"■";
    }
    
    // repeat the symbol 1, 2 or 3 times - for the card.number
    symbolString = [symbolString stringByPaddingToLength:card.number withString:symbolString startingAtIndex:0];
    
    NSMutableAttributedString *fancyString = [[NSMutableAttributedString alloc] initWithString:symbolString];
    
    NSRange wholeThing = NSMakeRange(0, [symbolString length]);
    
    // set the color - for the card.color
    UIColor *color;
    if ([card.color isEqualToString:@"RED"]) {
        color = [UIColor redColor];
    } else if ([card.color isEqualToString:@"GREEN"]) {
        color = [UIColor greenColor];
    } else if ([card.color isEqualToString:@"PURPLE"]) {
        color = [UIColor purpleColor];
    }
    
    // and the alpha for the card.shading
    if ([card.shading isEqualToString:@"SOLID"]) {
        
        color = [color colorWithAlphaComponent:1.0f];
        [fancyString addAttribute:NSForegroundColorAttributeName value:color range:wholeThing];
        [fancyString addAttribute:NSStrokeColorAttributeName value:color range:wholeThing];
        [fancyString addAttribute:NSStrokeWidthAttributeName value:@-10 range:wholeThing];
        
    } else if ([card.shading isEqualToString:@"STRIPED"]) {
        
        [fancyString addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:0.1] range:wholeThing];
        [fancyString addAttribute:NSStrokeColorAttributeName value:color range:wholeThing];
        [fancyString addAttribute:NSStrokeWidthAttributeName value:@-10 range:wholeThing];
        
    } else if ([card.shading isEqualToString:@"OPEN"]) {
        
        [fancyString addAttribute:NSStrokeColorAttributeName value:color range:wholeThing];
        [fancyString addAttribute:NSStrokeWidthAttributeName value:@10 range:wholeThing];
        
    }
    
    return fancyString;
}

+(NSAttributedString *)attributedResultSeparator
{
    return [[NSAttributedString alloc] initWithString:@"&"];
}

- (void)updateResultOfLastFlipLabel:(CardMatchingGameMove *)move
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    if (move.moveKind == MoveKindFlipUp)
    {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
    } else if (move.moveKind == MoveKindMatchForPoints)
    {
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
    }
    
    // for each card in the move's cards involved
    
    NSArray *cards = [move cardsThatWereFlipped];
    if ([cards count])
    {
        SetCard *card = cards[0];
        [result appendAttributedString:[SetCardMatchingGameViewController attributedStringDescriptionOfCard:card]];
        
        for (int i = 1; i < [cards count]; i++) {
            card = cards[i];
            [result appendAttributedString:[SetCardMatchingGameViewController attributedResultSeparator]];
            [result appendAttributedString:[SetCardMatchingGameViewController attributedStringDescriptionOfCard:card]];
        }
    }
    
    
    if (move.moveKind == MoveKindMismatchForPenalty)
    {
        NSString *dontMatchString = [[NSString alloc] initWithFormat:@" don't match! (%d penalty)", move.scoreDeltaForThisMove];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:dontMatchString]];
        
    } else if (move.moveKind == MoveKindMatchForPoints)
    {
        NSString *forNPoints = [[NSString alloc] initWithFormat:@" for %d points", move.scoreDeltaForThisMove];
        [result appendAttributedString:[[NSAttributedString alloc] initWithString:forNPoints]];
    }
    
    [result addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12] }
                    range:NSMakeRange(0, [result length])];
    
    self.flipResult.attributedText = result;
}*/
@end
