//
//  MainView.m
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "MainView.h"
#import "HSCButton.h"
#import "ButtonModal.h"
#import "CameraModal.h"
#import "RemoteModal.h"
#import "CemeraView.h"
#import "DatabaseOperation.h"
#import "RemoteBtn.h"
#import "SwitchBtn.h"
#import "NumberBtn.h"
#import "IObtn.h"
#define Margin 5
@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        bagImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bagImageView.image=[UIImage imageNamed:@"default"];
        
        [self addSubview:bagImageView];
             
        
        logView=[[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-2*Navi_height-20, (SCREEN_WIDTH-20)/3, Navi_height)];
        logView.backgroundColor=[UIColor clearColor];
        
        [self addSubview:logView];
//        backImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, logView.frame.size.width, logView.frame.size.height)];
//        backImg.backgroundColor=[UIColor clearColor];
//       // backImg.image=[UIImage imageNamed:@"左上角+号背景"];
//        [logView addSubview:backImg];
        
        
        //CGFloat message_y=logView.frame.size.height-20-2*Margin;
        
        messageBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        messageBtn.frame=CGRectMake(Margin, (Navi_height-22)/2, 22, 22);
        
        [messageBtn setBackgroundImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
        messageBtn.backgroundColor=[UIColor clearColor];
        [logView addSubview:messageBtn];
        messageBtn.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMessageBtn:)];
        longPressGr.minimumPressDuration = 1.0;
        [messageBtn addGestureRecognizer:longPressGr];

        
        
        
        
        long label_height=(logView.frame.size.height-3*Margin)/2;
        long label_weight=logView.frame.size.width-2*Margin;
        self.firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(3*Margin+28, (Navi_height-22)/2,label_weight,22)];
        self.firstLabel.textColor=[UIColor whiteColor];
        self.firstLabel.font=[UIFont systemFontOfSize:12];
        self.firstLabel.text=@"";
        //self.firstLabel.shadowColor=[UIColor blackColor];
        [logView addSubview:self.firstLabel];
        
//        self.secondLabel=[[UILabel alloc]initWithFrame:CGRectMake(2*Margin+25, 2*Margin+label_height,label_weight,label_height)];
//        self.secondLabel.textColor=[UIColor whiteColor];
//        self.secondLabel.shadowColor=[UIColor blackColor];
//        [logView addSubview:self.secondLabel];

        
        
        self.voiceFontLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT-Navi_height-45, 120, 30)];
        self.voiceFontLabel.textColor=[UIColor whiteColor];
        self.voiceFontLabel.textAlignment=NSTextAlignmentCenter;
        self.voiceFontLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.voiceFontLabel];
        

        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(queryCurrentSwichStatus:) name: @"querySwitch" object: nil];
         [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(firstLabel:) name: @"chinese" object: nil];//编辑按钮
        
    }
    return self;
}


-(void)showVoiceLabel:(NSString *)voiceText{
    
    self.voiceFontLabel.text=voiceText;
}

//文字反馈显示
-(void)firstLabel:(NSNotification*) notification{
    
    
    
    
    
    self.firstLabel.text=notification.object;
  
}


-(void)secondLabel:(NSString *)secondText{
    self.secondLabel.text=secondText;
}

//加载背景图片
-(void)setBackgroundImg:(NSString *)filePath{
    NSArray *views = [bagImageView subviews];
    for(UIView* view in views)
    {
       
        [view removeFromSuperview];
       
    }

        
    
    if ([filePath isEqualToString:@"default"]) {
        bagImageView.image=[UIImage imageNamed:filePath];
    }else{
        
        NSData *data=[NSData dataWithContentsOfFile:filePath];
        
        if (data==nil) {
            bagImageView.image=[UIImage imageNamed:@"default"];
        }else{
        bagImageView.image=[UIImage imageWithData:data];
        }
    }


}
//加载控件
-(void)setControlBtns:(NSArray *)items{
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        if ([view isKindOfClass:[HSCButton class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<items.count; i++) {
        ButtonModal *modal=[ButtonModal new];
        modal=[items objectAtIndex:i];
        HSCButton *hscbtn = [[HSCButton alloc] initWithFrame:CGRectMake(modal.button_x-modal.width/2, modal.button_y-modal.height/2, modal.width, modal.height) type:@"button"];
        hscbtn.enabled=YES;
        
        hscbtn.dragEnable =NO;
        hscbtn.tag=modal._id;
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake(0, 0, modal.width, modal.height);
        btn.backgroundColor=[UIColor clearColor];
        btn.enabled=YES;
        btn.userInteractionEnabled=YES;
        if ([modal.button_icon isEqualToString:@"(null)"]) {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"button_icon%d",modal.defaultIocn]] forState:UIControlStateNormal];

        }else{
            [btn setBackgroundImage:[UIImage imageNamed:modal.button_icon] forState:UIControlStateNormal];
        }
        
       // [btn setBackgroundImage:[UIImage imageNamed:modal.button_icon] forState:UIControlStateNormal];
        btn.tag=modal._id;
        [btn addTarget:self action:@selector(controlitemsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat label_y=CGRectGetMaxY(btn.frame);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x-80, label_y, btn.frame.size.width+160, 25)];
        
        label.text=modal.button_name;
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13];
        [hscbtn addSubview:label];
        [hscbtn addSubview:btn];
        [self addSubview:hscbtn];
        
    }
    
}



