//
//  EOCDatabaseManager.h
//  demo
//
//  Created by lee on 17/3/7.
//  Copyright © 2017年 lee. All rights reserved.
/*
  匿名对象表示返回的对象，隐藏类型
  涉及到数据库的方法放到一起，令返回的对象遵从此协议
  id返回类型：不同的类均可以用同一个方法返回了，调用的人仅仅知道返回对象能用来连接、断开数据库即可。
  封装：将实现包裹起来，使匿名对象成其子类，遵从协议，connectionwith方法返回这些类对象，后期无须改变公共api，即可切换后端实现。
 */

#import <Foundation/Foundation.h>

@protocol EOCDatabaseConnection;

@interface EOCDatabaseManager : NSObject

//单例提供数据库连接
+ (id)sharedInstance;
- (id<EOCDatabaseConnection>)connectionWithIdentifier:(NSString *)identifier;

@end
