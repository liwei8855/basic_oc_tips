//
//  PPClientController.m
//  basic_tips
//
//  Created by 李威 on 2022/3/17.
//

#import "PPClientController.h"
#import "Socket/GCDAsyncSocket.h"
#import "SocketClient.h"
#import "DrawView.h"

@interface PPClientController ()<GCDAsyncSocketDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextView *showTextView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) GCDAsyncSocket *mySocket;
@end

@implementation PPClientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(50, 50, 300, 40);
    DrawView *dv = [[DrawView alloc]initWithFrame:rect];
    [self.view addSubview:dv];
    self.ipTextField.hidden = YES;
    self.showTextView.hidden = YES;
    
//    [self setupPP];
}

- (void)setupPP {
    [self initServer];
    [self initClient];

    self.ipTextField.delegate = self;
    self.ipTextField.text = @"10.7.7.42";
    self.showTextView.delegate = self;
    self.inputTextView.delegate = self;
    [self.btnSend addTarget:self action:@selector(didSend) forControlEvents:UIControlEventTouchUpInside];
}

- (void)alert:(NSString *)msg {
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertvc animated:YES completion:nil];
}

- (void)initServer {
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:dispatch_queue_create("serverSocket", DISPATCH_QUEUE_SERIAL)];
    [self.serverSocket acceptOnPort:8992 error:nil];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self initClient];
//}

- (void)initClient {
    if (![[SocketClient sharedInstance].socket isConnected]) {
        [[SocketClient sharedInstance] connectToHost];
    }
}

- (void)didSend {
    [self sendData];
}

- (void)sendData {
    if ([self.mySocket isConnected]) {
        NSData *data = [self.inputTextView.text dataUsingEncoding:NSUTF8StringEncoding];
        [self.mySocket writeData:data withTimeout:-1 tag:0];
        [self.mySocket readDataWithTimeout:-1 tag:0];
        self.showTextView.text = [NSString stringWithFormat:@"%@\n我说：%@",self.showTextView.text,self.inputTextView.text];
    }
}

#pragma mark - delegate
///当socket接受一个连接时调用
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"%s",__func__);
    NSString *localAddr = [[NSString alloc]initWithData:newSocket.localAddress encoding:NSUTF8StringEncoding];
    NSString *connectAddr = [[NSString alloc]initWithData:newSocket.connectedAddress encoding:NSUTF8StringEncoding];
    NSLog(@"%@---%@",localAddr,connectAddr);
    self.mySocket = newSocket;//持有新接收的socket
}
/////当socket连接准备读写调用
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
//    NSLog(@"%s",__func__);
//}
///当socket读取数据时调用
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"%s",__func__);
    NSString *charStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    self.showTextView.text = [NSString stringWithFormat:@"%@\n对方说：%@",self.showTextView.text,charStr];
}
///持续发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {//sock是客户端socket 服务器接收到客户端发送数据消息
    NSLog(@"客户端socket发送成功");
    self.inputTextView.text = nil;
    NSString *string = [NSString stringWithFormat:@"收到"];
    NSData *sendData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self.serverSocket writeData:sendData withTimeout:-1 tag:0];
    [self.serverSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"%s",__func__);
    if (err) {
        NSLog(@"error:%@",err);
    }
//    [self.serverSocket disconnect];
    self.mySocket = nil;
}

@end
