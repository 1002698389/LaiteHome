//
//  SwitchBtn.h
//  NewHome
//
//  Created by 小热狗 on 15/12/11.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchBtn : UIButton
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@end
