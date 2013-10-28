//
//  Powerup.m
//  gcurve
//
//  Created by Griffin Schneider on 10/27/13.
//
//

#import "Powerup.h"

@implementation Powerup

+ (instancetype)newRandomPowerupInSize:(CGSize)size {
    
    Powerup *powerup;
    
    if (arc4random() % 2 > 0) {
        powerup = [[Powerup alloc] initWithFile:@"ButtonStar.png"];
        powerup.type = PowerupTypeForcedGap;
        powerup.effectMask = PowerupEffectMaskOwner;
    } else {
        powerup = [[Powerup alloc] initWithFile:@"ButtonStarSel.png"];
        powerup.type = PowerupTypeGrow;
        powerup.effectMask = PowerupEffectMaskEnemiesOfOwner;
    }
    
    powerup.position = CGPointMake(arc4random() % (int)size.width,
                                   arc4random() % (int)size.height);
    return powerup;
}

- (void)applyToGame:(HelloWorldLayer *)game withOwner:(Player *)owner {
    
    [game.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        if (self.effectMask == PowerupEffectMaskOwner && player != owner) {
            return;
        } else if (self.effectMask == PowerupEffectMaskEnemiesOfOwner && player == owner) {
            return;
        }
        
        switch (self.type) {
            case PowerupTypeGrow: {
                CGFloat oldRadius = player.radius;
                player.radius += 15;
                double delayInSeconds = 2.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    player.radius = oldRadius;
                    player.hasTemporaryCollisionImmunity = YES;
                });
                
                break;
            }
                
                
            case PowerupTypeForcedGap: {
                player.gapState = PlayerGapStateForcedGapping;
                double delayInSeconds = 3.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    player.gapState = PlayerGapStateNotGapping;
                });
                
                break;
            }
                
        }
    }];
    
}
        
@end
