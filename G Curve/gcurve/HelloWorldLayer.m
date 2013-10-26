//
//  HelloWorldLayer.m
//  gcurve
//
//  Created by Griffin Schneider on 10/26/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "CCTexture2DMutable.h"
#import "Player.h"

@interface HelloWorldLayer()

@property (nonatomic, strong) CCTexture2DMutable *texture;
@property (nonatomic, strong) NSMutableArray *players;

@end

@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:layer priority:0 swallowsTouches:YES];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

-(id)init {
	if((self=[super init])) {
        [self scheduleUpdate];
        [self genBackground];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)genBackground {
    
    void * data = malloc(2048 * 1536 * 8);
    
    self.texture = [[CCTexture2DMutable alloc] initWithData:data pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:2048 pixelsHigh:1536 contentSize:CGSizeMake(2048, 1536)];
    
    [self.texture fill:ccc4(0, 0, 0, 255)];
    [self.texture apply];
    
    CCSprite *sprite = [CCSprite spriteWithTexture:self.texture];
    sprite.position = CC_POINT_PIXELS_TO_POINTS(CGPointMake(self.texture.pixelsWide / 2,
                                                            self.texture.pixelsHigh / 2));
    
    [self addChild:sprite];
    
    self.players = [@[[Player newWithColor:ccc4(255, 0, 0, 255)]] mutableCopy];
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        player.loc = CGPointMake(500, 500);
    }];
}

static BOOL turningLeft = NO;
static BOOL turningRight = NO;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([touch locationInView:touch.view].x < (2048 / 2 / 2)) {
        turningLeft = YES;
    } else {
        turningRight = YES;
    }
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    turningLeft = NO;
    turningRight = NO;
}

- (void)update:(ccTime)dt {
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        
        if (turningLeft){
            player.angle -= 0.07;
        } else if (turningRight) {
            player.angle += 0.07;
        }
        
        player.loc = CGPointMake(player.loc.x + cos(player.angle)*5.0,
                                 player.loc.y + sin(player.angle)*5.0);
        
        [self drawCircleAtPoint:player.loc withRadius:10 andColor:player.color];
    }];
    
    [self.texture apply];
}

- (void)drawSquareAtPoint:(CGPoint)topLeft withSize:(CGSize)size andColor:(ccColor4B)color {
    for (int x = topLeft.x; x <= topLeft.x + size.width; x++) {
        for (int y = topLeft.y; y <= topLeft.y + size.width; y++) {
            [self.texture setPixelAt:CGPointMake(x, y) rgba:color];
        }
    }
}

- (void)drawCircleAtPoint:(CGPoint)center withRadius:(NSInteger)radius andColor:(ccColor4B)color {
    // Iterate over all pixels in the circle's bounding square
    for (int x = center.x-radius; x < center.x + radius; x++) {
        for (int y = center.y-radius; y < center.y + radius; y++) {
            // Color the pixel if it's in the circle
            if ((x-center.x)*(x-center.x)+(y-center.y)*(y-center.y) <= radius*radius) {
                [self.texture setPixelAt:CGPointMake(x, y) rgba:color];
            }
        }
    }
    
}


@end
