//
//  BoundaryView.m
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "BoundaryView.h"
#define BOUND_WIDTH_SCALE 3.5/100

@interface BoundaryView () {
    NSArray *coordinateArray;
}

@end

@implementation BoundaryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfiguration];
        [self setImage:[UIImage imageNamed:@"BoundaryView"]];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    super.frame = frame;
    [self setConfiguration];
}

- (void)setConfiguration{
    CGFloat width = self.frame.size.width;
    CGFloat itemWidth = width*(1-BOUND_WIDTH_SCALE*5)/4;
    NSMutableArray *config = [NSMutableArray arrayWithCapacity:16];
    for (int x = 1; x < 5; x++) {
        for (int y = 1; y < 5; y++) {
            CGRect yFrame = CGRectMake(BOUND_WIDTH_SCALE*width*y+itemWidth*(y-1), BOUND_WIDTH_SCALE*width*x+itemWidth*(x-1), itemWidth, itemWidth);
            NSValue *value = [NSValue valueWithBytes:&yFrame objCType:@encode(CGRect)];
            [config addObject:value];
        }
    }
    _boundWidth = BOUND_WIDTH_SCALE*width;
    _numItemWidth = itemWidth;
//    CGRect itemFrame;
//    [config[0] getValue:&itemFrame];
//    _configuration.x0y0 = itemFrame;
//    [config[1] getValue:&itemFrame];
//    _configuration.x0y1 = itemFrame;
//    [config[2] getValue:&itemFrame];
//    _configuration.x0y2 = itemFrame;
//    [config[3] getValue:&itemFrame];
//    _configuration.x0y3 = itemFrame;
//    [config[4] getValue:&itemFrame];
//    _configuration.x1y0 = itemFrame;
//    [config[5] getValue:&itemFrame];
//    _configuration.x1y1 = itemFrame;
//    [config[6] getValue:&itemFrame];
//    _configuration.x1y2 = itemFrame;
//    [config[7] getValue:&itemFrame];
//    _configuration.x1y3 = itemFrame;
//    [config[8] getValue:&itemFrame];
//    _configuration.x2y0 = itemFrame;
//    [config[9] getValue:&itemFrame];
//    _configuration.x2y1 = itemFrame;
//    [config[10] getValue:&itemFrame];
//    _configuration.x2y2 = itemFrame;
//    [config[11] getValue:&itemFrame];
//    _configuration.x2y3 = itemFrame;
//    [config[12] getValue:&itemFrame];
//    _configuration.x3y0 = itemFrame;
//    [config[13] getValue:&itemFrame];
//    _configuration.x3y1 = itemFrame;
//    [config[14] getValue:&itemFrame];
//    _configuration.x3y2 = itemFrame;
//    [config[15] getValue:&itemFrame];
//    _configuration.x3y3 = itemFrame;
    coordinateArray = config;
}

- (CGRect)frameAtRow:(Row)x column:(Column)y{
    NSInteger z = x*4+y;
    CGRect frame;
    [coordinateArray[z] getValue:&frame];
    return frame;
}

@end
