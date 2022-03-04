//
//  KVOProxy.m
//  basic_tips
//
//  Created by 李威 on 2022/3/4.
//

#import "KVOProxy.h"
#import <pthread.h>
#import "NSObject+GuardKVO.h"
#import <objc/runtime.h>

@implementation KVOProxyItem
- (instancetype)initWithObserver:(id)observer observed:(id)observed keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if (self = [super init]) {
        _observer = observer;
        _observed = observed;
        _context = context;
        _keyPath = keyPath;
        _options = options;
    }
    return self;
}
@end

@interface KVOProxy()
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableSet<KVOProxyItem *> *> *proxyItemMap;
@end

@implementation KVOProxy
- (instancetype)init {
    if (self = [super init]) {
        pthread_mutex_init(&_mutex, NULL);
        self.proxyItemMap = @{}.mutableCopy;
    }
    return self;
}
- (void)dealloc {
    //被释放前移除所有观察
    [self removeAllObserver];
    pthread_mutex_destroy(&_mutex);
}


//监听到变化执行此处
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (keyPath.length <= 0 || object == nil) {
        return;
    }
    [self lock];
    __block KVOProxyItem *item = nil;
    NSSet *set = [self.proxyItemMap valueForKey:keyPath];
    [set enumerateObjectsUsingBlock:^(KVOProxyItem *obj, BOOL * _Nonnull stop) {
        if (object == obj.observed && self == [obj.observer kvoProxy]) {
            item = obj;
            *stop = YES;
        }
    }];
    [self unlock];
    if (item == nil) {
        return;
    }
    
    //观察者被提前释放
    if (item.observer == nil) {
        return;
    }
    
    //判断当前观察者是否实现了方法observeValueForKeyPath
    //这个地方用respondsToSelector:检测,没用，未实现，也返回YES
    SEL selector = @selector(observeValueForKeyPath:ofObject:change:context:);
    BOOL exist = NO;
    unsigned int count = 0;
    Method *methodList = class_copyMethodList([item.observer class], &count);
    for (int i=0; i<count; i++) {
        Method method = methodList[i];
        if (method_getName(method) == selector) {
            exist = YES;
            break;
        }
    }
    if (!exist) {
        return;
    }
    //调用观察者回调方法
    [item.observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

//添加obsever代理
- (void)addObserverWithProxyItem:(KVOProxyItem *)proxyItem didAddBlock:(dispatch_block_t)didAddBlock {
    if (proxyItem == nil) {
        return;
    }
    if (proxyItem.keyPath.length <= 0) {
        return;
    }
    [self lock];
    __block BOOL added = NO;
    NSMutableSet *set = [self.proxyItemMap valueForKey:proxyItem.keyPath];
    [set enumerateObjectsUsingBlock:^(KVOProxyItem *obj, BOOL * _Nonnull stop) {
        if (obj.observer == proxyItem.observer && obj.observed == proxyItem.observed) {
            *stop = YES;
            added = YES;
        }
    }];
    if (added) {
        [self unlock];
        return;
    }
    if (set == nil) {
        set = [NSMutableSet set];
        [self.proxyItemMap setObject:set forKey:proxyItem.keyPath];
    }
    [set addObject:proxyItem];
    [self unlock];
    
    //必须解锁之后再进行回调，否则会导致启动后屏幕不显示内容
    if (didAddBlock) {
        didAddBlock();
    }
}

- (void)removeObserver:(NSObject *)observed keyPath:(NSString *)keyPath didRemoveBlock:(dispatch_block_t)didRemoveBlock {
    if (observed == nil || keyPath.length <= 0) {
        return;
    }
    
    [self lock];
    NSMutableSet *set = [self.proxyItemMap valueForKey:keyPath];
    __block KVOProxyItem *item = nil;
    [set enumerateObjectsUsingBlock:^(KVOProxyItem *obj, BOOL * _Nonnull stop) {
        if (obj.observed == observed) {
            *stop = YES;
            item = obj;
        }
    }];
    if (item != nil) {
        [set removeObject:item];
        if (didRemoveBlock) {
            didRemoveBlock();
        }
    }
    [self unlock];
}
- (KVOProxyItem *)proxyItemForKeyPath:(NSString *)keyPath observed:(id)observed {
    NSMutableSet *set = [self.proxyItemMap valueForKey:keyPath];
    __block KVOProxyItem *item;
    [set enumerateObjectsUsingBlock:^(KVOProxyItem *obj, BOOL * _Nonnull stop) {
        if (obj.observed == observed) {
            item = obj;
            *stop = YES;
        }
    }];
    return item;
}
//移除self的所有监听 防止出现对象被释放,但是未移除监听的问题
- (void)removeAllObserver {
    [_proxyItemMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableSet<KVOProxyItem *> * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(KVOProxyItem * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj.observed removeObserver:self forKeyPath:obj.keyPath];
        }];
    }];
    _proxyItemMap = nil;
}
- (void)lock {
    pthread_mutex_lock(&_mutex);
}
- (void)unlock {
    pthread_mutex_unlock(&_mutex);
}
@end
