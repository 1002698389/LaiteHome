//
//  NumberBtn.h
//  NewHome
//
//  Created by 小热狗 on 15/12/16.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberModal.h"
@interface NumberBtn : UIView
@property(nonatomic,strong)UITextField *valueText1;
@property(nonatomic,strong)UITextField *valueText2;
-(id)initWithFrame:(CGRect)frame numberModal:(NumberModal *)modal;


@end
