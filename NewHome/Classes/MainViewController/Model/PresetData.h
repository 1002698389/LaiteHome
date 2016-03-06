//
//  PresetData.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresetData : NSObject
@property(nonatomic,assign)NSInteger _id; //数据id
@property(nonatomic,strong)NSString *name;//数据名字
@property(nonatomic,assign)NSInteger data_type;//数据类型
@property(nonatomic,strong)NSString *data;//数据内容
@property(nonatomic,strong)NSString *syn;//同步判断
+ (instancetype)presetDataModalWith:(NSString *)name  data_type:(NSInteger)data_type  data:(NSString *)data presetId:(NSInteger)_id syn:(NSString *)syn;

@end
