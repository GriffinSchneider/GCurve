//
//  GameView.m
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import "GameView.h"

#define VELOCITY 2.0
#define TURN_VELOCITY 0.08

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
        self.players = [@[[Player newWithColor:[UIColor orangeColor]],
                          [Player newWithColor:[UIColor blueColor]],
                          [Player newWithColor:[UIColor brownColor]],
                          [Player newWithColor:[UIColor greenColor]]] mutableCopy];
        
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
    __block NSUInteger numDeadPlayers = 0;
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        
        if (player.dead) {
            numDeadPlayers++;
            return;
        }
        
        if (player.turnDirection == PlayerTurnDirectionLeft) {
            CGPoint center = CGPointMake(player.loc.x + cos(player.angle-M_PI_2)*RADIUS,
                                         player.loc.y + sin(player.angle-M_PI_2)*RADIUS);
            CGFloat startAngle = atan2(player.loc.y - center.y,
                                       player.loc.x - center.x);
            if (player.turnDirectionLastFrame == PlayerTurnDirectionLeft) {
                player.turnArcAngle += TURN_VELOCITY;
                CGPathRelease(player.path);
                player.path = CGPathCreateMutableCopy(player.savedPath);
                
                [self checkCollision:CGPointMake(center.x + cos(startAngle - player.turnArcAngle-TURN_VELOCITY)*RADIUS,
                                                 center.y + sin(startAngle - player.turnArcAngle-TURN_VELOCITY)*RADIUS)
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
                player.turnArcAngle -= TURN_VELOCITY;
                CGPathRelease(player.path);
                player.path = CGPathCreateMutableCopy(player.savedPath);
                
                [self checkCollision:CGPointMake(center.x + cos(startAngle - player.turnArcAngle+TURN_VELOCITY)*RADIUS,
                                                 center.y + sin(startAngle - player.turnArcAngle+TURN_VELOCITY)*RADIUS)
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
                
                [self checkCollision:CGPointMake(player.loc.x + cos(player.angle)*(VELOCITY+1),
                                                 player.loc.y + sin(player.angle)*(VELOCITY+1))
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
        
        
        // TODO: WTF is going on with my frame?
        if (!CGRectContainsPoint(CGRectMake(0, 0, 1024, 786), player.loc)) {
            player.dead = YES;
        }
        
        [self setNeedsDisplay];
    }];
    
    if (numDeadPlayers == self.players.count) {
        // lol.
        exit(0);
    }
}

- (void)checkCollision:(CGPoint)point withPlayer:(Player *)controllingPlayer {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        CGPathRef pathToCheck = (controllingPlayer == player) ? player.savedPath : player.path;
        CGPathRef thing = CGPathCreateCopyByStrokingPath(pathToCheck, NULL, LINE_WIDTH, LINE_CAP, kCGLineJoinRound, 0);
        if (CGPathContainsPoint(thing, NULL, point, NO)) {
            controllingPlayer.dead = YES;
        }
        CGPathRelease(thing);
    }];
}

- (void)setTurnDirectionForPlayerAtIndex:(NSUInteger)index withDirection:(PlayerTurnDirection)direction {
    Player *player = [self.players objectAtIndex:index];
    player.turnDirection = direction;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetMiterLimit(context, 0);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetLineCap(context, LINE_CAP);
    CGContextSetAllowsAntialiasing(context, NO);
    
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        CGContextSetStrokeColorWithColor(context, [player.color CGColor]);
        CGContextAddPath(context, player.path);
        CGContextStrokePath(context);
    }];
}

@end
