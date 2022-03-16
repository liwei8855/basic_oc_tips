//
//  AsyncNotificationController.m
//  basic_tips
//
//  Created by 李威 on 2022/3/16.
<<<<<<< HEAD
/*
 跨线程接受通知
 
 通知队列也可以实现异步，但是真正的异步还是得通过port
 NSPort,底层所有的消息触发都是通过端口来进行操作的
 */

#import "AsyncNotificationController.h"

@interface AsyncNotificationController ()<NSPortDelegate>
@property (nonatomic, strong) NSPort *port;
=======
//

#import "AsyncNotificationController.h"

@interface AsyncNotificationController ()

>>>>>>> crash_util
@end

@implementation AsyncNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    
    _port = [[NSPort alloc]init];
    _port.delegate = self;//消息处理通过代理来处理
    //把端口加在哪个线程里，就在哪个线程进行处理，下面：加在当前线程的runloop里
    [[NSRunLoop currentRunLoop] addPort:_port forMode:NSRunLoopCommonModes];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self sendPort];
    [NSThread detachNewThreadSelector:@selector(sendPort) toTarget:self withObject:nil];
}

//发送消息
- (void)sendPort {
    NSLog(@"port发送通知before:%@",[NSThread currentThread]);
    [_port sendBeforeDate:[NSDate date] msgid:1212 components:nil from:nil reserved:0];
    NSLog(@"port发送通知after:%@",[NSThread currentThread]);
}
//port delegate 处理消息
- (void)handlePortMessage:(NSPortMessage *)message{
    NSLog(@"port处理任务:%@",[NSThread currentThread]);
    NSObject * messageObj = (NSObject*)message;
    NSLog(@"=%@",[messageObj valueForKey:@"msgid"]);
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
