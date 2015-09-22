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
        case MovingDirectionUp:
            for (int i = 0; i < 4; i++) {
                NSArray *columns = @[positionsArray[0+i],positionsArray[4+i],positionsArray[8+i],positionsArray[12+i]];
                NSInteger moveSpace = 0;
                for (int j = 0; j < 4; j++) {
                    if ([columns[j] integerValue] == 1) {
                        //   蛋疼
                    }else{
                        moveSpace++;
                    }
                }
            }
            
            break;
        case MovingDirectionDown:
            
            break;
        case MovingDirectionLeft:
            
            break;
        case MovingDirectionRight:
            
            break;
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