//加载摄像头
-(void)setcamera:(NSArray *)cameraArray{
    
    for (int i=0; i<cameraArray.count; i++) {
        CameraModal *modal=[CameraModal new];
        modal=[cameraArray objectAtIndex:i];
        HSCButton *hscbtn = [[HSCButton alloc] initWithFrame:CGRectMake(modal.camear_x-modal.width/2, modal.camear_y-modal.height/2, modal.width,modal.height) type:@"camera"];
        hscbtn.enabled=YES;
        hscbtn.dragEnable =NO;
        hscbtn.tag=modal._id;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, hscbtn.frame.size.width, hscbtn.frame.size.height)];
        view.backgroundColor=[UIColor whiteColor];
        
//        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 5*hscbtn.frame.size.height/6, hscbtn.frame.size.width, hscbtn.frame.size.height/6)];
//        bottomView.backgroundColor=[UIColor blueColor];
//        
//        UIButton *listenBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        listenBtn.tag=1;
//        listenBtn.frame=CGRectMake(hscbtn.frame.size.width/6, 3, 2*hscbtn.frame.size.width/15, bottomView.frame.size.height-6);
//        [listenBtn setBackgroundImage:[UIImage imageNamed:@"监听"] forState:UIControlStateNormal];
//        [listenBtn addTarget:self action:@selector(cameraOperation:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:listenBtn];
//        
//        UIButton *talkBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        talkBtn.frame=CGRectMake(hscbtn.frame.size.width/6+2*listenBtn.frame.size.width, 3, 2*hscbtn.frame.size.width/15, bottomView.frame.size.height-6);
//        talkBtn.tag=2;
//        // [talkBtn addTarget:self action:@selector(cameraOperation:) forControlEvents:UIControlEventTouchUpInside];
//        [talkBtn setBackgroundImage:[UIImage imageNamed:@"对讲"] forState:UIControlStateNormal];
//        [bottomView addSubview:talkBtn];
//        
//        
//         UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(speekLongPress:)];
//        longPress.delegate = self;
//
//       [talkBtn addGestureRecognizer:longPress];
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        UIButton *muteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        muteBtn.frame=CGRectMake(hscbtn.frame.size.width/6+4*listenBtn.frame.size.width, 3, 2*hscbtn.frame.size.width/15, bottomView.frame.size.height-6);
//        muteBtn.tag=3;
//         [muteBtn addTarget:self action:@selector(cameraOperation:) forControlEvents:UIControlEventTouchUpInside];
//        [muteBtn setBackgroundImage:[UIImage imageNamed:@"静音"] forState:UIControlStateNormal];
//        [bottomView addSubview:muteBtn];
        
       // [view addSubview:bottomView];
        CemeraView *cameraView=[[CemeraView alloc]initWithFrame:CGRectMake(0, 0, hscbtn.frame.size.width, hscbtn.frame.size.height
                                                                           ) cameraUid:modal.uid userName:modal.user_name passWord:modal.password];
        
        //           CemeraView *cameraView=[[CemeraView alloc]initWithFrame:CGRectMake(1, 1, view.frame.size.width-2,view.frame.size.height-hscbtn.frame.size.height/6-2)];
        cameraView.backgroundColor=[UIColor grayColor];
        [view addSubview:cameraView];
        [hscbtn addSubview:view];
                
        [self addSubview:hscbtn];
        
    }
 }


//-(void)speekLongPress:(UILongPressGestureRecognizer *)sender
//
//{
//    
//    if (sender.state == UIGestureRecognizerStateChanged) {
//        
//        NSLog(@"长按");
//        [self.delegate speekTouchBegin];
//    }else if (sender.state == UIGestureRecognizerStateEnded){
//    
//   NSLog(@"放开");
//       [self.delegate speekTouchEnd];
//    }
//
//}

