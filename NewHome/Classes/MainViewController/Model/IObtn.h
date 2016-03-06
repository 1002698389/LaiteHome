//
//  IObtn.h
//  NewHome
//
//  Created by 小热狗 on 15/12/16.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOModal.h"
@interface IObtn : UIView
@property(nonatomic,strong)UIImageView *inImg1;
@property(nonatomic,strong)UIImageView *inImg2;
@property(nonatomic,strong)UIImageView *inImg3;
@property(nonatomic,strong)UIImageView *inImg4;
@property(nonatomic,strong)UIImageView *inImg5;
@property(nonatomic,strong)UIImageView *inImg6;
@property(nonatomic,strong)UIImageView *inImg7;
@property(nonatomic,strong)UIImageView *inImg8;
@property(nonatomic,strong)UIImageView *offImg1;
@property(nonatomic,strong)UIImageView *offImg2;
@property(nonatomic,strong)UIImageView *offImg3;
@property(nonatomic,strong)UIImageView *offImg4;
@property(nonatomic,strong)UIImageView *offImg5;
@property(nonatomic,strong)UIImageView *offImg6;
@property(nonatomic,strong)UIImageView *offImg7;
@property(nonatomic,strong)UIImageView *offImg8;
-(id)initWithFrame:(CGRect)frame ioModal:(IOModal *)modal;
@end
