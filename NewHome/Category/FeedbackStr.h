//
//  FeedbackStr.h
//  NewHome
//
//  Created by 小热狗 on 16/1/13.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackStr : NSObject

//同步
@property(nonatomic,strong)NSString *synComplete;
@property(nonatomic,strong)NSString *synOne;
@property(nonatomic,strong)NSString *sysTwo;
//IO反馈
@property(nonatomic,strong)NSString *ioComplete;
@property(nonatomic,strong)NSString *ioOne;
@property(nonatomic,strong)NSString *ioTwo;
//开关反馈
@property(nonatomic,strong)NSString *switchComplete;
@property(nonatomic,strong)NSString *switchOne;
@property(nonatomic,strong)NSString *switchTwo;
//文字反馈
@property(nonatomic,strong)NSString *textComplete;
@property(nonatomic,strong)NSString *textOne;
@property(nonatomic,strong)NSString *textTwo;

//数值反馈
@property(nonatomic,strong)NSString *numberComplete;
@property(nonatomic,strong)NSString *numberOne;
@property(nonatomic,strong)NSString *numberTwo;


//+(NSString *)completeBackStr:(NSString *)part


@end