//加载遥控板
-(void)setRomte:(NSArray *)remoteArray{
    
    
    
    
    
    reBtnModal=[RemoteBtn new];
   for (int i=0; i<remoteArray.count; i++) {
       RemoteModal *modal=[RemoteModal new];
       modal=[remoteArray objectAtIndex:i];
    HSCButton *hscbtn = [[HSCButton alloc] initWithFrame:CGRectMake(modal.remote_x-SCREEN_WIDTH/8.6, modal.remote_y-SCREEN_WIDTH/5.8,SCREEN_WIDTH/4.3,SCREEN_WIDTH/2.9) type:@"remote"];
    hscbtn.enabled=YES;
    hscbtn.backgroundColor=[UIColor clearColor];
     
       
    hscbtn.dragEnable =NO;
    hscbtn.tag=modal._id;

    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, hscbtn.frame.size.width, hscbtn.frame.size.height)];
   
       view.backgroundColor=[RGBACOLOR(35, 160, 210, 1) colorWithAlphaComponent:0.3];
       [view.layer setMasksToBounds:YES];
       [view.layer setCornerRadius:5.0];
    [self addSubview:view];
    
    
     NSArray *remBtnArray=[DatabaseOperation queryRemoteBtnData:modal._id];
       
       
      
       if (remBtnArray.count!=0) {
           
       
       
       
       
    long bigCircle=4*view.frame.size.width/5;
    long big_x=view.frame.size.width/10;
    long big_y=10;
    
    long smallCircle=4*bigCircle/5;
    long small_x=big_x+(bigCircle-smallCircle)/2;
    long small_y=big_y+(bigCircle-smallCircle)/2;
    
    long okCircle=smallCircle/2;
    long ok_x=small_x+(smallCircle-okCircle)/2;
    long ok_y=small_y+(smallCircle-okCircle)/2;
    
    
    long leftBtn_width=2*okCircle/5;
    long leftBtn_height=smallCircle/2;
    long left_x=small_x+(ok_x-small_x-leftBtn_width)/2+5;
    long left_y=small_y+smallCircle/4;
    
    long rightBtn_width=2*okCircle/5;
    long rightBtn_height=smallCircle/2;
    long rightBtn_x=okCircle+ok_x+(ok_x-small_x-leftBtn_width)/2-5;
    long rightBtn_y=small_y+smallCircle/4;
    
    
    long upBtn_width=smallCircle/2;
    long upBtn_height=2*okCircle/5;
    long upBtn_y=small_y+(ok_y-small_y-upBtn_height)/2+5;
    long upBtn_x=small_x+smallCircle/4;
    
    long downBtn_width=smallCircle/2;
    long downBtn_height=2*okCircle/5;
    long downBtn_y=ok_y+okCircle+(ok_y-small_y-upBtn_height)/2-5;
    long downBtn_x=small_x+smallCircle/4;
    
    
    
    
    UIImageView *bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(big_x, big_y, bigCircle, bigCircle)];
    bigImgView.image=[UIImage imageNamed:@"大圆"];
    [view addSubview:bigImgView];
    
    
    UIImageView *smallImgView=[[UIImageView alloc]initWithFrame:CGRectMake(small_x, small_y, smallCircle, smallCircle)];
    smallImgView.image=[UIImage imageNamed:@"中间小圆"];
    [view addSubview:smallImgView];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(ok_x, ok_y, okCircle, okCircle);
    okBtn.backgroundColor=[UIColor clearColor];
     reBtnModal=[remBtnArray objectAtIndex:0];
       okBtn.tag=reBtnModal._id;
       [okBtn addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"ok选中"] forState:UIControlStateNormal];
           UILongPressGestureRecognizer * longPressGr1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(remoteLongPress:)];
           longPressGr1.minimumPressDuration = 1.0;
           [okBtn addGestureRecognizer:longPressGr1];
    [view addSubview:okBtn];
    
    UIButton *leftCircleBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftCircleBtn.frame=CGRectMake(left_x, left_y, leftBtn_width, leftBtn_height);
    leftCircleBtn.backgroundColor=[UIColor clearColor];
       reBtnModal=[remBtnArray objectAtIndex:1];
       leftCircleBtn.tag=reBtnModal._id;
       [leftCircleBtn addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
           UILongPressGestureRecognizer * longPressGr2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(remoteLongPress:)];
           longPressGr2.minimumPressDuration = 1.0;
           [leftCircleBtn addGestureRecognizer:longPressGr2];
    [leftCircleBtn setBackgroundImage:[UIImage imageNamed:@"左选中"] forState:UIControlStateNormal];
    [view addSubview:leftCircleBtn];
    
    UIButton *rightCircleBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightCircleBtn.frame=CGRectMake(rightBtn_x, rightBtn_y, rightBtn_width, rightBtn_height);
    rightCircleBtn.backgroundColor=[UIColor clearColor];
       reBtnModal=[remBtnArray objectAtIndex:2];
       rightCircleBtn.tag=reBtnModal._id;
       [rightCircleBtn addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
           UILongPressGestureRecognizer * longPressGr3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(remoteLongPress:)];
           longPressGr3.minimumPressDuration = 1.0;
           [rightCircleBtn addGestureRecognizer:longPressGr3];
    [rightCircleBtn setBackgroundImage:[UIImage imageNamed:@"右选中"] forState:UIControlStateNormal];
    [view addSubview:rightCircleBtn];
    
    
    UIButton *upCircleBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    upCircleBtn.frame=CGRectMake(upBtn_x, upBtn_y, upBtn_width, upBtn_height);
    upCircleBtn.backgroundColor=[UIColor clearColor];
       reBtnModal=[remBtnArray objectAtIndex:3];
       upCircleBtn.tag=reBtnModal._id;
           UILongPressGestureRecognizer * longPressGr4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(remoteLongPress:)];
           longPressGr4.minimumPressDuration = 1.0;
           [upCircleBtn addGestureRecognizer:longPressGr4];
       [upCircleBtn addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [upCircleBtn setBackgroundImage:[UIImage imageNamed:@"上选中"] forState:UIControlStateNormal];
    [view addSubview:upCircleBtn];
    
    
    UIButton *downCircleBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    downCircleBtn.frame=CGRectMake(downBtn_x, downBtn_y, downBtn_width, downBtn_height);
    downCircleBtn.backgroundColor=[UIColor clearColor];
       reBtnModal=[remBtnArray objectAtIndex:4];
       downCircleBtn.tag=reBtnModal._id;
           UILongPressGestureRecognizer * longPressGr5 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(remoteLongPress:)];
           longPressGr5.minimumPressDuration = 1.0;
           [downCircleBtn addGestureRecognizer:longPressGr5];
       [downCircleBtn addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [downCircleBtn setBackgroundImage:[UIImage imageNamed:@"下选中"] forState:UIControlStateNormal];
    [view addSubview:downCircleBtn];
    
    
    
    CGFloat btn1_y=CGRectGetMaxY(bigImgView.frame)+5;
    
    
           CGFloat bottom_height=view.frame.size.height-btn1_y-10;
           
           
           
           
           
           long btn_height=bottom_height/3;
           long margin1=15;
           long margin2=10;
           long btn_width=(view.frame.size.width-margin1-2*margin2)/2;
           long pading=0;
           
    
       
       
       
      
       int n=5;
       
    for (int i=0; i<3; i++) {
        for (int j=0; j<2; j++) {
            reBtnModal=[remBtnArray objectAtIndex:n];
           

            UIButton *btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn1.frame=CGRectMake(margin2+j*(margin1+btn_width), btn1_y+i*(pading+btn_height), btn_width, btn_height);
            btn1.backgroundColor=[UIColor clearColor];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            btn1.tag=reBtnModal._id;
            if ([reBtnModal.button_name isEqualToString:@"(null)"]) {
                [btn1 setTitle:@"" forState:UIControlStateNormal];
            }else{
            [btn1 setTitle:reBtnModal.button_name forState:UIControlStateNormal];
            }
            [btn1 addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setBackgroundImage:[UIImage imageNamed:@"遥控器单个按钮"] forState:UIControlStateNormal];
            
            UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(remoteLongPress:)];
            longPressGr.minimumPressDuration = 1.0;
            [btn1 addGestureRecognizer:longPressGr];

            [view addSubview:btn1];
            n++;
        }
    }

    
       [hscbtn addSubview:view];
       }
    
     [self addSubview:hscbtn];
    
    
  
       
       
}
    
    
    
}



