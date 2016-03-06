//
//  BottomView.m
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "BottomView.h"
#import "RoomModal.h"
#import "AppDelegate.h"
@implementation BottomView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        long section_width=(frame.size.width-10)/3; //底部3等分
        long section_height=frame.size.height;
        
        micOpen=NO;
        //底部导航条
        bottomNavView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, section_width, section_height)];
        bottomNavView.backgroundColor=[UIColor clearColor];
        [self addSubview:bottomNavView];
        
        UIImageView *bottomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, section_width, section_height)];
        bottomImgView.image=[UIImage imageNamed:@"home_bg"];
        [bottomNavView addSubview:bottomImgView];
        
        //底部导航条上的增加按钮
         UIButton *addRoomBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        addRoomBtn.frame=CGRectMake(section_width*3/4, 0, section_width/4, section_height);
        //[addRoomBtn setBackgroundImage:[UIImage imageNamed:@"房间"] forState:UIControlStateNormal];
        UIImageView *roomBtnImgView=[[UIImageView alloc]initWithFrame:CGRectMake((addRoomBtn.frame.size.width-75/3.4)/2, (addRoomBtn.frame.size.height-56/3.4)/2, 75/3.4, 56/3.4)];
        roomBtnImgView.image=[UIImage imageNamed:@"房间增加"];
        [addRoomBtn addSubview:roomBtnImgView];

                addRoomBtn.backgroundColor=[UIColor clearColor];
        [addRoomBtn setTintColor:[UIColor whiteColor]];
        [addRoomBtn addTarget:self action:@selector(addRoomBtn) forControlEvents:UIControlEventTouchUpInside];
        [bottomNavView addSubview:addRoomBtn];

        
       //底部导航条上的滚动条
        bottomScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, section_width*3/4, section_height)];
        bottomScr.contentSize=CGSizeMake(section_width*3/4, 0);
        bottomScr.backgroundColor=[UIColor clearColor];
        [bottomNavView addSubview:bottomScr];
        
                  
    
    
        CGFloat mic_x=CGRectGetMaxX(bottomNavView.frame)+(section_width-section_height*209/188)/2;
      //中间麦克风
        microphoneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
         microphoneBtn.frame=CGRectMake(mic_x, 0,section_height*209/188,section_height);
        [microphoneBtn setBackgroundImage:[UIImage imageNamed:@"麦克风待机状态"] forState:UIControlStateNormal];
         microphoneBtn.backgroundColor=[UIColor clearColor];
        [microphoneBtn setTintColor:[UIColor whiteColor]];
        [microphoneBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:microphoneBtn];

    
    
        
        
        
        
        
        
        
        //底部设备分组
        equiView=[[UIView alloc]initWithFrame:CGRectMake(2*section_width+10, 0, section_width, section_height)];
        equiView.backgroundColor=[UIColor clearColor];
        [self addSubview:equiView];

    
        //底部设备分组滚动条
        equiScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, section_width*4/5, section_height)];
        equiScr.contentSize=CGSizeMake(section_width*4/5, 0);
        equiScr.backgroundColor=[UIColor clearColor];
        [equiView addSubview:equiScr];
    
    
    
    
      //底部设置按钮
        UIButton *setBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        setBtn.frame=CGRectMake(section_width*4/5, 0, section_width/5, section_height);
        setBtn.backgroundColor=[UIColor clearColor];
       // UIImage *btnImg=[self scaleToSize:[UIImage imageNamed:@"设置"] size:CGSizeMake(section_height-10, section_height/1.8)];
        UIImageView *setImgView=[[UIImageView alloc]initWithFrame:CGRectMake((setBtn.frame.size.width-section_height/1.7)/2, (setBtn.frame.size.height-section_height/1.7)/2, section_height/1.7, section_height/1.7)];
        setImgView.image=[UIImage imageNamed:@"设置"];
        setImgView.backgroundColor=[UIColor clearColor];
        [setBtn addSubview:setImgView];
        
        //[setBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
        
        [setBtn addTarget:self action:@selector(hostSet) forControlEvents:UIControlEventTouchUpInside];
        [equiView  addSubview:setBtn];
        
    
    }
    return self;
}




