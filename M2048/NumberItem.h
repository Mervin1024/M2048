//
//  NumberItem.h
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoundaryView.h"

@interface NumberItem : UIImageView

@property (nonatomic, assign) NSInteger power;
@property (nonatomic, assign) Position position;
- (void)setPosition:(Position)position;
- (void)setPosition:(Position)position andPower:(NSInteger)power;

- (instancetype)initWithBoundaryView:(BoundaryView *)view position:(Position)position power:(NSInteger)power animation:(BOOL)animation;

- (void)addAppearAnimation;
- (void)addCombineAnimation;
@end
