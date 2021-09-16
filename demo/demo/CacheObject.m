//
//  CacheObject.m
//  demo
//
//  Created by lw on 17/3/28.
//  Copyright © 2017年 lee. All rights reserved.
/*
 
 */

#import "CacheObject.h"
#import "EOCNetworkFetcher.h"

@implementation CacheObject{
    NSCache *_cache;
}

#pragma mark - NSCache 缓存

/*
    下载数据url是缓存的键，缓存未命中则下载数据放入缓存
    数据“开销值”为其长度
    可缓存对象上限100
    总开销 5M （以字节为单位）
 */
- (instancetype)init {

    if (self = [super init]) {
        _cache = [NSCache new];
        
        _cache.countLimit = 100;
        _cache.totalCostLimit = 5 * 1024 * 1024;//5M
    }
    return self;
}

//- (void)downloadDataForURL:(NSURL *)url {
//
//    NSData *cacheData = [_cache objectForKey:url];
//    if (cacheData) {
//        //data 存在
//    } else {
//        //data不存在 下载
//        EOCNetworkFetcher *fecher = [[EOCNetworkFetcher alloc] initWithURL:url];
//        [fecher startWithCompletionHandler:^(NSData *data) {
//            //缓存data
//            [_cache setObject:data forKey:url cost:data.length];
//        } failureHandler:^(NSError *error) {
//            NSLog(@"下载失败");
//        }];
//    }
//}

#pragma mark - NSPurgeableData 与NSCache搭配优化缓存

//NSPurgeableData NSMutableData的子类 实现了NSDiscardableContent协议
//如果某个对象所占内存能根据需要随时丢弃，就可以实现该协议所定义的接口：当系统资源紧张时可以把保存NSPurgeableData对象那块内存释放掉
//NSDiscardableContent协议定义了isContentDiscarded方法，查询内存是否已经释放

- (void)downloadDataForURL:(NSURL *)url {
    
    //当该对象为系统所丢弃时，也会自动从缓存中移除，通过evictsObjectsWithDiscardedContent属性设置
    NSPurgeableData *cacheData = [_cache objectForKey:url];
    
    if (cacheData) {
        //data 存在
        //告诉现在还不应该丢弃所占据的内存（与end方法对应出现）
        [cacheData beginContentAccess];
        
        // use data
        
        //告诉在必要时可以丢弃自己所占据的内存了
        [cacheData endContentAccess];
        
    } else {
        //data不存在 下载
        EOCNetworkFetcher *fecher = [[EOCNetworkFetcher alloc] initWithURL:url];
        [fecher startWithCompletionHandler:^(NSData *data) {
            //缓存data
            NSPurgeableData *purgeableData = [NSPurgeableData dataWithData:data];
            [_cache setObject:purgeableData forKey:url cost:purgeableData.length];
            //创建好NSPurgeableData对象后，purge引用计数多1，不需beginaccess，因为创建时已经标记了
            
            //use data
            
            //必要时可以丢弃
            [purgeableData endContentAccess];
            
        } failureHandler:^(NSError *error) {
            NSLog(@"下载失败");
        }];
    }
}



@end
