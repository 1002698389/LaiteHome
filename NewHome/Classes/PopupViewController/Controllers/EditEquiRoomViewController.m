//
//  EditEquiRoomViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/12/20.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "EditEquiRoomViewController.h"
#import "MLTableAlert.h"
#import "DatabaseOperation.h"
#define margin 10
@interface EditEquiRoomViewController ()

@end

@implementation EditEquiRoomViewController

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
    long padding=(contentView_height-3*textField_height)/5;//y间距
    long label_width=80;                                //标题长度
    long textfield_width=view_width-label_width-3*margin;   //输入框长度
    
    [self BtnData:self.roomId hostId:self.hostId];
    
    
    
    
    self.roomIcon=modal.room_icon;
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"编辑设备分组";
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
    
    CGFloat img_y=CGRectGetMaxY(roomNameText.frame)+margin;
    disPlayImgView=[[UIImageView alloc]initWithFrame:CGRectMake(imgView_X, img_y, 2*textfield_width/3-margin, 2*(padding+textField_height))];
    disPlayImgView.backgroundColor=[UIColor clearColor];
    
    if ([modal.room_background isEqualToString:@"default"]) {
        disPlayImgView.image=[UIImage imageNamed:@"default"];
    }else if (modal.room_background==nil){
       disPlayImgView.image=[UIImage imageNamed:@"default"];
    }
    
    else{
        
        NSData *data=[NSData dataWithContentsOfFile:modal.room_background];
        
        disPlayImgView.image=[UIImage imageWithData:data];
        
        
        
    }
    
    [self.view addSubview:disPlayImgView];
    
    
    //图标
    CGFloat icon_Y=CGRectGetMaxY(backImg.frame)+padding;
    UILabel *icon=[[UILabel alloc]initWithFrame:CGRectMake(margin, icon_Y, label_width, textField_height)];
    icon.text=@"图       标";
    icon.textColor=Text_color;
    [self.view addSubview:icon];
    
    
    CGFloat displayBtn1_X=CGRectGetMaxX(icon.frame)+margin;
    
    
     NSArray *imgs=[NSArray arrayWithObjects:@"d_01",@"d_02",@"d_03",@"d_04",@"d_05",@"d_06",@"d_07",@"d_08",@"d_09",@"d_10",@"d_11",@"d_12",@"d_13",@"d_14",@"d_15",@"d_16",@"d_17",@"d_18",@"d_19",@"d_20",@"d_21",@"d_22",@"d_23",@"d_24",@"d_25",@"d_26", nil];
    
    long nub=modal.room_icon;
    iconBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    iconBtn.frame=CGRectMake(displayBtn1_X, icon_Y, textField_height, textField_height);
    [iconBtn setBackgroundImage:[UIImage imageNamed:imgs[nub-1]] forState:UIControlStateNormal];
    iconBtn.backgroundColor=BACKGROUND_COLOR;
    [iconBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(showIconAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconBtn];
        
    
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width/2, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(editEquipment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width/2, cancelBtn.frame.origin.y, view_width/2, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(editEquipment:) forControlEvents:UIControlEventTouchUpInside];
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
-(void)editEquipment:(UIButton *)sender{
    [self.delegate editRoomName:roomNameText.text roomIcon:self.roomIcon tag:sender.tag];
    
}

-(void)showIconAlert:(id)sender{
    
    
        
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
          
            
            //        self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
        } andCompletionBlock:^{
            NSLog(@"选的开关:%d",self.roomIcon);
            
        }];
        
        // show the alert
        [self.alert show];
        
         
    
    
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
