//
//  NumberBtn.m
//  NewHome
//
//  Created by 小热狗 on 15/12/16.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "NumberBtn.h"

@implementation NumberBtn
-(id)initWithFrame:(CGRect)frame numberModal:(NumberModal *)modal
{
  
    self = [super initWithFrame:frame];
    if (self) {

    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    backView.backgroundColor=[UIColor whiteColor];

    backView.userInteractionEnabled=YES;
    long line_heitht=backView.frame.size.height/25;
    long label_height=(backView.frame.size.height-5*line_heitht)/3;
    long margin=backView.frame.size.width/20;
    long label_width=(backView.frame.size.width-3*margin)/2;
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, line_heitht)];
        topView.backgroundColor=RGBACOLOR(153, 204, 0, 1);
    [backView addSubview:topView];
    
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(margin, 3*line_heitht, label_width, label_height)];
    label1.text=modal.numberOne;
        label1.userInteractionEnabled=YES;
        
    label1.textAlignment=NSTextAlignmentCenter;
    //label1.font=[UIFont systemFontOfSize:9];
    [backView addSubview:label1];
    
    
    CGFloat label2_y=CGRectGetMaxY(label1.frame)+line_heitht;
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(margin,label2_y, label_width, label_height)];
    label2.text=modal.numberTwo;
    label2.textAlignment=NSTextAlignmentCenter;
        label2.userInteractionEnabled=YES;
//    label2.font=[UIFont systemFontOfSize:9];
    [backView addSubview:label2];
    
    CGFloat text_x=CGRectGetMaxX(label1.frame)+margin;
    self.valueText1=[[UITextField alloc]initWithFrame:CGRectMake(text_x, label1.frame.origin.y, label_width, label_height)];
    self.valueText1.backgroundColor=RGBACOLOR(51, 204, 255, 1);
    self.valueText1.enabled=NO;
         self.valueText1.font=[UIFont fontWithName:@"DBLCDTempBlack" size:9];
        self.valueText1.textAlignment=NSTextAlignmentCenter;
      
    [backView addSubview:self.valueText1];
    
    self.valueText2=[[UITextField alloc]initWithFrame:CGRectMake(text_x, label2.frame.origin.y, label_width, label_height)];
    self.valueText2.backgroundColor=RGBACOLOR(51, 204, 255, 1);
    self.valueText2.enabled=NO;
         self.valueText2.font=[UIFont fontWithName:@"DBLCDTempBlack" size:9];
        self.valueText2.textAlignment=NSTextAlignmentCenter;
      
    [backView addSubview:self.valueText2];
    
    
    CGFloat name_y=CGRectGetMaxY(label2.frame)+2*line_heitht;
    
    UITextField *text3=[[UITextField alloc]initWithFrame:CGRectMake(0, name_y, backView.frame.size.width, label_height)];
    text3.backgroundColor=RGBACOLOR(51, 204, 255, 1);
    text3.textAlignment=NSTextAlignmentCenter;
    text3.text=modal.numberName;
        
    text3.textColor=[UIColor whiteColor];
//    text3.font=[UIFont systemFontOfSize:9];
    text3.enabled=NO;
    [backView addSubview:text3];
    [self addSubview:backView];
   
    }
    return self;
}


@end
