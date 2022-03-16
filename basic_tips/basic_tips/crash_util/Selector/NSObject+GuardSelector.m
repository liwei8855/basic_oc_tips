//
//  NSObject+GuardSelector.m
//  basic_tips
//
//  Created by 李威 on 2022/3/7.
//

#import "NSObject+GuardSelector.h"
#import <objc/runtime.h>
#import "Swizzle.h"

@implementation NSObject (GuardSelector)
+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self switchMethod];
    });
}

+ (void)switchMethod {
    
    SEL method = @selector(forwardingTargetForSelector:);
    SEL newMethod = @selector(safe_forwardingTargetForSelector:);
    
    [NSObject swizzleMethod:method newMethod:newMethod isClassMethod:NO];
    [NSObject swizzleMethod:method newMethod:newMethod isClassMethod:YES];
    
    SEL selMethod = @selector(performSelector:withObject:withObject:);
    SEL newselMethod = @selector(safe_performSelector:withObject:withObject:);
    [NSObject swizzleMethod:selMethod newMethod:newselMethod isClassMethod:NO];
    
}

#pragma mark - selector
//一、动态方法解析
/*为对象添加方法的实现，再返回YES告诉已经为selector添加了实现。
 这样就会重新在对象上查找方法，找到我们新添加的方法后就直接调用。
 从而避免掉unrecognized selector sent to XXX
 */
//这两个方法会响应respondsToSelector:和instancesRespondToSelector:
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    //动态地为selector提供一个实例方法的实现
//    return YES;
//}
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    //动态地为selector提供一个类方法的实现
//    return YES;
//}

//二、消息转发：快速转发
- (id)safe_forwardingTargetForSelector:(SEL)aSelector {//对应实例方法
    //将消息转发给其它对象去处理
    //可以在这个方法中，返回一个对象，让这个对象来响应消息
    //如果在这个方法中返回self或nil，则表示没有可响应的目标
    Class rootClass = NSObject.class;
    Class currentClass = self.class;
    return [self.class actionForwardingTargetForSelector:aSelector rootClass:rootClass currentClass:currentClass];
}
+ (id)safe_forwardingTargetForSelector:(SEL)aSelector {//对应类方法
    Class rootClass = objc_getMetaClass(class_getName(NSObject.class));
    Class currentClass = objc_getMetaClass(class_getName(self.class));
    return [self actionForwardingTargetForSelector:aSelector rootClass:rootClass currentClass:currentClass];
}
//消息转发：常规转发
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//}
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//}

//添加guard方案：
/*
 动态方法解析阶段 - 不建议
 1.这个方法会为类添加本身不存在的方法，绝大多数情况下，这个方法时冗余的
 2.respondsToSelector:和instancesRespondToSelector:这两个方法都会调用到resolveInstanceMethod:，
 那么在我们需要使用这两个方法进行判断的时候，就会出现我们不想看到的情况
 */
/*
 消息快速转发 - 推荐
 会拦截掉已经通过消息常规转发实现的消息转发，但是可以通过判断避开对NSObject子类的消息常规转发的拦截
 消息常规转发 - 推荐
 不会对原有的消息转发机制产生影响，缺点是更大的性能开销
 */

+ (id)actionForwardingTargetForSelector:(SEL)aSelector rootClass:(Class)rootClass currentClass:(Class)currentClass {//消息快速转发拦截
    //过滤掉内部对象
    NSString *className = NSStringFromClass(currentClass);
    if ([className hasPrefix:@"_"]) {
        return [self safe_forwardingTargetForSelector:aSelector];
    }
    
    //判断当前类是否实现了methodSignatureForSelector:方法，
    //如果实现了该方法，就认为当前类已经实现了自己的消息转发机制，我们不对其进行拦截
    SEL methodSignatureSelector = @selector(methodSignatureForSelector:);
    IMP rootMethodSignatureMethod = class_getMethodImplementation(rootClass, methodSignatureSelector);
    IMP currentMethodSignatureMethod = class_getMethodImplementation(currentClass, methodSignatureSelector);
    if (rootMethodSignatureMethod != currentMethodSignatureMethod) {
        return [self safe_forwardingTargetForSelector:aSelector];
    }
    
    NSString *selectorName = NSStringFromSelector(aSelector);
    NSLog(@"上报异常 unrecognized selector crash:%@:%@",className,selectorName);
    
    NSString *targetClassName = @"GuardSelector";
    Class cls = NSClassFromString(targetClassName);
    if (!cls) {
        // 如果要注册类，则必须要先判断class是否已经存在，否则会产生崩溃
        // 如果不注册类，则可以重复创建class
        cls = objc_allocateClassPair(NSObject.class, targetClassName.UTF8String, 0);
        objc_registerClassPair(cls);
    }
    
    // 如果类没有对应的方法，则动态添加一个
    if (!class_getInstanceMethod(cls, aSelector)) {
//        Method method = class_getInstanceMethod(cls, @selector(crashPreventor));
//        class_addMethod(cls, aSelector, method_getImplementation(method), method_getTypeEncoding(method));
        //类没有实现方法 动态添加一个
        class_addMethod(cls, aSelector, (IMP)Crash, "@@:@");
    }
    // 把消息转发到当前动态生成类的实例对象上
    return [cls new];
}

//- (void)crashPreventor {
//
//}
// 动态添加的方法实现
static int Crash(id slf, SEL selector) {
    return 0;
}
//消息常规转发拦截
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"@"];//返回值为void的NSMethodSignature
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation------");
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"@"];
}
+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation------");
}

#pragma mark - perform selector
- (id)safe_performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 {
    if ([self respondsToSelector:aSelector]) {
        if ([self isSelectorReturnType:aSelector]) {
            typedef id (*MethodType)(id, SEL,id,id);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            if (methodToCall) {
                return methodToCall(self,aSelector,object1,object2);
            }
            return nil;
        } else {
            typedef void (*MethodType)(id,SEL,id,id);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            if (methodToCall) {
                methodToCall(self,aSelector,object1,object2);
            }
            return nil;
        }
    } else {
        NSString *err = [NSString stringWithFormat:@"[%@ %@] unrecognized selector sent to instance ",[[self class]description],NSStringFromSelector(aSelector)];
        NSLog(@"%@",err);
        return nil;
    }
}
- (BOOL)isSelectorReturnType:(SEL)aSelector {//判断是否有返回值yes有 no没有
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        const char *returnType = signature.methodReturnType;
        if (returnType && !strcpy((char *)returnType, @encode(void))) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}
@end
