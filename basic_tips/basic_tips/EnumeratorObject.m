//
//  EnumeratorObject.m
//  demo
//
//  Created by lw on 17/3/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EnumeratorObject.h"

@implementation EnumeratorObject


#pragma mark - NSEnumerator类遍历

- (void)collectionEnumerator {

    NSArray *anArray;
    NSEnumerator *enumerator = [anArray objectEnumerator];
    id objectArray;
    while ((objectArray = [enumerator nextObject]) != nil) {
        NSLog(@"数组遍历");
    }
    
    [anArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (true/*stop*/) {
            //obj：对象
            //idx：下标
            *stop = YES;
        }
    }];
    
    
    NSDictionary *aDictionary;
    enumerator = [aDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]) != nil) {
        id value = aDictionary[key];
        NSLog(@"字典遍历");
    }
    
    NSSet *aSet;
    enumerator = [aSet objectEnumerator];
    id objectSet;
    while ((objectSet = [enumerator nextObject]) != nil) {
        NSLog(@"set遍历");
    }
    
}

#pragma mark - 反向遍历
- (void)reverseEnumerator {

    NSArray *anArray;
    NSEnumerator *enumerator = [anArray reverseObjectEnumerator];
    id object;
    while ((object = [enumerator nextObject]) != nil) {
        NSLog(@"反向遍历");
    }
    
    for (id object in [anArray reverseObjectEnumerator]) {
        NSLog(@"快速遍历反向遍历");
    }

}

#pragma mark - 块枚举法 能通过GCD并发遍历操作
- (void)blockEnumerator {

    NSDictionary *dict;
    //NSEnumerationConcurrent并行执行
    //NSEnumerationReverse反向遍历
    [dict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        
    }];
    
    NSArray *array;
    [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

@end
