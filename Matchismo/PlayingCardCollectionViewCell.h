//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Matthew Evans on 2/20/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
