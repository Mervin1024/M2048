//
//  NSArray+MEROperation.h
//  M2048
//
//  Created by sh219 on 15/9/22.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MEROperation)

- (NSArray *)arrayBySelect:(BOOL(^)(id))select;
- (NSArray *)arrayByMap:(id(^)(id))map;
- (void)operationArray:(void(^)(id))operation;

@end
