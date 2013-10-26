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

#define BACKGROUND_COLOR ccc4(0, 0, 0, 255)
#define PLAYER_RADIUS 10

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
    
    [self.texture fill:BACKGROUND_COLOR];
    [self.texture apply];
    
    CCSprite *sprite = [CCSprite spriteWithTexture:self.texture];
    sprite.position = CC_POINT_PIXELS_TO_POINTS(CGPointMake(self.texture.pixelsWide / 2,
                                                            self.texture.pixelsHigh / 2));
    
    [self addChild:sprite];
    
    self.players = [@[[Player newWithColor:ccc4(255, 0, 0, 255)],
                      [Player newWithColor:ccc4(0, 255, 0, 255)]] mutableCopy];
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        player.loc = CGPointMake(500*(idx + 1), 500*(idx + 1));
        player.radius = PLAYER_RADIUS;
    }];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        if ([touch locationInView:touch.view].x < (2048 / 2 / 2)) {
            player.turnDirection = PlayerTurnDirectionLeft;
        } else {
            player.turnDirection = PlayerTurnDirectionRight;
        }
    }];
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        player.turnDirection = PlayerTurnDirectionNone;
    }];
}

- (void)update:(ccTime)dt {
    
    __block BOOL isEveryoneDead = YES;
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        
        if (!player.dead) {
            isEveryoneDead = NO;
            [player update:dt];
            
            if ([self drawPlayer:player]) {
                player.dead = YES;
            }
        }
    }];
    
    if (isEveryoneDead) {
        exit(0);
    }
    
    [self.texture apply];
}

- (void)drawSquareAtPoint:(CGPoint)topLeft withSize:(CGSize)size andColor:(ccColor4B)color {
    for (int x = topLeft.x; x <= topLeft.x + size.width; x++) {
        for (int y = topLeft.y; y <= topLeft.y + size.width; y++) {
            [self.texture setPixelAt:CGPointMake(x, y) rgba:color];
        }
    }
}

- (void)drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius andColor:(ccColor4B)color {
    // Iterate over all pixels in the circle's bounding square
    for (int x = center.x-radius; x < center.x + radius; x++) {
        for (int y = center.y-radius; y < center.y + radius; y++) {
            // Color the pixel if it's in the circle
            if ([self isPixel:CGPointMake(x, y) inCircleAtPoint:center withRadius:radius]) {
                [self.texture setPixelAt:CGPointMake(x, y) rgba:color];
            }
        }
    }
}

- (BOOL)drawPlayer:(Player *)player {
    
    BOOL retVal = NO;
    
    CGFloat minX = player.loc.x-player.radius;
    CGFloat maxX = player.loc.x+player.radius;
    CGFloat minY = player.loc.y-player.radius;
    CGFloat maxY = player.loc.y+player.radius;
    
    // Iterate over all pixels in the circle's bounding square
    for (int x = minX; x < maxX; x++) {
        for (int y = minY; y < maxY; y++) {
            
            CGPoint point = CGPointMake(x, y);
            
            // If this pixel is in the player's head...
            if ([self isPixel:point inCircleAtPoint:player.loc withRadius:player.radius]) {
                // ...and this pixel wasn't in the player's head last frame...
                if (![self isPixel:point inCircleAtPoint:player.previousLoc withRadius:player.radius]) {
                    ccColor4B color = [self.texture pixelAt:point];
                    // ...and this pixel contains another snake body...
                    if ((color.r != BACKGROUND_COLOR.r) ||
                        (color.g != BACKGROUND_COLOR.g) ||
                        (color.b != BACKGROUND_COLOR.b) ||
                        (color.a != BACKGROUND_COLOR.a)) {
                        // ...then there was a collision.
                        retVal = YES;
                    }
                }
                
                // Fill in the player's head after collision detection.
                [self.texture setPixelAt:point rgba:player.color];
            }
        }
    }
    
    
    // If the player is gapping, then erase the trail.
    if (player.gapState == PlayerGapStateAutoGapping || player.gapState == PlayerGapStateForcedGapping) {
        
        retVal = NO;
    
        minX = player.previousLoc.x-player.radius;
        maxX = player.previousLoc.x+player.radius;
        minY = player.previousLoc.y-player.radius;
        maxY = player.previousLoc.y+player.radius;
        
        for (int x = minX; x < maxX; x++) {
            for (int y = minY; y < maxY; y++) {
                CGPoint point = CGPointMake(x, y);
                // If this pixel is not in the player's head...
                if (![self isPixel:point inCircleAtPoint:player.loc withRadius:player.radius] &&
                    // ...and this pixel is in the player's head from the previous frame...
                    [self isPixel:point inCircleAtPoint:player.previousLoc withRadius:player.radius] &&
                    // ...and this pixel was not in the player's head when the gap started...
                    ![self isPixel:point inCircleAtPoint:player.gapBeginLoc withRadius:player.radius]) {
                    // ...then clear the pixel.
                    [self.texture setPixelAt:point rgba:BACKGROUND_COLOR];
                }
            }
        }
    }
    
    return retVal;
}

- (BOOL)isPixel:(CGPoint)pixel inCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius {
    return (pixel.x-center.x)*(pixel.x-center.x)+(pixel.y-center.y)*(pixel.y-center.y) <= radius*radius;
}

@end
