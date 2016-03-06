//
//  SwitchModal.m
//  NewHome
//
//  Created by 小热狗 on 15/12/8.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "SwitchModal.h"

@implementation SwitchModal
+ (instancetype)switchModalWith:(NSString *)switchName switchAddr:(NSString *)switchAddr switchIcon:(NSInteger)switchIcon switchLine:(NSInteger)switchLine room_id:(NSInteger)room_id  switch_x:(NSInteger)switch_x switch_y:(NSInteger)switch_y _id:(NSInteger)_id{
    SwitchModal *modal = [[SwitchModal alloc] init];
    modal.switchName = switchName;
    modal.switchAddr = switchAddr;
    modal.switchIcon = switchIcon;
    modal.switchLine=switchLine;
    modal.switch_x=switch_x;
    modal.switch_y=switch_y;
    modal.room_id=room_id;
    modal._id=_id;
    
    return modal;

    
    
    
    
}
@end
