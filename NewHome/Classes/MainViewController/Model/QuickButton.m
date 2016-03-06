//
//  QuickButton.m
//  NewHome
//
//  Created by 小热狗 on 15/7/31.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "QuickButton.h"

@implementation QuickButton
+ (instancetype)quickButtonModalWith:(NSString *)button_name  presetDataId:(NSInteger)preset_data_id  hostId:(NSInteger)host_id quickBtnId:(NSInteger)_id net_data:(NSString *)net_data{
    
    QuickButton *modal = [[QuickButton alloc] init];
    modal.button_name = button_name;
    modal.preset_data_id=preset_data_id;
    modal.host_id=host_id;
    modal._id=_id;
    modal.net_data=net_data;
    return modal;
    
}
@end
