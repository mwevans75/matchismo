//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Matthew Evans on 2/17/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

-(void)pinch:(UIPinchGestureRecognizer *) gesture;

@end
