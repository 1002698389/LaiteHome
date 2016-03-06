//
//  RemoteBtn.h
//  NewHome
//
//  Created by 冉思路 on 15/8/31.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteBtn : NSObject
@property(nonatomic,assign)NSInteger _id; //按钮id
@property(nonatomic,strong)NSString *button_name;//按钮名字

@property(nonatomic,strong)NSString *preset_data;//按钮数据

@property(nonatomic,assign)NSInteger remote_id;//遥控板id



+(instancetype)remoteModalWith:(NSString *)button_name preset_data:(NSString *)preset_data remoteBtnId:(NSInteger)_id remoteId:(NSInteger)remote_id;


@end
