//
//  EOCDataModel.m
//  demo
//
//  Created by lee on 17/3/3.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "EOCDataModel.h"

@interface EOCDataModel() <EOCNetworkFetcherDelegate>

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) EOCNetworkFetcher *fetcher;

@end

@implementation EOCDataModel

#pragma mark - block

- (void)fetchBlockData {
    NSURL *url = [NSURL URLWithString:@""];
    self.fetcher = [[EOCNetworkFetcher alloc] initWithURL:url];
    [self.fetcher startWithCompletionHandler:^(NSData *data) {
        //循环引用了：
        //这里设置_data必须捕获self变量，即handler保留了datamodel实例，datamodel又保留了fetcher
        _data = data;
        _fetcher = nil;
    } failureHandler:^(NSError *error) {
       //handle failure
    }];
    //_fetcher = nil打破循环引用 方法一，但不总是有机会设置nil，如果handler不运行就一直循环引用着
    //打破上边循环引用方法二：fethcer不保存为property，每次创建新的；大部分网络获取器使用这种写法
    
}

#pragma mark - delegate

- (void)fetchFooData {
    EOCNetworkFetcher *fetcher = [[EOCNetworkFetcher alloc] init];
    fetcher.delegate = self;
}

- (void)networkFetcher:(EOCNetworkFetcher *)fetcher didReceiveData:(NSData *)data {
    _data = data;
}

- (void)networkFetcher:(EOCNetworkFetcher *)fetcher didFailWithError:(NSError *)error {}

@end
