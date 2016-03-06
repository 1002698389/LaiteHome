//
//  IObtn.m
//  NewHome
//
//  Created by 小热狗 on 15/12/16.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "IObtn.h"

@implementation IObtn
-(id)initWithFrame:(CGRect)frame ioModal:(IOModal *)modal
{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.backgroundColor=[UIColor whiteColor];
        
        
        float out_width=frame.size.width/(4.5+8);
        float out_height=out_width*172/164;
        float line_height=frame.size.height/25;
        float in_height=out_height/8;
        float text_height=out_height;
        float margin_y=(frame.size.height-in_height-2*out_height)/3;
        float margin_x=out_width/2;
        
        
        
        
        
//        
//        long line_heitht=backView.frame.size.height/25;
//        
//  
//        
//        long margin=10;
//        long label_width=(backView.frame.size.width-9*margin)/8;//输出宽度(圆圈)
//        long label_height=label_width*172/164;//输出高度(圆圈)
//        long label_height1=(backView.frame.size.height-5*line_heitht)/6;//输入高度（线）

        
        
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, line_height)];
        topView.backgroundColor=RGBACOLOR(153, 204, 0, 1);
        [backView addSubview:topView];
        
       
        CGFloat img_y=CGRectGetMaxY(topView.frame)+margin_y;
        
        
        
           self.inImg1=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x, img_y, out_width, in_height)];
            self.inImg1.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg1];
        
            self.inImg2=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+out_width+margin_x, img_y, out_width, in_height)];
            self.inImg2.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg2];
        
            self.inImg3=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+2*(out_width+margin_x),img_y, out_width, in_height)];
            self.inImg3.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg3];
        
            self.inImg4=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+3*(out_width+margin_x), img_y, out_width, in_height)];
            self.inImg4.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg4];
        
            self.inImg5=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+4*(out_width+margin_x), img_y, out_width, in_height)];
            self.inImg5.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg5];
        
            self.inImg6=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+5*(out_width+margin_x), img_y, out_width, in_height)];
            self.inImg6.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg6];
        
            self.inImg7=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+6*(out_width+margin_x), img_y, out_width, in_height)];
            self.inImg7.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg7];
        
            self.inImg8=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+7*(out_width+margin_x), img_y, out_width, in_height)];
            self.inImg8.image=[UIImage imageNamed:@"in_off"];
            [backView addSubview:self.inImg8];
        
                
        CGFloat img_y1=CGRectGetMaxY(self.inImg1.frame)+margin_y;

        
            self.offImg1=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x, img_y1, out_width, out_height)];
            self.offImg1.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg1];
            
            self.offImg2=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+out_width+margin_x, img_y1, out_width, out_height)];
            self.offImg2.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg2];
            
            self.offImg3=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+2*(out_width+margin_x), img_y1, out_width, out_height)];
            self.offImg3.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg3];
            
            self.offImg4=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+3*(out_width+margin_x), img_y1, out_width, out_height)];
            self.offImg4.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg4];
            
            self.offImg5=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+4*(out_width+margin_x), img_y1, out_width, out_height)];
            self.offImg5.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg5];
            
            self.offImg6=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+5*(out_width+margin_x), img_y1, out_width, out_height)];
            self.offImg6.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg6];
            
            self.offImg7=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+6*(out_width+margin_x), img_y1, out_width, out_height)];
            self.offImg7.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg7];
            
            self.offImg8=[[UIImageView alloc]initWithFrame:CGRectMake(margin_x+7*(out_width+margin_x),  img_y1, out_width, out_height)];
            self.offImg8.image=[UIImage imageNamed:@"out_off"];
            [backView addSubview:self.offImg8];
        
        
      
 
        CGFloat text_y=CGRectGetMaxY(self.offImg1.frame)+margin_y;
        
        
        UITextField *text3=[[UITextField alloc]initWithFrame:CGRectMake(0, text_y, backView.frame.size.width, text_height)];
        text3.backgroundColor=RGBACOLOR(51, 204, 255, 1);
        text3.textAlignment=NSTextAlignmentCenter;
        text3.text=modal.ioName;
        text3.textColor=[UIColor whiteColor];
//        text3.font=[UIFont systemFontOfSize:9];
        text3.enabled=NO;
        [backView addSubview:text3];
        
        [self addSubview:backView];
        
    }
    return self;



}

@end
