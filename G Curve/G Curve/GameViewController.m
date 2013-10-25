//
//  GameViewController.m
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"

@interface GameViewController ()

@property (nonatomic, strong) GameView *gameView;

@end

@implementation GameViewController

- (void)loadView {
    self.gameView = [[GameView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = self.gameView;
    
    // Top Left
    UIButton *b0 = [UIButton buttonWithType:UIButtonTypeCustom];
    b0.tag = 0;
    [b0 setBackgroundColor:[UIColor redColor]];
    b0.frame = CGRectMake(80, 40, 80, 60);
    [b0 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b0 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b0 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b0 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b0 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b0];
    
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.tag = 1;
    [b1 setBackgroundColor:[UIColor blueColor]];
    b1.frame = CGRectMake(0, 40, 80, 60);
    [b1 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b1 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b1 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b1 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b1 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b1];
    
    
    // Bottom Left
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    b2.tag = 2;
    [b2 setBackgroundColor:[UIColor redColor]];
    b2.frame = CGRectMake(0, 768 - 80, 80, 60);
    [b2 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b2 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b2 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b2 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b2 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b2];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    b3.tag = 3;
    [b3 setBackgroundColor:[UIColor blueColor]];
    b3.frame = CGRectMake(80, 768 - 80, 80, 60);
    [b3 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b3 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b3 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b3 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b3 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b3];
    
    
    // Top Right
    UIButton *b4 = [UIButton buttonWithType:UIButtonTypeCustom];
    b4.tag = 4;
    [b4 setBackgroundColor:[UIColor redColor]];
    b4.frame = CGRectMake(1024 - 80, 40, 80, 60);
    [b4 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b4 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b4 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b4 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b4 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b4];
    
    UIButton *b5 = [UIButton buttonWithType:UIButtonTypeCustom];
    b5.tag = 5;
    [b5 setBackgroundColor:[UIColor blueColor]];
    b5.frame = CGRectMake(1024 - 160, 40, 80, 60);
    [b5 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b5 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b5 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b5 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b5 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b5];
    
    
    // Bottom Right
    UIButton *b6 = [UIButton buttonWithType:UIButtonTypeCustom];
    b6.tag = 6;
    [b6 setBackgroundColor:[UIColor redColor]];
    b6.frame = CGRectMake(1024 - 160, 768 - 80, 80, 60);
    [b6 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b6 addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b6 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b6 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b6 addTarget:self action:@selector(leftButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b6];
    
    UIButton *b7 = [UIButton buttonWithType:UIButtonTypeCustom];
    b7.tag = 7;
    [b7 setBackgroundColor:[UIColor blueColor]];
    b7.frame = CGRectMake(1024 - 80, 768 - 80, 80, 60);
    [b7 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [b7 addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [b7 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [b7 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchDragExit];
    [b7 addTarget:self action:@selector(rightButtonReleased:) forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:b7];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (void)leftButtonPressed:(UIButton *)sender {
    [self.gameView setTurnDirectionForPlayerAtIndex:sender.tag/2 withDirection:PlayerTurnDirectionLeft];
}

- (void)rightButtonPressed:(UIButton *)sender {
    [self.gameView setTurnDirectionForPlayerAtIndex:sender.tag/2 withDirection:PlayerTurnDirectionRight];
}

- (void)leftButtonReleased:(UIButton *)sender {
    [self.gameView setTurnDirectionForPlayerAtIndex:sender.tag/2 withDirection:PlayerTurnDirectionNone];
}

- (void)rightButtonReleased:(UIButton *)sender {
    [self.gameView setTurnDirectionForPlayerAtIndex:sender.tag/2 withDirection:PlayerTurnDirectionNone];
}

@end
