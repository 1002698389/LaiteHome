//
//  RemoteModal.h
//  NewHome
//
//  Created by 冉思路 on 15/8/30.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteModal : NSObject
@property(nonatomic,assign)NSInteger _id; //遥控板id
@property(nonatomic,assign)NSInteger remote_x;//遥控板x坐标
@property(nonatomic,assign)NSInteger remote_y;//遥控板坐标
@property(nonatomic,assign)NSInteger room_id;//房间Id

+ (instancetype)remoteModalWith:(NSInteger)_id  remote_x:(NSInteger)remote_x  remote_y:(NSInteger)remote_y room_id:(NSInteger)room_id;
@end
