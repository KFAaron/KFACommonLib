//
//  NSArray+KFASafe.h
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/13.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (KFASafe)

- (id)kfa_objectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (KFASafe)

- (void)kfa_addObject:(id)anObject;
- (void)kfa_insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)kfa_removeObjectAtIndex:(NSUInteger)index;
- (void)kfa_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)kfa_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)kfa_removeObjectsInRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
