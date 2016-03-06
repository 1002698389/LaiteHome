//
//  RoomModal.m
//  NewHome
//
//  Created by 小热狗 on 15/7/21.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "RoomModal.h"

@implementation RoomModal
+ (instancetype)roomModalWith:(NSString *)room_name roomIcon:(NSInteger)room_icon roomBackground:(NSString *)room_background roomHaveCamera:(NSInteger)room_have_camera cameraAddress:(NSString *)camera_address cameraUsername:(NSString *)camera_username cameraPassword:(NSString *)camera_password hostId:(NSInteger)host_id roomType:(NSInteger)room_type roomId:(NSInteger)_id{
    RoomModal *modal = [[RoomModal alloc] init];
    modal.room_name = room_name;
    modal.room_icon = room_icon;
    modal.room_background= room_background;
    modal.room_have_camera=room_have_camera;
    modal.camera_address=camera_address;
    modal.camera_username=camera_username;
    modal.camera_password=camera_password;
    modal.host_id=host_id;
    modal.room_type=room_type;
    modal._id=_id;
    return modal;
    
}
@end