-(void)cameraOperation:(UIButton *)sender{
    if (sender.tag==1) {
       //监听
        [self.delegate cameraOperation:1];
        
    }else if (sender.tag==2){
    //语音
        [self.delegate cameraOperation:2];

        
        
    }else if (sender.tag==3){
       //静听
        [self.delegate cameraOperation:3];
    }
    
    
}

//开关
-(void)setSwitchBtns:(NSArray *)items{
    
    NSMutableDictionary * switchDic = [NSMutableDictionary dictionaryWithCapacity:5];
    
    self.switchArray=[NSArray arrayWithArray:items];
    for (int i=0; i<items.count; i++) {
        SwitchModal *modal=[SwitchModal new];
        modal=[items objectAtIndex:i];
        
        [switchDic setObject:@"switchAddr" forKey:modal.switchAddr];
        
        HSCButton *hscbtn = [[HSCButton alloc] initWithFrame:CGRectMake(modal.switch_x-25, modal.switch_y-25, 50, 50) type:@"switch"];
        hscbtn.enabled=YES;
       hscbtn.tag=modal._id;
        hscbtn.dragEnable =NO;
        
        
        SwitchBtn *btn=[[SwitchBtn alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        btn.backgroundColor=[UIColor clearColor];
        btn.enabled=YES;
        btn.userInteractionEnabled=YES;
        switch (modal.switchIcon) {
            case 1:
           [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed1_unknow"] forState:UIControlStateNormal];
                break;
            case 2:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed2_unknow"] forState:UIControlStateNormal];
                break;
            case 3:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed3_unknow"] forState:UIControlStateNormal];
                break;
            case 4:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed4_unknow"] forState:UIControlStateNormal];
                break;
            case 5:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed5_unknow"] forState:UIControlStateNormal];
                break;
            case 6:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed6_unknow"] forState:UIControlStateNormal];
                break;
            case 7:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed7_unknow"] forState:UIControlStateNormal];
                break;
            case 8:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed8_unknow"] forState:UIControlStateNormal];
                break;
            case 9:
                 [btn setBackgroundImage:[UIImage imageNamed:@"ic_feed9_unknow"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
        
        
       
        btn.tag=modal._id*100;
      
        
        
        
//        btn.userInteractionEnabled=YES;
        
        
        
        
        [btn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat label_y=CGRectGetMaxY(btn.frame);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x-80, label_y, btn.frame.size.width+160, 25)];
        label.userInteractionEnabled=YES;
        label.tag=modal._id;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
        
        [label addGestureRecognizer:labelTapGestureRecognizer];
        
        label.text=modal.switchName;
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13];
        [hscbtn addSubview:label];
        [hscbtn addSubview:btn];
        [self addSubview:hscbtn];
        
    }
    
    NSArray *switchAddrs=[switchDic allKeys];
    self.switchKeys=[switchDic allKeys];
    


    if (self.ioArray.count>0) {
        [self performSelector:@selector(timerFiredIo) withObject:nil afterDelay:1.0f];//延迟查询开关

        
    }else{
        
        
        [self querySwitchs:switchAddrs];
        
        
    }










}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    
    NSLog(@"%@被点击了",label.text);
    
    
    
}



-(void)timerFiredIo{
    
    
    [self querySwitchs:self.switchKeys];
   

}
//数值
-(void)setNumberBtns:(NSArray *)items{
    //    NSArray *views = [self subviews];
    //    for(UIView* view in views)
    //    {
    //        if ([view isKindOfClass:[HSCButton class]]) {
    //            [view removeFromSuperview];
    //        }
    //    }
    
    self.numberArray=[NSArray arrayWithArray:items];
  
    
    for (int i=0; i<items.count; i++) {
        NumberModal *modal=[NumberModal new];
        modal=[items objectAtIndex:i];
        HSCButton *hscbtn = [[HSCButton alloc] initWithFrame:CGRectMake(modal.number_x-modal.width/2, modal.number_y-modal.height/2, modal.width, modal.height) type:@"number"];
        hscbtn.enabled=YES;
        hscbtn.userInteractionEnabled=YES;
        
        hscbtn.dragEnable =NO;
        hscbtn.tag=modal._id;
        
        NumberBtn *btn=[[NumberBtn alloc]initWithFrame:CGRectMake(0, 0, modal.width, modal.height) numberModal:modal];
                                          
       // btn.frame=CGRectMake(0, 0, 150, 50);
        btn.backgroundColor=[UIColor clearColor];
       
        btn.userInteractionEnabled=YES;
                
        
        btn.tag=modal._id*1000;
        btn.userInteractionEnabled=YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        UIView *singleTapView = [singleTap view];
        singleTapView.tag =modal._id;
        [btn addGestureRecognizer:singleTap];
        
        
       // [btn  addTarget:self action:@selector(numberClick:) forControlEvents:UIControlEventTouchUpInside];
        [hscbtn addSubview:btn];
        [self addSubview:hscbtn];
        
    }
    
    
    if (self.switchKeys.count>0) {
        float second=1.0+0.3*self.switchKeys.count;
        [self performSelector:@selector(timerFiredNumber) withObject:nil afterDelay:second];

        
    }else{
   
       
        self.numberNub=0;
        [self loadNumberValue:self.numberArray count:0];

    
    
   
    }
    
}




-(void)timerFiredNumber{
    
    self.numberNub=0;
    [self loadNumberValue:self.numberArray count:0];
    
    
}


//数值
-(void)setIOBtns:(NSArray *)items{
    
    
    self.ioArray=[NSArray arrayWithArray:items];
       for (int i=0; i<items.count; i++) {
        IOModal *modal=[IOModal new];
        modal=[items objectAtIndex:i];
           
         
        HSCButton *hscbtn = [[HSCButton alloc] initWithFrame:CGRectMake(modal.io_x-modal.width/2, modal.io_y-modal.height/2, modal.width, modal.height) type:@"io"];
           
           
        hscbtn.enabled=YES;
        
        hscbtn.dragEnable =NO;
        hscbtn.tag=modal._id;
        
        IObtn *btn=[[IObtn alloc]initWithFrame:CGRectMake(0, 0, modal.width, modal.height) ioModal:modal];
        
        btn.backgroundColor=[UIColor clearColor];
        
        btn.userInteractionEnabled=YES;
        
        
        btn.tag=modal._id*10000;
        
           UITapGestureRecognizer* ioTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ioTap:)];
           UIView *singleTapView = [ioTap view];
           singleTapView.tag =modal._id;
           [btn addGestureRecognizer:ioTap];

       
        [hscbtn addSubview:btn];
        [self addSubview:hscbtn];
        
    }
    


    [self queryIoVaule];




}

-(void)remoteLongPress:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.operId=gesture.view.tag;
        NSLog(@"长按%ld",self.operId);
    [self.delegate editRomteBtn:self.operId];

    }
}












