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

- (void)update:(ccTime)dt {
    
    if (self.turnDirection == PlayerTurnDirectionLeft){
        self.angle -= 0.07;
    } else if (self.turnDirection == PlayerTurnDirectionRight) {
        self.angle += 0.07;
    }
    
    self.previousLoc = self.loc;
    self.loc = CGPointMake(self.loc.x + cos(self.angle)*5.0,
                           self.loc.y + sin(self.angle)*5.0);
    
    self.timeSinceLastAutoGap += dt;
    
    if (self.gapState == PlayerGapStateNotGapping) {
        if (self.timeSinceLastAutoGap > 3.0) {
            if ((arc4random() % 100) > 98) {
                self.gapState = PlayerGapStateAutoGapping;
                self.timeSinceLastAutoGap = 0;
            }
        }
    } else if (self.gapState == PlayerGapStateAutoGapping) {
        if (self.timeSinceLastAutoGap > 0.4) {
            self.gapState = PlayerGapStateNotGapping;
            self.timeSinceLastAutoGap = 0;
        }
    }
}

@end
