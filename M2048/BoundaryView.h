//
//  BoundaryView.h
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef struct {
//    CGRect x0y0;   // 第一行
//    CGRect x0y1;
//    CGRect x0y2;
//    CGRect x0y3;
//    CGRect x1y0;   // 第二行
//    CGRect x1y1;
//    CGRect x1y2;
//    CGRect x1y3;
//    CGRect x2y0;   // 第三行
//    CGRect x2y1;
//    CGRect x2y2;
//    CGRect x2y3;
//    CGRect x3y0;   // 第四行
//    CGRect x3y1;
//    CGRect x3y2;
//    CGRect x3y3;
//}Configuration;
typedef NS_ENUM(NSInteger, Row) {
    Row_1 = 0,
    Row_2 = 1,
    Row_3 = 2,
    Row_4 = 3
};

typedef NS_ENUM(NSInteger, Column) {
    Column_1 = 0,
    Column_2 = 1,
    Column_3 = 2,
    Column_4 = 3
};

typedef struct {
    Row row;
    Column column;
}Position;

@interface BoundaryView : UIImageView

//@property (nonatomic, assign, readonly) Configuration configuration;
@property (nonatomic, assign) CGFloat boundWidth;
@property (nonatomic, assign) CGFloat numItemWidth;

- (CGRect)frameAtRow:(Row)x column:(Column)y; 
@end
