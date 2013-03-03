//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Matthew Evans on 2/9/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCard.h"

@interface PlayingCardMatchingGameViewController ()

@end

@implementation PlayingCardMatchingGameViewController

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define REMOVE_MATCHED NO
#define ADD_CARD_COUNT 0


- (NSUInteger) startingCardCount
{
    return 22;
}


- (NSString *)obtainCardCollectionViewReuseIdentifier
{
    return @"PlayingCard";
}

- (PlayingCardDeck *) createDeck
{
    self.flipCost = FLIP_COST;
    self.mismathPenalty = MISMATCH_PENALTY;
    self.matchBonus = MATCH_BONUS;
    self.removeMatched = REMOVE_MATCHED;
    self.addCardCount = ADD_CARD_COUNT;
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]){
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
            
            if (animate && playingCardView.faceUp != playingCard.isFaceUp){
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    playingCardView.faceUp = playingCard.isFaceUp;
                                }
                                completion:NULL];
            } else {
                playingCardView.faceUp = playingCard.isFaceUp;
            }
        }
    }
}

@end
