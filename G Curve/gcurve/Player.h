//
//  Player.h
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef NS_ENUM(NSInteger, PlayerTurnDirection) {
    PlayerTurnDirectionNone = 0,
    PlayerTurnDirectionLeft,
    PlayerTurnDirectionRight
};

typedef NS_ENUM(NSInteger, PlayerGapState) {
    PlayerGapStateNotGapping = 0,
    PlayerGapStateAutoGapping,
    PlayerGapStateForcedGapping,
};


@interface Player : NSObject

@property (nonatomic) BOOL dead;
@property (nonatomic) PlayerTurnDirection turnDirection;

@property (nonatomic) BOOL hasTemporaryCollisionImmunity;

@property (nonatomic) ccTime timeSinceLastAutoGap;
@property (nonatomic) PlayerGapState gapState;
@property (nonatomic) CGPoint gapBeginLoc;

@property (nonatomic) CGFloat velocity;
@property (nonatomic) CGFloat angle;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat previousRadius;

@property (nonatomic) CGPoint loc;
@property (nonatomic) CGPoint previousLoc;

@property (nonatomic) ccColor4B color;

+ (id)newWithColor:(ccColor4B)color;

- (void)update:(ccTime)dt;

@end