//遥控板按钮点击事件
-(void)remoteBtnClick:(UIButton *)sender{
    
    
    
     [self.delegate remoteButtonClick:sender.tag];
    
     [CurrentTableName shared].queryResult=@"no";
}





-(void)stopshow{
    
    [self.delegate stopCameraShow];
    
}



//查询开关状态
-(void)querySwitchStatus:(NSString *)swithcLine switchAddr:(NSString *)swichAddr{
    
    [self.delegate querySwitchStatus:swithcLine switchAddr:swichAddr];
}


//按钮点击事件
-(void)controlitemsClick:(UIButton *)sender{
    
    NSLog(@"点击");
   [self.delegate BtnClick:sender.tag];

    
}

//开关点击事件
-(void)switchBtnClick:(UIButton *)sender{
    
    NSLog(@"开关单点");
    [self.delegate switchClick:sender.tag];
    
}



-(void)querySwitchs:(NSArray *)swichAddrs{
    
    if (swichAddrs.count>0) {
        
        for (NSString *addr in swichAddrs) {
            
        [self querySwitchStatus:@"0000" switchAddr:addr];
        
        }
    
    
    
    }
    
    
    
}




-(void)loadNumberValue:(NSArray *)numbers count:(long)count{
    if (numbers.count>0) {
        
        
        NumberModal *modal=[NumberModal new];
        modal=[numbers objectAtIndex:count];
        
        self.currentNumberId=modal._id;
        [self.delegate queryNumberValue:modal.numberAddr];
        
}
    

    
    
}



