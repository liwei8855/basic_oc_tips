//
//  NotificationDemoController.m
//  basic_tips
//
//  Created by 李威 on 2022/3/16.
//

#import "NotificationDemoController.h"

<<<<<<< HEAD
NSString *const NOTIFICATION_NAME = @"NOTIFICATION_NAME";

=======
>>>>>>> crash_util
@interface NotificationDemoController ()

@end

@implementation NotificationDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    
    //object：指定接受某个对象的通知，为nil表示可以接受任意对象的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifi:) name:NOTIFICATION_NAME object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [NSThread detachNewThreadSelector:@selector(sendNotification) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(sendAsyncNotification) toTarget:self withObject:nil];
}

//同步发送通知
- (void)sendNotification0 {
    //直接发通知
//    NSLog(@"发送通知before:%@",[NSThread currentThread]);
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME object:nil];
//    NSLog(@"发送通知after:%@",[NSThread currentThread]);
}

- (void)sendNotification {
    //先将通知放到队列，再发
    //每个线程都默认又一个通知队列，可以直接获取，也可以alloc
    NSNotificationQueue * notificationQueue = [NSNotificationQueue defaultQueue];
    NSNotification * notification = [NSNotification notificationWithName:NOTIFICATION_NAME object:nil];
    /*     (NSPostingStyle) 什么时候发送
         NSPostWhenIdle = 1,//空闲时发送
         NSPostASAP = 2,//尽快发送
         NSPostNow = 3,//现在发送
         
         <#(NSNotificationCoalescing)#>消息合并的方式
         NSNotificationNoCoalescing = 0, //不合并
         NSNotificationCoalescingOnName = 1,//按名称合并
         NSNotificationCoalescingOnSender = 2,//按发送者合并*/
    
    /*参数组合
     NSPostWhenIdle + NSNotificationCoalescingOnName：发多条相同名称的通知，只收到一条通知，合并了
     NSPostNow + NSNotificationCoalescingOnName：发送几条收到几条，与同步类似，发送一条处理后再下一条，没有机会合并
     */

    NSLog(@"发送通知before:%@",[NSThread currentThread]);
    //异步时只有NSPostNow这个模式能收到消息
    [notificationQueue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    NSLog(@"发送通知after:%@",[NSThread currentThread]);
}

//异步发
- (void)sendAsyncNotification{
    //每个线程都默认又一个通知队列，可以直接获取，也可以alloc
    NSNotificationQueue * notificationQueue = [NSNotificationQueue defaultQueue];
    NSNotification * notification = [NSNotification notificationWithName:NOTIFICATION_NAME object:nil];
   
    NSLog(@"异步发送通知before:%@",[NSThread currentThread]);
    //NSPostNow异步可以发送出去，NSPostWhenIdle可能发不出去
    [notificationQueue enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
    NSLog(@"异步发送通知after:%@",[NSThread currentThread]);
    //每个线程都有一个通知队列，当线程结束了，通知队列就被释放了
    //异步下NSPostWhenIdle空闲时发送和NSPostASAP，通知队列释放了，通知发不出去
    //子线程runloop默认不开启，需要开启防止线程结束通知队列释放
    NSPort * port = [NSPort new];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (void)handleNotifi:(NSNotification*)notif{
    NSLog(@"接收到通知了:%@",[NSThread currentThread]);
}
=======
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
>>>>>>> crash_util

@end
