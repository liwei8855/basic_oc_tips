//
//  SocketClient.m
//  basic_tips
//
//  Created by 李威 on 2022/3/16.
//
//域名前缀
#define YUMINGQIANZUI [@"NO" isEqualToString:NSLocalizedStringFromTable(@"isDistribution", @"SettingInitInfo",nil)]?@"test.":@""
//#define SocketIp [NSString stringWithFormat:@"%@push.babamai.com.cn",YUMINGQIANZUI]
#define SocketIp @"10.7.7.42"
#define TOKEN @"token"

#import "SocketClient.h"

static bool RUNNING = NO;

//服务器断开后重连计数
static int reconnectTimes = -1;

//连接注册失败后，重连计数
static int regFailReconnectTimes = -1;

@implementation SocketClient
+ (instancetype)sharedInstance {
    static dispatch_once_t token;
    static SocketClient *client = nil;
    dispatch_once(&token, ^{
        client = [SocketClient new];
    });
    return client;
}

- (instancetype)init {
    if (self = [super init]) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:dispatch_queue_create("socketQueue", DISPATCH_QUEUE_SERIAL)];
        
        [self setupReachability];
        
    }
    return self;
}

- (void)setupReachability {
    _reach = [Reachability reachabilityForInternetConnection];
    __weak SocketClient *weakSelf = self;
    _reach.reachableBlock = ^(Reachability *reachability) {
        if (![weakSelf.socket isConnected]) {
            [weakSelf connectToHost];
        }
    };
    _reach.unreachableBlock = ^(Reachability *reachability) {
        [weakSelf closeSocket];
    };
    [_reach startNotifier];
}

- (void)connectToHost {
    [self reconnectToHost];
}

- (void)reconnectToHost {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.socket.isConnected) {
            [self closeSocket];
        }
        NSError *error;
        [self.socket connectToHost:@"10.7.7.42" onPort:8992 withTimeout:5 error:&error];
        if (error) {
            NSLog(@"socket连接错误：%@",error);
        }
    });
}

- (void)closeSocket {
    dispatch_async(dispatch_get_main_queue(), ^{
        RUNNING = NO;
        [self.socketTimer invalidate];
        if (self.socket.isConnected) {
            [self.socket disconnect];
        }
        NSLog(@"SocketClient - closeSocket: %@", RUNNING?@"RUN":@"STOP");
    });
}

/*
 客户端收到服务端的消息后，调用此方法向服务端发一条回复消息，让服务端知道此消息已经知道
 */
- (void)replyServer:(NSString *)msgId {
    [[SocketClient sharedInstance] writeDataToServer:@{@"msgId":msgId} withServiceId:1 withSerializerType:SERIALIZETYPE_JSON withSessionID:SESSIONID_NONE withRp:nil withUrl:@"/reply"];
}

/* 现在向服务器发消息都是通过http，所以此方法暂时木有用
 向服务器端写数据
 dic：业务数据字典
 serviceId：调用后台的服务号ID
 serializeType：业务数据序列化类型
 sessionId：业务来自前台的功能模块的ID
 rp:前台需要的数据，后台不做处理直接传回来
 url：后台处理业务的方法路径
 */
