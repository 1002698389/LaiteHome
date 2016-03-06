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
#define margin 10
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

-(NSMutableArray *)muArray{
    if (!_muArray) {
        _muArray = [[NSMutableArray alloc] init];
    }
    return _muArray;
 
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.buttonStyle=1;//默认普通按钮
        [self getPredataArray:1];
        long btn_width=frame.size.width/4;
        long btn_height=frame.size.height/6;
        
        long contentView_height=frame.size.height-2*btn_height;  //内容高度
        long padding=(contentView_height-4*TextField_height)/5;//y间距
        long label_width=60;                                //标题长度
        long textfield_width=frame.size.width-label_width-3*margin;   //输入框长度
        long radio_width=60;
        
        
        
        
        //标题栏
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, btn_height)];
        titleView.backgroundColor=PopView_TitleColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/2, 5, 2*btn_width, btn_height-10)];
        titleLabel.text=@"新建按钮";
        titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
        [titleView addSubview:titleLabel];
        
        [self addSubview:titleView];
        
        
       //名称
        CGFloat btnName_Y=CGRectGetMaxY(titleView.frame)+padding;
        UILabel *btnName=[[UILabel alloc]initWithFrame:CGRectMake(margin, btnName_Y,label_width, TextField_height)];
        btnName.text=@"名称";
        btnName.textColor=Text_color;
        btnName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:btnName];
        
        CGFloat nameField_X=CGRectGetMaxX(btnName.frame)+margin;
        
        btnNameField=[[UITextField alloc]initWithFrame:CGRectMake(nameField_X, btnName_Y, textfield_width, TextField_height)];
        btnNameField.delegate=self;
        btnNameField.backgroundColor=BACKGROUND_COLOR;
        [self addSubview:btnNameField];
        
        
        //功能
        CGFloat backImg_Y=CGRectGetMaxY(btnName.frame)+padding;
        UILabel *backImg=[[UILabel alloc]initWithFrame:CGRectMake(margin, backImg_Y, label_width,TextField_height)];
        backImg.text=@"功能";
        backImg.textColor=Text_color;
        backImg.textAlignment=NSTextAlignmentCenter;
        [self addSubview:backImg];
        
        
        
        CGFloat relayBtn_x=CGRectGetMaxX(backImg.frame)+margin;
        QRadioButton *relayBtn=[[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        relayBtn.frame=CGRectMake(relayBtn_x,backImg.frame.origin.y,radio_width,TextField_height);
        [relayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [relayBtn setTitle:@"继电器" forState:UIControlStateNormal];
        relayBtn.titleLabel.font=ContentFont;
        relayBtn.delegate=self;
        relayBtn.checked=YES;
        relayBtn.tag=10000;
        [self addSubview:relayBtn];
        
        
        CGFloat wirelessBtn_x=CGRectGetMaxX(relayBtn.frame)+margin;
        QRadioButton *wirelessBtn=[[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        wirelessBtn.frame=CGRectMake(wirelessBtn_x,backImg.frame.origin.y,radio_width,TextField_height);
        [wirelessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [wirelessBtn setTitle:@"无线" forState:UIControlStateNormal];
        wirelessBtn.titleLabel.font=ContentFont;
        wirelessBtn.delegate=self;
        wirelessBtn.tag=10001;
        [self addSubview:wirelessBtn];
        
        
        CGFloat sceneBtn_x=CGRectGetMidX(wirelessBtn.frame)+2*margin;
        QRadioButton *sceneBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
        sceneBtn.frame=CGRectMake(sceneBtn_x,backImg.frame.origin.y,radio_width,TextField_height);
        [sceneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sceneBtn setTitle:@"情景" forState:UIControlStateNormal];
        sceneBtn.titleLabel.font=ContentFont;
        sceneBtn.delegate=self;
        sceneBtn.tag=10002;
        [self addSubview:sceneBtn];
        
        
        CGFloat conditions_x=CGRectGetMidX(sceneBtn.frame)+2*margin;
        QRadioButton *conditionsBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
        conditionsBtn.frame=CGRectMake(conditions_x,backImg.frame.origin.y,radio_width,TextField_height);
        [conditionsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [conditionsBtn setTitle:@"条件" forState:UIControlStateNormal];
        conditionsBtn.titleLabel.font=ContentFont;
        conditionsBtn.delegate=self;
        conditionsBtn.tag=10003;
        [self addSubview:conditionsBtn];
        
        
        
//        CGFloat customBtn_x=CGRectGetMidX(conditionsBtn.frame)+2*margin;
//        QRadioButton *customBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
//        customBtn.frame=CGRectMake(customBtn_x,backImg.frame.origin.y,radio_width,TextField_height);
//        [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [customBtn setTitle:@"自定义" forState:UIControlStateNormal];
//        customBtn.titleLabel.font=ContentFont;
//        customBtn.delegate=self;
//        customBtn.tag=10004;
//        [self addSubview:customBtn];
        
        
       
        
        CGFloat menu_y=CGRectGetMaxY(backImg.frame)+padding;
        
        menuList =[[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(self.frame.size.width/4, menu_y) andHeight:TextField_height];
        menuList.dataSource = self;
        menuList.delegate = self;
        menuList.backgroundColor=[UIColor grayColor];
        [self addSubview:menuList];
        
        
        
        
        
        
        
        
        //图标
        CGFloat icon_Y=CGRectGetMaxY(menuList.frame)+padding;
        UILabel *icon=[[UILabel alloc]initWithFrame:CGRectMake(margin, icon_Y,label_width, TextField_height)];
        icon.text=@"图标";
        icon.textColor=Text_color;
        icon.textAlignment=NSTextAlignmentCenter;
        [self addSubview:icon];
        
        
        CGFloat displayBtn1_X=CGRectGetMaxX(icon.frame)+margin;
        UIButton *displayBtn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        displayBtn1.frame=CGRectMake(displayBtn1_X, icon.frame.origin.y, label_width, TextField_height);
        displayBtn1.backgroundColor=[UIColor clearColor];
        [displayBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [displayBtn1 setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
        
        [displayBtn1 setTitle:@"浏览" forState:UIControlStateNormal];
        [displayBtn1 addTarget:self action:@selector(upLoadImg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:displayBtn1];
        
        CGFloat quickBtn_X=CGRectGetMaxX(displayBtn1.frame)+margin;
        quickBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        quickBtn.frame=CGRectMake(quickBtn_X, displayBtn1.frame.origin.y+TextField_height/4, TextField_height/2, TextField_height/2);
        quickBtn.backgroundColor=[UIColor clearColor];
        [quickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        quickBtn.tintColor=[UIColor clearColor];
        [quickBtn setBackgroundImage:[UIImage imageNamed:@"方框选中"] forState:UIControlStateSelected];
        [quickBtn setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
        [quickBtn addTarget:self action:@selector(quickBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quickBtn];
        
        CGFloat eqGroup_X=CGRectGetMaxX(quickBtn.frame)+margin;
        UILabel *eqGroup=[[UILabel alloc]initWithFrame:CGRectMake(eqGroup_X, displayBtn1.frame.origin.y, 2*label_width, TextField_height)];
        eqGroup.text=@"设为快捷键";
        eqGroup.font=[UIFont systemFontOfSize:13];
        eqGroup.textColor=[UIColor grayColor];
        [self addSubview:eqGroup];
  
        
        
        
        
        
        
        
        
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame=CGRectMake(0, frame.size.height-btn_height, frame.size.width*2/3, btn_height);
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.tag=1;
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame=CGRectMake(frame.size.width*2/3, cancelBtn.frame.origin.y, frame.size.width/3, btn_height);
        okBtn.backgroundColor=[UIColor clearColor];
        okBtn.tag=2;
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:okBtn];
           
        
        
    }
    return self;
}




//获取数据类型数组（无线，情景，条件。。）
-(void)getPredataArray:(long)presetId{
    [self.muArray removeAllObjects];
    
    [self.radioDownArray removeAllObjects];
    NSArray *presetModals=[DatabaseOperation queryPresetData]; //获取数据数组
    [_radioDownArray addObjectsFromArray:presetModals];

    
    if(presetId==1) {
        
   
        for (int i=0; i<34; i++) {
            [_muArray addObject:[_radioDownArray objectAtIndex:i]];
            
        }

    
    
    }else if (presetId==35){
        
        for (int i=34; i<547; i++) {
            [_muArray addObject:[_radioDownArray objectAtIndex:i]];
        
        }
   
    
    
    
    }else if (presetId==547){
        for (int i=546; i<674; i++) {
            [_muArray addObject:[_radioDownArray objectAtIndex:i]];
            
        }

    }else if(presetId==675){
        for (int i=674; i<801; i++) {
            [_muArray addObject:[_radioDownArray objectAtIndex:i]];
            
        }
    }else if (presetId==10004){
        for (int i=675; i<10004; i++) {
            [_muArray addObject:[_radioDownArray objectAtIndex:i]];
            
        }
    }
    
    
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
    
    [self.delegate addButton:btnNameField.text preset_data_id:self.presetDataId net_data:self.presetData tag:sender.tag buttonType:self.buttonStyle];

}


//刷新下拉菜单
-(void)menuListRefresh{
    [menuList setDataSource:menuList.dataSource];
    [menuList.dataSource menu:menuList titleForRowAtIndexPath:0];
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




#pragma mark 弹出视图下拉菜单delegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    return self.muArray.count;
    
    
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    
    
   
    
    self.presetModal=self.muArray[indexPath.row];
    
    return _presetModal.name;
    
    
    
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
   self.presetModal=self.muArray[indexPath.row]; //得到模型数据
   self.presetDataId=self.presetModal._id; //得到数据id
    self.presetData=self.presetModal.data; //得到数据内容
    
    static NSString *prediStr1 = @"SELF LIKE '*'";
    switch (indexPath.column) {
        case 0:{
            if (indexPath.row == 0) {
                prediStr1 = @"SELF LIKE '*'";
            } else {
                // prediStr1 = [NSString stringWithFormat:@"SELF CONTAINS '%@'", title];
            }
        }
            break;
            
        default:
            break;
    }
    
}






#pragma mark RadioButton Delegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    NSLog(@"did selected radio:%ld groupId:%@", (long)radio.tag, groupId);
    
    if (radio.tag!=10000) {
        QRadioButton *btn=(QRadioButton *)[self viewWithTag:10000];
        btn.checked=NO;
    }
    self.buttonType=@"继电器";
    self.presetDataId=1;
    
    
    switch (radio.tag) {
        case 10000:
            self.buttonType=@"继电器";
            self.presetDataId=1;
            break;
        case 10001:
            self.buttonType=@"无线";
            self.presetDataId=35;
            break;
        case 10002:
            self.buttonType=@"情景";
            self.presetDataId=547;
            break;
        case 10003:
            self.buttonType=@"条件";
            self.presetDataId=675;
            break;
        case 10004:
            self.buttonType=@"自定义";
            self.presetDataId=1;
            break;
        default:
            break;
    }
    
    self.presetData=[DatabaseOperation queryData:self.presetDataId];
    
    //    NSNumber *preNb=[NSNumber numberWithInt:self.presetDataId];
//    NSArray *array=[NSArray arrayWithObjects:self.buttonType,preNb, nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"radioButton" object:array];
    [self getPredataArray:self.presetDataId];
    
    [self menuListRefresh];



}



@end
