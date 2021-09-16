//
//  EOCPerson.m
//  demo
//
//  Created by lee on 17/3/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCPerson.h"

@implementation EOCPerson {
    NSMutableSet *_friends;
}

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {

    if (self = [super init]) {
        _firstName = [firstName copy];
        _lastName = [lastName copy];
        _friends = [NSMutableSet new];
    }
    return self;
}

#pragma mark - 实现copy功能
//1.遵守NSCopying协议 2.实现copyWithZone:
//之前会把内存分成不同的区zone，现在每个程序只有一个zone
- (id)copyWithZone:(NSZone *)zone {
    EOCPerson *copy = [[[self class] allocWithZone:zone] initWithFirstName:_firstName lastName:_lastName];
    
    //浅拷贝
    copy->_friends = [_friends mutableCopy];//不是属性，不能用点语法
    return copy;
}

//深拷贝
- (instancetype)deepCopy {
    EOCPerson *copy = [[[self class] alloc] initWithFirstName:_firstName lastName:_lastName];
    
    //YES：该方法会向数组中的每个元素发送copy消息，用copy好的元素创建新的set
    copy->_friends = [[NSMutableSet alloc] initWithSet:_friends copyItems:YES];
    return copy;
}

- (void)addFriend:(EOCPerson *)person {
    [_friends addObject:person];
}

- (void)removeFriend:(EOCPerson *)person {
    [_friends removeObject:person];
}

#pragma mark - description

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>",[self class], self, @{@"firstName":_firstName,@"lastName":_lastName}];
}

//断点控制台输出 po 时候调用此方法
//- (NSString *)debugDescription {
//
//}

#pragma mark - 重写NSObject协议中声明的“isEqual“方法来判断两个对象的等同性
/*
 两个类的所有字段均想等，那么两个对象就相等
 当且仅当其“指针值(pointer value)“完全相等时，这两个对象才相等
 */

//- (BOOL)isEqual:(id)object {
//
//    if (self == object) {
//        return YES;
//    }
//
//    if ([self class] != [object class]) {
//        return NO;
//    }
//
//    EOCPerson *otherPerson = (EOCPerson *)object;
//    if (![_firstName isEqualToString:otherPerson.firstName]) {
//        return NO;
//    }
//    if (![_lastName isEqualToString:_lastName]) {
//        return NO;
//    }
//    if (_age != otherPerson.age) {
//        return NO;
//    }
//    return YES;
//}

//这种做法能保持较高效率，又能使哈希码至少位于一定范围内不会过于频繁的重复
- (NSUInteger)hash {
    
    NSUInteger firstNameHash = [_firstName hash];
    NSUInteger lastNameHash = [_lastName hash];
    NSUInteger ageHash = _age;
    return firstNameHash ^ lastNameHash ^ ageHash;
}

#pragma mark - 特定类所具有的等同性判定方法

/* 编写本类的等同性方法,也应一并覆写isEqual方法
 实现方式：如果受测的参数与接受该消息的对象都属于同一个类，
 那么就调用自己编写的判定方法，否则交由超类判断。
 */

- (BOOL)isEqualToPerson:(EOCPerson *)otherPerson {
    
    if (self == otherPerson) {
        return YES;
    }
    
    if (![_firstName isEqualToString:otherPerson.firstName]) {
        return NO;
    }
    
    if (![_lastName isEqualToString:otherPerson.lastName]) {
        return NO;
    }
    
    if (_age != otherPerson.age) {
        return NO;
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    
    if ([self class] == [object class]) {
        return [self isEqualToPerson:(EOCPerson *)object];
    } else {
        return [super isEqual:object];
    }
}

@end
