//
//  HostModal.m
//  NewHome
//
//  Created by 小热狗 on 15/7/21.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "HostModal.h"

@implementation HostModal
+ (instancetype)hostModalWith:(NSString *)host_name imei:(NSString *)imei hostNetwork:(NSString *)host_network hostIntranet:(NSString *)host_intranet networkPort:(NSString *)network_port intranetPort:(NSString *)intranet_port Type:(NSInteger)type  hostId:(NSInteger)_id{
    HostModal *modal = [[HostModal alloc] init];
    modal.host_name = host_name;
    modal.imei = imei;
    modal.host_network = host_network;
    modal.host_intranet=host_intranet;
    modal.network_port=network_port;
    modal.intranet_port=intranet_port;
    modal.type=type;
    modal._id=_id;
  
    return modal;
}

@end
