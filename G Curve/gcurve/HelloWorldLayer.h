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

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <
GCHelperDelegate
>

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
