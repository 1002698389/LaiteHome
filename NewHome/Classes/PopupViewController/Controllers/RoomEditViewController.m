//
//  RoomEditViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/12/20.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "RoomEditViewController.h"
#import "DatabaseOperation.h"
#define margin 10
@interface RoomEditViewController ()

@end

@implementation RoomEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
       
    
    long view_heiht=SCREEN_HEIGHT/2;
    long view_width=SCREEN_WIDTH/2;
    
    
    
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
    
    
    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/6;
    
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
    

    
    
    
    
    
    long contentView_height=self.view.frame.size.height-2*btn_height;  //内容高度
    long padding=(contentView_height-2*textField_height)/3;//y间距
    long label_width=80;                                //标题长度
    long textfield_width=view_width-label_width-3*margin;   //输入框长度

     [self BtnData:self.roomId hostId:self.hostId];
    
    
    
    
    
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"编辑房间";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    
    //房间名称
    
    CGFloat roomName_Y=CGRectGetMaxY(titleView.frame)+padding;
    UILabel *roomName=[[UILabel alloc]initWithFrame:CGRectMake(margin, roomName_Y, label_width, textField_height)];
    roomName.text=@"房间名称";
    roomName.textColor=Text_color;
    [self.view addSubview:roomName];
    
    CGFloat nameField_X=CGRectGetMaxX(roomName.frame)+margin;
    roomNameText=[[UITextField alloc]initWithFrame:CGRectMake(nameField_X, roomName_Y, textfield_width, textField_height)];
   
    roomNameText.text=modal.room_name;
    roomNameText.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:roomNameText];
    
    
    
    //背景图片
    CGFloat backImg_Y=CGRectGetMaxY(roomName.frame)+padding;
    UILabel *backImg=[[UILabel alloc]initWithFrame:CGRectMake(margin, backImg_Y, label_width,textField_height)];
    backImg.text=@"背景图片";
    backImg.textColor=Text_color;
    [self.view addSubview:backImg];
    
    CGFloat displayBtn_X=CGRectGetMaxX(backImg.frame)+margin;
    UIButton *displayBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    displayBtn.frame=CGRectMake(displayBtn_X, backImg_Y, textfield_width/3, textField_height);
    displayBtn.backgroundColor=[UIColor clearColor];
    [displayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [displayBtn setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
    [displayBtn addTarget:self action:@selector(upLoadImg) forControlEvents:UIControlEventTouchUpInside];
    [displayBtn setTitle:@"浏览" forState:UIControlStateNormal];
    [self.view addSubview:displayBtn];
    
    CGFloat imgView_X=CGRectGetMaxX(displayBtn.frame)+margin;
    
    CGFloat img_y=CGRectGetMaxY(roomNameText.frame);
    disPlayImgView=[[UIImageView alloc]initWithFrame:CGRectMake(imgView_X, img_y, 2*textfield_width/3-margin, 2*padding+textField_height)];
    disPlayImgView.backgroundColor=[UIColor clearColor];
    
    if ([modal.room_background isEqualToString:@"default"]) {
        disPlayImgView.image=[UIImage imageNamed:@"default"];
    }else{
        
        NSData *data=[NSData dataWithContentsOfFile:modal.room_background];
        
        disPlayImgView.image=[UIImage imageWithData:data];
        
        
        
    }
    
    [self.view addSubview:disPlayImgView];
    
    
    
    
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width/2, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(editRemote:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width/2, cancelBtn.frame.origin.y, view_width/2, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(editRemote:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    
    
    // Do any additional setup after loading the view.
}



-(void)BtnData:(long)btnId hostId:(long)hostId{
    
    modal=[RoomModal new];
    
    modal=[DatabaseOperation queryRoom:btnId hostId:hostId];
}



//选择房间图片（本地）
-(void)upLoadImg{
    
    [self.delegate upLoadImgEdit];
    
}

//浏览图片
-(void)setImage:(UIImage *)image{
    
    disPlayImgView.image=image;
    
}
//添加房间(确认，取消)
-(void)editRemote:(UIButton *)sender{
    
    [self.delegate editRoomName:roomNameText.text tag:sender.tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
