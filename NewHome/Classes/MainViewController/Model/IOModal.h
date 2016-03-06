//
//  IOModal.h
//  NewHome
//
//  Created by 小热狗 on 15/12/8.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOModal : NSObject

@property(nonatomic,assign)NSInteger _id; //数据id
@property(nonatomic,strong)NSString *ioName;

@property(nonatomic,assign)NSInteger room_id;//


@property(nonatomic,assign)NSInteger io_x;//数据类型
@property(nonatomic,assign)NSInteger io_y;//数据类型
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;

@property(nonatomic,assign)NSInteger customSelect;
+ (instancetype)ioModalWith:(NSString *)ioName  room_id:(NSInteger)room_id  io_x:(NSInteger)io_x io_y:(NSInteger)io_y width:(float)width height:(float)height customSelect:(NSInteger)customSelect _id:(NSInteger)_id;
@end
