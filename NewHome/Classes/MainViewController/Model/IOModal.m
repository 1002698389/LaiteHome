//
//  IOModal.m
//  NewHome
//
//  Created by 小热狗 on 15/12/8.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "IOModal.h"

@implementation IOModal
+ (instancetype)ioModalWith:(NSString *)ioName  room_id:(NSInteger)room_id  io_x:(NSInteger)io_x io_y:(NSInteger)io_y width:(float)width height:(float)height customSelect:(NSInteger)customSelect _id:(NSInteger)_id{
    IOModal *modal = [[IOModal alloc] init];
    modal.ioName = ioName;
    
    modal.io_x=io_x;
    modal.io_y=io_y;
    modal.room_id=room_id;
    modal._id=_id;
    modal.width=width;
    modal.height=height;
    modal.customSelect=customSelect;
    return modal;
    
}
@end
