//
//  HelloWorldLayer.h
//  gcurve
//
//  Created by Griffin Schneider on 10/26/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <
CCTargetedTouchDelegate
>

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
