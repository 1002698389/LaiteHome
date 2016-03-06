//
//  NumberModal.h
//  NewHome
//
//  Created by 小热狗 on 15/12/8.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberModal : NSObject
@property(nonatomic,assign)NSInteger _id; //数据id
@property(nonatomic,strong)NSString *numberName;
@property(nonatomic,strong)NSString *numberAddr;
@property(nonatomic,strong)NSString * numberOne;
@property(nonatomic,strong)NSString * numberTwo;
@property(nonatomic,assign)NSInteger room_id;//


@property(nonatomic,assign)NSInteger number_x;//数据类型
@property(nonatomic,assign)NSInteger number_y;//数据类型
@property(nonatomic,assign)float width;
@property(nonatomic,assign)float height;

@property(nonatomic,assign)NSInteger customSelect;
+ (instancetype)numberModalWith:(NSString *)numberName numberAddr:(NSString *)numberAddr numberOne:(NSString *)numberOne numberTwo:(NSString *)numberTwo room_id:(NSInteger)room_id  number_x:(NSInteger)number_x number_y:(NSInteger)number_y width:(float)width height:(float)height customSelect:(NSInteger)customSelect _id:(NSInteger)_id;
@end
