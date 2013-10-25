//
//  GameView.h
//  G Curve
//
//  Created by Griffin Schneider on 10/24/13.
//  Copyright (c) 2013 Griffin Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface GameView : UIView

- (void)setTurnDirectionForPlayerAtIndex:(NSUInteger)index withDirection:(PlayerTurnDirection)direction;

@end
