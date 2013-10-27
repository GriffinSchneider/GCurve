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
#define PLAYER_RADIUS 8

@interface HelloWorldLayer()

@property (nonatomic, strong) CCTexture2DMutable *texture;
@property (nonatomic, strong) NSMutableArray *players;

@property (nonatomic, strong) NSMutableArray *touches;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic) void* textureData;

@property (nonatomic, strong) CCScene *scene;

@end

@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    layer.scene = scene;
    layer.isTouchEnabled = YES;
    
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

- (void)restart {
	HelloWorldLayer *layer = [HelloWorldLayer node];
    layer.scene = self.scene;
    layer.isTouchEnabled = YES;
    
    [self.scene removeChild:self cleanup:YES];
    [self.scene addChild:layer];
}

-(id)init {
	if((self=[super init])) {
        self.touches = [NSMutableArray array];
        self.buttons = [NSMutableArray array];
        
        [GCHelper sharedInstance].delegate = self;
        [self scheduleUpdate];
        
        [self genBackground];
	}
	return self;
}

- (void)dealloc {
    NSLog(@"DEALLOC");
    free(self.textureData);
}

- (void)genBackground {
    
    self.textureData = malloc(2048 * 1536 * 8);
    
    self.texture = [[CCTexture2DMutable alloc] initWithData:self.textureData pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:2048 pixelsHigh:1536 contentSize:CGSizeMake(2048, 1536)];
    
    [self.texture fill:BACKGROUND_COLOR];
    [self.texture apply];
    
    CCSprite *sprite = [CCSprite spriteWithTexture:self.texture];
    sprite.position = CC_POINT_PIXELS_TO_POINTS(CGPointMake(self.texture.pixelsWide / 2,
                                                            self.texture.pixelsHigh / 2));
    
    [self addChild:sprite];
    
    self.players = [@[[Player newWithColor:ccc4(255, 0, 0, 255)],
                      [Player newWithColor:ccc4(0, 255, 0, 255)],
                      [Player newWithColor:ccc4(100, 100, 255, 255)],
                      [Player newWithColor:ccc4(0, 255, 255, 255)],
                      [Player newWithColor:ccc4(255, 255, 255, 255)]] mutableCopy];
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        player.loc = CGPointMake(250*(idx + 1), 250*(idx + 1));
        player.radius = PLAYER_RADIUS;
    }];
    
    CCSprite *buttonSprite;
    
    // Bottom left
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake(120, 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake(60, 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    // Bottom right
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake([self boundingBox].size.width - 60, 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake([self boundingBox].size.width - 120, 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    // Top Right
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake([self boundingBox].size.width - 120,
                                        [self boundingBox].size.height - 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake([self boundingBox].size.width - 60,
                                        [self boundingBox].size.height - 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    // Top left
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake(60,
                                        [self boundingBox].size.height - 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    buttonSprite = [CCSprite spriteWithFile:@"ButtonStar.png"];
    buttonSprite.position = CGPointMake(120,
                                        [self boundingBox].size.height - 60);
    buttonSprite.scale = 3.0;
    [self.buttons addObject:buttonSprite];
    [self addChild:buttonSprite];
    
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        
        [self.touches addObject:touch];
        
        if ([touch locationInView:touch.view].x < (300)) {
            [[GCHelper sharedInstance].match sendData:[@"left" dataUsingEncoding:NSUTF8StringEncoding] toPlayers:[GCHelper sharedInstance].match.playerIDs withDataMode:GKMatchSendDataUnreliable error:nil];
        } else {
            [[GCHelper sharedInstance].match sendData:[@"right" dataUsingEncoding:NSUTF8StringEncoding] toPlayers:[GCHelper sharedInstance].match.playerIDs withDataMode:GKMatchSendDataUnreliable error:nil];
        }
    }];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[GCHelper sharedInstance].match sendData:[@"none" dataUsingEncoding:NSUTF8StringEncoding] toPlayers:[GCHelper sharedInstance].match.playerIDs withDataMode:GKMatchSendDataUnreliable error:nil];
    [touches enumerateObjectsUsingBlock:^(UITouch *touch, BOOL *stop) {
        [self.touches removeObject:touch];
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
        
        if (idx != 4) {
            player.turnDirection = PlayerTurnDirectionNone;
        }
    }];
    
    if (isEveryoneDead) {
       [self restart];
    }
    
    [self.texture apply];
    
    for (UITouch *touch in self.touches) {
        CGPoint location = [touch locationInView:touch.view];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        [self.buttons enumerateObjectsUsingBlock:^(CCSprite *button, NSUInteger idx, BOOL *stop) {
            if (CGRectContainsPoint([button boundingBox], convertedLocation)) {
                [[self.players objectAtIndex:idx / 2] setTurnDirection:(idx%2 > 0) ? PlayerTurnDirectionLeft : PlayerTurnDirectionRight];
            }
        }];
    }
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
                if (![self isPixel:point inCircleAtPoint:player.previousLoc withRadius:player.previousRadius]) {
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
    
        minX = player.previousLoc.x-player.previousRadius;
        maxX = player.previousLoc.x+player.previousRadius;
        minY = player.previousLoc.y-player.previousRadius;
        maxY = player.previousLoc.y+player.previousRadius;
        
        for (int x = minX; x < maxX; x++) {
            for (int y = minY; y < maxY; y++) {
                CGPoint point = CGPointMake(x, y);
                // If this pixel is not in the player's head...
                if (![self isPixel:point inCircleAtPoint:player.loc withRadius:player.radius] &&
                    // ...and this pixel is in the player's head from the previous frame...
                    [self isPixel:point inCircleAtPoint:player.previousLoc withRadius:player.previousRadius] &&
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

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    CCLOG(@"Received data: %@", string);
    if ([string isEqualToString:@"left"]) {
        [[self.players objectAtIndex:4] setTurnDirection:PlayerTurnDirectionLeft];
    } else if ([string isEqualToString:@"right"]) {
        [[self.players objectAtIndex:4] setTurnDirection:PlayerTurnDirectionRight];
    } else {
        [[self.players objectAtIndex:4] setTurnDirection:PlayerTurnDirectionNone];
    }
}


@end
