//
//  SwitchModal.h
//  NewHome
//
//  Created by 小热狗 on 15/12/8.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchModal : NSObject
@property(nonatomic,assign)NSInteger _id; //数据id
@property(nonatomic,strong)NSString *switchName;
@property(nonatomic,strong)NSString *switchAddr;
@property(nonatomic,assign)NSInteger switchIcon;
@property(nonatomic,assign)NSInteger switchLine;
@property(nonatomic,assign)NSInteger room_id;//


@property(nonatomic,strong)NSString *password;//数据名字
@property(nonatomic,assign)NSInteger switch_x;//数据类型
@property(nonatomic,assign)NSInteger switch_y;//数据类型


+ (instancetype)switchModalWith:(NSString *)switchName switchAddr:(NSString *)switchAddr switchIcon:(NSInteger)switchIcon switchLine:(NSInteger)switchLine room_id:(NSInteger)room_id  switch_x:(NSInteger)switch_x switch_y:(NSInteger)switch_y _id:(NSInteger)_id;
@end
