//
//  AddButtonView.m
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "AddButtonView.h"
#import "QRadioButton.h"
#import "DatabaseOperation.h"
#import "MLTableAlert.h"

#define margin 8

@implementation AddButtonView







//模型初始化
-(PresetData *)presetModal{
    if (!_presetModal) {
        _presetModal = [[PresetData alloc] init];
    }
    return _presetModal;
    
}


//数据源
- (NSMutableArray *)radioDownArray {
    if (!_radioDownArray) {
        _radioDownArray = [[NSMutableArray alloc] init];
    }
    return _radioDownArray;
}


- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId
{
    self = [super initWithFrame:frame];
    if (self) {
        
     
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showIconFrame:) name: @"iconFrame" object: nil];
        
        
        self.buttonStyle=1;//默认普通按钮
        self.customSize=1;//默认大小
        self.defaultIcon=1;//默认图标
        self.btnMode=@"add";
            self.currentHostId=hostId;
        if ([[CurrentTableName shared].operBtnState isEqualToString:@"edit"]) {
            self.btnMode=@"edit";
             [self BtnData:btnId];
            self.defaultIcon=modal.defaultIocn;
        }else if ([[CurrentTableName shared].operBtnState isEqualToString:@"quickedit"]){
            self.btnMode=@"edit";
            self.buttonStyle=2;
            [self QuickData:btnId];
        }else if ([[CurrentTableName shared].operBtnState isEqualToString:@"remoteedit"]){
            [self RemoteBtnData:btnId];
        }
       
       
        customSelect=NO;
        
              
        
        self.tableName=[CurrentTableName shared].tableName;
        NSArray *dataArray=[DatabaseOperation queryCategroyPredata:1 tableName:[NSString stringWithFormat:@"%ld",hostId]];
        [self.radioDownArray addObjectsFromArray:dataArray];
        long btn_width=frame.size.width/4;
        long btn_height=frame.size.height/6;
        
    
        
        long radio_width;
        long Margin_x;
        switch ( [UIDevice iPhonesModel]) {
            case iPhone4:
                textField_height=25.0;
                radio_width=48;
                Margin_x=frame.size.width/5;
                break;
            case iPhone5:
                textField_height=25.0;
                radio_width=48;
                Margin_x=frame.size.width/5;

                break;
            case iPhone6:
                textField_height=30.0;
                radio_width=60;
                Margin_x=frame.size.width/4;

                break;
            case iPhone6Plus:
                textField_height=30.0;
                radio_width=60;
                Margin_x=frame.size.width/4;

                break;
            case UnKnown:
                textField_height=50.0;
                radio_width=60;
                Margin_x=frame.size.width/4;

                break;
                
                
            default:
                break;
        }

        
        
        
        long contentView_height=frame.size.height-2*btn_height;  //内容高度
       
        
    
        
        
        
        
        
        long padding=(contentView_height-5*textField_height)/6;//y间距
        long label_width=60;                                //标题长度
        long textfield_width=frame.size.width-label_width-2*margin-Margin_x;   //输入框长度
        
        
        
        float imgSize=Margin_x-2*margin;
        float imgHeight=imgSize*384/308;
        long imgY=(contentView_height-imgHeight)/2+btn_height;
        
        //标题栏
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, btn_height)];
        titleView.backgroundColor=PopView_TitleColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
        titleLabel.text=@"新建按钮";
        titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
        [titleView addSubview:titleLabel];
        
        [self addSubview:titleView];
        
        
       //名称
        CGFloat btnName_Y=CGRectGetMaxY(titleView.frame)+padding;
        UILabel *btnName=[[UILabel alloc]initWithFrame:CGRectMake(Margin_x, btnName_Y,label_width, textField_height)];
        btnName.text=@"名称";
        btnName.textColor=Text_color;
        btnName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:btnName];
        
        
        
        btnImg=[[UIImageView alloc]initWithFrame:CGRectMake(margin, imgY, imgSize, imgHeight)];
        btnImg.backgroundColor=[UIColor clearColor];
        btnImg.userInteractionEnabled=YES;
        if ([self.btnMode isEqualToString:@"add"]) {
             btnImg.image=[UIImage imageNamed:@"button_img1"];
            iconWidth=btnImg.image.size.width;
           iconHeight=btnImg.image.size.height;
        }else if ([self.btnMode isEqualToString:@"edit"]){
            if ([[CurrentTableName shared].operBtnState isEqualToString:@"quickedit"]) {
                btnImg.image=[UIImage imageNamed:@"button_img1"];
                iconWidth=btnImg.image.size.width;
                iconHeight=btnImg.image.size.height;
            
            }else{
            btnImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",(long)modal.defaultIocn]];
                iconWidth=btnImg.image.size.width;
                iconHeight=btnImg.image.size.height;
        }
        
        }
        
        
        
       
               [self addSubview:btnImg];

        UISwipeGestureRecognizer *recognizer;
        
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [btnImg addGestureRecognizer:recognizer];
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [btnImg addGestureRecognizer:recognizer];
       
        
        
        
        
        
        
        
        
        
        
        
        
        
        CGFloat nameField_X=CGRectGetMaxX(btnName.frame)+10;
        
        btnNameField=[[UITextField alloc]initWithFrame:CGRectMake(nameField_X, btnName_Y, textfield_width, textField_height)];
        btnNameField.delegate=self;
        btnNameField.placeholder=@"名称";
        if ([[CurrentTableName shared].operBtnState isEqualToString:@"edit"]) {
            btnNameField.text=modal.button_name;
        }else if([[CurrentTableName shared].operBtnState isEqualToString:@"quickedit"]){
            
             btnNameField.text=modalQuick.button_name;
        }else if ([[CurrentTableName shared].operBtnState isEqualToString:@"remoteedit"]){
            
             btnNameField.text=remoteBtn.button_name;
        }
       
        btnNameField.backgroundColor=BACKGROUND_COLOR;
        [self addSubview:btnNameField];
        
        
        //功能
        CGFloat backImg_Y=CGRectGetMaxY(btnName.frame)+padding;
        backImg=[[UILabel alloc]initWithFrame:CGRectMake(Margin_x, backImg_Y, label_width,textField_height)];
        backImg.text=@"功能";
        backImg.textColor=Text_color;
        backImg.textAlignment=NSTextAlignmentCenter;
        [self addSubview:backImg];
        
        
        
        CGFloat relayBtn_x=CGRectGetMaxX(backImg.frame);
        QRadioButton *relayBtn=[[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        relayBtn.frame=CGRectMake(relayBtn_x,backImg.frame.origin.y,radio_width,textField_height);
        [relayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [relayBtn setTitle:@"继电器" forState:UIControlStateNormal];
        relayBtn.titleLabel.font=ContentFont;
        relayBtn.delegate=self;
        relayBtn.checked=YES;
        relayBtn.tag=10000;
        [self addSubview:relayBtn];
        
        
        CGFloat wirelessBtn_x=CGRectGetMaxX(relayBtn.frame)+margin;
        QRadioButton *wirelessBtn=[[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        wirelessBtn.frame=CGRectMake(wirelessBtn_x,backImg.frame.origin.y,radio_width,textField_height);
        [wirelessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [wirelessBtn setTitle:@"无线" forState:UIControlStateNormal];
        wirelessBtn.titleLabel.font=ContentFont;
        wirelessBtn.delegate=self;
        wirelessBtn.tag=10001;
        [self addSubview:wirelessBtn];
        
        
        CGFloat sceneBtn_x=CGRectGetMidX(wirelessBtn.frame)+2*margin;
        QRadioButton *sceneBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
        sceneBtn.frame=CGRectMake(sceneBtn_x,backImg.frame.origin.y,radio_width,textField_height);
        [sceneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sceneBtn setTitle:@"情景" forState:UIControlStateNormal];
        sceneBtn.titleLabel.font=ContentFont;
        sceneBtn.delegate=self;
        sceneBtn.tag=10002;
        [self addSubview:sceneBtn];
        
        
        CGFloat conditions_x=CGRectGetMidX(sceneBtn.frame)+2*margin;
        QRadioButton *conditionsBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
        conditionsBtn.frame=CGRectMake(conditions_x,backImg.frame.origin.y,radio_width,textField_height);
        [conditionsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [conditionsBtn setTitle:@"条件" forState:UIControlStateNormal];
        conditionsBtn.titleLabel.font=ContentFont;
        conditionsBtn.delegate=self;
        conditionsBtn.tag=10003;
        [self addSubview:conditionsBtn];
        
        CGFloat customer_x=CGRectGetMidX(conditionsBtn.frame)+2*margin;
        QRadioButton *customerBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
        customerBtn.frame=CGRectMake(customer_x,backImg.frame.origin.y,radio_width,textField_height);
        [customerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [customerBtn setTitle:@"自定义" forState:UIControlStateNormal];
        customerBtn.titleLabel.font=ContentFont;
        customerBtn.delegate=self;
        customerBtn.tag=10004;
        [self addSubview:customerBtn];
        
        
        
        long radioTag=_presetModal.data_type;
        if (radioTag==1) {
            relayBtn.checked=YES;

        }else if (radioTag==2){
            wirelessBtn.checked=YES;

       
        
        
        
        }else if (radioTag==3){
            sceneBtn.checked=YES;

        }else if (radioTag==4){
             conditionsBtn.checked=YES;
        }else{
             customerBtn.checked=YES;
        }
        
        
        
       self.btnMode=@"add";
        
        CGFloat menu_y=CGRectGetMaxY(backImg.frame)+padding;
        
        if (customSelect==NO) {
            if (menuBtn==nil) {
                [self createMenuBtn];
            }
        }
       

       

        
        
        
        //图标
       
        CGFloat icon_Y= menu_y+textField_height+padding;
        UILabel *icon=[[UILabel alloc]initWithFrame:CGRectMake(Margin_x, icon_Y,label_width, textField_height)];
        icon.text=@"图标";
        icon.textColor=Text_color;
        icon.textAlignment=NSTextAlignmentCenter;
        [self addSubview:icon];
        
        
        CGFloat displayBtn1_X=CGRectGetMaxX(icon.frame)+margin;
        UIButton *displayBtn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        displayBtn1.frame=CGRectMake(displayBtn1_X, icon.frame.origin.y, label_width, textField_height);
        displayBtn1.backgroundColor=[UIColor clearColor];
        [displayBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [displayBtn1 setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
        
        [displayBtn1 setTitle:@"浏览" forState:UIControlStateNormal];
        [displayBtn1 addTarget:self action:@selector(upLoadImg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:displayBtn1];
        
        CGFloat quickBtn_X=CGRectGetMaxX(displayBtn1.frame)+margin;
        quickBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        quickBtn.frame=CGRectMake(quickBtn_X, displayBtn1.frame.origin.y+textField_height/4, textField_height/2, textField_height/2);
        quickBtn.backgroundColor=[UIColor clearColor];
        [quickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quickBtn.tintColor=[UIColor clearColor];
        [quickBtn setBackgroundImage:[UIImage imageNamed:@"方框选中"] forState:UIControlStateSelected];
        [quickBtn setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
        [quickBtn addTarget:self action:@selector(quickBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quickBtn];
        
        CGFloat eqGroup_X=CGRectGetMaxX(quickBtn.frame)+margin;
        UILabel *eqGroup=[[UILabel alloc]initWithFrame:CGRectMake(eqGroup_X, displayBtn1.frame.origin.y, 2*label_width, textField_height)];
        eqGroup.text=@"设为快捷键";
        eqGroup.font=[UIFont systemFontOfSize:13];
        eqGroup.textColor=[UIColor grayColor];
        [self addSubview:eqGroup];
  
        
        if ( [[CurrentTableName shared].operBtnState isEqualToString:@"add"]) {
            quickBtn.hidden=NO;
            eqGroup.hidden=NO;
            displayBtn1.hidden=NO;
            icon.hidden=NO;

        }else if ([[CurrentTableName shared].operBtnState isEqualToString:@"edit"]){
            quickBtn.hidden=YES;
            eqGroup.hidden=YES;
        }else if ([[CurrentTableName shared].operBtnState isEqualToString:@"quickedit"]){
            quickBtn.hidden=YES;
            eqGroup.hidden=YES;
            displayBtn1.hidden=YES;
            icon.hidden=YES;
        }
        
        
        CGFloat sizeLabel_Y= CGRectGetMaxY(icon.frame)+padding;
        UILabel *sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(Margin_x, sizeLabel_Y,label_width, textField_height)];
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
                widthText.text=@"25";
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
            heightText.text=@"33";
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
        [cancelBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame=CGRectMake(frame.size.width*2/3, cancelBtn.frame.origin.y, frame.size.width/3, btn_height);
        okBtn.backgroundColor=[UIColor clearColor];
        okBtn.tag=2;
        [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:okBtn];
           
        
        
    }
    return self;
}


-(void)showIconFrame:(NSNotification *)notification{
    
    NSArray *array=notification.object;
    
    
  
        if (self.customSize==1) {
            iconWidth=[array[0] floatValue];
            iconHeight=[array[1] floatValue];
            
            
        }
    
    
    
    
    
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
       
        if (self.defaultIcon==1) {
            
            
             btnImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];
            
            iconWidth=image.size.width;
            iconHeight=image.size.height;
        }else{
        
        self.defaultIcon-=1;
        
       
            btnImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];
            
            iconWidth=image.size.width;
            iconHeight=image.size.height;

        
        
        
        }
        NSLog(@"swipe down");
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        if (self.defaultIcon==41) {
            
            btnImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];

            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];
            
            iconWidth=image.size.width;
            iconHeight=image.size.height;

        
        }else{
        
        self.defaultIcon+=1;
        
         btnImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"button_img%ld",self.defaultIcon]];

            iconWidth=image.size.width;
            iconHeight=image.size.height;

        }
        
        
        
     NSLog(@"swipe up");
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe left");
        //执行程序
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"swipe right");
        //执行程序
    }
    
}
-(void)BtnData:(long)btnId{
    
    modal=[ButtonModal new];
    
    modal=[DatabaseOperation queryBtn:btnId];
    
  
    
    if (modal.preset_data_id==20000) {
        
        self.data_type=5;
        self.cutomeBtnName=modal.net_data;
    
    }else{
    _presetModal=[DatabaseOperation queryPresetModal:modal.net_data hostId:self.currentHostId];
    self.presetDataId=_presetModal._id;
    self.presetData=_presetModal.data;
    self.data_type=_presetModal.data_type;
   
    }
    
    

}

-(void)QuickData:(long)quickId{
    
    modalQuick=[QuickButton new];
    
    modalQuick=[DatabaseOperation queryQuickBtn:quickId];
    if (modalQuick.preset_data_id==20000) {
        
        self.data_type=5;
        self.cutomeBtnName=modalQuick.net_data;
        
    }else{
        
    _presetModal=[DatabaseOperation queryPresetModal:modalQuick.net_data hostId:self.currentHostId];
    self.presetDataId=_presetModal._id;
    self.presetData=_presetModal.data;
    self.data_type=_presetModal.data_type;
    }

}

-(void)RemoteBtnData:(long)remoteBtnId{
    
    remoteBtn=[RemoteBtn new];
    
    remoteBtn=[DatabaseOperation queryRemoteBtn:remoteBtnId];
    
}

//上传按钮图片
-(void)upLoadImg{
    
    if (self.buttonStyle==2) {
        NSString *message=@"快捷键暂不能设置图片";
        [self makeToast:message];
    }else if(self.buttonStyle==1){
    [self.delegate upLoadBtnImg];
    }
}


//添加按钮(确定，取消）
-(void)addButtonClick:(UIButton *)sender{
    
       if (customSelect==YES) {
        self.presetData=self.customText.text;
    }
    if ([self.presetData isEqualToString:@""]) {
        NSString *message=@"请输入自定义命令";
        [self makeToast:message];
    }else{
     
        if (self.customSize==1) {
//            widthText.text=@"25";
//            heightText.text=@"33";
             [self.delegate addButton:btnNameField.text preset_data_id:self.presetDataId net_data:self.presetData tag:sender.tag buttonType:self.buttonStyle defaultIcon:self.defaultIcon width:[NSString stringWithFormat:@"%f",iconWidth/8] height:[NSString stringWithFormat:@"%f",iconHeight/8] customSelect:self.customSize];
        }else{
            
            iconWidth=[widthText.text floatValue];
            iconHeight=[heightText.text floatValue];

               [self.delegate addButton:btnNameField.text preset_data_id:self.presetDataId net_data:self.presetData tag:sender.tag buttonType:self.buttonStyle defaultIcon:self.defaultIcon width:[NSString stringWithFormat:@"%f",iconWidth] height:[NSString stringWithFormat:@"%f",iconHeight] customSelect:self.customSize];
                
            }
            
       
   
    }
}





//快捷按钮选择
-(void)quickBtnSelect:(UIButton *)sender{
    
    
    if (sender.selected==YES) {
        
        sender.selected=NO;
        self.buttonStyle=1; //普通
        
    }else{
        
        sender.selected=YES;
        self.buttonStyle=2;//快捷
    }
    
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




#pragma mark RadioButton Delegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    
    NSLog(@"%ld",(long)radio.tag);
    if (radio.tag==10004) {
        customSelect=YES;
        self.data_type=5;
       
        self.presetDataId=20000;
        if (menuBtn!=nil) {
            
            [menuBtn removeFromSuperview];
            menuBtn=nil;
           
        }
        if (self.customText==nil) {
           
            [self createCustomerText];
            
        }
    
    }else{
        customSelect=NO;
    if ([self.btnMode isEqualToString:@"add"]) {
        self.data_type=1;
        //self.buttonStyle=1;//默认普通按钮
        self.buttonType=@"继电器";
        self.presetDataId=1;
        
        [_radioDownArray removeAllObjects];
        if (radio.tag!=10000) {
            QRadioButton *btn=(QRadioButton *)[self viewWithTag:10000];
            btn.checked=NO;
        }
        
        if (self.customText!=nil) {
            [self.customText removeFromSuperview];
            self.customText=nil;
             NSLog(@"customText:%@",self.customText);
        }
        if (menuBtn==nil) {
            [self createMenuBtn];
        }

        
        switch (radio.tag) {
            case 10000:
                self.data_type=1;
                self.presetDataId=1;
                break;
            case 10001:
                self.data_type=2;
                self.presetDataId=35;
                
                break;
            case 10002:
                self.data_type=3;
                self.presetDataId=547;
                
                break;
            case 10003:
                self.data_type=4;
                self.presetDataId=675;
                
                break;
            default:
                break;
        }
        
        
        
        
        self.presetData=[DatabaseOperation queryData:self.presetDataId];
        NSArray *array=[DatabaseOperation queryCategroyPredata:self.data_type tableName:[NSString stringWithFormat:@"%ld",self.currentHostId]];
        [_radioDownArray addObjectsFromArray:array];
        
        self.presetModal=[DatabaseOperation queryPresetModal:self.presetData hostId:self.currentHostId];
        [menuBtn setTitle:_presetModal.name forState:UIControlStateNormal];

    }else if ([self.btnMode isEqualToString:@"edit"]){
        
    }
    
    
    
    }


}


-(void)createMenuBtn{
    long Margin_x=self.frame.size.width/4;
    long padding=((self.frame.size.height-2*self.frame.size.height/6)-5*textField_height)/6;
    CGFloat menu_y=CGRectGetMaxY(backImg.frame)+padding;
    menuBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuBtn.frame=CGRectMake(self.frame.size.width/4+Margin_x/2, menu_y, self.frame.size.width/2-Margin_x/2, textField_height);
    if (_presetModal==nil) {
        
    }
    [menuBtn setTitle:_presetModal.name forState:UIControlStateNormal];
    menuBtn.backgroundColor=[UIColor clearColor];
    [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(showTableAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:menuBtn];
    
}
-(void)createCustomerText{
    long Margin_x=self.frame.size.width/4;
    long padding=((self.frame.size.height-2*self.frame.size.height/6)-5*textField_height)/6;
    CGFloat menu_y=CGRectGetMaxY(backImg.frame)+padding;
    self.customText=[[UITextField alloc]initWithFrame:CGRectMake(self.frame.size.width/4+Margin_x/2, menu_y, self.frame.size.width/2-Margin_x/2, textField_height)];
    self.customText.text=self.cutomeBtnName;
    self.customText.backgroundColor=BACKGROUND_COLOR;
    
    [self addSubview:self.customText];




}

-(void)geitBtnName:(NSString *)btnName{
    
    
    btnNameField.text=btnName;
    
}

-(void)showTableAlert:(id)sender
{
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"选择功能" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                  {
                     
                      return _radioDownArray.count;
                     
                  }
                andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      
                      _presetModal=self.radioDownArray[indexPath.row];
                      
                      
                      cell.textLabel.text =_presetModal.name;
                                           return cell;
                  }];
    
    // Setting custom alert height
    self.alert.height = 350;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        NSLog(@"%d",selectedIndex.row);
        _presetModal=_radioDownArray[selectedIndex.row]; //得到模型数据
        self.presetDataId=_presetModal._id; //得到数据id
        self.presetData=_presetModal.data; //得到数据内容
       
        if ([btnNameField.text isEqualToString:@""]) {
            [self geitBtnName:_presetModal.name]; 
        }
        
       [menuBtn setTitle:_presetModal.name forState:UIControlStateNormal];
        
        //        self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
    } andCompletionBlock:^{
        //        self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
    }];
    
    // show the alert
    [self.alert show];
}

    
    
    
    
@end
