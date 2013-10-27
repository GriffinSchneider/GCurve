//
//  IntroLayer.m
//  gcurve
//
//  Created by Griffin Schneider on 10/26/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter {
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

    [GCHelper sharedInstance].delegate = self;
    [[GCHelper sharedInstance] authenticateLocalUser];
    
    CCMenuItem *menuItem1 = [CCMenuItemFont itemWithString:@"Local Multiplayer" target:self selector:@selector(localMultiplayerPressed:)];
    CCMenuItem *menuItem2 = [CCMenuItemFont itemWithString:@"Gamecenter Matchmaking" target:self selector:@selector(gameCenterMatchmakingPressed:)];
    
    CCMenu *menu = [CCMenu menuWithArray:@[menuItem1, menuItem2]];
    [menu alignItemsVerticallyWithPadding:10];
    menu.position = CGPointMake(size.width/2, size.height/2);
    [self addChild:menu];
}

-(void) makeTransition {
    CCScene *newScene = [HelloWorldLayer scene];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:newScene withColor:ccBLACK]];
}

- (void)localMultiplayerPressed:(CCMenuItem *)sender {
    [self makeTransition];
}

- (void)gameCenterMatchmakingPressed:(CCMenuItem *)sender {
    AppController *appDelegate = (AppController *)[UIApplication sharedApplication].delegate;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:appDelegate.navController delegate:self];
}

- (void)userAuthenticated {
}

- (void)matchStarted {
    CCLOG(@"Match started");
    [self makeTransition];
}

- (void)matchEnded {
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
}

@end
