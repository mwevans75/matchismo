//
//  CardMatchingGameMove.h
//  Matchismo
//
//  Created by Matthew Evans on 2/12/13.
//  Copyright (c) 2013 Matt's Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

// a gameMove object stores the result of doing a flip
// we could have an array of gameMoves to represent the game's history, for example
// a gameMove can describe itself

// result of move is either
// flipped the x card up
// matched x y (& z) cards for %d points
// flipped x y (& z) - no match! %d point penalty!

typedef NS_ENUM(NSInteger, MoveKindType) {
    MoveKindFlipUp,
    MoveKindMatchForPoints,
    MoveKindMismatchForPenalty
};

@interface CardMatchingGameMove : NSObject

// this is the designated initializer
-(id)     initWithMoveKind:(MoveKindType) moveKind
      cardsThatWereFlipped:(NSArray *)cardsThatWereFlipped
     scoreDeltaForThisMove:(NSUInteger) scoreDelta;

-(NSString *)descriptionOfMove;

@property (nonatomic) NSArray *cardsThatWereFlipped; // array holds card pointers
@property (nonatomic) int scoreDeltaForThisMove;

@property (nonatomic) MoveKindType moveKind;

@end
