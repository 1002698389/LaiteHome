//
//  CurrentTableName.m
//  NewHome
//
//  Created by 冉思路 on 15/8/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "CurrentTableName.h"

@implementation CurrentTableName
+ (instancetype)shared
{
    static CurrentTableName *userData=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[CurrentTableName alloc]init];
        
    });
    return userData;
}


@end
