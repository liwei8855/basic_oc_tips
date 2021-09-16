//
//  EOCPerson+Friendship.m
//  demo
//
//  Created by lee on 17/3/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCPerson+Friendship.h"
#import <objc/runtime.h>

static const NSString *kFriendsPropertyKey = @"kFriendsPropertyKey";

@implementation EOCPerson (Friendship)

- (BOOL)isFriendsWith:(EOCPerson *)person {
    return [self.friends containsObject:person];
}

//- (NSArray *)friends {
//    return objc_getAssociatedObject(self, (__bridge const void *)(kFriendsPropertyKey));
//}
//
//- (void)setFriends:(NSArray *)friends {
//    objc_setAssociatedObject(self, (__bridge const void *)(kFriendsPropertyKey), friends, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

/*
 *  _cmd 代指当前方法的选择子，也就是 @selector(friends)
 *  getter、setter方法原型：
 *  //根据 key 获取关联对象
 *  id objc_getAssociatedObject(id object, const void *key);
 *  //以键值对形式添加关联对象
 *  void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
 *  参数key可以使用静态指针 static void * 类型的参数来代替，（如上边实现）
 *  但使用 @selector(friends)作为key，省略了声明参数的代码，并且能很好地保证key的唯一性
 */

/*
     移除所有关联对象
     void objc_removeAssociatedObjects(id object);
 */

- (NSArray *)friends {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFriends:(NSArray *)friends {
    objc_setAssociatedObject(self, @selector(friends), friends, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
