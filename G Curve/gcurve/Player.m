//
//  Player.m
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import "Player.h"

@implementation Player

+ (id)newWithColor:(ccColor4B)color {
    Player *player = [Player new];
    player.color = color;
    return player;
}

- (void)move:(ccTime)dt {
    
    if (self.turnDirection == PlayerTurnDirectionLeft){
        self.angle -= 0.07;
    } else if (self.turnDirection == PlayerTurnDirectionRight) {
        self.angle += 0.07;
    }
    
    self.previousLoc = self.loc;
    self.loc = CGPointMake(self.loc.x + cos(self.angle)*5.0,
                           self.loc.y + sin(self.angle)*5.0);
}

@end
