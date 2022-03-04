//
//  NSMutableDictionary+Guard.h
//  OPCategories
//
//  Created by 李威 on 2019/2/16.
//  Copyright © 2019年 Opera Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Guard)
- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)safeRemoveObjectForKey:(id)aKey;
//todo:delete
- (void)setSafeObject:(id)anObject forKey:(id)aKey;
@end

@interface NSDictionary (Guard)
+ (instancetype)safeDictionaryWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt;
@end

@interface SyncMutableDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

- (instancetype)initWithDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;

- (nullable id)objectForKey:(_Nonnull id)aKey;
    
- (nullable id)valueForKey:(_Nonnull id)aKey;

- (NSArray * _Nonnull)allKeys;

- (NSArray * _Nonnull)allValues;
    
- (void)setObject:(nullable id)anObject forKey:(_Nonnull id <NSCopying>)aKey;

- (void)removeObjectForKey:(_Nonnull id)aKey;

- (void)removeObjectsForKeys:(NSArray<id> *)keyArray;
    
- (void)removeAllObjects;
    
- (NSMutableDictionary *_Nonnull)getDictionary;

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
