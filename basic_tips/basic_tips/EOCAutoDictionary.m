//
//  EOCAutoDictionary.m
//  demo
//
//  Created by lee on 17/2/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCAutoDictionary.h"
#import <objc/runtime.h>

@interface EOCAutoDictionary()

@property (strong, nonatomic) NSMutableDictionary *backingStore;

@end

@implementation EOCAutoDictionary

//将属性声明为@dynamic编译器就不会为其自动生成实例变量存取方法了
@dynamic string, number, date, opaqueObject;

- (instancetype)init {

    if (self = [super init]) {
        _backingStore = [NSMutableDictionary new];
    }
    return self;
}

//对象收到无法解读的消息后，首先调用其所属类的下列类方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {

    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
    } else {
        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
}

#pragma mark - getter
id autoDictionaryGetter(id self, SEL _cmd) {
    EOCAutoDictionary *typedSelf = (EOCAutoDictionary *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    //selector name
    NSString *key = NSStringFromSelector(_cmd);
    //retrun value
    return [backingStore objectForKey:key];
}

#pragma mark - setter
void autoDictionarySetter(id self, SEL _cmd, id value) {
    EOCAutoDictionary *typedSelf = (EOCAutoDictionary *)self;
    NSMutableDictionary *backingStore = typedSelf.backingStore;
    /* the selector will be for example: setOpaqueObject:
        we need to remove the "set" and ":" and lowercase the first
        letter of the remainder
     */
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSMutableString *key = [selectorString mutableCopy];
    
    //remove ':'
    [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
    
    //remove 'set'
    [key deleteCharactersInRange:NSMakeRange(0, 3)];
    
    //lowercase the first character
    NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
    
    if (value) {
        [backingStore setObject:value forKey:key];
    } else {
        [backingStore removeObjectForKey:key];
    }

}


@end
