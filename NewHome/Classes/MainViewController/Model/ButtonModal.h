//
//  ButtonModal.h
//  NewHome
//
//  Created by 小热狗 on 15/7/21.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonModal : NSObject
@property(nonatomic,assign)NSInteger _id; //按钮id
@property(nonatomic,assign)NSInteger button_room;// 属于哪个房间
@property(nonatomic,strong)NSString *button_name;//按钮名字
@property(nonatomic,strong)NSString *button_icon;//按钮图片
@property(nonatomic,assign)NSInteger preset_data_id;//按钮数据id
@property(nonatomic,strong)NSString *net_data;//按钮数据
@property(nonatomic,assign)NSInteger button_x;//按钮x坐标
@property(nonatomic,assign)NSInteger button_y;//按钮有坐标
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;
@property(nonatomic,assign)NSInteger defaultIocn;
@property(nonatomic,assign)NSInteger customSelect;

+ (instancetype)buttonModalWith:(NSInteger)button_room buttonName:(NSString *)button_name buttonIcon:(NSString *)button_icon presetDataId:(NSInteger)preset_data_id netData:(NSString *)net_data buttonX:(NSInteger)button_x buttonY:(NSInteger)button_y width:(float)width height:(float)height defaultIcon:(NSInteger)defaultIcon customSelect:(NSInteger)customSelect buttonId:(NSInteger)_id;

@end
