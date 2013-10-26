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


@interface Player : NSObject

@property (nonatomic) BOOL dead;
@property (nonatomic) PlayerTurnDirection turnDirection;

@property (nonatomic) CGFloat velocity;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGPoint loc;
@property (nonatomic) CGPoint previousLoc;

@property (nonatomic) ccColor4B color;

+ (id)newWithColor:(ccColor4B)color;

- (void)move:(ccTime)dt;

@end
