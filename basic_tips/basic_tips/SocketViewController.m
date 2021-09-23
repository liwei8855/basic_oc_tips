//
//  ViewController.m
//  socket演练
//
//  Created by lw on 15/8/20.
//  Copyright © 2015年 lw. All rights reserved.
/*
     GCDAsyncSocket：socket框架
 */
/*
 操作说明：
 host:127.0.0.1  port:12345
 打开netcat：nc -lk 12345
 */

#import "SocketViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface SocketViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hostText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UITextField *msgText;
@property (weak, nonatomic) IBOutlet UILabel *recLabel;

//定义全局socket
@property (nonatomic,assign) int clientSocket;

@end

@implementation SocketViewController
- (IBAction)connBtn:(id)sender {

    BOOL result = [self connectToHost:self.hostText.text port:self.portText.text.intValue];
    self.recLabel.text = result ? @"成功" : @"失败";
}
- (IBAction)sedButton:(id)sender {
    self.recLabel.text = [self sendAndRecv:self.msgText.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//连接到服务器
-(BOOL)connectToHost:(NSString *)host port:(int)port{
//   1. socket
    self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"%d",self.clientSocket);
//   2.connect
    struct sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_addr.s_addr = inet_addr(host.UTF8String);
    serverAddress.sin_port = HTONS(port);
    
    return (connect(self.clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress)) ==0);
}

//发送和接收
- (NSString *)sendAndRecv:(NSString *)msg{

    ssize_t sendLen = send(self.clientSocket, msg.UTF8String, strlen(msg.UTF8String), 0);
    NSLog(@"%ld  %tu",sendLen, msg.length);
    uint8_t buffer[1024];
    ssize_t recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

//断开连接
-(void)disconnection{

    close(self.clientSocket);
}
@end









































