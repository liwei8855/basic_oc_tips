//
//  EOCDatabaseConnection.h
//  demo
//
//  Created by lee on 17/3/7.
//  Copyright © 2017年 lee. All rights reserved.
/*
 匿名对象表示返回的对象
 */

#import <Foundation/Foundation.h>

@protocol EOCDatabaseConnection <NSObject>

- (void)connect;
- (void)disconnect;
- (BOOL)isConnected;
- (NSArray *)performQuery:(NSString *)query;

@end