//滚动条加载房间按钮
-(void)setBottomItems:(NSArray *)items{
    
    for (UIView *view in [bottomScr subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    
    
    long btn_width=bottomNavView.frame.size.width/4;
    long btn_hight=bottomNavView.frame.size.height;
    
      long w=0;
    //加载房间按钮
    for (int i=0; i<items.count; i++) {
        RoomModal *modal=[RoomModal new];
        modal=[items objectAtIndex:i];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag=modal._id;
        if (i==0) {
            btn.selected=YES;
            selectBtn=btn;
        }
        
      
    
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
//         CGFloat length = [modal.room_name boundingRectWithSize:CGSizeMake(MAXFLOAT, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
//        btn.frame=CGRectMake(w, 0, length+15, btn_hight);
        
       btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
       CGSize titleSize = [modal.room_name sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        titleSize.height=btn_hight;
        titleSize.width+=15;
        btn.frame=CGRectMake(w, 0, titleSize.width, titleSize.height);
        
        
        
//        [btn setBackgroundImage:[UIImage imageNamed:@"房间"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"left_top_select"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:modal.room_name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(roomSelect:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor clearColor]];
//        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.backgroundColor=[UIColor clearColor];
       
        btn.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [btn addGestureRecognizer:longPressGr];
       w = btn.frame.size.width + btn.frame.origin.x;
        bottomScr.contentSize=CGSizeMake(w, 0);
        [bottomScr addSubview:btn];
        
   
    
    
    }
       bottomScr.contentSize=CGSizeMake(w, 0);

}

//设备分组按钮
-(void)setEquipmentItems:(NSArray *)items{
    for (UIView *view in [equiScr subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }

    
    
    float btn_hight=equiScr.frame.size.height/1.7;
    float padding=(equiScr.frame.size.width/4-btn_hight)/2;
    //加载房间按钮
    for (int i=0; i<items.count; i++) {
        RoomModal *modal=[RoomModal new];
        modal=[items objectAtIndex:i];
         UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake(padding+i*(btn_hight+2*padding), (equiScr.frame.size.height-btn_hight)/2, btn_hight, btn_hight);
        NSInteger iconTag=modal.room_icon;
        NSString *imgStr;
        NSString *selectStr;
        switch (iconTag) {
            case 1:
                imgStr=@"d_01";
                selectStr=@"d_01_s";
                break;
            case 2:
                imgStr=@"d_02";
                selectStr=@"d_02_s";
                break;
            case 3:
                imgStr=@"d_03";
                selectStr=@"d_03_s";
                break;
            case 4:
                imgStr=@"d_04";
                selectStr=@"d_04_s";
                break;
            case 5:
                imgStr=@"d_05";
                selectStr=@"d_05_s";
                break;
            case 6:
                imgStr=@"d_06";
                selectStr=@"d_06_s";
                break;
            case 7:
                imgStr=@"d_07";
                selectStr=@"d_07_s";
                break;
            case 8:
                imgStr=@"d_08";
                selectStr=@"d_08_s";
                break;
            case 9:
                imgStr=@"d_09";
                selectStr=@"d_09_s";
                break;
            case 10:
                imgStr=@"d_10";
                selectStr=@"d_10_s";
                break;
            case 11:
                imgStr=@"d_11";
                selectStr=@"d_11_s";
                break;
            case 12:
                imgStr=@"d_12";
                selectStr=@"d_12_s";
                break;
            case 13:
                imgStr=@"d_13";
                selectStr=@"d_13_s";
                break;
            case 14:
                imgStr=@"d_14";
                selectStr=@"d_14_s";
                break;
            case 15:
                imgStr=@"d_15";
                selectStr=@"d_15_s";
                break;
            case 16:
                imgStr=@"d_16";
                selectStr=@"d_16_s";
                break;
            case 17:
                imgStr=@"d_17";
                selectStr=@"d_17_s";
                break;
            case 18:
                imgStr=@"d_18";
                selectStr=@"d_18_s";
                break;
            case 19:
                imgStr=@"d_19";
                selectStr=@"d_19_s";
                break;
            case 20:
                imgStr=@"d_20";
                selectStr=@"d_20_s";
                break;
            case 21:
                imgStr=@"d_21";
                selectStr=@"d_21_s";
                break;
            case 22:
                imgStr=@"d_22";
                selectStr=@"d_22_s";
                break;
            case 23:
                imgStr=@"d_23";
                selectStr=@"d_23_s";
                break;
            case 24:
                imgStr=@"d_24";
                selectStr=@"d_24_s";
                break;
            case 25:
                imgStr=@"d_25";
                selectStr=@"d_25_s";
                break;
            case 26:
                imgStr=@"d_26";
                selectStr=@"d_26_s";
                break;
                
            default:
                break;
        }
        
        btn.tintColor=[UIColor clearColor];
        [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:selectStr] forState:UIControlStateSelected];
        btn.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEqui:)];
        longPressGr.minimumPressDuration = 1.0;
        [btn addGestureRecognizer:longPressGr];

        btn.tag=modal._id;
        [btn addTarget:self action:@selector(roomSelect:) forControlEvents:UIControlEventTouchUpInside];
        [equiScr addSubview:btn];
        
    }
    
    equiScr.contentSize=CGSizeMake(items.count*equiScr.frame.size.width/4, 0);

    equiScr.contentOffset=CGPointMake(equiScr.frame.size.width/4, 0);
}



-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        
        [self becomeFirstResponder];
        self.roomId=gesture.view.tag;
       
        UIButton *btn=(UIButton *)[self viewWithTag:self.roomId];
        
        m_menuCtrl = [UIMenuController sharedMenuController];
        
        
        
        UIMenuItem *itemEdit = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editRoom)];
       
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteRoom)];
        
        
        [m_menuCtrl setMenuItems:[NSArray arrayWithObjects:itemEdit,itemDelete, nil]];
        [m_menuCtrl setTargetRect:btn.frame inView: btn.superview];
        
        [m_menuCtrl setMenuVisible:YES animated:YES];
        
    }
    
}



