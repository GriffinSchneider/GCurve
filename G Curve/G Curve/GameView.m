//
//  GameView.m
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import "GameView.h"
#import "Player.h"

#define TURN_RADS_PER_FRAME 0.04
#define VELOCITY 2.5

#define RADIUS 30.0f

#define LINE_WIDTH 8
#define LINE_CAP kCGLineCapRound

@interface GameView()


@property CADisplayLink *displayLink;


@property (nonatomic, retain) NSMutableArray *players;

@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.players = [@[[Player new],
                          [Player new],
                          [Player new],
                          [Player new]] mutableCopy];
        
        [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
            
            player.loc = CGPointMake(((float)rand() / RAND_MAX) * (frame.size.width - 20) + 40,
                                     ((float)rand() / RAND_MAX) * (frame.size.height - 20) + 40);
            
            
            CGPathMoveToPoint(player.path, NULL, player.loc.x, player.loc.y);
            player.savedPath = CGPathCreateMutableCopy(player.path);
        }];
        
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSRunLoopCommonModes];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)update:(CADisplayLink *)sender {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        
        if (player.turnDirection == PlayerTurnDirectionLeft) {
            CGPoint center = CGPointMake(player.loc.x + cos(player.angle-M_PI_2)*RADIUS,
                                         player.loc.y + sin(player.angle-M_PI_2)*RADIUS);
            CGFloat startAngle = atan2(player.loc.y - center.y,
                                       player.loc.x - center.x);
            if (player.turnDirectionLastFrame == PlayerTurnDirectionLeft) {
                player.turnArcAngle += 0.1;
                CGPathRelease(player.path);
                player.path = CGPathCreateMutableCopy(player.savedPath);
                
                [self checkCollision:CGPointMake(center.x + cos(startAngle - player.turnArcAngle-0.1)*RADIUS,
                                                 center.y + sin(startAngle - player.turnArcAngle-0.1)*RADIUS)
                          withPlayer:player];
            } else {
                player.turnArcAngle = 0;
                CGPathRelease(player.savedPath);
                player.savedPath = CGPathCreateMutableCopy(player.path);
            }
            
            
            CGPathAddArc(player.path, NULL,
                         center.x, center.y,
                         RADIUS,
                         startAngle, startAngle - player.turnArcAngle,
                         YES);
            
            
            
            player.turnDirectionLastFrame = PlayerTurnDirectionLeft;
            
        } else if (player.turnDirection == PlayerTurnDirectionRight) {
            CGPoint center = CGPointMake(player.loc.x + cos(player.angle+M_PI_2)*RADIUS,
                                         player.loc.y + sin(player.angle+M_PI_2)*RADIUS);
            CGFloat startAngle = atan2(player.loc.y - center.y,
                                       player.loc.x - center.x);
            if (player.turnDirectionLastFrame == PlayerTurnDirectionRight) {
                player.turnArcAngle -= 0.1;
                CGPathRelease(player.path);
                player.path = CGPathCreateMutableCopy(player.savedPath);
                
                [self checkCollision:CGPointMake(center.x + cos(startAngle - player.turnArcAngle+0.1)*RADIUS,
                                                 center.y + sin(startAngle - player.turnArcAngle+0.1)*RADIUS)
                 withPlayer:player];
                
            } else {
                player.turnArcAngle = 0;
                CGPathRelease(player.savedPath);
                player.savedPath = CGPathCreateMutableCopy(player.path);
            }
            
            
            CGPathAddArc(player.path, NULL,
                         center.x, center.y,
                         RADIUS,
                         startAngle, startAngle - player.turnArcAngle,
                         NO);
            
            player.turnDirectionLastFrame = PlayerTurnDirectionRight;
            
        } else {
            if (player.turnDirectionLastFrame == PlayerTurnDirectionNone) {
                CGPathRelease(player.path);
                player.path = CGPathCreateMutableCopy(player.savedPath);
                
                [self checkCollision:CGPointMake(player.loc.x + cos(player.angle)*VELOCITY,
                                                 player.loc.y + sin(player.angle)*VELOCITY)
                 withPlayer:player];
            } else {
                if (player.turnDirectionLastFrame == PlayerTurnDirectionLeft) {
                    CGPoint center = CGPointMake(player.loc.x + cos(player.angle-M_PI_2)*RADIUS,
                                                 player.loc.y + sin(player.angle-M_PI_2)*RADIUS);
                    CGFloat startAngle = atan2(player.loc.y - center.y,
                                               player.loc.x - center.x);
                    player.loc = CGPointMake(center.x + cos(startAngle - player.turnArcAngle)*RADIUS,
                                             center.y + sin(startAngle - player.turnArcAngle)*RADIUS);
                    
                    CGPathMoveToPoint(player.path, NULL, player.loc.x, player.loc.y);
                    
                    player.angle = (startAngle - player.turnArcAngle) - M_PI_2;
                }
                if (player.turnDirectionLastFrame == PlayerTurnDirectionRight) {
                    CGPoint center = CGPointMake(player.loc.x + cos(player.angle+M_PI_2)*RADIUS,
                                                 player.loc.y + sin(player.angle+M_PI_2)*RADIUS);
                    CGFloat startAngle = atan2(player.loc.y - center.y,
                                               player.loc.x - center.x);
                    player.loc = CGPointMake(center.x + cos(startAngle - player.turnArcAngle)*RADIUS,
                                             center.y + sin(startAngle - player.turnArcAngle)*RADIUS);
                    
                    CGPathMoveToPoint(player.path, NULL, player.loc.x, player.loc.y);
                    
                    player.angle = (startAngle - player.turnArcAngle) + M_PI_2;
                }
                CGPathRelease(player.savedPath);
                player.savedPath = CGPathCreateMutableCopy(player.path);
            }
            
            
            player.loc = CGPointMake(player.loc.x + cos(player.angle)*VELOCITY,
                                     player.loc.y + sin(player.angle)*VELOCITY);
            

            CGPathAddLineToPoint(player.path, NULL, player.loc.x, player.loc.y);
            player.turnDirectionLastFrame = PlayerTurnDirectionNone;
        }
        
        [self setNeedsDisplay];
    }];
}

- (void)checkCollision:(CGPoint)point withPlayer:(Player *)controllingPlayer {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        CGPathRef pathToCheck = (controllingPlayer == player) ? player.savedPath : player.path;
        CGPathRef thing = CGPathCreateCopyByStrokingPath(pathToCheck, NULL, LINE_WIDTH, LINE_CAP, kCGLineJoinRound, 0);
        if (CGPathContainsPoint(thing, NULL, point, NO)) {
            [self.displayLink invalidate];
        }
        CGPathRelease(thing);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        if (point.x < self.frame.size.width / 2.0f) {
            player.turnDirection = PlayerTurnDirectionLeft;
        } else {
            player.turnDirection = PlayerTurnDirectionRight;
        }
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        if (point.x < self.frame.size.width / 2.0f) {
            player.turnDirection = PlayerTurnDirectionLeft;
        } else {
            player.turnDirection = PlayerTurnDirectionRight;
        }
    }];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        player.turnDirection = PlayerTurnDirectionNone;
    }];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetMiterLimit(context, 0);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetLineCap(context, LINE_CAP);
    CGContextSetAllowsAntialiasing(context, NO);
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextAddPath(context, player.path);
        CGContextStrokePath(context);
    }];
}

@end
