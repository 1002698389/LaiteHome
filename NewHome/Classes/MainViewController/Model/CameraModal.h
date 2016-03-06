//
//  CameraModal.h
//  NewHome
//
//  Created by 冉思路 on 15/8/27.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraModal : NSObject
@property(nonatomic,assign)NSInteger _id; //数据id
@property(nonatomic,strong)NSString *camear_name;
@property(nonatomic,assign)NSInteger room_id;//数据类型
@property(nonatomic,strong)NSString *uid;//数据名字
@property(nonatomic,strong)NSString *user_name;//数据名字
@property(nonatomic,strong)NSString *password;//数据名字
@property(nonatomic,assign)NSInteger camear_x;//数据类型
@property(nonatomic,assign)NSInteger camear_y;//数据类型
@property(nonatomic,assign)NSInteger definition;//清晰度
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;

@property(nonatomic,assign)NSInteger customSelect;


+ (instancetype)cameraModalWith:(NSString *)camear_name uid:(NSString *)uid user_name:(NSString *)user_name password:(NSString *)password camear_x:(NSInteger)camear_x  camear_y:(NSInteger)camear_y width:(float)width height:(float)height customSelect:(NSInteger)customSelect definition:(NSInteger)definition room_id:(NSInteger)room_id _id:(NSInteger)_id;

@end
