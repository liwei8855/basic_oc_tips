//
//  CodeObject.m
//  demo
//
//  Created by lee on 2018/8/2.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "CodeObject.h"
#import <objc/runtime.h>

@implementation CodeObject

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([CodeObject class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        
        //kvc
        id value = [self valueForKey:key];
        //编码
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

//解档

@end
