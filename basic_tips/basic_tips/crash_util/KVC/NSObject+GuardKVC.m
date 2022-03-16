//
//  NSObject+GuardKVC.m
//  basic_tips
//
//  Created by 李威 on 2022/3/7.
/*
 KVC异常原因：
 1.key值为nil，抛出异常NSInvalidArgumentException
 2.value值为nil，并且是为非对象属性设置值，抛出异常NSInvalidArgumentException
 3.在对象上找不到key对应的属性，抛出异常NSUndefinedKeyException
    key不是对象的属性
    keyPath不正确
 */

#import "NSObject+GuardKVC.h"
#import <objc/runtime.h>
#import "Swizzle.h"

@implementation NSObject (GuardKVC)
+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self switchMethod];
    });
}

+ (void)switchMethod {
    SEL method1 = @selector(setValue:forKey:);
    SEL method2 = @selector(valueForKey:);

    SEL newMethod1 = @selector(safe_setValue:forKey:);
    SEL newMethod2 = @selector(safe_valueForKey:);

    [NSObject swizzleMethod:method1 newMethod:newMethod1 isClassMethod:NO];
    [NSObject swizzleMethod:method2 newMethod:newMethod2 isClassMethod:NO];
}

//guard key = nil
- (void)safe_setValue:(id)value forKey:(NSString *)key {
    if (key == nil || key.length <= 0) {
        NSLog(@"error");
        return;
    }
    [self safe_setValue:value forKey:key];
}
- (id)safe_valueForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [self safe_valueForKey:key];
}

//guard value = nil
- (void)setNilValueForKey:(NSString *)key {
    //收集异常信息
}
//guard对象找不到属性
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //收集异常信息
}
- (id)valueForUndefinedKey:(NSString *)key {
    //收集异常信息
    return nil;
}

@end

