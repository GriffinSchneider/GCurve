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

@interface GameView()

@property BOOL turningLeft;
@property BOOL turningRight;

@property CADisplayLink *displayLink;

@property (nonatomic) CGMutablePathRef path;

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
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                               forMode:NSRunLoopCommonModes];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)update:(CADisplayLink *)sender {
    [self.players enumerateObjectsUsingBlock:^(Player *player, NSUInteger idx, BOOL *stop) {
        player.loc = CGPointMake(player.loc.x + cos(player.angle)*VELOCITY,
                                 player.loc.y + sin(player.angle)*VELOCITY);
        
        CGPathAddLineToPoint(self.path, NULL, player.loc.x, player.loc.y);
        
        if (self.turningLeft) {
            player.angle -= TURN_RADS_PER_FRAME;
        } else if (self.turningRight) {
            player.angle += TURN_RADS_PER_FRAME;
        }
        
        [self setNeedsDisplay];
    }];
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
    CGContextSetLineWidth(context, 8);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextAddPath(context, self.path);
    CGContextStrokePath(context);
}

@end
