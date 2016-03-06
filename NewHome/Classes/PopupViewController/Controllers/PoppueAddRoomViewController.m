//
//  PoppueAddRoomViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/8/3.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "PoppueAddRoomViewController.h"
#import "DatabaseOperation.h"
#import "HYActivityView.h"
#import "MLTableAlert.h"
#define margin 10
@interface PoppueAddRoomViewController ()

@end

@implementation PoppueAddRoomViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self BtnData:self.roomId hostId:self.hostId];

    self.view.backgroundColor=[UIColor whiteColor];
    //弹出视图大小
    long view_heiht=2*SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
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

    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/6;
    
    long contentView_height=view_heiht-2*btn_height;  //内容高度
    long padding=(contentView_height-4*textField_height)/5;//y间距
    long label_width=80;                                //标题长度
    long textfield_width=view_width-label_width-3*margin;   //输入框长度
    
    
    
   
    
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"新建房间";
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
    roomNameField=[[UITextField alloc]initWithFrame:CGRectMake(nameField_X, roomName_Y, textfield_width, textField_height)];
    roomNameField.delegate=self;
    
    roomNameField.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:roomNameField];
    
    
    
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
    
    
    disPlayImgView=[[UIImageView alloc]initWithFrame:CGRectMake(imgView_X, backImg_Y, 2*textfield_width/3-margin, 3*textField_height+2*padding)];
    
    
    
         disPlayImgView.image=[UIImage imageNamed:@"default"];
    
    [self.view addSubview:disPlayImgView];
    
    
    
    
    
    
    
    
    //添加方式
    CGFloat addMode_Y=CGRectGetMaxY(backImg.frame)+padding;
    UILabel *addMode=[[UILabel alloc]initWithFrame:CGRectMake(margin, addMode_Y, label_width, textField_height)];
    addMode.text=@"添加方式";
    addMode.textColor=Text_color;
    [self.view addSubview:addMode];
    
    CGFloat selectBtn_X=CGRectGetMaxX(addMode.frame)+margin;
    selectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBtn.frame=CGRectMake(selectBtn_X, addMode_Y+textField_height/4, textField_height/2, textField_height/2);
    selectBtn.backgroundColor=[UIColor clearColor];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"方框选中"] forState:UIControlStateSelected];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(addRoomSelect:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setSelected:NO];
    selectBtn.tintColor=[UIColor clearColor];
    [self.view addSubview:selectBtn];
     self.roomType=1;
    
    
    CGFloat eqGroup_X=CGRectGetMaxX(selectBtn.frame)+margin;
    UILabel *eqGroup=[[UILabel alloc]initWithFrame:CGRectMake(eqGroup_X, addMode_Y, label_width, textField_height)];
    eqGroup.text=@"设备分组";
    eqGroup.textColor=[UIColor grayColor];
    [self.view addSubview:eqGroup];
    
    
    
    //图标
    CGFloat icon_Y=CGRectGetMaxY(addMode.frame)+padding;
    UILabel *icon=[[UILabel alloc]initWithFrame:CGRectMake(margin, icon_Y, label_width, textField_height)];
    icon.text=@"图       标";
    icon.textColor=Text_color;
    [self.view addSubview:icon];
    
    
    CGFloat displayBtn1_X=CGRectGetMaxX(icon.frame)+margin;
    
    
    iconBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    iconBtn.frame=CGRectMake(displayBtn1_X, icon_Y, textField_height, textField_height);
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"d_01"] forState:UIControlStateNormal];
    iconBtn.backgroundColor=BACKGROUND_COLOR;
    [iconBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(showIconAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconBtn];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width*2/3, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(addRoomClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width*2/3, cancelBtn.frame.origin.y, view_width/3, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(addRoomClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];

    
    // Do any additional setup after loading the view.
}


-(void)BtnData:(long)btnId hostId:(long)hostId{
    
    modal=[RoomModal new];
    
    modal=[DatabaseOperation queryRoom:btnId hostId:hostId];
}


#pragma mark 设备分组
//-(void)equiGroup{
//    
//    if (selectBtn.selected==NO) {
//  NSString *message=@"请选择设备分组";
//  [self.view makeToast:message];
//
//    }else{
//       
//    }
//    
//}





//设备分组选择
-(void)addRoomSelect:(UIButton *)sender{
    
    
    
    
    if (sender.selected==YES) {
        self.roomType=1;
        roomDisplay.enabled=YES;
        self.roomIcon=1;

        sender.selected=NO;
        
    }else{
         self.roomIcon=1;
        self.roomType=2;
        sender.selected=YES;
        roomDisplay.enabled=NO;
        
    }
    
}

//
////下拉菜单内容
//- (NSArray *)createDemoButtonArray {
//    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
//    imgArray=[NSArray arrayWithObjects:@"右下角灯光1",@"右下角灯光2",@"右下角灯光3",@"右下角灯光4", nil];
////    imgName=[NSArray arrayWithObjects:@"灯光",@"台灯",@"音乐",@"运动", nil];
//    
//    //给self.view添加一个手势监测；
//    
//    int view_width=self.view.frame.size.width/4;
//    CGFloat view_height=self.view.frame.size.height/6;
//    for (int i=0; i<4; i++) {
//        
//        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, view_width, view_height-4)];
//        view.backgroundColor=[UIColor grayColor];
//        view.tag=(i+1)*10000;
//        view.alpha=0.7;
//        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view_height-4, view_height-4)];
//        imgView.image=[UIImage imageNamed:imgArray[i]];
////        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(view_width/2, 2, view_width/2-5, view_height-4)];
////        label.text=imgName[i];
////        label.textColor=[UIColor whiteColor];
//        //label.font=ContentFont;
//        [view addSubview:imgView];
////        [view addSubview:label];
//        
//        UITapGestureRecognizer* singleRecognizer;
//        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
//        //点击的次数
//        singleRecognizer.numberOfTapsRequired = 1; // 单击
//        
//        [view addGestureRecognizer:singleRecognizer];
//        
//        
//        [buttonsMutable addObject:view];
//    }
//    
//    return [buttonsMutable copy];
//}
//
//
//
//
//
////设备分组选择
//-(void)SingleTap:(UITapGestureRecognizer*)recognizer
//{
//    //处理单击操作
//    
//    
//    [upMenuView dismissButtons];//下拉菜单消失
//    NSInteger tag=recognizer.view.tag;
//    
//    [roomDisplay setBackgroundImage:[UIImage imageNamed:imgArray[tag/10000-1]] forState:UIControlStateNormal];
//    [roomDisplay setTitle:nil forState:UIControlStateNormal];
//    [roomDisplay setBackgroundColor:[UIColor grayColor]];
//    
//    //下拉菜单选择
//    switch (tag/10000) {
//        case 1:
//            self.roomIcon=1;
//            break;
//        case 2:
//            self.roomIcon=2;
//            break;
//        case 3:
//            self.roomIcon=3;
//            break;
//        case 4:
//            self.roomIcon=4;
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    [self.delegate equimentGroupSelect:self.roomIcon];
//    
//}




-(void)remoteSelect:(UIButton *)sender{
    
    
//    switch (sender.tag) {
//        case 1:
//            
//            self.remoteState=Music;
//            
//            break;
//        case 2:
//            self.remoteState=Television;
//            break;
//        case 3:
//            self.remoteState=Box;
//            break;
//        case 4:
//            self.remoteState=Air_conditioning;
//            break;
//        case 5:
//            self.remoteState=Video;
//            break;
//        case 6:
//            self.remoteState=Projector;
//            break;
//            
//        default:
//            break;
//    }
    
    
    
    
   // [delegate createRomoteView:self.remoteState];
    
    
}




//选择房间图片
-(void)upLoadImg{
    
    
    
    [self.delegate upLoadImg];
    
   
}

//浏览图片
-(void)setImage:(UIImage *)image{
    
    disPlayImgView.image=image;
    
}


//添加房间(确认，取消)
-(void)addRoomClick:(UIButton *)sender{
    
    [self.delegate addRoom:roomNameField.text room_icon:self.roomIcon room_type:self.roomType tag:sender.tag];
}


-(void)showIconAlert:(id)sender{
    
    if (selectBtn.selected==NO) {
        NSString *message=@"请选择设备分组";
        [self.view makeToast:message];
        
    }else{
        
   
        NSArray *imgs=[NSArray arrayWithObjects:@"d_01",@"d_02",@"d_03",@"d_04",@"d_05",@"d_06",@"d_07",@"d_08",@"d_09",@"d_10",@"d_11",@"d_12",@"d_13",@"d_14",@"d_15",@"d_16",@"d_17",@"d_18",@"d_19",@"d_20",@"d_21",@"d_22",@"d_23",@"d_24",@"d_25",@"d_26", nil];
        // create the alert
        self.alert = [MLTableAlert tableAlertWithTitle:@"选择图标" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                      {
                          
                          return 26;
                          
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
            
            self.roomIcon=selectedIndex.row+1;
            [self.delegate equimentGroupSelect:self.roomIcon];
            //        self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
        } andCompletionBlock:^{
            NSLog(@"选的开关:%d",self.roomIcon);

        }];
        
        // show the alert
        [self.alert show];
        
         
        
     
    }
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
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
