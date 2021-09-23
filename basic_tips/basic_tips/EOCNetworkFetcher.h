//
//  EOCNetworkFetcher.h
//  demo
//
//  Created by lee on 17/3/3.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - delegate
@class EOCNetworkFetcher;
@protocol EOCNetworkFetcherDelegate <NSObject>

- (void)networkFetcher:(EOCNetworkFetcher *)fetcher didReceiveData:(NSData *)data;
@optional
- (void)networkFetcher:(EOCNetworkFetcher *)fetcher didFailWithError:(NSError *)error;

@end

#pragma mark - block
typedef void(^EOCNetworkFetcherCompletionHandler) (NSData *data);
typedef void(^EOCNetworkFetcherErrorHandler) (NSError *error);


@interface EOCNetworkFetcher : NSObject

#pragma mark - delegate
@property (weak, nonatomic) id <EOCNetworkFetcherDelegate> delegate;

#pragma mark - block
@property (strong, nonatomic, readonly) NSURL *url;
- (id)initWithURL:(NSURL *)url;
- (void)startWithCompletionHandler:(EOCNetworkFetcherCompletionHandler)handler failureHandler:(EOCNetworkFetcherErrorHandler)failure;
@end
