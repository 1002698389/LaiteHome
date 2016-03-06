//
//  QuickButton.h
//  NewHome
//
//  Created by 小热狗 on 15/7/31.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickButton : NSObject
@property(nonatomic,assign)NSInteger _id; //按钮id
@property(nonatomic,strong)NSString *button_name;//按钮名字
@property(nonatomic,assign)NSInteger preset_data_id;//按钮数据id
@property(nonatomic,assign)NSInteger host_id;//主机id
@property(nonatomic,strong)NSString *net_data;

+ (instancetype)quickButtonModalWith:(NSString *)button_name  presetDataId:(NSInteger)preset_data_id  hostId:(NSInteger)host_id quickBtnId:(NSInteger)_id net_data:(NSString *)net_data;
@end
