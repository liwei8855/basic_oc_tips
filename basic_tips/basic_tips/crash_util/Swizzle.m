//
//  NSObject+Swizzle.m
//  OPCategories
//
//  Created by 李威 on 2019/2/16.
//  Copyright © 2019年 Opera Software. All rights reserved.
//

#import "Swizzle.h"
#import <objc/runtime.h>
@implementation NSObject (Swizzle)

+ (void)swizzleMethod:(SEL)method newMethod:(SEL)newMethod isClassMethod:(BOOL)classType {
    Class class = objc_getClass(NSStringFromClass([self class]).UTF8String);
    if (classType) {
        class = objc_getMetaClass(NSStringFromClass([self class]).UTF8String);
    }
    Method originalMethod;
    Method swizzleMethod;
    
    if (classType) {
        originalMethod = class_getClassMethod(class, method);
        swizzleMethod = class_getClassMethod(class, newMethod);
    } else {
        originalMethod = class_getInstanceMethod(class, method);
        swizzleMethod = class_getInstanceMethod(class, newMethod);
    }
    
    BOOL hasMethod = class_addMethod(class, method, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (hasMethod) {
        class_replaceMethod(class, newMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

@end
