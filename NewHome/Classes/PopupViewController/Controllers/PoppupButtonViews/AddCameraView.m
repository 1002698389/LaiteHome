//
//  AddCameraView.m
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "AddCameraView.h"

@implementation AddCameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        long btn_width=frame.size.width/4;
        long btn_height=frame.size.height/6;
        
        //        long contentView_height=view_heiht-2*btn_height;  //内容高度
        //        long padding=(contentView_height-4*TextField_height)/5;//y间距
        //        long label_width=80;                                //标题长度
        //        long textfield_width=view_width-label_width-3*margin;   //输入框长度
        
        
        
        
        
        //标题栏
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, btn_height)];
        titleView.backgroundColor=PopView_TitleColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/2, 5, 2*btn_width, btn_height-10)];
        titleLabel.text=@"新建摄像头";
        titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
        [titleView addSubview:titleLabel];
        
        [self addSubview:titleView];
        
        
        
        
        
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame=CGRectMake(0, frame.size.height-btn_height, frame.size.width*2/3, btn_height);
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.tag=1;
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(addRoomClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame=CGRectMake(frame.size.width*2/3, cancelBtn.frame.origin.y, frame.size.width/3, btn_height);
        okBtn.backgroundColor=[UIColor clearColor];
        okBtn.tag=2;
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addRoomClick:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:okBtn];
        
        
        
        
    }
    return self;
}

@end
