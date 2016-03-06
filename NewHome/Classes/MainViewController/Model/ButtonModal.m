//
//  ButtonModal.m
//  NewHome
//
//  Created by 小热狗 on 15/7/21.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "ButtonModal.h"

@implementation ButtonModal
+ (instancetype)buttonModalWith:(NSInteger)button_room buttonName:(NSString *)button_name buttonIcon:(NSString *)button_icon presetDataId:(NSInteger)preset_data_id netData:(NSString *)net_data buttonX:(NSInteger)button_x buttonY:(NSInteger)button_y width:(float)width height:(float)height defaultIcon:(NSInteger)defaultIcon customSelect:(NSInteger)customSelect buttonId:(NSInteger)_id{
    ButtonModal *modal = [[ButtonModal alloc] init];
    modal.button_room = button_room;
    modal.button_name = button_name;
    modal.button_icon = button_icon;
    modal.preset_data_id=preset_data_id;
    modal.net_data=net_data;
    modal.button_x=button_x;
    modal.button_y=button_y;
    modal.width=width;
    modal.height=height;
    modal.defaultIocn=defaultIcon;
    modal._id=_id;
    modal.customSelect=customSelect;
    return modal;

    
    
    
    
}
@end
