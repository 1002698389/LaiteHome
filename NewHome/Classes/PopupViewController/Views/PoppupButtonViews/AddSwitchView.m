//
//  AddSwitchView.m
//  NewHome
//
//  Created by 小热狗 on 15/10/23.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "AddSwitchView.h"
#import "MLTableAlert.h"
#import "HYActivityView.h"
#import "DatabaseOperation.h"
#import "MLTableAlert.h"
#define margin 10
@implementation AddSwitchView

- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId;//初始化
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.swithIcon=1;
        self.swithLine=1;
       [self switchData:btnId];
       
        
        long btn_width=frame.size.width/4;
        long btn_height=frame.size.height/6;
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


        long contentView_height=frame.size.height-2*btn_height;  //内容高度
        long padding=(contentView_height-4*textField_height)/5;//y间距
        float img_height=contentView_height-2*padding;//标题长度
        float img_width=img_height*621/496;
         float imgY=(contentView_height-img_height)/2+btn_height;
        long label_width=60;
        long textfield_width=frame.size.width-label_width-img_width-4*margin;   //输入框长度
        
        
        
        //标题栏
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, btn_height)];
        titleView.backgroundColor=PopView_TitleColor;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
        titleLabel.text=@"新建开关";
        titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
        [titleView addSubview:titleLabel];
        
        [self addSubview:titleView];
        
        
        
        
        
        
        
        CGFloat btnName_Y=CGRectGetMaxY(titleView.frame)+padding;
        UIImageView *cameraView=[[UIImageView alloc]initWithFrame:CGRectMake(margin, imgY, img_width, img_height)];
        cameraView.image=[UIImage imageNamed:@"主机IO主图标"];
        [self addSubview:cameraView];
        
        CGFloat carmeraName_x=CGRectGetMaxX(cameraView.frame)+margin;
        UILabel *carmeraName=[[UILabel alloc]initWithFrame:CGRectMake(carmeraName_x, btnName_Y, label_width, textField_height)];
        carmeraName.text=@"名称";
        carmeraName.textColor=Text_color;
        [self addSubview:carmeraName];
        
        CGFloat uid_y=CGRectGetMaxY(carmeraName.frame)+padding;
        UILabel *carmeraUid=[[UILabel alloc]initWithFrame:CGRectMake(carmeraName_x, uid_y, label_width, textField_height)];
        carmeraUid.text=@"地址码";
        carmeraUid.textColor=Text_color;
        [self addSubview:carmeraUid];
        
        CGFloat carmeraUsername_y=CGRectGetMaxY(carmeraUid.frame)+padding;
        UILabel *carmeraUsername=[[UILabel alloc]initWithFrame:CGRectMake(carmeraName_x, carmeraUsername_y, label_width, textField_height)];
        carmeraUsername.text=@"图标";
        carmeraUsername.textColor=Text_color;
        [self addSubview:carmeraUsername];
        
        CGFloat carmeraPassword_y=CGRectGetMaxY(carmeraUsername.frame)+padding;
        UILabel *carmeraPassword=[[UILabel alloc]initWithFrame:CGRectMake(carmeraName_x, carmeraPassword_y, label_width, textField_height)];
        carmeraPassword.text=@"第几路";
        carmeraPassword.textColor=Text_color;
        [self addSubview:carmeraPassword];
        
        
        CGFloat carmeraNameText_x=CGRectGetMaxX(carmeraName.frame)+margin;
        carmeraNameText=[[UITextField alloc]initWithFrame:CGRectMake(carmeraNameText_x, btnName_Y, textfield_width, textField_height)];
        carmeraNameText.backgroundColor=BACKGROUND_COLOR;
        carmeraNameText.text=modal.switchName;
        carmeraNameText.placeholder=@"名称";
        //imeiText.text=hostInterFace.host_network;
        carmeraNameText.delegate=self;
        [self addSubview:carmeraNameText];
        
        
        CGFloat carmeraUidText_y=CGRectGetMaxY(carmeraNameText.frame)+padding;
        carmeraUidText=[[UITextField alloc]initWithFrame:CGRectMake(carmeraNameText_x, carmeraUidText_y, textfield_width, textField_height)];
        carmeraUidText.backgroundColor=BACKGROUND_COLOR;
         carmeraUidText.placeholder=@"地址码";
        carmeraUidText.text=modal.switchAddr;
        // imeiText.text=hostInterFace.host_network;
        carmeraUidText.delegate=self;
        [self addSubview:carmeraUidText];
        
//        CGFloat scanBtn_x=CGRectGetMaxX(carmeraUidText.frame)+10;
//        UIButton *scanBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        scanBtn.frame=CGRectMake(scanBtn_x, carmeraUidText_y, textfield_width/3-10,TextField_height);
//        [scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
//        scanBtn.backgroundColor=[UIColor blueColor];
//        [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [scanBtn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:scanBtn];
        
