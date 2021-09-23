//
//  getCache.m
//  登陆demo
//
//  Created by lw on 15/12/14.
//  Copyright © 2015年 lw. All rights reserved.
/*
 get方法缓存处理
*/

#import "getCache.h"

@interface getCache()

@property(nonatomic,strong)NSString *etag;

@end

@implementation getCache


//实现get缓存
-(void)getCacheDemo{
    
    NSURL *url = [NSURL URLWithString:@"http://localhost/123.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    NSURLSession *session = [NSURLSession sharedSession];
    //发送etag
    //    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (self.etag.length > 0) {
        
        [request setValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    }
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ %tu",httpResponse,data.length);
        //判断如果服务器未更新则取本地缓存(304服务器内容未更新)
        if (httpResponse.statusCode == 304) {
            //            获取本地缓存，根据请求获取到‘被缓存的响应’
            NSCachedURLResponse *urlCache = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            //            拿到缓存的数据
            data = urlCache.data;
            NSLog(@"加载本地缓存%@",data);
        }
        //        记录住etag
        self.etag = httpResponse.allHeaderFields[@"Etag"];
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image = [UIImage imageWithData:data];
        });
    }];
    [task resume];
}


@end
