//
//  PoppueProgressViewController.h
//  NewHome
//
//  Created by 冉思路 on 15/8/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ProgressGradientView.h"
@protocol showProgressViewDelegate <NSObject>

-(void)showProgress:(long)tag;//添加按钮(确定，取消）


@end
@interface PoppueProgressViewController : UIViewController
{
    
    ProgressGradientView *pgv;
  

    UILabel *proLabel;
}
@property(nonatomic,retain)id <showProgressViewDelegate> delegate;
-(void)animationProgress:(float)number;
-(void)showLabel:(NSString *)progressNub;
@end
