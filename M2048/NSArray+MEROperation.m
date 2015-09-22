//
//  NSArray+MEROperation.m
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "NSArray+MEROperation.h"

@implementation NSArray (MEROperation)

- (NSArray *)arrayBySelect:(BOOL(^)(id))select{
    NSMutableArray *arr = [NSMutableArray array];
    for (id item in self) {
        if (select(item)) {
            [arr addObject:item];
        }
    }
    return arr;
}

- (NSArray *)arrayByMap:(id(^)(id))map{
    NSMutableArray *arr = [NSMutableArray array];
    for (id item in self) {
        id new = map(item);
        [arr addObject:new];
    }
    return arr;
}

- (void)operationArray:(void(^)(id))operation{
    for (id item in self) {
        operation(item);
    }
}

@end
