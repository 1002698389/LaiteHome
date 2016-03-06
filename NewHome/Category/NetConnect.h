//
//  NetConnect.h
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostModal.h"
#import "AsyncSocket.h"
@interface NetConnect : NSObject
{
    AsyncSocket *client;//实例化socket

}


-(void)connectHost:(HostModal *)modal;//连接主机
- (void)sendMsg:(NSString *)dataMsg;//发送数据
@end
