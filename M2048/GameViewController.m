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
#import "NSArray+MEROperation.h"

@interface GameViewController () {
    BoundaryView *boundaryView;
    NSMutableDictionary *items;
    NSMutableArray *positionsArray;
    BOOL moveEnable;
    CGPoint touchPoint;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    moveEnable = NO;
    items = [NSMutableDictionary dictionaryWithCapacity:16];
    positionsArray = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0,  @0,@0,@0,@0,  @0,@0,@0,@0,  @0,@0,@0,@0 ]];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-52);
    [self.view setFrame:CGRectMake(26, [UIScreen mainScreen].bounds.size.height-100-width, width, width)];
    boundaryView = [[BoundaryView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self.view addSubview:boundaryView];
    
    [self addNewNumberItemWithAnimation:NO];
    [self addNewNumberItemWithAnimation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addNewNumberItemWithAnimation:(BOOL)animation{
    if ([self arrayOfSurplusPositions].count == 0) {
        NSLog(@"full");
        return;
    }
    Position p = [self positionRandom];
    NSInteger index = p.row*4+p.column;
    positionsArray[index] = @1;
    NSInteger power = (arc4random() % 2)+1;
    NumberItem *item = [[NumberItem alloc] initWithBoundaryView:boundaryView position:p power:power animation:animation];
    [items setObject:item forKey:[NSString stringWithFormat:@"%ld",index]];
}

- (NSArray *)arrayOfSurplusPositions{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:16];
    for (int i = 0; i < positionsArray.count; i++) {
        if ([positionsArray[i] integerValue] == 0) {
            [arr addObject:@(i)];
        }
    }
    return arr;
}

- (id)randomFromArray:(NSArray *)arr{
    NSInteger a = arc4random() % arr.count;
    return arr[a];
}

- (Position)positionRandom{
    NSArray *arr = [self arrayOfSurplusPositions];
    NSInteger a = [[self randomFromArray:arr] integerValue];
    Position p;
    p.row = a/4;
    p.column = a%4;
    return p;
}
#pragma mark - move and combine

- (void)moveWithMovingDirection:(MovingDirection)movingDirection{
    switch (movingDirection) {
        case MovingDirectionUp:{
            for (int i = 0; i < 4; i++) {
//                NSLog(@"------------上移----------");
//                NSLog(@"-----------第%d列---------",i);
                NSArray *columns = @[positionsArray[0+i],positionsArray[4+i],positionsArray[8+i],positionsArray[12+i]];
//                NSLog(@"初始:%@",columns);
                NSMutableArray *columnItems = [NSMutableArray arrayWithCapacity:4];
                for (int j = 0; j < 4; j++) {
                    NSNumber *number = columns[j];
                    if ([number integerValue] == 1) {
//                        NSLog(@"有数字的方格:%d",j*4+i);
                        NumberItem *item = [items objectForKey:[NSString stringWithFormat:@"%d",j*4+i]];
                        [items removeObjectForKey:[NSString stringWithFormat:@"%d",j*4+i]];
                        [columnItems addObject:item];
                    }
                }
//                NSLog(@"筛选过后:%lu",(unsigned long)columnItems.count);
                if (columnItems.count == 0) {
                    continue;
                }
                NSMutableArray *newColumnItems = [NSMutableArray arrayWithCapacity:4];
                NSInteger pow = 0;
                for (int k = 0; k < columnItems.count; k++) {
                    NumberItem *item = columnItems[k];
                    if (item.power != pow) {
                        
                    }else{
                        NumberItem *ite = columnItems[k-1];
                        if (ite.CombineEnable) {
                            item.CombineEnable = NO;
                            Position p;
                            p.row = newColumnItems.count-1;
                            p.column = i;
                            [ite setPosition:p dealloc:YES];
                            [newColumnItems removeLastObject];
                        }
                    }
                    [newColumnItems addObject:item];
                    pow = item.power;
                }
//                NSLog(@"合并后:%ld",newColumnItems.count);
                for (int m = 0; m < 4; m++) {
                    positionsArray[m*4+i] = @0;
                    
                }
                for (int l = 0; l < newColumnItems.count; l++) {
                    NumberItem *item = newColumnItems[l];
                    Position p;
                    p.row = l;
                    p.column = i;
                    if (!item.CombineEnable) {
                        NSInteger power = item.power+1;
                        [item setPosition:p andPower:power];
                    }else{
                        [item setPosition:p];
                    }
                    [items setObject:item forKey:[NSString stringWithFormat:@"%d",l*4+i]];
                    positionsArray[l*4+i] = @1;
                }
//                NSLog(@"-------最终:\n%@,\n%@,\n%@,\n%@\n--------",positionsArray[0+i],positionsArray[4+i],positionsArray[8+i],positionsArray[12+i]);
            }
            
            break;
        }
        case MovingDirectionDown:{
            for (int i = 0; i < 4; i++) {
//                NSLog(@"------------下移----------");
//                NSLog(@"-----------第%d列---------",i);
                NSArray *columns = @[positionsArray[12+i],positionsArray[8+i],positionsArray[4+i],positionsArray[0+i]];
//                NSLog(@"初始:%@",columns);
                NSMutableArray *columnItems = [NSMutableArray arrayWithCapacity:4];
                for (int j = 0; j < 4; j++) {
                    NSNumber *number = columns[j];
                    if ([number integerValue] == 1) {
                        //                        NSLog(@"有数字的方格:%d",j*4+i);
                        NumberItem *item = [items objectForKey:[NSString stringWithFormat:@"%d",(3-j)*4+i]];
                        [items removeObjectForKey:[NSString stringWithFormat:@"%d",(3-j)*4+i]];
                        [columnItems addObject:item];
                    }
                }
                if (columnItems.count == 0) {
                    continue;
                }
                NSMutableArray *newColumnItems = [NSMutableArray arrayWithCapacity:4];
                NSInteger pow = 0;
                for (int k = 0; k < columnItems.count; k++) {
                    NumberItem *item = columnItems[k];
                    if (item.power != pow) {
                        
                    }else{
                        NumberItem *ite = columnItems[k-1];
                        if (ite.CombineEnable) {
                            item.CombineEnable = NO;
                            Position p;
                            p.row = 3-(newColumnItems.count-1);
                            p.column = i;
                            [ite setPosition:p dealloc:YES];
                            [newColumnItems removeLastObject];
                        }
                    }
                    [newColumnItems addObject:item];
                    pow = item.power;
                }
                //                NSLog(@"合并后:%ld",newColumnItems.count);
                for (int m = 0; m < 4; m++) {
                    positionsArray[m*4+i] = @0;
                    
                }
                for (int l = 0; l < newColumnItems.count; l++) {
                    NumberItem *item = newColumnItems[l];
                    Position p;
                    p.row = 3-l;
                    p.column = i;
                    if (!item.CombineEnable) {
                        NSInteger power = item.power+1;
                        [item setPosition:p andPower:power];
                    }else{
                        [item setPosition:p];
                    }
                    [items setObject:item forKey:[NSString stringWithFormat:@"%d",(3-l)*4+i]];
                    positionsArray[(3-l)*4+i] = @1;
                }
//                NSLog(@"-------最终:\n%@,\n%@,\n%@,\n%@\n--------",positionsArray[0+i],positionsArray[4+i],positionsArray[8+i],positionsArray[12+i]);
            }
            break;
        }
        case MovingDirectionLeft:{
            for (int i = 0; i < 4; i++) {
//                NSLog(@"------------左移----------");
//                NSLog(@"-----------第%d行---------",i);
                NSArray *columns = @[positionsArray[i*4+0],positionsArray[i*4+1],positionsArray[i*4+2],positionsArray[i*4+3]];
//                NSLog(@"初始:%@",columns);
                NSMutableArray *columnItems = [NSMutableArray arrayWithCapacity:4];
                for (int j = 0; j < 4; j++) {
                    NSNumber *number = columns[j];
                    if ([number integerValue] == 1) {
//                        NSLog(@"有数字的方格:%d",j*4+i);
                        NumberItem *item = [items objectForKey:[NSString stringWithFormat:@"%d",i*4+j]];
                        [items removeObjectForKey:[NSString stringWithFormat:@"%d",i*4+j]];
                        [columnItems addObject:item];
                    }
                }
                if (columnItems.count == 0) {
                    continue;
                }
                NSMutableArray *newColumnItems = [NSMutableArray arrayWithCapacity:4];
                NSInteger pow = 0;
                for (int k = 0; k < columnItems.count; k++) {
                    NumberItem *item = columnItems[k];
                    if (item.power != pow) {
                        
                    }else{
                        NumberItem *ite = columnItems[k-1];
                        if (ite.CombineEnable) {
                            item.CombineEnable = NO;
                            Position p;
                            p.row = i;
                            p.column = newColumnItems.count-1;
                            [ite setPosition:p dealloc:YES];
                            [newColumnItems removeLastObject];
                        }
                    }
                    [newColumnItems addObject:item];
                    pow = item.power;
                }
//                NSLog(@"合并后:%ld",newColumnItems.count);
                for (int m = 0; m < 4; m++) {
                    positionsArray[i*4+m] = @0;
                    
                }
                for (int l = 0; l < newColumnItems.count; l++) {
                    NumberItem *item = newColumnItems[l];
                    Position p;
                    p.row = i;
                    p.column = l;
                    if (!item.CombineEnable) {
                        NSInteger power = item.power+1;
                        [item setPosition:p andPower:power];
                    }else{
                        [item setPosition:p];
                    }
                    [items setObject:item forKey:[NSString stringWithFormat:@"%d",i*4+l]];
                    positionsArray[i*4+l] = @1;
                }
//                NSLog(@"-------最终:\n%@,\n%@,\n%@,\n%@\n--------",positionsArray[0+i],positionsArray[4+i],positionsArray[8+i],positionsArray[12+i]);
            }
            break;
        }
        case MovingDirectionRight:{
            for (int i = 0; i < 4; i++) {
//                NSLog(@"------------右移----------");
//                NSLog(@"-----------第%d行---------",i);
                NSArray *columns = @[positionsArray[i*4+3],positionsArray[i*4+2],positionsArray[i*4+1],positionsArray[i*4+0]];
//                NSLog(@"初始:%@",columns);
                NSMutableArray *columnItems = [NSMutableArray arrayWithCapacity:4];
                for (int j = 0; j < 4; j++) {
                    NSNumber *number = columns[j];
                    if ([number integerValue] == 1) {
//                        NSLog(@"有数字的方格:%d",j*4+i);
                        NumberItem *item = [items objectForKey:[NSString stringWithFormat:@"%d",i*4+(3-j)]];
                        [items removeObjectForKey:[NSString stringWithFormat:@"%d",i*4+(3-j)]];
                        [columnItems addObject:item];
                    }
                }
                if (columnItems.count == 0) {
                    continue;
                }
                NSMutableArray *newColumnItems = [NSMutableArray arrayWithCapacity:4];
                NSInteger pow = 0;
                for (int k = 0; k < columnItems.count; k++) {
                    NumberItem *item = columnItems[k];
                    if (item.power != pow) {
                        
                    }else{
                        NumberItem *ite = columnItems[k-1];
                        if (ite.CombineEnable) {
                            item.CombineEnable = NO;
                            Position p;
                            p.row = i;
                            p.column = 3-(newColumnItems.count-1);
                            [ite setPosition:p dealloc:YES];
                            [newColumnItems removeLastObject];
                        }
                    }
                    [newColumnItems addObject:item];
                    pow = item.power;
                }
//                NSLog(@"合并后:%ld",newColumnItems.count);
                for (int m = 0; m < 4; m++) {
                    positionsArray[i*4+m] = @0;
                    
                }
                for (int l = 0; l < newColumnItems.count; l++) {
                    NumberItem *item = newColumnItems[l];
                    Position p;
                    p.row = i;
                    p.column = 3-l;
                    if (!item.CombineEnable) {
                        NSInteger power = item.power+1;
                        [item setPosition:p andPower:power];
                    }else{
                        [item setPosition:p];
                    }
                    [items setObject:item forKey:[NSString stringWithFormat:@"%d",i*4+(3-l)]];
                    positionsArray[i*4+(3-l)] = @1;
                }
//                NSLog(@"-------最终:\n%@,\n%@,\n%@,\n%@\n--------",positionsArray[0+i],positionsArray[4+i],positionsArray[8+i],positionsArray[12+i]);
            }
            break;
        }
    }
    
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
    MovingDirection movingDirection;
    if (x > 30 || y > 30) {
        if (x > 30) {
            if (point.x > touchPoint.x) {
                NSLog(@"右移");
                movingDirection = MovingDirectionRight;
            }else{
                NSLog(@"左移");
                movingDirection = MovingDirectionLeft;
            }
        }else{
            if (point.y > touchPoint.y) {
                NSLog(@"下移");
                movingDirection = MovingDirectionDown;
            }else{
                NSLog(@"上移");
                movingDirection = MovingDirectionUp;
            }
        }
        
        moveEnable = NO;
        [self moveWithMovingDirection:movingDirection];
        [self addNewNumberItemWithAnimation:YES];
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
