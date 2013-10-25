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

@property BOOL turningLeft;
@property BOOL turningRight;

@property BOOL wasTurningLeftLastFrame;
@property BOOL wasTurningRightLastFrame;

@property CADisplayLink *displayLink;

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic) CGMutablePathRef savedPath;

@property (nonatomic, retain) NSMutableArray *players;

@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.path = CGPathCreateMutable();
        self.players = [@[[Player new]] mutableCopy];
        
        [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
            player.loc = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
            CGPathMoveToPoint(self.path, NULL, player.loc.x, player.loc.y);
        }];
        
        self.savedPath = CGPathCreateMutableCopy(self.path);
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSRunLoopCommonModes];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)update:(CADisplayLink *)sender {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        
        if (self.turningLeft) {
            CGPoint center = CGPointMake(player.loc.x + cos(player.angle-M_PI_2)*RADIUS,
                                         player.loc.y + sin(player.angle-M_PI_2)*RADIUS);
            CGFloat startAngle = atan2(player.loc.y - center.y,
                                       player.loc.x - center.x);
            if (self.wasTurningLeftLastFrame) {
                player.turnArcAngle += 0.1;
                CGPathRelease(self.path);
                self.path = CGPathCreateMutableCopy(self.savedPath);
                
                [self checkCollision:CGPointMake(center.x + cos(startAngle - player.turnArcAngle-0.1)*RADIUS,
                                                 center.y + sin(startAngle - player.turnArcAngle-0.1)*RADIUS)];
            } else {
                player.turnArcAngle = 0;
                CGPathRelease(self.savedPath);
                self.savedPath = CGPathCreateMutableCopy(self.path);
            }
            
            
            CGPathAddArc(self.path, NULL,
                         center.x, center.y,
                         RADIUS,
                         startAngle, startAngle - player.turnArcAngle,
                         YES);
            
            
            
            self.wasTurningLeftLastFrame = YES;
            self.wasTurningRightLastFrame = NO;
            
        } else if (self.turningRight) {
            CGPoint center = CGPointMake(player.loc.x + cos(player.angle+M_PI_2)*RADIUS,
                                         player.loc.y + sin(player.angle+M_PI_2)*RADIUS);
            CGFloat startAngle = atan2(player.loc.y - center.y,
                                       player.loc.x - center.x);
            if (self.wasTurningRightLastFrame) {
                player.turnArcAngle -= 0.1;
                CGPathRelease(self.path);
                self.path = CGPathCreateMutableCopy(self.savedPath);
                
                [self checkCollision:CGPointMake(center.x + cos(startAngle - player.turnArcAngle+0.1)*RADIUS,
                                                 center.y + sin(startAngle - player.turnArcAngle+0.1)*RADIUS)];
                
            } else {
                player.turnArcAngle = 0;
                CGPathRelease(self.savedPath);
                self.savedPath = CGPathCreateMutableCopy(self.path);
            }
            
            
            CGPathAddArc(self.path, NULL,
                         center.x, center.y,
                         RADIUS,
                         startAngle, startAngle - player.turnArcAngle,
                         NO);
            
            
            self.wasTurningRightLastFrame = YES;
            self.wasTurningLeftLastFrame = NO;
            
        } else {
            BOOL wasStraightLastFrame = !self.wasTurningLeftLastFrame && !self.wasTurningRightLastFrame;
            
            if (wasStraightLastFrame) {
                CGPathRelease(self.path);
                self.path = CGPathCreateMutableCopy(self.savedPath);
                
                [self checkCollision:CGPointMake(player.loc.x + cos(player.angle)*VELOCITY,
                                                 player.loc.y + sin(player.angle)*VELOCITY)];
            } else {
                if (self.wasTurningLeftLastFrame) {
                    CGPoint center = CGPointMake(player.loc.x + cos(player.angle-M_PI_2)*RADIUS,
                                                 player.loc.y + sin(player.angle-M_PI_2)*RADIUS);
                    CGFloat startAngle = atan2(player.loc.y - center.y,
                                               player.loc.x - center.x);
                    player.loc = CGPointMake(center.x + cos(startAngle - player.turnArcAngle)*RADIUS,
                                             center.y + sin(startAngle - player.turnArcAngle)*RADIUS);
                    
                    CGPathMoveToPoint(self.path, NULL, player.loc.x, player.loc.y);
                    
                    player.angle = (startAngle - player.turnArcAngle) - M_PI_2;
                }
                if (self.wasTurningRightLastFrame) {
                    CGPoint center = CGPointMake(player.loc.x + cos(player.angle+M_PI_2)*RADIUS,
                                                 player.loc.y + sin(player.angle+M_PI_2)*RADIUS);
                    CGFloat startAngle = atan2(player.loc.y - center.y,
                                               player.loc.x - center.x);
                    player.loc = CGPointMake(center.x + cos(startAngle - player.turnArcAngle)*RADIUS,
                                             center.y + sin(startAngle - player.turnArcAngle)*RADIUS);
                    
                    CGPathMoveToPoint(self.path, NULL, player.loc.x, player.loc.y);
                    
                    player.angle = (startAngle - player.turnArcAngle) + M_PI_2;
                }
                CGPathRelease(self.savedPath);
                self.savedPath = CGPathCreateMutableCopy(self.path);
            }
            
            
            player.loc = CGPointMake(player.loc.x + cos(player.angle)*VELOCITY,
                                     player.loc.y + sin(player.angle)*VELOCITY);
            

            CGPathAddLineToPoint(self.path, NULL, player.loc.x, player.loc.y);
            self.wasTurningLeftLastFrame = NO;
            self.wasTurningRightLastFrame = NO;
        }
        
        
        [self setNeedsDisplay];
    }];
}

- (void)checkCollision:(CGPoint)point {
    CGPathRef thing = CGPathCreateCopyByStrokingPath(self.savedPath, NULL, LINE_WIDTH, LINE_CAP, kCGLineJoinRound, 0);
    if (CGPathContainsPoint(thing, NULL, point, NO)) {
        [self.displayLink invalidate];
    }
    CGPathRelease(thing);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.x < self.frame.size.width / 2.0f) {
        self.turningRight = NO;
        self.turningLeft = YES;
    } else {
        self.turningLeft = NO;
        self.turningRight = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (point.x < self.frame.size.width / 2.0f) {
        self.turningRight = NO;
        self.turningLeft = YES;
    } else {
        self.turningLeft = NO;
        self.turningRight = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.turningLeft = NO;
    self.turningRight = NO;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetMiterLimit(context, 0);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetLineCap(context, LINE_CAP);
    CGContextSetAllowsAntialiasing(context, NO);
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextAddPath(context, self.path);
    CGContextStrokePath(context);
}

@end
