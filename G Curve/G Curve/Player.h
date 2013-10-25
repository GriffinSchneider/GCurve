//
//  Player.h
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerTurnDirection) {
    PlayerTurnDirectionNone = 0,
    PlayerTurnDirectionRight,
    PlayerTurnDirectionLeft,
};


@interface Player : NSObject

@property (nonatomic) BOOL dead;

@property (nonatomic) CGFloat turnArcAngle;

@property (nonatomic) CGFloat angle;
@property (nonatomic) CGPoint loc;

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic) CGMutablePathRef savedPath;

@property (nonatomic) PlayerTurnDirection turnDirection;
@property (nonatomic) PlayerTurnDirection turnDirectionLastFrame;

@property (nonatomic, strong) UIColor *color;

+ (id)newWithColor:(UIColor *)color;

@end
