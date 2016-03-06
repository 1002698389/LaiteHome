//
//  RoomModal.h
//  NewHome
//
//  Created by 小热狗 on 15/7/21.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomModal : NSObject


@property(nonatomic,assign)NSInteger _id;//房间id
@property(nonatomic,strong)NSString *room_name; //房间名字
@property(nonatomic,assign)NSInteger room_icon;//房间图标
@property(nonatomic,strong)NSString *room_background;//房间背景
@property(nonatomic,assign)NSInteger room_have_camera;//是否有摄像头
@property(nonatomic,strong)NSString *camera_address;//摄像头地址
@property(nonatomic,strong)NSString *camera_username;//摄像头用户名
@property(nonatomic,strong)NSString *camera_password;//摄像头密码
@property(nonatomic,assign)NSInteger host_id;//主机id
@property(nonatomic,assign)NSInteger room_type;//房间类型
+ (instancetype)roomModalWith:(NSString *)room_name roomIcon:(NSInteger)room_icon roomBackground:(NSString *)room_background roomHaveCamera:(NSInteger)room_have_camera cameraAddress:(NSString *)camera_address cameraUsername:(NSString *)camera_username cameraPassword:(NSString *)camera_password hostId:(NSInteger)host_id roomType:(NSInteger)room_type roomId:(NSInteger)_id;

@end