//        CGFloat carmeraUserName_y=CGRectGetMaxY(carmeraUidText.frame)+padding;
//        carmeraUserNameText=[[UITextField alloc]initWithFrame:CGRectMake(carmeraNameText_x, carmeraUserName_y, textfield_width, TextField_height)];
//        carmeraUserNameText.backgroundColor=BACKGROUND_COLOR;
//        
//      //  carmeraUserNameText.text=modal.user_name;
//        // imeiText.text=hostInterFace.host_network;
//        carmeraUserNameText.delegate=self;
//        [self addSubview:carmeraUserNameText];
        
        
        
        
         CGFloat displayBtn1_X=CGRectGetMaxX(carmeraUsername.frame)+margin;
//        roomDisplay=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//        roomDisplay.frame=CGRectMake(0, 0, textfield_width/3, TextField_height);
//        roomDisplay.backgroundColor=[UIColor clearColor];
//        [roomDisplay setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        
//        [roomDisplay setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
//        [roomDisplay addTarget:self action:@selector(equiGroup) forControlEvents:UIControlEventTouchUpInside];
//        [roomDisplay setTitle:@"浏览" forState:UIControlStateNormal];
//        roomDisplay.enabled=NO;
//        [self addSubview:roomDisplay];
//        upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(displayBtn1_X, carmeraUsername_y, textfield_width/3, TextField_height)
//                                            expansionDirection:DirectionUp];
//        upMenuView.homeButtonView = roomDisplay;
//        
//        [upMenuView addButtons:[self createDemoButtonArray]];
//        
//        [self addSubview:upMenuView];
//        
//        menu_frame=upMenuView.frame;

        
        
        
        
        
        NSString *imgStr;
        if (modal.switchIcon==0) {
            self.swithIcon=1;
            
            imgStr=@"ic_feed1_open";
        }else{
        switch (modal.switchIcon) {
            case 1:
              imgStr=@"ic_feed1_open";
                break;
            case 2:
                imgStr=@"ic_feed2_open";

                break;
            case 3:
                imgStr=@"ic_feed3_open";

                break;
            case 4:
                imgStr=@"ic_feed4_open";

                break;
            case 5:
                imgStr=@"ic_feed5_open";

                break;
            case 6:
                imgStr=@"ic_feed6_open";

                break;
            case 7:
                imgStr=@"ic_feed7_open";

                break;
            case 8:
                imgStr=@"ic_feed8_open";

                break;
            case 9:
                imgStr=@"ic_feed9_open";

                break;
                
            default:
                break;
        }
        
        
        }
        
        
        
        iconBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        iconBtn.frame=CGRectMake(displayBtn1_X, carmeraUsername_y, textField_height, textField_height);
        [iconBtn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        iconBtn.backgroundColor=BACKGROUND_COLOR;
        [iconBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(showIconAlert:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconBtn];

        
        
        
        
        
        
        
       
        
        
        
       CGFloat carmeraPassWordText_y=CGRectGetMaxY(carmeraUsername.frame)+padding;
//        carmeraPassWordText=[[UITextField alloc]initWithFrame:CGRectMake(carmeraNameText_x, carmeraPassWordText_y, textfield_width, TextField_height)];
//        carmeraPassWordText.backgroundColor=BACKGROUND_COLOR;
//        
//        // carmeraPassWordText.text=modal.password;
//        //imeiText.text=hostInterFace.host_network;
//        carmeraPassWordText.delegate=self;
//        [self addSubview:carmeraPassWordText];
        
        
        menuBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        menuBtn.frame=CGRectMake(carmeraNameText_x, carmeraPassWordText_y, textfield_width, textField_height);
        long lineRoad;
        if (modal.switchLine==0) {
            lineRoad=1;
            self.swithLine=1;
        }else{
            lineRoad=modal.switchLine;
        }
        [menuBtn setTitle:[NSString stringWithFormat:@"第%ld路", lineRoad] forState:UIControlStateNormal];
        menuBtn.backgroundColor=[UIColor clearColor];
        [menuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"新建房间"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(showTableAlert:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        
        
        
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame=CGRectMake(0, frame.size.height-btn_height, frame.size.width*2/3, btn_height);
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.tag=1;
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(addSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        okBtn.frame=CGRectMake(frame.size.width*2/3, cancelBtn.frame.origin.y, frame.size.width/3, btn_height);
        okBtn.backgroundColor=[UIColor clearColor];
        okBtn.tag=2;
        [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
        [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(addSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:okBtn];
        
        
        
        
    }
    return self;
}




//下拉菜单内容
- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    imgArray=[NSArray arrayWithObjects:@"右下角灯光1",@"右下角灯光2",@"右下角灯光3",@"右下角灯光4", nil];
    imgName=[NSArray arrayWithObjects:@"灯光",@"台灯",@"音乐",@"运动", nil];
    
    //给self.view添加一个手势监测；
    
    int view_width=self.frame.size.width/4;
    CGFloat view_height=self.frame.size.height/6;
    for (int i=0; i<4; i++) {
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, view_width, view_height-4)];
        view.backgroundColor=[UIColor grayColor];
        view.tag=(i+1)*10000;
        view.alpha=0.7;
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view_height-4, view_height-4)];
        imgView.image=[UIImage imageNamed:imgArray[i]];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(view_width/2, 2, view_width/2-5, view_height-4)];
        label.text=imgName[i];
        label.textColor=[UIColor whiteColor];
        //label.font=ContentFont;
        [view addSubview:imgView];
        [view addSubview:label];
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        [view addGestureRecognizer:singleRecognizer];
        
        
        [buttonsMutable addObject:view];
    }
    
    return [buttonsMutable copy];
}


