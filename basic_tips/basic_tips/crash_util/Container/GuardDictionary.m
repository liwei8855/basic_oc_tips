//
//  NSMutableDictionary+Guard.m
//  OPCategories
//
//  Created by 李威 on 2019/2/16.
//  Copyright © 2019年 Opera Software. All rights reserved.
//

#import "GuardDictionary.h"

#define ENABLE_ASSERT NO

@implementation NSDictionary (Guard)

+ (instancetype)safeDictionaryWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    for (int i=0; i<cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil ||  tmpKey == nil) {
            return nil;
        }
    }
    return [self safeDictionaryWithObjects:objects forKeys:keys count:cnt];
}

@end

@implementation NSMutableDictionary (Guard)

#pragma mark -
- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self safeSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
//        LCLog(@"exception:name:%@,reason:%@",[exception name],[exception reason]);
    }
}

- (void)safeRemoveObjectForKey:(id)aKey {
    if (aKey) {
        [self safeRemoveObjectForKey:aKey];
    } else {
//        LCLog(@"NSMutableDictionary removeObjectForKey: key is nil");
    }
}

#pragma mark - todo:delete

- (void)setSafeObject:(id)anObject forKey:(id)aKey {
    if (!aKey || !anObject) {
#ifdef DEBUG
        if (ENABLE_ASSERT) {
            NSAssert(NO, @"Error setObject %@/%@",aKey,anObject);
        }
#endif
        return;
    }

    if ([aKey isKindOfClass:[NSString class]]) {
        NSString *key = (NSString *)aKey;
        if (!key.length) {
#ifdef DEBUG
            if (ENABLE_ASSERT) {
                NSAssert(NO, @"Error setObject");
            }
#endif
            return;
        }
    }
    
    [self setObject:anObject forKey:aKey];
}

@end


@interface SyncMutableDictionary ()
    
@property(nonatomic, strong) NSMutableDictionary *dictionary;
@property(nonatomic, strong) dispatch_queue_t dispatchQueue;
    
@end

@implementation SyncMutableDictionary

- (instancetype)init {
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary new];
        _dispatchQueue = dispatch_queue_create("com.opera.OperaNews.SyncMutableDictionary", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary<id, id> *)otherDictionary{
    if (self = [super init]) {
        _dictionary = [[NSMutableDictionary alloc]initWithDictionary:otherDictionary];
        _dispatchQueue = dispatch_queue_create("com.opera.OperaNews.SyncMutableDictionary", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
    
- (NSArray * _Nonnull)allKeys{
    __weak typeof(self) weakSelf = self;
    __block NSArray *allKeys = [NSArray array];
    dispatch_sync(_dispatchQueue, ^{
        allKeys = [weakSelf.dictionary allKeys];
    });
    return allKeys;
}

- (NSArray * _Nonnull)allValues{
    __weak typeof(self) weakSelf = self;
    __block NSArray *allValues = [NSArray array];
    dispatch_sync(_dispatchQueue, ^{
        allValues = [weakSelf.dictionary allValues];
    });
    return allValues;
}
    
- (nullable id)objectForKey:(_Nonnull id)aKey{
    __weak typeof(self) weakSelf = self;
    __block id returnObject = nil;
    if(!aKey) return returnObject;
    dispatch_sync(_dispatchQueue, ^{
        returnObject = weakSelf.dictionary[aKey];
    });
    return returnObject;
}
    
- (void)setValue:(nullable id)value forKey:(NSString *)key {
    __weak typeof(self) weakSelf = self;
    if(!key) return;
    dispatch_barrier_async(_dispatchQueue, ^{
        [weakSelf.dictionary setValue:value forKey:key];
    });
}
    
- (nullable id)valueForKey:(_Nonnull id)aKey{
    __weak typeof(self) weakSelf = self;
    __block id returnObject = nil;
    dispatch_sync(_dispatchQueue, ^{
        returnObject = [weakSelf.dictionary valueForKey:aKey];
    });
    return returnObject;
}
    
- (void)setObject:(nullable id)anObject forKey:(_Nonnull id <NSCopying>)aKey{
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_dispatchQueue, ^{
        if (anObject == nil) return;
        weakSelf.dictionary[aKey] = anObject;
    });
}
    
- (void)removeObjectForKey:(_Nonnull id)aKey{
    //NSLog(@"--test removeObjectForKey :%@", aKey);
    __weak typeof(self) weakSelf = self;
    if(!aKey) return;
    dispatch_sync(_dispatchQueue, ^{
        [weakSelf.dictionary removeObjectForKey:aKey];
    });
}

- (void)removeObjectsForKeys:(NSArray<id> *)keyArray{
//    for (id key in keyArray) {
//        NSLog(@"--test removeObjectsForKeys %@",key);
//    }
    __weak typeof(self) weakSelf = self;
    dispatch_sync(_dispatchQueue, ^{
        [weakSelf.dictionary removeObjectsForKeys:keyArray];
    });
}
    
- (void)removeAllObjects {
//    NSLog(@"--test removeAllObjects :\n%@", self.dictionary);
    __weak typeof(self) weakSelf = self;
    dispatch_sync(_dispatchQueue, ^{
        [weakSelf.dictionary removeAllObjects];
    });
}
    
- (NSMutableDictionary *)getDictionary {
    __weak typeof(self) weakSelf = self;
    __block NSMutableDictionary *temp;
    dispatch_sync(_dispatchQueue, ^{
        temp = weakSelf.dictionary;
    });
    return temp;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))block{
    __weak typeof(self) weakSelf = self;
    dispatch_sync(_dispatchQueue, ^{
        [weakSelf.dictionary enumerateKeysAndObjectsUsingBlock:block];
    });
}
    
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.dictionary];
}
    
@end
