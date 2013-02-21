//
//  GameResult.h
//  Matchismo
//
//  Created by Matthew Evans on 2/8/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject


@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) NSString *gameName;
@property (nonatomic) int score;

+ (NSArray *)allGameResults; //of Game Result

+ (void)resetGameResults;

- (id)initWithGameName: (NSString *) gameName;

@end