#pragma mark 设备分组
-(void)equiGroup{
    
    
}





-(void)showTableAlert:(id)sender
{
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"选择路数" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                  {
                      
                      return 16;
                     
                  }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                      
                      
                      cell.textLabel.text =[NSString stringWithFormat:@"第%d路",indexPath.row+1];
                      
                      return cell;
                  }];
    
    // Setting custom alert height
    self.alert.height = 350;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        
        NSString *resultText;
        resultText= [NSString stringWithFormat:@"第%d路",selectedIndex.row+1];
        [menuBtn setTitle:resultText forState:UIControlStateNormal];
        
          self.swithLine=selectedIndex.row+1;
    } andCompletionBlock:^{
        //        self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
    }];
    
    // show the alert
    [self.alert show];
}



-(void)showIconAlert:(id)sender{
    
    NSArray *imgs=[NSArray arrayWithObjects:@"ic_feed1_open",@"ic_feed2_open",@"ic_feed3_open",@"ic_feed4_open",@"ic_feed5_open",@"ic_feed6_open",@"ic_feed7_open",@"ic_feed8_open",@"ic_feed9_open", nil];
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:@"选择图标" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                  {
                      
                      return 9;
                      
                  }
                                          andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                           
                      
                      cell.imageView.image=[UIImage imageNamed:imgs[indexPath.row]];
                      cell.textLabel.backgroundColor = [UIColor clearColor];
                      
                      UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
                      backgrdView.backgroundColor = BACKGROUND_COLOR;
                      cell.backgroundView = backgrdView;
                      //                      [NSString stringWithFormat:@"Section %d Row %d", indexPath.section, indexPath.row];
                      //
                      return cell;
                  }];
    
    // Setting custom alert height
    self.alert.height = 350;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
        
        
        [iconBtn setBackgroundImage:[UIImage imageNamed:imgs[selectedIndex.row]] forState:UIControlStateNormal];
        
        self.swithIcon=selectedIndex.row+1;
       // [self.delegate equimentGroupSelect:self.roomIcon];
        //        self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
    } andCompletionBlock:^{
        NSLog(@"选的开关:%ld",self.swithIcon);
        
    }];
    
    // show the alert
    [self.alert show];
    
    

    
    
//    if (!self.activityView) {
//        self.activityView = [[HYActivityView alloc]initWithTitle:@"选择图标" referView:self];
//
//        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
//        self.activityView.numberOfButtonPerLine = 6;
//        
//        ButtonView *bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed1_open"] handler:^(ButtonView *buttonView){
//            [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed1_open"] forState:UIControlStateNormal];
//            
//            self.swithIcon=1;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed2_open"] handler:^(ButtonView *buttonView){
//           [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed2_open"] forState:UIControlStateNormal];
//             self.swithIcon=2;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed3_open"] handler:^(ButtonView *buttonView){
//           [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed3_open"] forState:UIControlStateNormal];
//             self.swithIcon=3;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed4_open"] handler:^(ButtonView *buttonView){
//           [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed4_open"] forState:UIControlStateNormal];
//             self.swithIcon=4;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed5_open"] handler:^(ButtonView *buttonView){
//            [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed5_open"] forState:UIControlStateNormal];
//             self.swithIcon=5;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed6_open"] handler:^(ButtonView *buttonView){
//           [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed6_open"] forState:UIControlStateNormal];
//             self.swithIcon=6;
//        }];
//        [self.activityView addButtonView:bv];
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed7_open"] handler:^(ButtonView *buttonView){
//           [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed7_open"] forState:UIControlStateNormal];
//             self.swithIcon=7;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed8_open"] handler:^(ButtonView *buttonView){
//            [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed8_open"] forState:UIControlStateNormal];
//             self.swithIcon=8;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        bv = [[ButtonView alloc]initWithText:nil image:[UIImage imageNamed:@"ic_feed9_open"] handler:^(ButtonView *buttonView){
//          [iconBtn setBackgroundImage:[UIImage imageNamed:@"ic_feed9_open"] forState:UIControlStateNormal];
//             self.swithIcon=9;
//        }];
//        [self.activityView addButtonView:bv];
//        
//        
//    }
//    
//    [self.activityView show];




}


-(void)switchData:(long)switchId{
    
    modal=[SwitchModal new];
    
    modal=[DatabaseOperation querySwitch:switchId];
    self.swithLine=modal.switchLine;
    self.swithIcon=modal.switchIcon;
    
}
-(void)addSwitch:(UIButton *)sender{
    
    
    
    
    
    
    [self.delegate addSwitch:carmeraNameText.text switchAddr:carmeraUidText.text switchIcon:self.swithIcon tag:sender.tag swtichLine:self.swithLine];
    
    
    
    
    
    
    
    
    
   
}
@end