- (void)writeDataToServer:(NSDictionary *)dic withServiceId:(int)serviceId withSerializerType:(SerializeType)serializeType withSessionID:(SessionID)sessionId withRp:(NSString *)rp withUrl:(NSString *)url {
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *jsonData = [self packageJsonSocketData:dic withRp:rp withURL:url];
    NSData *headData = [self packageHeadDataWithServiceID:1 withSerializerType:SERIALIZETYPE_JSON withSessionID:SESSIONID_NONE withBodyDataLength:jsonData.length];
    NSData *endMarkData = [EndMark dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *all = [NSMutableData data];
    [all appendData:headData];
    [all appendData:jsonData];
    [all appendData:endMarkData];
    [self.socket writeData:all withTimeout:-1 tag:0];
}

//注册socket成功后向服务器发送token消息
- (void)registerSocket:(GCDAsyncSocket *)socket {
    //现在已deviceid来注册  token不是必须的
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *deviceId = [NSString stringWithFormat:@"%@-c",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    [dic setValue:deviceId forKey:@"deviceId"];
    [dic setValue:token forKey:@"token"];
    NSData *bodyData = [self packageJsonSocketData:dic withRp:nil withURL:@"/reg"];
    NSData *headData = [self packageHeadDataWithServiceID:1 withSerializerType:SERIALIZETYPE_JSON withSessionID:SESSIONID_NONE withBodyDataLength:bodyData.length];
    
    NSData *endMarkData = [EndMark dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *all = [[NSMutableData alloc] init];
    [all appendData:headData];
    [all appendData:bodyData];
    [all appendData:endMarkData];
    [self.socket writeData:all withTimeout:-1 tag:0];
}

//注销socket的uid
- (void)logoutUserInSocket
{
    NSLog(@"=========================注销socket中得uid");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *deviceId = [NSString stringWithFormat:@"%@-c",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    [dic setValue:deviceId forKey:@"deviceId"];
    [dic setValue:token forKey:@"token"];
    
    NSData *bodyData = [self packageJsonSocketData:dic withRp:nil withURL:@"/unreg"];
    NSData *headData = [self packageHeadDataWithServiceID:1 withSerializerType:SERIALIZETYPE_JSON withSessionID:SESSIONID_NONE withBodyDataLength:bodyData.length];
    
    NSData *endMarkData = [EndMark dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *all = [[NSMutableData alloc] init];
    [all appendData:headData];
    [all appendData:bodyData];
    [all appendData:endMarkData];
    [self.socket writeData:all withTimeout:-1 tag:0];
}

-(void)keepLongConnectToSocket
{
    NSLog(@"发送保持长连接的心跳包");

    NSData *bodyData = [self packageJsonSocketData:nil withRp:nil withURL:@"/ping"];
    NSData *headData = [self packageHeadDataWithServiceID:1 withSerializerType:SERIALIZETYPE_JSON withSessionID:SESSIONID_NONE withBodyDataLength:bodyData.length];
    
    NSData *endMarkData = [EndMark dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *all = [[NSMutableData alloc] init];
    [all appendData:headData];
    [all appendData:bodyData];
    [all appendData:endMarkData];
    [self.socket writeData:all withTimeout:-1 tag:0];
}

-(void)reconnectTimerAction
{
    NSLog(@"服务器断开后socket第%d此重连",reconnectTimes);
    [self connectToHost];
}

-(void)regFailReconnectTimerAction
{
    NSLog(@"注册失败后socket第%d此重连",regFailReconnectTimes);
    [self connectToHost];
}

- (NSData *)packageHeadDataWithServiceID:(int)serviceId withSerializerType:(SerializeType)serializeType withSessionID:(SessionID)sessionId withBodyDataLength:(NSInteger)length {
    Byte headByte[13];
    Byte *versionB = [self intToBytes:1];
    Byte *lenghtB = [self intToBytes:(int)length+13];
    Byte *sessionIDB = [self intToBytes:sessionId];
    Byte *serviceIDB = [self intToBytes:serviceId];
    Byte *sdpTypeB = [self intToBytes:SDPTYPE_REQUEST];
    Byte *compressTypeB = [self intToBytes:0];
    Byte *serializeTypeB = [self intToBytes:(int)serializeType];
    
    //添加版本号
    headByte[0]=versionB[0];
    //添加数据长度
    for (int i =0; i<4; i++) {
        headByte[i+1] = lenghtB[i];
    }
    //添加前端功能识别号
    for (int i =0; i<4; i++) {
        headByte[i+5] = sessionIDB[i];
    }
    //添加服务编码
    headByte[9] = serviceIDB[0];
    //添加消息体类型
    headByte[10] = sdpTypeB[0];
    //添加采用的压缩算法
    headByte[11] = compressTypeB[0];
    //添加序列化规则
    headByte[12] = serializeTypeB[0];
    
    return [[NSData alloc]initWithBytes:headByte length:13];
}
/*
 发送消息时，组装socket的消息体数据，转化成json格式的string
 */
- (NSData *)packageJsonSocketData:(NSDictionary *)dataDic withRp:(NSString *)rp withURL:(NSString *)url {
    NSError *error;
    NSData *ywJsonData = [NSJSONSerialization dataWithJSONObject:dataDic?dataDic:@{} options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"CommonUtil.m===packageSocketData:===业务数据转json失败：%@",error);
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"t"];
    [dic setValue:[[NSString alloc] initWithData:ywJsonData encoding:NSUTF8StringEncoding] forKey:@"d"];
    [dic setValue:@"1" forKey:@"v"];
    [dic setValue:rp?rp:@"" forKey:@"rp"];
    [dic setValue:url?url:@"" forKey:@"url"];
    [dic setValue:@"u" forKey:@"c"];
    [dic setValue:@"ios" forKey:@"p"];
    [dic setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"v"];
    NSData *allJsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"CommonUtil.m===packageSocketData:===消息body所有数据数据转json失败：%@",error);
        return nil;
    }
    NSLog(@"发送数据======socket消息主体：%@",[[NSString alloc] initWithData:allJsonData encoding:NSUTF8StringEncoding]);
    return allJsonData;
}
/**
 * 将int数值转换为占四个字节的byte数组
 */
- (Byte *)intToBytes:(int)value {
    NSData *data = [NSData dataWithBytes:&value length:sizeof(value)];
    return (Byte *)[data bytes];
}

#pragma mark - delegate
//- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
//    NSLog(@"client:  %s",__func__);
//}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"client:  %s",__func__);
    [self.socket readDataWithTimeout:-1 tag:0];//不加这句收不到消息
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"client:  %s",__func__);
    NSString *charStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *string = [NSString stringWithFormat:@"%@收到！",charStr];
    NSData *sendData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:sendData withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"client 发送成功");
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"client:  %s",__func__);
}
@end
