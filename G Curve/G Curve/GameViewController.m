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

@end

@implementation GameViewController

- (void)loadView {
    // create and configure the table view
    GameView *gameView = [[GameView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = gameView;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}


@end
