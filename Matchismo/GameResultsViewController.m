//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Matthew Evans on 2/8/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResult.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@end

@implementation GameResultsViewController

- (IBAction)resetScores {
    [GameResult resetGameResults];
    [self updateUI];
    
}

- (void)updateUI
{
    NSString *displayText = @"";
    for (GameResult *result in [GameResult allGameResults]) {
        displayText = [displayText stringByAppendingFormat:@"%@ - Score %d (%@, %0gs)\n", result.gameName, result.score, result.end, round(result.duration)];
    }
    self.display.text = displayText;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}
- (void)setup
{
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

@end
