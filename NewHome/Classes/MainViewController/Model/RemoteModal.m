//
//  RemoteModal.m
//  NewHome
//
//  Created by 冉思路 on 15/8/30.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "RemoteModal.h"

@implementation RemoteModal
+ (instancetype)remoteModalWith:(NSInteger)_id  remote_x:(NSInteger)remote_x  remote_y:(NSInteger)remote_y room_id:(NSInteger)room_id{
    
    RemoteModal *modal = [[RemoteModal alloc] init];
    modal._id=_id;
    modal.remote_x=remote_x;
    modal.remote_y=remote_y;
    modal.room_id=room_id;
    return modal;

    
}
@end
