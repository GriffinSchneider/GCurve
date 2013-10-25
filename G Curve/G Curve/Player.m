//
//  Player.m
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import "Player.h"

@implementation Player

+ (id)newWithColor:(UIColor *)color {
    Player *player = [Player new];
    player.color = color;
    return player;
}

- (id)init {
    if ((self = [super init])) {
        self.path = CGPathCreateMutable();
    }
    return self;
}

@end