-(void)queryIoVaule{
    
    [self.delegate queryIoVaule];
}




//展示开关状态
-(void)showSwitchStatus:(NSString *)swithAddr newStr:(NSString *)newStr currentRoomId:(long)roomId{
    
    
    
    NSArray *swichs=[DatabaseOperation querySwitchs:swithAddr roomId:roomId];
    
    for (SwitchModal *modal in swichs) {
        SwitchBtn *btn=(SwitchBtn *)[self viewWithTag:modal._id*100];
        NSString *statusStr;
        if (modal.switchLine==1) {
            statusStr=[newStr substringToIndex:2];
            
        }else if (modal.switchLine==2){
            NSRange range1= NSMakeRange(2,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==3){
            NSRange range1= NSMakeRange(4,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==4){
            NSRange range1= NSMakeRange(6,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==5){
            NSRange range1= NSMakeRange(8,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==6){
            NSRange range1= NSMakeRange(10,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==7){
            NSRange range1= NSMakeRange(12,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==8){
            NSRange range1= NSMakeRange(14,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==9){
            NSRange range1= NSMakeRange(16,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==10){
            NSRange range1= NSMakeRange(18,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==11){
            NSRange range1= NSMakeRange(20,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==12){
            NSRange range1= NSMakeRange(22,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==13){
            NSRange range1= NSMakeRange(24,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==14){
            NSRange range1= NSMakeRange(26,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==15){
            NSRange range1= NSMakeRange(28,2);
            statusStr=[newStr substringWithRange:range1];
        }else if (modal.switchLine==16){
            NSRange range1= NSMakeRange(30,2);
            statusStr=[newStr substringWithRange:range1];
        }
        
        NSString *imgStr;
        if ([statusStr isEqualToString:@"00"]) {
            
            imgStr=[NSString stringWithFormat:@"ic_feed%ld_close",(long)modal.switchIcon];
            
        }else if ([statusStr isEqualToString:@"01"]) {
            
            
            imgStr=[NSString stringWithFormat:@"ic_feed%ld_open",(long)modal.switchIcon];
            
        }else if ([statusStr isEqualToString:@"0f"]) {
            imgStr=[NSString stringWithFormat:@"ic_feed%ld_unknow",(long)modal.switchIcon];
        }
        
        [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];

    }
    
}

-(void)showNumberText1:(NSString *)text1 color1:(NSString *)color1 text2:(NSString *)text2 color2:(NSString *)color2 numberAddr:(NSString *)numAddr{
    
    
    NumberModal *modal=[NumberModal new];
    modal=[DatabaseOperation queryCurrentNumber:numAddr];
    
    NumberBtn *btn=(NumberBtn *)[self viewWithTag:modal._id*1000];
    
    btn.backgroundColor=[UIColor clearColor];
    
    if ([btn isKindOfClass:[NumberBtn class]]) {
        btn.valueText1.text=text1;
        btn.valueText2.text=text2;
        if ([color1 isEqualToString:@"green"]) {
            btn.valueText1.textColor=[UIColor greenColor];
        }else if([color1 isEqualToString:@"white"]){
            btn.valueText1.textColor=[UIColor whiteColor];
        }
        if ([color2 isEqualToString:@"green"]) {
            btn.valueText2.textColor=[UIColor greenColor];
        }else if([color2 isEqualToString:@"white"]){
            btn.valueText2.textColor=[UIColor whiteColor];
        }
        
        
        self.numberNub++;
        if (self.numberNub<self.numberArray.count) {
            [self loadNumberValue:self.numberArray count:self.numberNub];
        }

    }
    
    

}
-(void)showIoStatus:(NSString *)reciveStr{
    
    
    
    for (IOModal *modal in self.ioArray) {
        IObtn *btn=(IObtn *)[self viewWithTag:modal._id*10000];
        NSString *str1=[reciveStr substringToIndex:2];
        NSString *str2=[reciveStr substringWithRange:NSMakeRange(2, 2)];
        NSString *str3=[reciveStr substringWithRange:NSMakeRange(4, 2)];
        NSString *str4=[reciveStr substringWithRange:NSMakeRange(6, 2)];
        NSString *str5=[reciveStr substringWithRange:NSMakeRange(8, 2)];
        NSString *str6=[reciveStr substringWithRange:NSMakeRange(10, 2)];
        NSString *str7=[reciveStr substringWithRange:NSMakeRange(12, 2)];
        NSLog(@"reciveStr:%@",reciveStr);
        NSString *str8=[reciveStr substringWithRange:NSMakeRange(14, 2)];
        NSString *str9=[reciveStr substringWithRange:NSMakeRange(16, 2)];
        NSString *str10=[reciveStr substringWithRange:NSMakeRange(18, 2)];
        NSString *str11=[reciveStr substringWithRange:NSMakeRange(20, 2)];
        NSString *str12=[reciveStr substringWithRange:NSMakeRange(22, 2)];
        NSString *str13=[reciveStr substringWithRange:NSMakeRange(24, 2)];
        NSString *str14=[reciveStr substringWithRange:NSMakeRange(26, 2)];
        NSString *str15=[reciveStr substringWithRange:NSMakeRange(28, 2)];
        NSString *str16=[reciveStr substringWithRange:NSMakeRange(30, 2)];
        
        if ([str1 isEqualToString:@"00"]) {
            btn.inImg1.image=[UIImage imageNamed:@"in_off"];
        }else if ([str1 isEqualToString:@"01"]){
            btn.inImg1.image=[UIImage imageNamed:@"in_on"];

        }
        if ([str2 isEqualToString:@"00"]) {
            btn.inImg2.image=[UIImage imageNamed:@"in_off"];
        }else if ([str2 isEqualToString:@"01"]){
             btn.inImg2.image=[UIImage imageNamed:@"in_on"];
        }if ([str3 isEqualToString:@"00"]) {
            btn.inImg3.image=[UIImage imageNamed:@"in_off"];
        }else if ([str3 isEqualToString:@"01"]){
             btn.inImg3.image=[UIImage imageNamed:@"in_on"];
        }if ([str4 isEqualToString:@"00"]) {
            btn.inImg4.image=[UIImage imageNamed:@"in_off"];
        }else if ([str4 isEqualToString:@"01"]){
             btn.inImg4.image=[UIImage imageNamed:@"in_on"];
        }if ([str5 isEqualToString:@"00"]) {
            btn.inImg5.image=[UIImage imageNamed:@"in_off"];
        }else if ([str5 isEqualToString:@"01"]){
             btn.inImg5.image=[UIImage imageNamed:@"in_on"];
        }if ([str6 isEqualToString:@"00"]) {
            btn.inImg6.image=[UIImage imageNamed:@"in_off"];
        }else if ([str6 isEqualToString:@"01"]){
             btn.inImg6.image=[UIImage imageNamed:@"in_on"];
        }if ([str7 isEqualToString:@"00"]) {
            btn.inImg7.image=[UIImage imageNamed:@"in_off"];
        }else if ([str7 isEqualToString:@"01"]){
             btn.inImg7.image=[UIImage imageNamed:@"in_on"];
        }if ([str8 isEqualToString:@"00"]) {
            btn.inImg8.image=[UIImage imageNamed:@"in_off"];
        }else if ([str8 isEqualToString:@"01"]){
             btn.inImg8.image=[UIImage imageNamed:@"in_on"];
        }if ([str9 isEqualToString:@"00"]) {
            btn.offImg1.image=[UIImage imageNamed:@"out_off"];
        }else if ([str9 isEqualToString:@"01"]){
             btn.offImg1.image=[UIImage imageNamed:@"out_on"];
        }if ([str10 isEqualToString:@"00"]) {
            btn.offImg2.image=[UIImage imageNamed:@"out_off"];
        }else if ([str10 isEqualToString:@"01"]){
             btn.offImg2.image=[UIImage imageNamed:@"out_on"];
        }if ([str11 isEqualToString:@"00"]) {
             btn.offImg3.image=[UIImage imageNamed:@"out_off"];
        }else if ([str11 isEqualToString:@"01"]){
             btn.offImg3.image=[UIImage imageNamed:@"out_on"];
        }if ([str12 isEqualToString:@"00"]) {
             btn.offImg4.image=[UIImage imageNamed:@"out_off"];
        }else if ([str12 isEqualToString:@"01"]){
             btn.offImg4.image=[UIImage imageNamed:@"out_on"];
        }if ([str13 isEqualToString:@"00"]) {
             btn.offImg5.image=[UIImage imageNamed:@"out_off"];
        }else if ([str13 isEqualToString:@"01"]){
             btn.offImg5.image=[UIImage imageNamed:@"out_on"];
        }if ([str14 isEqualToString:@"00"]) {
             btn.offImg6.image=[UIImage imageNamed:@"out_off"];
        }else if ([str14 isEqualToString:@"01"]){
             btn.offImg6.image=[UIImage imageNamed:@"out_on"];
        }if ([str15 isEqualToString:@"00"]) {
             btn.offImg7.image=[UIImage imageNamed:@"out_off"];
        }else if ([str15 isEqualToString:@"01"]){
             btn.offImg7.image=[UIImage imageNamed:@"out_on"];
        }if ([str16 isEqualToString:@"00"]) {
             btn.offImg8.image=[UIImage imageNamed:@"out_off"];
        }else if ([str16 isEqualToString:@"01"]){
             btn.offImg8.image=[UIImage imageNamed:@"out_on"];
        }
    
       
    
    }
    
    
}


 -(void)singleTap:(UITapGestureRecognizer *)sender{
     UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    
    [self.delegate numberClick:[singleTap view].tag];
    
}
//IO点击事件
-(void)ioTap:(UITapGestureRecognizer *)sender{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    
    [self.delegate IOClick:[singleTap view].tag];
    
}



-(void)longPressMessageBtn:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        [self becomeFirstResponder];
        
        
        self.operId=gesture.view.tag;
        m_menuCtrl = [UIMenuController sharedMenuController];
        
    
            UIMenuItem *itemOpen = [[UIMenuItem alloc] initWithTitle:@"开启" action:@selector(openMsg)];
            UIMenuItem *itemClose = [[UIMenuItem alloc] initWithTitle:@"关闭" action:@selector(coloseMsg)];
            UIMenuItem *itemCheck = [[UIMenuItem alloc] initWithTitle:@"查看" action:@selector(checkMsg)];
            UIMenuItem *itemSet = [[UIMenuItem alloc] initWithTitle:@"设置" action:@selector(setMsg)];

        
            [m_menuCtrl setMenuItems:[NSArray arrayWithObjects:itemOpen,itemClose, itemCheck,itemSet,nil]];
            
            
        
        
        [m_menuCtrl setTargetRect:messageBtn.frame inView:messageBtn.superview];
        [m_menuCtrl setMenuVisible:YES animated:YES];
        
        
        
    }




}





-(BOOL)canBecomeFirstResponder{
    return YES;
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(openMsg)) {
        
        return YES;
        
    }else if (action == @selector(coloseMsg)){
        return YES;
    }else if (action == @selector(checkMsg)){
        return YES;
    }else if (action == @selector(setMsg)){
        return YES;
    }
    
    
    
    
    return NO;
    
}

-(void)queryCurrentSwichStatus:(NSNotification*) notification{
    self.currentSwitchId=[notification.object integerValue];
    
}
-(void)openMsg{
    [self.delegate openMessagePush];
}
-(void)coloseMsg{
    [self.delegate closeMessagePush];
}
-(void)checkMsg{
    [self.delegate checkLog];
}
-(void)setMsg{
    [self.delegate setLog];
}

@end
