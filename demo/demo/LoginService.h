//
//  LoginService.h
//  登陆demo
//
//  Created by lw on 15/12/16.
//  Copyright © 2015年 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultReturnBlock)(BOOL success, NSError *error);
@interface LoginService : NSObject

+(void)GET:(NSString *)name passWord:(NSString *)password finished:(resultReturnBlock)finished;
+(void)POST:(NSString *)name passWord:(NSString *)password finished:(resultReturnBlock)finished;
@end
