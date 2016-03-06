//
//  AddRemoteView.m
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "AddRemoteView.h"
#define padinng 5
@implementation AddRemoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        long btn_width=frame.size.width/4;
        long btn_height=frame.size.height/6;
        switch ( [UIDevice iPhonesModel]) {
            case iPhone4:
                textField_height=25.0;
                break;
            case iPhone5:
                textField_height=25.0;
                break;
            case iPhone6:
                textField_height=30.0;
                break;
            case iPhone6Plus:
                textField_height=30.0;
                break;
            case UnKnown:
                textField_height=50.0;
                break;
                
                
            default:
                break;
        }
        
        
        
        
        
        
        //标题栏
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, btn_height)];
        titleView.backgroundColor=PopView_TitleColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
        titleLabel.text=@"新建遥控";
        titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
        [titleView addSubview:titleLabel];
        
        [self addSubview:titleView];
        
        
        
       long contentView_height=frame.size.height-2*btn_height;  //内容高度
       
       // long width=btn_width/3;
        float height=contentView_height-2*padinng;
        float width=height*573/1024;
        float img_x=(self.frame.size.width-width)/2;
        
        //794 1048
        CGFloat btn_y=CGRectGetMaxY(titleView.frame)+padinng;
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake(img_x, btn_y, width, height);
        [btn setBackgroundImage:[UIImage imageNamed:@"control_normal"] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor clearColor];
        //[btn addTarget:self action:@selector(remoteSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        
        
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame=CGRectMake(0, frame.size.height-btn_height, frame.size.width*2/3, btn_height);
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.tag=1;
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(addRemote:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame=CGRectMake(frame.size.width*2/3, cancelBtn.frame.origin.y, frame.size.width/3, btn_height);
        okBtn.backgroundColor=[UIColor clearColor];
        okBtn.tag=2;
        [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addRemote:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:okBtn];
        
        
        
    }
    return self;
}




//添加摄像头
-(void)addRemote:(UIButton *)sender{
    
    
    [self.delegate showRemote:sender.tag];

    
    
    
}





-(void)remoteSelect{
    
    
    
    
    
    
}
@end
