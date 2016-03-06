//
//  RemoteBtn.m
//  NewHome
//
//  Created by 冉思路 on 15/8/31.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "RemoteBtn.h"

@implementation RemoteBtn
+(instancetype)remoteModalWith:(NSString *)button_name preset_data:(NSString *)preset_data remoteBtnId:(NSInteger)_id remoteId:(NSInteger)remote_id{
    RemoteBtn *modal = [[RemoteBtn alloc] init];
    modal.button_name= button_name;
    modal.preset_data = preset_data;
    modal._id=_id;
    modal.remote_id=remote_id;
    return modal;
    

    
    
    
    
}
@end
