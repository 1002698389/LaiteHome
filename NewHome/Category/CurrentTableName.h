//
//  CurrentTableName.h
//  NewHome
//
//  Created by 冉思路 on 15/8/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentTableName : NSObject
+(instancetype)shared;
@property (nonatomic,strong)NSString *tableName;//表名
@property(nonatomic,strong)NSString *operBtnState;//当前操作按钮的状态(添加，编辑）
@property(nonatomic,strong)NSString *operRoomState;//当前操作房间的状态(添加，编辑）
@property(nonatomic,strong)NSString *operCameraState;//当前操作摄像头的状态(添加，编辑）
@property(nonatomic,assign)long hostId;
@property(nonatomic,strong)NSString *cameraUid;//摄像头uid
@property(nonatomic,strong)NSArray *keysArray;
@property(nonatomic,strong)NSString *queryResult;
@property(nonatomic,strong)NSString *netStatus;
@property(nonatomic,assign)long noResultCount;
@property(nonatomic,strong)NSString *hostSynStatus;
@property(nonatomic,strong)NSString *hostIsSyn;
@property(nonatomic,strong)NSString *synOne;//主机
@property(nonatomic,strong)NSString *synTwo;//主机

@property(nonatomic,strong)NSString *feedBackOne;//文字反馈
@property(nonatomic,strong)NSString *feedBackTwo;//文字反馈


@property(nonatomic,strong)NSString *numAndSwiOne;//开关数值反馈
@property(nonatomic,strong)NSString *numAndSwiTwo;//开关数值反馈

@property(nonatomic,strong)NSString *ioOne;//开关数值反馈
@property(nonatomic,strong)NSString *ioTwo;//开关数值反馈

@property(nonatomic,strong)NSString *enviOne;//开关数值反馈
@property(nonatomic,strong)NSString *enviTwo;//开关数值反馈
@end
