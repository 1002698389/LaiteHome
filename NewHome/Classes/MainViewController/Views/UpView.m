//
//  UpView.m
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "UpView.h"
#import "QuickButton.h"
#define TopNav_Width 100
#define margin 4
@implementation UpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        checkDenfense=NO;
        
        long section_width=frame.size.width/3; //顶部3等分
        long section_height=frame.size.height;
        
        
        //顶部导航条
        upNavView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, section_width, section_height)];
        upNavView.backgroundColor=[UIColor clearColor];
        [self addSubview:upNavView];
        
        UIImageView *bottomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, section_width, section_height)];
        bottomImgView.image=[UIImage imageNamed:@"home_bg"];
        [upNavView addSubview:bottomImgView];

        
//        //中间logo
//        UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(section_width+40, 8, section_width-80, section_height-16)];
//        logo.image=[UIImage imageNamed:@"homeLogo"];
//        [upNavView addSubview:logo];
        
        
        //右上视图
        environmentView=[[UIView alloc]initWithFrame:CGRectMake(2*section_width, 0, section_width, section_height)];
        environmentView.backgroundColor=[UIColor clearColor];
        [self addSubview:environmentView];
        
        [self setEnvironmentSubview:section_width height:section_height];
        
        
        //顶部导航条上的增加按钮
        UIButton *addRoomBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        addRoomBtn.frame=CGRectMake(0, 0, section_width/5, section_height);
        UIImageView *roomBtnImgView=[[UIImageView alloc]initWithFrame:CGRectMake((addRoomBtn.frame.size.width-addRoomBtn.frame.size.height/1.8)/2, (addRoomBtn.frame.size.height-addRoomBtn.frame.size.height/1.8)/2, addRoomBtn.frame.size.height/1.8, addRoomBtn.frame.size.height/1.8)];
       // [addRoomBtn setBackgroundImage:[UIImage imageNamed:@"左上角+号背景"] forState:UIControlStateNormal];
        roomBtnImgView.image=[UIImage imageNamed:@"左上角+号"];
        [addRoomBtn addSubview:roomBtnImgView];
        
        addRoomBtn.backgroundColor=[UIColor clearColor];
        [addRoomBtn setTintColor:[UIColor clearColor]];
        [addRoomBtn addTarget:self action:@selector(addTopBtn) forControlEvents:UIControlEventTouchUpInside];
        [upNavView addSubview:addRoomBtn];
        
        
        //顶部导航条上的滚动条
        upScr=[[UIScrollView alloc]initWithFrame:CGRectMake(section_width/5, 0, section_width*4/5, section_height)];
        upScr.contentSize=CGSizeMake(section_width*4/5, 0);
        upScr.backgroundColor=[UIColor clearColor];
        [upNavView addSubview:upScr];

        
         [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(defenseOpen) name: @"defenseOpen" object: nil];//设防开启
         [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(defenseClose) name: @"defenseClose" object: nil];//设防关闭
        
  
    
    }
    return self;
}

-(void)defenseOpen{
     [lockBtn setBackgroundImage:[UIImage imageNamed:@"设防"] forState:UIControlStateNormal];
}


-(void)defenseClose{
     [lockBtn setBackgroundImage:[UIImage imageNamed:@"撤防"] forState:UIControlStateNormal];
    
}

