//
//  NumberItem.m
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "NumberItem.h"

@interface NumberItem () {
    UILabel *numLabel;
    long number;
    BoundaryView *boundaryView;
}

@end

@implementation NumberItem

- (instancetype)initWithBoundaryView:(BoundaryView *)view position:(Position)position power:(NSInteger)power animation:(BOOL)animation{
    CGRect frame = [view frameAtRow:position.row column:position.column];
    self = [super initWithFrame:frame];
    if (self) {
        boundaryView = view;
        _position = position;
        _power = power;
        number = pow(2, power);
        NSString *imageName;
        if (power < 9) {
            imageName = [NSString stringWithFormat:@"%ld",number];
        }else{
            imageName = @"256";
        }
        [self setImage:[UIImage imageNamed:imageName]];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        NSInteger digits = 0;
        for (long num = number; num >= 1; num = num/10) {
            digits++;
        }
        [numLabel setFont:[UIFont boldSystemFontOfSize:36]];
        [numLabel setText:[NSString stringWithFormat:@"%ld",number]];
        [numLabel setTextColor:[UIColor whiteColor]];
        if (power < 3) {
            [numLabel setTextColor:[UIColor darkGrayColor]];
        }
        [numLabel setTextAlignment:NSTextAlignmentCenter];// 文字中心对齐
        [numLabel setAdjustsFontSizeToFitWidth:YES]; // 字体适应frame大小
        [numLabel setNumberOfLines:1]; // 行数
        [numLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters]; // 自适应的方式
        [self addSubview:numLabel];
        [view addSubview:self];
        if (animation) {
//            self.hidden = YES;
            numLabel.hidden = YES;
            [self addAppearAnimation];
        }else{
            
        }
    }
    return self;
}

- (void)setPower:(NSInteger)power{
    number = pow(2, power);
    [numLabel setText:[NSString stringWithFormat:@"%ld",number]];
    _power = power;
}

- (void)setPosition:(Position)position{
    if (position.row == _position.row && position.column == _position.column) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:[boundaryView frameAtRow:position.row column:position.column]];
    }completion:^(BOOL finished){
        if (finished) {
//            [self addCombineAnimation];
        }
    }];
    _position = position;
}

- (void)setPosition:(Position)position andPower:(NSInteger)power{
//    if (position.row == _position.row && position.column == _position.column) {
//        return;
//    }
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:[boundaryView frameAtRow:position.row column:position.column]];
    }completion:^(BOOL finished){
        if (finished) {
            [self setPower:power];
            [self addCombineAnimation];
        }
    }];
    _position = position;
}
// 合并时的动画效果
- (void)addCombineAnimation{
    [self.layer addAnimation:[self scale:@1.0 orgin:@1.2 durTimes:0.1 Rep:1] forKey:nil];
}

-(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}
// 出现时的动画效果
- (void)addAppearAnimation{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2, 0, 0);
    [self setFrame:newFrame];
//    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:frame];
    }completion:^(BOOL finished){
        if (finished) {
            numLabel.hidden = NO;
        }
    }];
}
@end
