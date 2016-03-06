//
//  HostModal.h
//  NewHome
//
//  Created by 小热狗 on 15/7/21.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostModal : NSObject

@property(nonatomic,assign)NSInteger _id; //主机id
@property(nonatomic,strong)NSString *host_network;//外网地址
@property(nonatomic,strong)NSString *host_intranet;//内网地址
@property(nonatomic,strong)NSString *network_port;//外网端口
@property(nonatomic,strong)NSString *intranet_port;//内网端口
@property(nonatomic,strong)NSString *imei;//机器码
@property(nonatomic,assign)NSInteger type;// 是否使用
@property(nonatomic,strong)NSString *host_name;//主机名字

+ (instancetype)hostModalWith:(NSString *)host_name imei:(NSString *)imei hostNetwork:(NSString *)host_network hostIntranet:(NSString *)host_intranet networkPort:(NSString *)network_port intranetPort:(NSString *)intranet_port Type:(NSInteger)type  hostId:(NSInteger)_id ;




@end
