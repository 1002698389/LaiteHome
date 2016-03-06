//
//  LGSocketServe.h
//  AsyncSocketDemo
//
//  Created by ligang on 15/4/3.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "HostModal.h"
#import "AppDelegate.h"

enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};


@interface LGSocketServe : NSObject<AsyncSocketDelegate>
{
    HostModal *hostModal;
    BOOL pushWord;
    long currentHostId;
    BOOL checkRecive;
    dispatch_source_t _timer;
}
@property (nonatomic, strong) AsyncSocket         *socket;       // socket
@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器
@property(nonatomic,strong)NSString *ipAddress;
@property(nonatomic,strong)NSString *ipPort;

+ (LGSocketServe *)sharedSocketServe;

//  socket连接
- (void)startConnectSocket:(NSString *)address port:(NSString *)port hostId:(long)hostId;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendMessage:(id)message;



@end
