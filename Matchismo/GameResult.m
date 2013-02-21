//
//  GameResult.m
//  Matchismo
//
//  Created by Matthew Evans on 2/8/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResult_ALL"
#define GAMENAME_KEY @"GameName"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    
    return allGameResults;
}

+ (void)resetGameResults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs removeObjectForKey:ALL_RESULTS_KEY];
    [defs synchronize];
}

-(id)initFromPropertyList:(id)plist
{
    self = [self init];
    if (self){
        if ([plist isKindOfClass:[NSDictionary class]]){
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _gameName = resultDictionary[GAMENAME_KEY];
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end) {
                self = nil;
            }
        }
    }
    return self;
}

-(id)asPropertyList
{
    return @{ GAMENAME_KEY : self.gameName, START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score)};
}

// designated initializer
- (id)initWithGameName: (NSString *) gameName
{
    self = [super init];
    if (self) {
        _gameName = gameName;
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}
@end
