//
//  ViewController.m
//  demo
//
//  Created by lw on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "NSString+EOCMyAdditions.h"
#import "EOCEmployee.h"
#import "EOCAutoDictionary.h"

#import "APerson.h"

typedef NS_ENUM(NSInteger, demoList) {
    DEMO_CLUSTER,//类族
    DEMO_AUTOSELECTOR,//动态方法解析
    DEMO_METHODSWIZZLING,//运行时方法交换
    DEMO_DESIGNATEDINITIALIZER,//全能初始化方法
    DEMO_EXCEPTION,//抛出异常
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self m1];
}

#pragma mark -  面试题
- (void)m1 {
    /*1.你要了解super的本质,第一个参数要传结构体
     2.函数的堆栈分配问题
     3.消息机制,调用方法是怎么调用
     4.访问成员变量的本质
     */
    
//    NSString *test = @"123";
    id cls = [APerson class];
    void *obj = &cls;
    [(__bridge id)obj print];
    
    /*能成功：[(__bridge id)obj print];
     这个代码的本质是:给obj发一条print的消息,就会去通过obj的isa找到obj的类对象,去找方法列表,
     obj指向isa(存储类对象的地址)找到类对象所以能调用
     */
    /*self.name的调用结果是123的问题
     小端模式：代码自上往下由高地址向低地址排布
     寻找_name属性就是从isa往后8位即为_name的地址
     obj指向isa，往后8位正好在test的位置所以输出name是123
     */
    /*把test行去掉，结果是viewController：主要是[super viewDidLoad]影响
     super做了什么事它底层是这样实现的(上个博客说得很清楚): objc_msgSendSuper({ self,[UIViewController Class]} ,@selector(viewDidLoad));其他就是做了这件事**@selector**(viewDidLoad)也可以写出sel_registerName("viewDidLoad")
     调用之前生成结构体：
     struct abc = {self, [UIViewController Class]},
     objc_msgSendSuper(abc,@selector(viewDidLoad))
     跟123类似,找_name找到了abc即为UIViewController
     */
}

#pragma mark -
- (void)test1 {
    NSInteger type = DEMO_METHODSWIZZLING;
    switch (type) {
        case DEMO_CLUSTER:
            [self clusterDemo];
            break;
        case DEMO_AUTOSELECTOR:
            [self autoSelector];
            break;
        case DEMO_METHODSWIZZLING:
            [self methodSwizzling];
            break;
        case DEMO_EXCEPTION:
            [self exception];
        default:
            break;
    }
}

#pragma mark - runtime方法交换
- (void)methodSwizzling {
    //方法交换一般只用来调试，项目中应用会导致代码不易懂
    Method original = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method swapped = class_getInstanceMethod([NSString class], @selector(eoc_myLowercaseString));
    method_exchangeImplementations(original, swapped);
    NSString *str = @"ThIs iS tHe StRiNg";
    NSString *lower = [str lowercaseString];
    NSLog(@"%@",lower);
}

#pragma mark - 类族模式
//通过父类type创建不同子类使接口简单，但实际仍是返回的子类，并且执行的也是子类的方法
- (void)clusterDemo {

    EOCEmployee *developer = [EOCEmployee employeeWithType:EOCEmployeeTypeDeveloper];
    NSLog(@"%@",developer);
    [developer doADaysWork];
}

#pragma mark - 动态方法解析
//其他属性相似，要添加新属性，用@property定义，声明为@dynamic即可
//CoreAnimation框架中，CALayer就用了类似实现方式，使得CALayer成为“兼容于键值编码的”容器类，能随意添加属性，键值对形式访问
//于是，开发者可以向其中新增自定义属性，这些值的存储工作由基类直接负责，只要在CALayer子类中定义新属性即可
- (void)autoSelector {
    //以setter方法为例，@dynamic不实现setter，动态解析来处理setter，getter方法
    EOCAutoDictionary *dict = [EOCAutoDictionary new];
    dict.date = [NSDate dateWithTimeIntervalSince1970:475372800];
    NSLog(@"date = %@",dict.date);
    
}

#pragma mark - 抛出异常
//非ARC:
//relase不能放在try中，因为如果dosome方法抛出异常，则object有泄漏
- (void)exception {
//
//    EOCEmployee *object;
//    @try {
//        object = [[EOCEmployee alloc] init];
//        [object doSomethingThatMayThrow];
//    } @catch (NSException *exception) {
//        NSLog(@"there was an error.");
//    } @finally {
//        [object release];
//    }
}
//ARC情况下因为不能release，就不能在finally中release，问题就更大了
//-fobjc-arc-exceptions标志，开启arc安全处理异常功能：OC++会自动开启，arc需手动开启
//由于开启后自动生成处理异常代码，会导致应用程序变大，降低运行效率。
//在发现大量异常捕获操作时，应重构代码，用NSError式错误传递法取代异常

@end
