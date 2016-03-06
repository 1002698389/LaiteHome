//
//  AddIOView.m
//  NewHome
//
//  Created by 小热狗 on 15/12/2.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "AddIOView.h"
#import "DatabaseOperation.h"
#define margin 10
@implementation AddIOView
- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId;//初始化
{
    self = [super initWithFrame:frame];
    if (self) {
        
         [self ioData:btnId];
        customSelect=NO;
       self.customSize=1;//默认大小
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(getCameraUid:) name: @"cameraUid" object: nil];
        long label_width;
        
        
        switch ( [UIDevice iPhonesModel]) {
            case iPhone4:
                textField_height=25.0;
                label_width=45;
                break;
            case iPhone5:
                textField_height=25.0;
                label_width=45;
                break;
            case iPhone6:
                textField_height=30.0;
                label_width=60;
                break;
            case iPhone6Plus:
                textField_height=30.0;
                label_width=60;
                break;
            case UnKnown:
                textField_height=50.0;
                label_width=60;
                break;
                
                
            default:
                break;
        }

        long btn_width=frame.size.width/4;
        long btn_height=frame.size.height/6;
              

        long contentView_height=frame.size.height-2*btn_height;  //内容高度
        long padding=(contentView_height-4*textField_height)/5;//y间距
        long padding1=(contentView_height-4*textField_height)/5;//y间距
        float img_height=contentView_height-4*padding1;//标题长度
        float img_width=img_height*539/425;
        float imgY=(contentView_height-img_height)/2+btn_height;

        
        long textfield_width=frame.size.width-label_width-img_width-4*margin;   //输入框长度
        
        
        
        //标题栏
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, btn_height)];
        titleView.backgroundColor=PopView_TitleColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
        titleLabel.text=@"IO";
        titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
        [titleView addSubview:titleLabel];
        
        [self addSubview:titleView];
        
        
        
        
        
        
        
        CGFloat btnName_Y=CGRectGetMaxY(titleView.frame)+padding;
        UIImageView *cameraView=[[UIImageView alloc]initWithFrame:CGRectMake(margin, imgY, img_width, img_height)];
        cameraView.image=[UIImage imageNamed:@"ic_io_img"];
        [self addSubview:cameraView];
        
        
        
        
        
        long pading=(img_width-2*textField_height)/3;
        CGFloat nameLabel_x=CGRectGetMaxX(cameraView.frame)+margin;
        long labelWidth=60;
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel_x, btnName_Y+pading, labelWidth, textField_height)];
        nameLabel.text=@"名称";
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.textColor=Text_color;
        [self addSubview:nameLabel];
        
        CGFloat nameText_y=CGRectGetMaxY(nameLabel.frame)+pading;
        CGFloat nameText_x=CGRectGetMaxX(nameLabel.frame)+margin;
        long name_width=self.frame.size.width-nameText_x-margin;

        self.nameText=[[UITextField alloc]initWithFrame:CGRectMake(nameText_x, btnName_Y+pading, name_width, textField_height)];
        self.nameText.text=modal.ioName;
        self.nameText.backgroundColor=BACKGROUND_COLOR;
        self.nameText.placeholder=@"名称";
        [self addSubview:self.nameText];
        
        CGFloat sizeLabel_Y= CGRectGetMaxY(nameLabel.frame)+pading;
        UILabel *sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel_x, sizeLabel_Y,label_width, textField_height)];
        sizeLabel.text=@"宽高";
        sizeLabel.textColor=Text_color;
        sizeLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:sizeLabel];
        
        CGFloat sizeBtn_X=CGRectGetMaxX(sizeLabel.frame)+margin;
        sizeBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        sizeBtn.frame=CGRectMake(sizeBtn_X, sizeLabel.frame.origin.y+textField_height/4, textField_height/2, textField_height/2);
        sizeBtn.backgroundColor=[UIColor clearColor];
        [sizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sizeBtn.tintColor=[UIColor clearColor];
        [sizeBtn setBackgroundImage:[UIImage imageNamed:@"方框选中"] forState:UIControlStateSelected];
        [sizeBtn setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
        [sizeBtn addTarget:self action:@selector(sizeBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sizeBtn];
        
        CGFloat widthText_X=CGRectGetMaxX(sizeBtn.frame)+margin;
        widthText=[[UITextField alloc]initWithFrame:CGRectMake(widthText_X,sizeLabel.frame.origin.y, label_width, textField_height)];
         widthText.textColor=[UIColor lightGrayColor];
                if (modal.customSelect==2) {
                    long btnWidth=modal.width;
                    widthText.text=[NSString stringWithFormat:@"%0ld",btnWidth];
                    self.customSize=2;
                    sizeBtn.selected=YES;
        
                    widthText.enabled=YES;
        
                }else{
                    widthText.text=@"200";
        widthText.enabled=NO;
                }
        
        
        widthText.backgroundColor=BACKGROUND_COLOR;
        
        widthText.keyboardType= UIKeyboardTypeNumberPad;
        [self addSubview:widthText];
        
        CGFloat heightText_X=CGRectGetMaxX(widthText.frame)+margin;
        heightText=[[UITextField alloc]initWithFrame:CGRectMake(heightText_X,sizeLabel.frame.origin.y, label_width, textField_height)];
         heightText.textColor=[UIColor lightGrayColor];
                if (modal.customSelect==2) {
                    long btnHeight=modal.height;
                    heightText.text=[NSString stringWithFormat:@"%ld",btnHeight];
                    self.customSize=2;
                    sizeBtn.selected=YES;
        
                    heightText.enabled=YES;
        
                }else{
                    heightText.text=@"55";
        heightText.enabled=NO;
                }
        
        
        
        heightText.backgroundColor=BACKGROUND_COLOR;
        heightText.keyboardType= UIKeyboardTypeNumberPad;
        [self addSubview:heightText];

        
        
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame=CGRectMake(0, frame.size.height-btn_height, frame.size.width*2/3, btn_height);
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.tag=1;
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(addIoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame=CGRectMake(frame.size.width*2/3, cancelBtn.frame.origin.y, frame.size.width/3, btn_height);
        okBtn.backgroundColor=[UIColor clearColor];
        okBtn.tag=2;
        [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addIoClick:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:okBtn];
        
        
        
        
    }
    return self;
}
-(void)sizeBtnSelect:(UIButton *)sender{
    
    if (sender.selected==YES) {
        
        sender.selected=NO;
        self.customSize=1; //默认
        widthText.enabled=NO;
        heightText.enabled=NO;
        
    }else{
        
        sender.selected=YES;
        self.customSize=2;//自定义
        widthText.enabled=YES;
        heightText.enabled=YES;
    }
    
    
    
    
    
}
-(void)ioData:(long)ioId{
    
    modal=[IOModal new];
    
    modal=[DatabaseOperation queryIo:ioId];
    
    
}

-(void)addIoClick:(UIButton *)sender{
    if (self.customSize==1) {
        widthText.text=@"150";
        heightText.text=@"50";
        
         [self.delegate addIo:_nameText.text tag:sender.tag width:widthText.text height:heightText.text customSelect:self.customSize];
        
    }else{
        
        
        if ([widthText.text isEqualToString:@""]||[heightText.text isEqualToString:@""]) {
            NSString *message=@"按钮宽高不能为空";
            [self makeToast:message];
            return;
        }else if ([widthText.text isEqualToString:@"0"]||[heightText.text isEqualToString:@"0"]) {
            NSString *message=@"按钮宽高不能为0";
            [self makeToast:message];
            return;
        }else{
             [self.delegate addIo:_nameText.text tag:sender.tag width:widthText.text height:heightText.text customSelect:self.customSize];
        }
        
        
        
        
        
        
        
    }

   
    
    
    
}
@end
