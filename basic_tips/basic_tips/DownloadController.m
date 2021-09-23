//
//  DownloadController.m
//  demo
//
//  Created by lee on 2018/4/11.
//  Copyright © 2018年 lee. All rights reserved.
/*  断点续传
    在http header中配置 Range 返回206
    Range
    bytes=x-y   :   从x字节开始下载，下载y个字节
    bytes=x-    :   从x字节开始下载，下载到文件末尾
    bytes=-x    :   从文件开始下载，下载x字节
 
 */

#import "DownloadController.h"

@interface DownloadController ()

@end

@implementation DownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://60.205.8.55:6100/PersonalPowerOfAttorney.pdf
}

- (void)downloadWithURL:(NSURL *)url offset:(long long)offset {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:15.0];
    //传递给服务器附加信息
    NSString *rangeStr = [NSString stringWithFormat:@"bytes=%lld-",offset];
    [request setValue:rangeStr forHTTPHeaderField:@"Range"];
}

- (void)download {
//    CFRunLoopRun();
//    CFRunLoopStop(CFRunLoopGetCurrent());
    
//    [[NSRunLoop currentRunLoop] run]
}

@end
