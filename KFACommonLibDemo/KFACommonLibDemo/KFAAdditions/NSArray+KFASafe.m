//
//  NSArray+KFASafe.m
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/13.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import "NSArray+KFASafe.h"

@implementation NSArray (KFASafe)

- (id)kfa_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end

@implementation NSMutableArray (KFASafe)

- (void)kfa_addObject:(id)anObject {
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)kfa_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject != nil) {
        if ((index == 0 && self.count == 0) || index < self.count) {
            [self insertObject:anObject atIndex:index];
        }
    }
}

- (void)kfa_removeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)kfa_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)kfa_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (idx1 < self.count && idx2 < self.count) {
        [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }
}

- (void)kfa_removeObjectsInRange:(NSRange)range {
    if (range.location+range.length <= self.count) {
        [self removeObjectsInRange:range];
    }
}

@end
