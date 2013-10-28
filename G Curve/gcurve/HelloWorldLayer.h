//
//  HelloWorldLayer.h
//  gcurve
//
//  Created by Griffin Schneider on 10/26/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GCHelper.h"
#import "CCTexture2DMutable.h"

@class HelloWorldLayer;
typedef void (^GameBlock)(HelloWorldLayer *game);

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <
GCHelperDelegate
>

@property (nonatomic, strong) CCTexture2DMutable *texture;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *powerups;

@property (nonatomic) ccTime timeSinceLastRandomPowerup;

@property (nonatomic, strong) NSMutableArray *touches;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic) void* textureData;

@property (nonatomic, strong) CCScene *scene;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *)scene;

@end
