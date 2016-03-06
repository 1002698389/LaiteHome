//
//  RemoteBtnViewController.m
//  NewHome
//
//  Created by 冉思路 on 15/8/31.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "RemoteBtnViewController.h"
#import "DatabaseOperation.h"
#import "MLTableAlert.h"
#define margin 10
@interface RemoteBtnViewController ()

@end

@implementation RemoteBtnViewController





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




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
   
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

    
    self.data_type=1;
    self.presetDataId=1;

    self.tableName=[CurrentTableName shared].tableName;
    NSArray *dataArray=[DatabaseOperation queryCategroyPredata:1 tableName:self.tableName];
    [self.radioDownArray addObjectsFromArray:dataArray];
      [self getRemoteBtnData];
    
    
    
     customSelect=NO;
    long view_heiht=SCREEN_HEIGHT/2;
    long view_width=2*SCREEN_WIDTH/3;
    
    
    
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
    
    
    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/6;
    
    
    
    
    
    
    
    long contentView_height=self.view.frame.size.height-2*btn_height;  //内容高度
    long padding=(contentView_height-4*textField_height)/5;//y间距
    long label_width=60;                                //标题长度
    long textfield_width=self.view.frame.size.width-label_width-3*margin;   //输入框长度
    long radio_width=60;

    
    


    
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"编辑按钮";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    
    //名称
    CGFloat btnName_Y=CGRectGetMaxY(titleView.frame)+18*padding;
    UILabel *btnName=[[UILabel alloc]initWithFrame:CGRectMake(margin, btnName_Y,label_width, textField_height)];
    btnName.text=@"名称";
    
    btnName.textColor=Text_color;
    btnName.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:btnName];

    
    
    CGFloat nameField_X=CGRectGetMaxX(btnName.frame)+margin;
    
    btnNameField=[[UITextField alloc]initWithFrame:CGRectMake(nameField_X, btnName_Y, textfield_width, textField_height)];
    btnNameField.delegate=self;
    if ([[CurrentTableName shared].operBtnState isEqualToString:@"edit"]) {
        //btnNameField.text=modal.button_name;
    }else if([[CurrentTableName shared].operBtnState isEqualToString:@"quickedit"]){
        
       // btnNameField.text=modalQuick.button_name;
    }
    
    if ([remoteBtnModal.button_name isEqualToString:@"(null)"]) {
        btnNameField.text=@"";
    }else{
    btnNameField.text=remoteBtnModal.button_name;
}
    btnNameField.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:btnNameField];
    
    
    
    
    if ([btnNameField.text isEqualToString:@""]) {
        self.btnMode=@"add";
    }else{
         self.btnMode=@"edit";
    }
    
    
    //功能
    CGFloat backImg_Y=CGRectGetMaxY(btnName.frame)+padding;
    backImg=[[UILabel alloc]initWithFrame:CGRectMake(margin, backImg_Y, label_width,textField_height)];
    backImg.text=@"功能";
    backImg.textColor=Text_color;
    backImg.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:backImg];
    
    
    
    CGFloat relayBtn_x=CGRectGetMaxX(backImg.frame)+margin;
    QRadioButton *relayBtn=[[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    relayBtn.frame=CGRectMake(relayBtn_x,backImg.frame.origin.y,radio_width,textField_height);
    [relayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [relayBtn setTitle:@"继电器" forState:UIControlStateNormal];
    relayBtn.titleLabel.font=ContentFont;
    relayBtn.delegate=self;
    relayBtn.tag=10000;
    relayBtn.checked=YES;
    
    [self.view addSubview:relayBtn];
   
    
    CGFloat wirelessBtn_x=CGRectGetMaxX(relayBtn.frame)+margin;
    QRadioButton *wirelessBtn=[[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    wirelessBtn.frame=CGRectMake(wirelessBtn_x,backImg.frame.origin.y,radio_width,textField_height);
    [wirelessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wirelessBtn setTitle:@"无线" forState:UIControlStateNormal];
    wirelessBtn.titleLabel.font=ContentFont;
    wirelessBtn.delegate=self;
    wirelessBtn.tag=10001;
    [self.view addSubview:wirelessBtn];
    
    
    CGFloat sceneBtn_x=CGRectGetMidX(wirelessBtn.frame)+2*margin;
    QRadioButton *sceneBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
    sceneBtn.frame=CGRectMake(sceneBtn_x,backImg.frame.origin.y,radio_width,textField_height);
    [sceneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sceneBtn setTitle:@"情景" forState:UIControlStateNormal];
    sceneBtn.titleLabel.font=ContentFont;
    sceneBtn.delegate=self;
    sceneBtn.tag=10002;
    [self.view addSubview:sceneBtn];
    
    
    CGFloat conditions_x=CGRectGetMidX(sceneBtn.frame)+2*margin;
    QRadioButton *conditionsBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
    conditionsBtn.frame=CGRectMake(conditions_x,backImg.frame.origin.y,radio_width,textField_height);
    [conditionsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [conditionsBtn setTitle:@"条件" forState:UIControlStateNormal];
    conditionsBtn.titleLabel.font=ContentFont;
    conditionsBtn.delegate=self;
    conditionsBtn.tag=10003;
    [self.view addSubview:conditionsBtn];
    
    
  
    CGFloat customer_x=CGRectGetMidX(conditionsBtn.frame)+2*margin;
    QRadioButton *customerBtn=[[QRadioButton alloc]initWithDelegate:self groupId:@"groupId1"];
    customerBtn.frame=CGRectMake(customer_x,backImg.frame.origin.y,radio_width,textField_height);
    [customerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [customerBtn setTitle:@"自定义" forState:UIControlStateNormal];
    customerBtn.titleLabel.font=ContentFont;
    customerBtn.delegate=self;
    customerBtn.tag=10004;
    [self.view addSubview:customerBtn];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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

//    menuBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    menuBtn.frame=CGRectMake(self.view.frame.size.width/4, menu_y, self.view.frame.size.width/2, TextField_height);
//    [menuBtn setTitle:_presetModal.name forState:UIControlStateNormal];
//    menuBtn.backgroundColor=[UIColor clearColor];
//    [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [menuBtn setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(showTableAlert:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:menuBtn];

    
    
    
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width/2, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(editRemote:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width/2, cancelBtn.frame.origin.y, view_width/2, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(editRemote:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    

    // Do any additional setup after loading the view.
}




-(void)createMenuBtn{
    long padding=((self.view.frame.size.height-2*self.view.frame.size.height/6)-4*textField_height)/5;
    CGFloat menu_y=CGRectGetMaxY(backImg.frame)+padding;
    menuBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuBtn.frame=CGRectMake(self.view.frame.size.width/4, menu_y, self.view.frame.size.width/2, textField_height);
    if (_presetModal==nil) {
        
    }
    [menuBtn setTitle:_presetModal.name forState:UIControlStateNormal];
    menuBtn.backgroundColor=[UIColor clearColor];
    [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(showTableAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];
    
}
-(void)createCustomerText{
    
    long padding=((self.view.frame.size.height-2*self.view.frame.size.height/6)-4*textField_height)/5;
    CGFloat menu_y=CGRectGetMaxY(backImg.frame)+padding;
    self.customText=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, menu_y, self.view.frame.size.width/2, textField_height)];
    if ([self.cutomeBtnName isEqualToString:@"(null)"]) {
         self.customText.text=@"";
    }else{
    self.customText.text=self.cutomeBtnName;
    }
    self.customText.backgroundColor=BACKGROUND_COLOR;
    
    [self.view addSubview:self.customText];
    
    
    
    
}






#pragma mark RadioButton Delegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
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
    if ([self.btnMode isEqualToString:@"add"]){
    [_radioDownArray removeAllObjects];
    if (radio.tag!=10000) {
        QRadioButton *btn=(QRadioButton *)[self.view viewWithTag:10000];
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
        case 10004:
            self.data_type=5;
            self.presetDataId=1;
            break;
        default:
            break;
    }
    
    self.presetData=[DatabaseOperation queryData:self.presetDataId];
    
    
    NSArray *array=[DatabaseOperation queryCategroyPredata:self.data_type tableName:[CurrentTableName shared].tableName];
    [_radioDownArray addObjectsFromArray:array];
    
   
        self.presetModal=[DatabaseOperation queryPresetModal:self.presetData hostId:self.currentHostId];
        [menuBtn setTitle:_presetModal.name forState:UIControlStateNormal];
    
    }else if ([self.btnMode isEqualToString:@"edit"]){
        
    }
    }
}




-(void)editRemote:(UIButton *)sender{
    if (customSelect==YES) {
        self.presetData=self.customText.text;
    }
    if ([self.presetData isEqualToString:@""]) {
        NSString *message=@"请输入自定义命令";
        [self.view makeToast:message];
    }else{
     [self.delegate addRemoteBtn:btnNameField.text preset_data_id:self.presetDataId net_data:self.presetData tag:sender.tag];
    
    }
}




-(void)geitBtnName:(NSString *)btnName{
    
    
    btnNameField.text=btnName;
    [menuBtn setTitle:btnName forState:UIControlStateNormal];
    
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

-(void)getRemoteBtnData{
    
    remoteBtnModal=[RemoteBtn new];
    remoteBtnModal=[DatabaseOperation queryEditRemoteBtn:self.editBtnTag];
    
        
        self.data_type=5;
        self.cutomeBtnName=remoteBtnModal.preset_data;
        
  
    self.presetModal=[DatabaseOperation queryPresetModal:remoteBtnModal.preset_data hostId:self.currentHostId];
    self.presetDataId=_presetModal._id;
    self.presetData=_presetModal.data;
    self.data_type=_presetModal.data_type;
    self.buttonName=_presetModal.name;
    
    
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
