//
//  NSObject+GuardKVO.m
//  basic_tips
//
//  Created by 李威 on 2022/3/4.
/*
 引起崩溃的原因：
1.添加或移除观察时，keypath长度为0
2.观察者忘记写监听回调方法observeValueForKeyPath:ofObject:change:context:
3.添加和移除观察的次数不匹配:
 观察者dealloc后没有移除监听
 移除未添加监听的观察者
 多次添加和移除观察者，但添加和移除的次数不相同
4.观察者和被观察者生命周期不一致，其中一个被释放而另一个未被释放(比如两个局部变量之间添加观察)
 被观察者被提前释放，iOS10及以前会崩溃
 观察者提前被释放，如果未移除观察，则会崩溃
 */

#import "NSObject+GuardKVO.h"
#import <objc/runtime.h>
#import "KVOProxy.h"

@implementation NSObject (GuardKVO)

+ (void)load {
    dispatch_once_t token;
    dispatch_once(&token, ^{
        [self switchMethod];
    });
}

+ (void)switchMethod {
    SEL removeSel = @selector(removeObserver:forKeyPath:);
    SEL myRemoveSel = @selector(safe_removeObserver:forKeyPath:);
    SEL addSel = @selector(addObserver:forKeyPath:options:context:);
    SEL myaddSel = @selector(safe_addObserver:forKeyPath:options:context:);
    
    Method systemRemoveMethod = class_getClassMethod([self class],removeSel);
    Method DasenRemoveMethod = class_getClassMethod([self class], myRemoveSel);
    Method systemAddMethod = class_getClassMethod([self class],addSel);
    Method DasenAddMethod = class_getClassMethod([self class], myaddSel);
    
    method_exchangeImplementations(systemRemoveMethod, DasenRemoveMethod);
    method_exchangeImplementations(systemAddMethod, DasenAddMethod);
}

- (void)safe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

#pragma mark - 实现方法一（简单）
    if (![self observerKeyPath:keyPath observer:observer]) {
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
    
#pragma mark - 实现方法一（比较复杂 用代理实现）
    if (keyPath.length <= 0) {
        return;
    }
    /*如果keyPath是多级 如keyPath:myView.myLabel.text 会逐级添加监听
     observer:myView    - keyPath:myView.myLabel.text
     observer:NSKeyValueObservance - keyPath:myLabel.text
     observer:NSKeyValueObservance - keyPath:text
     keyPath逐级变化，而系统添加的后续步骤的 观察者是NSKeyValueObservance对象所以我们需要进行一次过滤.
     */
    if ([observer isKindOfClass:NSClassFromString(@"NSKeyValueObservance")]) {
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    
    KVOProxyItem *item = [[KVOProxyItem alloc]initWithObserver:observer observed:self keyPath:keyPath options:options context:context];
    // 向观察者的kvoProxy添加KVOProxyItem,如果成功则在self作为被观察者添加观察者observer.kvoProxy
    [observer.kvoProxy addObserverWithProxyItem:item didAddBlock:^{
        //实际添加的obser不是传入的obser，而是包装了传入observer的item
        [self safe_addObserver:observer.kvoProxy forKeyPath:keyPath options:options context:context];
    }];
}

- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
#pragma mark - 实现方法一（简单）
    if (![self observerKeyPath:keyPath observer:observer]) {
        [self safe_removeObserver:observer forKeyPath:keyPath];
    }
    
#pragma mark - 实现方法一（比较复杂 用代理实现）
    [observer.kvoProxy removeObserver:self keyPath:keyPath didRemoveBlock:^{
        [self safe_removeObserver:self.kvoProxy forKeyPath:keyPath];
    }];
}
//-(void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
//    //判断context是否一致后调用
//    //removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
//    //所以不需要交换
//}
- (KVOProxy *)kvoProxy {
    id proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [KVOProxy new];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return proxy;
}
#pragma mark 方法二
/*observationInfo属性
 只要是继承与NSObject的对象都有observationInfo属性
 observationInfo是系统通过分类给NSObject增加的属性
 分类文件是NSKeyValueObserving.h这个文件
 这个属性中存储有属性的监听者，通知者，还有监听的keyPath，等等KVO相关的属性
 observationInfo是一个void指针，指向一个包含所有观察者的一个标识信息对象，信息包含了每个监听的观察者,注册时设定的选项等
 */
/*
 通过私有属性直接拿到当前对象所监听的keyPath，判断keyPath有或者无来实现防止多次重复添加和删除KVO监听
 _observances数组存储需要监听的对象：NSKeyValueObservance对象，监听了几个属性，数组中就有几个对象
 */
/*NSKeyValueObservance包含：
 _observer属性：里面放的是监听属性的监听者，也就是当属性改变的时候让哪个对象执行observeValueForKeyPath的对象。
 _property属性：NSKeyValueProperty，存储的有keyPath
 */
// 进行检索获取Key
- (BOOL)observerKeyPath:(NSString *)key observer:(id )observer
{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        id newObserver = [objc valueForKeyPath:@"_observer"];
        
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath] && [newObserver isEqual:observer]) {
            return YES;
        }
    }
    return NO;
}


@end
