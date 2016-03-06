//
//  LogModal.m
//  NewHome
//
//  Created by 小热狗 on 15/12/17.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "LogModal.h"

@implementation LogModal
+ (instancetype)logModalWith:(NSString *)createTime content:(NSString *)content  hostId:(NSInteger)host_id  logId:(NSInteger)_id{
    LogModal *modal = [[LogModal alloc] init];
    modal.createTime = createTime;
    modal.content = content;
    modal.host_id=host_id;
    modal._id=_id;
    return modal;
    
    
}
@end
