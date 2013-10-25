//
//  Player.h
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic) CGFloat turnArcAngle;

@property (nonatomic) CGFloat angle;
@property (nonatomic) CGPoint loc;

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic) CGMutablePathRef savedPath;

@end
