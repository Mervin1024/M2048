//
//  GameViewController.h
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoundaryView.h"

typedef NS_ENUM(NSInteger, MovingDirection) {
    MovingDirectionUp,
    MovingDirectionDown,
    MovingDirectionLeft,
    MovingDirectionRight
};

@interface GameViewController : UIViewController
- (void)reStart;
@end
