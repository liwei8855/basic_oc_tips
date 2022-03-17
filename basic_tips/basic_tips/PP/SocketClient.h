//
//  SocketClient.h
//  basic_tips
//
//  Created by 李威 on 2022/3/16.
//

#import <UIKit/UIKit.h>
#import "Socket/GCDAsyncSocket.h"
#import "Reachability/Reachability.h"

NS_ASSUME_NONNULL_BEGIN

//socket数据的序列化类型
typedef enum {
    SERIALIZETYPE_JSON = 1,
    SERIALIZETYPE_BINARY = 2,
    SERIALIZETYPE_XML = 3
}SerializeType;

//收到socket消息后处理功能模块对应的sessionID
typedef enum {
    SESSIONID_NONE = 0,
    SESSIONID_RECEVIEORDER = 1,
    SESSIONID_RECEVIEIMMESSAGE = 2,
    SESSIONID_SENDIMMESSAGESUCCESS = 3,
    SESSIONID_BROADCAST = 4
}SessionID;

//socket消息的消息类型
typedef enum {
    SDPTYPE_REQUEST = 1,
    SDPTYPE_RESPONSE = 2,
    SDPTYPE_PUSH = 3,
    SDPTYPE_BROADCAST = 4,
    SDPTYPE_EXCEPTION = 5
}SdpType;

//socket消息结束标示符
#define EndMark @"9527"
#define EndMarkByte "9527"

@interface SocketClient : NSObject<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, strong) NSTimer *socketTimer;
@property (nonatomic, assign) BOOL isConnect;
+ (instancetype)sharedInstance;
- (void)replyServer:(NSString *)msgId;
- (void)connectToHost;
- (void)closeSocket;
- (void)logoutUserInSocket;
@end

NS_ASSUME_NONNULL_END