-(BOOL)canBecomeFirstResponder{
    return YES;
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(editRoom)){
        return YES;
    }else if (action == @selector(deleteRoom)){
        return YES;
    }else if (action == @selector(editEquiRoom)){
        return YES;
    }else if (action == @selector(deleteEquiRoom)){
        return YES;
    }
    
    
    
    return NO;
    
}



-(void)longPressEqui:(UILongPressGestureRecognizer *)gesture
{
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        
        [self becomeFirstResponder];
        self.roomId=gesture.view.tag;
        
        UIButton *btn=(UIButton *)[self viewWithTag:self.roomId];
        
        m_menuCtrl_equi = [UIMenuController sharedMenuController];
        
        
        
        UIMenuItem *itemEdit = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editEquiRoom)];
        
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteEquiRoom)];
        
        
        [m_menuCtrl_equi setMenuItems:[NSArray arrayWithObjects:itemEdit,itemDelete, nil]];
        [m_menuCtrl_equi setTargetRect:btn.frame inView: btn.superview];
        
        [m_menuCtrl_equi setMenuVisible:YES animated:YES];
        
    }
    
}









-(void)editRoom{
    
    
    
    [self.delegate editRoom:self.roomId];
   


}

-(void)deleteRoom{
    
    [self.delegate deleteRoom:self.roomId];
    
}




-(void)editEquiRoom{
    [self.delegate editEquiRoom:self.roomId];
  }

-(void)deleteEquiRoom{
    [self.delegate deleteRoom:self.roomId];
    
}


-(void)voiceClick{
    
    if (micOpen==NO) {
        
        [microphoneBtn setBackgroundImage:[UIImage imageNamed:@"麦克风识别状态"] forState:UIControlStateNormal];
        
        micOpen=YES;
        [appDelegate.appDefault setObject:@"alwaysYes" forKey:@"micStatus"];
        [CurrentTableName shared].noResultCount=1;
         [self.delegate VoiceClick];
    
    }else{
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelMic" object:nil];
         [appDelegate.appDefault setObject:@"no" forKey:@"findNick"];
        [microphoneBtn setBackgroundImage:[UIImage imageNamed:@"麦克风待机状态"] forState:UIControlStateNormal];
        
        
        micOpen=NO;
        [self.delegate stopVoiceClick];
        
    }
    
    
    
    
   
}



//主机设置
-(void)hostSet{
    
    
    [self.delegate showHostSettingView];
    
}

//房间添加
-(void)addRoomBtn{
    [CurrentTableName shared].operRoomState=@"add";

    [self.delegate showAddRoomView];
    
}














//房间选择
-(void)roomSelect:(UIButton *)sender{
    
    
    if (sender.tag==1) {
        if (sender!=selectBtn) {
            selectBtn.selected=NO;
            selectBtn=sender;
        } selectBtn.selected=YES;
    }else{
    
    
    if(sender!=selectBtn)
    {
        selectBtn.selected=NO;
        selectBtn=sender;
    }
    selectBtn.selected=YES;

}
    
    [self.delegate changeRoom:sender.tag];
    
    
}

-(void)loadRoomSelect:(long)tag{
    
    UIButton *sender=(UIButton *)[self viewWithTag:tag];
    
    if (tag==1) {
        if (sender!=selectBtn) {
            selectBtn.selected=NO;
            selectBtn=sender;
        } selectBtn.selected=YES;
    }else{
        
        
        if(sender!=selectBtn)
        {
            selectBtn.selected=NO;
            selectBtn=sender;
        }
        selectBtn.selected=YES;
        
    }

    
    
}






- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}






@end
