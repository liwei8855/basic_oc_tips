//
//  LoginService.m
//  登陆demo
//
//  Created by lw on 15/12/16.
//  Copyright © 2015年 lw. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

+(void)GET:(NSString *)name passWord:(NSString *)password finished:(resultReturnBlock)finished{
    
//    http://localhost/login.php?username=%@&password=%@
    NSString *urlStr = [NSString stringWithFormat:@"http://10.0.94.123/login/app-login?username=%@&password=%@",name,password];
    //    url百分号转译
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",dict);
        finished(dict[@"userId"],error);
        
    }] resume];
}
    
+(void)POST:(NSString *)name passWord:(NSString *)password finished:(resultReturnBlock)finished{
    //    url不需要百分号转译（内部实现的）
// http://localhost/login.php
    NSURL *url = [NSURL URLWithString:@"https://10.0.94.123/login/app-login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    //    设置请求方法
    request.HTTPMethod = @"POST";
    //    设置请求体二进制数据
    NSString *requestBody = [NSString stringWithFormat:@"username=%@&password=%@",name,password];
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",data);
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        NSLog(@"%@ %@",result,result[@"userId"]);
//        finished(result[@"userId"],error);
        
    }] resume];
}
@end
