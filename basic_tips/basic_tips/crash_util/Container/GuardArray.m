//
//  NSMutableArray+Guard.m
//  OPCategories
//
//  Created by 李威 on 2019/2/16.
//  Copyright © 2019年 Opera Software. All rights reserved.
//

#import "GuardArray.h"

@implementation NSMutableArray (Guard)
- (id)objectSafeAtIndex:(NSUInteger)index {
    if (index >= self.count) {
#ifdef DEBUG
        NSAssert(NO, @"Error objectAtIndex");
#endif
        return nil;
    }
    return [self objectAtIndex:index];
}

- (void)insertSafeObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count || !anObject) {
#ifdef DEBUG
        NSAssert(NO, @"Error insertObject");
#endif
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)insertSafeObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (indexes.firstIndex > self.count || !objects) {
#ifdef DEBUG
        NSAssert(NO, @"Error insertObjects");
#endif
        return;
    }
    [self insertObjects:objects atIndexes:indexes];
}

#pragma mark - for test
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if (index >= self.count && !anObject) {
        return;
    }
    [self safeInsertObject:anObject atIndex:index];
}

- (void)safeRemoveObject:(id)anObject{
    if (anObject) {
        [self safeRemoveObject:anObject];
    }
}

- (void)safeAddObjectsFromArray:(NSArray *)otherArray{
    if (otherArray) {
        [self safeAddObjectsFromArray:otherArray];
    }
}

@end

@implementation NSArray (Guard)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self safeObjectAtIndex:index];
}

- (id)safeArray0ObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self safeArray0ObjectAtIndex:index];
}

- (id)safeSingleArrayObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self safeSingleArrayObjectAtIndex:index];
}

+ (instancetype)safeArrayWithObjects:(const id [])objects count:(NSUInteger)count {
    for (int i=0; i<count; i++) {
        id objc = objects[i];
        if (objc == nil) {
            return nil;
        }
    }
    return [self safeArrayWithObjects:objects count:count];
}

#pragma mark - todo: delete

- (id)objectSafeAtIndex:(NSUInteger)index {
    if (index >= self.count) {
#ifdef DEBUG
        NSAssert(NO, @"Error objectAtIndex");
#endif
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSUInteger)indexSafeOfObject:(id)anObject {
    if (!anObject) {
#ifdef DEBUG
        NSAssert(NO, @"Error indexOfObject");
#endif
        return 0;
    }
    return [self indexOfObject:anObject];
}

@end
