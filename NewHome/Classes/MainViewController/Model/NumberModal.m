//
//  NumberModal.m
//  NewHome
//
//  Created by 小热狗 on 15/12/8.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "NumberModal.h"

@implementation NumberModal
+ (instancetype)numberModalWith:(NSString *)numberName numberAddr:(NSString *)numberAddr numberOne:(NSString *)numberOne numberTwo:(NSString *)numberTwo room_id:(NSInteger)room_id  number_x:(NSInteger)number_x number_y:(NSInteger)number_y width:(float)width height:(float)height customSelect:(NSInteger)customSelect _id:(NSInteger)_id{
    NumberModal *modal = [[NumberModal alloc] init];
    modal.numberName = numberName;
    modal.numberAddr = numberAddr;
    modal.numberOne = numberOne;
    modal.numberTwo=numberTwo;
    modal.number_x=number_x;
    modal.number_y=number_y;
    modal.room_id=room_id;
    modal._id=_id;
    modal.width=width;
    modal.height=height;
    modal.customSelect=customSelect;
    return modal;
    
    
    
    
    
}

@end
