//
//  LogModal.h
//  NewHome
//
//  Created by 小热狗 on 15/12/17.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogModal : NSObject
@property(nonatomic,assign)NSInteger _id;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createTime;

@property(nonatomic,assign)NSInteger host_id;

+ (instancetype)logModalWith:(NSString *)createTime content:(NSString *)content  hostId:(NSInteger)host_id  logId:(NSInteger)_id;

@end