-(void)showNetConnectStatus:(NSString *)imgStr{
    
    netImgView.image=[UIImage imageNamed:imgStr];
    
    
}
//加载右上环境子视图
-(void)setEnvironmentSubview:(long)section_width height:(long)section_height{
    int button_y=5;
     long button_margin=5;//4个间隔（温度，湿度，设防，网络）
    
    //%=50 湿度＝70 温度＝70  c＝50  设防＝51 网络＝72
    
    CGFloat fontSize;
    switch ( [UIDevice iPhonesModel]) {
        case iPhone4:
            fontSize=20;
            break;
        case iPhone5:
            fontSize=20;
            break;
        case iPhone6:
            fontSize=22;
            break;
        case iPhone6Plus:
            fontSize=22;
            break;
        case UnKnown:
            fontSize=25;
            break;
            
            
        default:
            break;
    }

    
    
    
    float image_hight=section_height-margin;
    float image_y=margin/2;
    float image_width=image_hight*93/87;
    float wet_width=image_hight*60/87;
    float pading=(section_width-5*image_width-2*wet_width)/8;
    
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
//    NSLog(@"%d",1+70/50+70/50+1+51/50+72/50+80/50+80/50);
//     float width=(section_width-3*button_margin)/ (1+1.4+1.4+1+1.02+1.44+1.4+1.4);//%宽度
//    float labelWidth=width*80/50;
//    float wetImgWidth=width*70/50;
//    float temImgWidth=width*70/50;
//    float lockWidth=width*51/50;
//    float netWidth=width*72/50;
//    
//    float wetImgY=(section_height-wetImgWidth)/2;
//    float labelY=(section_height-labelWidth)/2;
//    float lockY=(section_height-lockWidth*64/51)/2;
//    float netY=(section_height-netWidth*71/72)/2;
//    
//    
//    int button_x=0;
    
    UIButton *wetBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    wetBtn.frame=CGRectMake(pading, image_y, wet_width, image_hight);
    wetBtn.backgroundColor=[UIColor clearColor];
    [wetBtn setBackgroundImage:[UIImage imageNamed:@"湿度2"] forState:UIControlStateNormal];
    wetBtn.tag=100;
    [wetBtn addTarget:self action:@selector(environmentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat wetLabel_x=CGRectGetMaxX(wetBtn.frame)+pading;
    self.wetLabel=[[UILabel alloc]initWithFrame:CGRectMake(wetLabel_x, image_y+4, image_width, image_hight)];
    self.wetLabel.text=@"";
    self.wetLabel.backgroundColor=[UIColor clearColor];
    self.wetLabel.font=[UIFont fontWithName:@"DBLCDTempBlack" size:fontSize];
    self.wetLabel.textColor=[UIColor whiteColor];
    //self.wetLabel.font=[UIFont systemFontOfSize:14];
    self.wetLabel.textAlignment=NSTextAlignmentCenter;
    
    
//    CGFloat wetImgViewBack_x=CGRectGetMaxX(self.wetLabel.frame);
//    UIImageView *wetImgViewBack=[[UIImageView alloc]initWithFrame:CGRectMake(wetImgViewBack_x, section_height-width, width, width)];
//    wetImgViewBack.image=[UIImage imageNamed:@"humidity_symbol"];
    
    [environmentView addSubview:wetBtn];
    [environmentView addSubview:self.wetLabel];
   // [environmentView addSubview:wetImgViewBack];
    
    
    CGFloat temImgView_x=CGRectGetMaxX(self.wetLabel.frame)+pading;
    
    
    UIButton *temBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    temBtn.frame=CGRectMake(temImgView_x, image_y, wet_width, image_hight);
    temBtn.backgroundColor=[UIColor clearColor];
    [temBtn setBackgroundImage:[UIImage imageNamed:@"温度2"] forState:UIControlStateNormal];
    temBtn.tag=200;
    [temBtn addTarget:self action:@selector(environmentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    CGFloat tempLabel_x=CGRectGetMaxX(temBtn.frame)+pading;
    self.tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(tempLabel_x, image_y+4, image_width, image_hight)];
    self.tempLabel.text=@"";
    self.tempLabel.textColor=[UIColor whiteColor];
  
    self.tempLabel.font=[UIFont fontWithName:@"DBLCDTempBlack" size:fontSize];


    self.tempLabel.textAlignment=NSTextAlignmentCenter;
    
    
//    CGFloat temImgViewBack_x=CGRectGetMaxX(self.tempLabel.frame);
//    UIImageView *temImgViewBack=[[UIImageView alloc]initWithFrame:CGRectMake(temImgViewBack_x, section_height-width, width, width)];
//    temImgViewBack.image=[UIImage imageNamed:@"temperature_symbol"];
    
    [environmentView addSubview:temBtn];
    [environmentView addSubview:self.tempLabel];
    //[environmentView addSubview:temImgViewBack];
    
    
    CGFloat lockBtnBack_x=CGRectGetMaxX(self.tempLabel.frame)+pading;
    lockBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    lockBtn.frame=CGRectMake(lockBtnBack_x,image_y, image_width, image_hight);
    [lockBtn setBackgroundImage:[UIImage imageNamed:@"设防"] forState:UIControlStateNormal];

    lockBtn.tag=300;
     [lockBtn addTarget:self action:@selector(environmentClick:) forControlEvents:UIControlEventTouchUpInside];
    lockBtn.backgroundColor=[UIColor clearColor];
    [lockBtn setTintColor:[UIColor whiteColor]];
    //[lockBtn addTarget:self action:@selector(addTopBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [environmentView   addSubview:lockBtn];
  
    
    
    
    
    
    
    
    CGFloat clockBtn_x=CGRectGetMaxX(lockBtn.frame)+pading;
    clockBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    clockBtn.frame=CGRectMake(clockBtn_x, image_y, image_width, image_hight);
    [clockBtn setBackgroundImage:[UIImage imageNamed:@"定时"] forState:UIControlStateNormal];
//    [clockBtn setBackgroundImage:[UIImage imageNamed:@"timing_true"] forState:UIControlStateNormal];
    clockBtn.backgroundColor=[UIColor clearColor];
    clockBtn.tag=400;
    [clockBtn addTarget:self action:@selector(environmentClick:) forControlEvents:UIControlEventTouchUpInside];
    [clockBtn setTintColor:[UIColor whiteColor]];
    // [clockBtn addTarget:self action:@selector(addTopBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [environmentView   addSubview:clockBtn];
    
    
    CGFloat netBtn_x=CGRectGetMaxX(clockBtn.frame)+pading;
    
    netImgView=[[UIImageView alloc]initWithFrame:CGRectMake(netBtn_x, image_y, image_width, image_hight)];
    netImgView.backgroundColor=[UIColor clearColor];
    netImgView.image=[UIImage imageNamed:@"互联网连接"];
    //netImgView.image=[UIImage imageNamed:@"连接断开"];
    
    
    
    
    [environmentView   addSubview:netImgView];

    
}

-(void)environmentClick:(UIButton *)sender{
    if (sender.tag==100||sender.tag==200) {
       //湿度.温度
        
        [self.delegate queryTempAndWet];
    }else if (sender.tag==300) {
        //设防.撤防
        
        if (checkDenfense==NO) {
             [lockBtn setBackgroundImage:[UIImage imageNamed:@"设防"] forState:UIControlStateNormal];
       
            checkDenfense=YES;
        }else{
            
             [lockBtn setBackgroundImage:[UIImage imageNamed:@"撤防"] forState:UIControlStateNormal];
            
             checkDenfense=NO;
        }
        [self.delegate defenseClick:checkDenfense];
        
               
        
    }else if (sender.tag==400) {
        //定时
        [self.delegate timeClick];
    
    }
    
    
    
}



//加载温度和湿度
-(void)setTemperature:(int)temperature Wet:(int)wet{
    
    
    self.tempLabel.text=[NSString stringWithFormat:@"%d",temperature];
    self.wetLabel.text=[NSString stringWithFormat:@"%d",wet];
    
}
//设防撤防状态
-(void)loadDefenceStatus:(NSString *)str{
    
    if ([str isEqualToString:@"00"]) {
        
       [lockBtn setBackgroundImage:[UIImage imageNamed:@"撤防"] forState:UIControlStateNormal];

    
    }else if ([str isEqualToString:@"01"]){
        
        [lockBtn setBackgroundImage:[UIImage imageNamed:@"设防"] forState:UIControlStateNormal];

    
    }



}


//添加按钮
-(void)addTopBtn{
     [CurrentTableName shared].operBtnState=@"add";
    [self.delegate showAddBtnView:@"add" btnId:0];

}

//加载快捷键按钮
-(void)loadItems:(NSArray *)itmes{
    
    NSArray *views = [upScr subviews];
    for(UIView* view in views)
    {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }

    
    
    long btn_width=upScr.frame.size.width/4;
    long btn_hight=upScr.frame.size.height;
    long w=0;
    for (int i=0; i<itmes.count; i++) {
        QuickButton *modal=[QuickButton new];
       
        modal=[itmes objectAtIndex:i];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        CGSize titleSize = [modal.button_name sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        titleSize.height=btn_hight;
        titleSize.width+=15;
        btn.frame=CGRectMake(w, 0, titleSize.width, titleSize.height);
        btn.backgroundColor=[UIColor clearColor];
        [btn setTitle:modal.button_name forState:UIControlStateNormal];
        btn.tag=modal._id;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"左上角+号背景"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(quickBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        btn.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [btn addGestureRecognizer:longPressGr];
        
        
        
        
        
//        if ([quickBtn.icon isEqual:@"0"]) {
//            [btn setBackgroundImage:[UIImage imageNamed:@"左上角+号背景"] forState:UIControlStateNormal];
//            
//        }else{
//            
//            [btn setBackgroundImage:[UIImage imageNamed:quickBtn.icon] forState:UIControlStateNormal];
//            
//        }
        
//        btn.titleLabel.font=ContentFont;
//        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        
        w = btn.frame.size.width + btn.frame.origin.x;
     

        [upScr addSubview:btn]; //顶部导航条添加items
        
       
        
    }
    
    upScr.contentSize=CGSizeMake(w, 0);
    

    



}


-(void)quickBtnClick:(UIButton *)sender{
    
    [self.delegate quickButtonClick:sender.tag];
    
}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        
        [self becomeFirstResponder];
        self.quickId=gesture.view.tag;
        
        UIButton *btn=(UIButton *)[self viewWithTag:self.quickId];
        
        m_menuCtrl = [UIMenuController sharedMenuController];
        
        
        
        UIMenuItem *itemEdit = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editQuick:)];
        
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteQuick:)];
        
        
        [m_menuCtrl setMenuItems:[NSArray arrayWithObjects:itemEdit,itemDelete, nil]];
        [m_menuCtrl setTargetRect:btn.frame inView: upScr];
        [m_menuCtrl setMenuVisible:YES animated:YES];
        
    }
    
}



-(BOOL)canBecomeFirstResponder{
    return YES;
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(editQuick:)){
        return YES;
    }else if (action == @selector(deleteQuick:)){
        return YES;
    }
    
    
    
    return NO;
    
}




-(void)editQuick:(long)quickId{
    
    [self.delegate editQuick:self.quickId];
    
}//编辑快捷
-(void)deleteQuick:(long)quickId{
    
    [self.delegate deleteQuick:self.quickId];
    
}//删除快捷



@end
