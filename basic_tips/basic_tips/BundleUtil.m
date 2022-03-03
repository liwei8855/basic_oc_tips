//
//  BundleUtil.m
//  basic_tips
//
//  Created by 李威 on 2021/10/22.
//

#import "BundleUtil.h"

@implementation BundleUtil

- (void)test1 {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
//    2、使用路径获取一个NSBundle 对象,这个路径应该是一个目录的全路径
    NSString *path = [mainBundle resourcePath];
    NSBundle *language = [NSBundle bundleWithPath:path];
    
//    3、使用路径初始化一个NSBundle
    NSBundle *bundle2 = [[NSBundle alloc]initWithPath:path];
    
//    6、根据一个特殊的class 获取NSBundle
    NSBundle *bundle3 = [NSBundle bundleForClass:[self class]];
    
//    7、获取特定名称的bundle
    NSBundle *nameBundle = [NSBundle bundleWithIdentifier:@""];
    
//    8、使用NSBundle 获取所有的bundle信息(由于ios安全沙盒的限制，所有的获取的资源，是应用程序的资源)
//    注：官方标注，获取所有的非framework 的bundle;
    NSArray *all = [NSBundle allBundles];
    
//    9、获取应用程序加载的所有framework的资源
    NSArray *allFrameworks = [NSBundle allFrameworks];
    
//    13、加载资源，如果有错误的话，会放置错误信息
    
}

- (void)bundleError {
    NSError *error;
    BOOL isError = [[NSBundle mainBundle] loadAndReturnError:&error];
    BOOL ifError = [[NSBundle mainBundle] preflightAndReturnError:&error];
    
}

@end
