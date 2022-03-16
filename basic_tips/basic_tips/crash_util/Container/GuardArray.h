//
//  NSMutableArray+Guard.h
//  OPCategories
//
//  Created by 李威 on 2019/2/16.
//  Copyright © 2019年 Opera Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Guard)

- (id)objectSafeAtIndex:(NSUInteger)index;
- (void)insertSafeObject:(id)anObject atIndex:(NSUInteger)index;
- (void)insertSafeObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
@end

@interface NSArray (Guard)
- (id)safeObjectAtIndex:(NSUInteger)index;
+ (instancetype)safeArrayWithObjects:(const id [])objects count:(NSUInteger)count;
- (id)safeArray0ObjectAtIndex:(NSUInteger)index;
- (id)safeSingleArrayObjectAtIndex:(NSUInteger)index;

//todo:delete:
- (id)objectSafeAtIndex:(NSUInteger)index;
- (NSUInteger)indexSafeOfObject:(id)anObject;
@end

NS_ASSUME_NONNULL_END
