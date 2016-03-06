//
//  CameraModal.m
//  NewHome
//
//  Created by 冉思路 on 15/8/27.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "CameraModal.h"

@implementation CameraModal
+ (instancetype)cameraModalWith:(NSString *)camear_name uid:(NSString *)uid user_name:(NSString *)user_name password:(NSString *)password camear_x:(NSInteger)camear_x  camear_y:(NSInteger)camear_y width:(float)width height:(float)height customSelect:(NSInteger)customSelect definition:(NSInteger)definition room_id:(NSInteger)room_id _id:(NSInteger)_id{
    
    CameraModal *modal = [[CameraModal alloc] init];
    modal.camear_name = camear_name;
    modal.uid = uid;
    modal.user_name = user_name;
    modal.password=password;
    modal.camear_x=camear_x;
    modal.camear_y=camear_y;
    modal.definition=definition;
    modal.room_id=room_id;
    modal._id=_id;
    modal.width=width;
    modal.height=height;
    modal.customSelect=customSelect;
    return modal;

    
}

@end
