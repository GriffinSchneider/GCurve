//
//  Powerup.h
//  gcurve
//
//  Created by Griffin Schneider on 10/27/13.
//
//

#import "CCSprite.h"
#import "HelloWorldLayer.h"
#import "Player.h"

typedef NS_ENUM(NSInteger, PowerupEffectMask) {
    PowerupEffectMaskOwner = 0,
    PowerupEffectMaskEnemiesOfOwner,
    PowerupEffectMaskEveryone
};

typedef NS_ENUM(NSInteger, PowerupType) {
    PowerupTypeGrow,
    PowerupTypeForcedGap
};

@interface Powerup : CCSprite

@property (nonatomic) PowerupEffectMask effectMask;
@property (nonatomic) PowerupType type;

+ (instancetype)newRandomPowerupInSize:(CGSize)size;

- (void)applyToGame:(HelloWorldLayer *)game withOwner:(Player *)owner;

@end
