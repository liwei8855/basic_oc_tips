//
//  EOCPerson.h
//  demo
//
//  Created by lee on 17/3/2.
//  Copyright © 2017年 lee. All rights reserved.
/*
 1.自定义类实现copy功能
 2.重写description
 */

#import <Foundation/Foundation.h>

@interface EOCPerson : NSObject <NSCopying>

@property (copy, nonatomic, readonly) NSString *firstName;
@property (copy, nonatomic, readonly) NSString *lastName;
@property (assign, nonatomic) NSUInteger age;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
- (void)addFriend:(EOCPerson *)person;
- (void)removeFriend:(EOCPerson *)person;


@end
