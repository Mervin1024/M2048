//
//  GameViewController.m
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "GameViewController.h"
#import "BoundaryView.h"
#import "NumberItem.h"

@interface GameViewController () {
    BoundaryView *boundaryView;
    NSMutableArray *items;
    NSMutableArray *positionsArray;
    BOOL moveEnable;
    CGPoint touchPoint;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    moveEnable = NO;
    items = [NSMutableArray arrayWithCapacity:16];
    positionsArray = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,  @0,@0,@0,@0,  @0,@0,@0,@0,  @0,@0,@0,@0 ]];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-52);
    [self.view setFrame:CGRectMake(26, [UIScreen mainScreen].bounds.size.height-100-width, width, width)];
    boundaryView = [[BoundaryView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self.view addSubview:boundaryView];
    
    [self addNewNumberItemWithAnimation:NO];
    [self addNewNumberItemWithAnimation:NO];
//    [self performSelector:@selector(move) withObject:nil afterDelay:3];
}

//- (void)move{
//    
//    NumberItem *item = items[0];
//    NSLog(@"move before:%ld,%ld",item.position.row,item.position.column);
//    [item setPosition:(Position){0,item.position.column}];
//    NSLog(@"move after:%ld,%ld",item.position.row,item.position.column);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addNewNumberItemWithAnimation:(BOOL)animation{
    Position p = [self positionRandom];
    positionsArray[p.row*4+p.column] = @1;
    NSInteger power = (arc4random() % 2)+1;
    NumberItem *item = [[NumberItem alloc] initWithBoundaryView:boundaryView position:p power:power animation:animation];
    [items addObject:item];
}

- (id)randomFromArray:(NSArray *)arr{
    NSInteger a = arc4random() % arr.count;
    return arr[a];
}

- (Position)positionRandom{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:16];
    for (int i = 0; i < positionsArray.count; i++) {
        if ([positionsArray[i] integerValue] == 0) {
            [arr addObject:@(i)];
        }
    }
    NSInteger a = [[self randomFromArray:arr] integerValue];
    Position p;
    p.row = a/4;
    p.column = a%4;
    return p;
}
#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    moveEnable = YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    touchPoint = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (!moveEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGFloat x = fabs(point.x - touchPoint.x);
    CGFloat y = fabs(point.y - touchPoint.y);
    if (x > 30) {
        NSLog(@"横移");
        moveEnable = NO;
    }else if (y > 30){
        NSLog(@"竖移");
        moveEnable = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    moveEnable = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    moveEnable = NO;
}
@end
