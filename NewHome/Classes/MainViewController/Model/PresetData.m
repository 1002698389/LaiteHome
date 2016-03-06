//
//  PresetData.m
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "PresetData.h"

@implementation PresetData
+ (instancetype)presetDataModalWith:(NSString *)name  data_type:(NSInteger)data_type  data:(NSString *)data presetId:(NSInteger)_id syn:(NSString *)syn{
    
    PresetData *modal = [[PresetData alloc] init];
    modal.name = name;
    modal.data_type=data_type;
    modal.data=data;
    modal._id=_id;
    modal.syn=syn;
    return modal;

    
}
@end
