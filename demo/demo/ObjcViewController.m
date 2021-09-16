//
//  ObjcViewController.m
//  demo
//
//  Created by lee on 2018/6/8.
//  Copyright © 2018年 lee. All rights reserved.
/*
    消息发送机制
 */

#import "ObjcViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "Teacher.h"
#import "Student.h"
#import <objc/runtime.h>

@interface ObjcViewController ()

@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Student *s = [[Student alloc] init];
//    [s performSelector:@selector(smile)];
    [s performSelector:@selector(smile:) withObject:@"哈哈"];
    
}

- (void)msgSendSuper {
    Student *t = [[Student alloc] init];
    //发消息给父类
    /* objc_super结构体
     struct objc_super {
     //本类实例
     __unsafe_unretained _Nonnull id receiver;
     //父类
     __unsafe_unretained _Nonnull Class class;
     __unsafe_unretained _Nonnull Class super_class;
     // super_class is the first class to search
     };
     */
    /* 参数
     1 objc_super结构体指针
     2 方法编号
     3 参数
     */
    //定义objc_super结构体
//    struct objc_super teacherSuper = {t, class_getSuperclass(objc_getClass("Student"))};
    //给父类发消息
//    objc_msgSendSuper(&teacherSuper, @selector(eatWith:), @"fish");
}

- (void)msgSend {
    //    alloc 分配内存空间 底层malloc()
    //    init 初始化属性和方法
    //    Person *p = [[Person alloc] init];
    // ==>
    //    Person * p = objc_msgSend([Person class], @selector(alloc));
    // ==>
    //    NSClassFromString(@"Person"); //底层 ==>
    //    objc_getClass("Person")
//    Person * p = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
//    //    p = objc_msgSend(p, @selector(init));
//    // ==>
//    p = objc_msgSend(p, sel_registerName("init"));
//
//    [p eat];
//    objc_msgSend(p, sel_registerName("eatWith:"), @"food");
}


@end
