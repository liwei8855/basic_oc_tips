//
//  KVOProxy.h
//  basic_tips
//
//  Created by 李威 on 2022/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface KVOProxyItem : NSObject
@property (nonatomic, weak) id observed;//被观察者
@property (nonatomic, weak) id observer;//观察者
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
@property (nonatomic, assign) void *context;
- (instancetype)initWithObserver:(id)observer observed:(id)observed keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
@interface KVOProxy : NSObject
- (void)addObserverWithProxyItem:(KVOProxyItem *)proxyItem didAddBlock:(dispatch_block_t)didAddBlock;
- (void)removeObserver:(NSObject *)observerd keyPath:(NSString *)keyPath didRemoveBlock:(dispatch_block_t)didRemoveBlock;
- (void)removeAllObserver;
@end

NS_ASSUME_NONNULL_END
