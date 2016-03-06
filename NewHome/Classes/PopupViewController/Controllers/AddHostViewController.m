//
//  AddHostViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "AddHostViewController.h"
#import "HostModal.h"
#import "DatabaseOperation.h"
#import "UIDevice+IPhoneModel.h"
#define margin 10
@interface AddHostViewController ()

@end

@implementation AddHostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getHostData];
    
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
    long padding=(contentView_height-3*textField_height)/4;//y间距
    long label_width=40;                                //标题长度
    long textfield_width=(view_width-2*label_width-5*margin)/2;   //输入框长度

    
    
    
    
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"主机设置";
    titleLabel.textColor=RGBACOLOR(92, 170, 247, 1);
   
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];

    
    
    
    
    //主机
    CGFloat hostName_y=CGRectGetMaxY(titleView.frame)+padding;
    UILabel *hostName=[[UILabel alloc]initWithFrame:CGRectMake(margin, hostName_y, label_width, textField_height)];
    hostName.text=@"主机";

    hostName.textColor=RGBACOLOR(92, 170, 247, 1);
    [self.view addSubview:hostName];
    
    CGFloat hostName_x=CGRectGetMaxX(hostName.frame)+margin;
    hostNameText=[[UITextField alloc]initWithFrame:CGRectMake(hostName_x, hostName_y, textfield_width, textField_height)];
    hostNameText.layer.cornerRadius = 3.0;
    hostNameText.placeholder=@"主机名称";
    hostNameText.delegate=self;
    hostNameText.text=modal.host_name;
    hostNameText.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:hostNameText];
    
    
    
    
    //机器码
    CGFloat imeiCode_x=CGRectGetMaxX(hostNameText.frame)+margin;
    UILabel *imeiCode=[[UILabel alloc]initWithFrame:CGRectMake(imeiCode_x, hostName_y, label_width, textField_height)];
    imeiCode.text=@"ID";
    imeiCode.textColor=RGBACOLOR(92, 170, 247, 1);
    [self.view addSubview:imeiCode];
    
    CGFloat imeiText_x=CGRectGetMaxX(imeiCode.frame)+margin;
    imeiText=[[UITextField alloc]initWithFrame:CGRectMake(imeiText_x, hostName_y, textfield_width, textField_height)];
    imeiText.layer.cornerRadius = 3.0;
    imeiText.delegate=self;
    imeiText.placeholder=@"机器码";
    imeiText.text=modal.imei;
    imeiText.keyboardType= UIKeyboardTypeASCIICapable;
    imeiText.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:imeiText];
    
   
    
    
    
    //外网地址
    CGFloat network_y=CGRectGetMaxY(hostName.frame)+padding;
    UILabel *network=[[UILabel alloc]initWithFrame:CGRectMake(margin, network_y, label_width, textField_height)];
    network.text=@"外网";
    network.textColor=RGBACOLOR(92, 170, 247, 1);
    [self.view addSubview:network];
    
    CGFloat networkText_x=CGRectGetMaxX(network.frame)+margin;
    networkText=[[UITextField alloc]initWithFrame:CGRectMake(networkText_x, network_y, textfield_width, textField_height)];
    networkText.layer.cornerRadius = 3.0;
    networkText.delegate=self;
     networkText.placeholder=@"外网地址";
    networkText.text=modal.host_network;
    networkText.backgroundColor=BACKGROUND_COLOR;
    //networkText.keyboardType= UIKeyboardTypeDecimalPad;

    [self.view addSubview:networkText];
    
   
    
    
    //外网端口
    CGFloat networkPort_x=CGRectGetMaxX(networkText.frame)+margin;
    UILabel *networkPort=[[UILabel alloc]initWithFrame:CGRectMake(networkPort_x, network_y, label_width, textField_height)];
    networkPort.text=@"端口";
    networkPort.textColor=RGBACOLOR(92, 170, 247, 1);
    [self.view addSubview:networkPort];
    
    CGFloat networkPortText_x=CGRectGetMaxX(networkPort.frame)+margin;
    networkPortText=[[UITextField alloc]initWithFrame:CGRectMake(networkPortText_x, network_y, textfield_width, textField_height)];
    networkPortText.layer.cornerRadius = 3.0;
    networkPortText.delegate=self;
     networkPortText.placeholder=@"外网端口";

    networkPortText.text=modal.network_port;
    networkPortText.backgroundColor=BACKGROUND_COLOR;
    networkPortText.keyboardType= UIKeyboardTypeNumberPad;

    [self.view addSubview:networkPortText];
    
    
    
    //内网地址
    CGFloat intranet_y=CGRectGetMaxY(network.frame)+padding;
    UILabel *intranet=[[UILabel alloc]initWithFrame:CGRectMake(margin, intranet_y, label_width, textField_height)];
    intranet.text=@"内网";
    intranet.textColor=RGBACOLOR(92, 170, 247, 1);
    [self.view addSubview:intranet];
    
    CGFloat intranetText_x=CGRectGetMaxX(intranet.frame)+margin;
    intranetText=[[UITextField alloc]initWithFrame:CGRectMake(intranetText_x, intranet_y,textfield_width, textField_height)];
    intranetText.layer.cornerRadius = 3.0;
    intranetText.delegate=self;
    intranetText.placeholder=@"内网地址";

    intranetText.text=modal.host_intranet;
    intranetText.backgroundColor=BACKGROUND_COLOR;
    //intranetText.keyboardType= UIKeyboardTypeDecimalPad;
    [self.view addSubview:intranetText];
    
    
    
    //内网端口
    CGFloat intranetPort_x=CGRectGetMaxX(intranetText.frame)+margin;
    UILabel *intranetPort=[[UILabel alloc]initWithFrame:CGRectMake(intranetPort_x, intranet_y, label_width, textField_height)];
    intranetPort.text=@"端口";
    intranetPort.textColor=RGBACOLOR(92, 170, 247, 1);
    [self.view addSubview:intranetPort];
    
    CGFloat intranetPortText_x=CGRectGetMaxX(intranetPort.frame)+margin;
    intranetPortText=[[UITextField alloc]initWithFrame:CGRectMake(intranetPortText_x, intranet_y, textfield_width, textField_height)];
    intranetPortText.layer.cornerRadius = 3.0;
    intranetPortText.delegate=self;
    intranetPortText.placeholder=@"内网端口";
    intranetPortText.text=modal.intranet_port;
    intranetPortText.backgroundColor=BACKGROUND_COLOR;
    intranetPortText.keyboardType= UIKeyboardTypeNumberPad;
    [self.view addSubview:intranetPortText];

    
    
    
    
       
    
    
    
    
    
    
    
    
    //取消按钮
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width/3, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(addHostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    //关于按钮
    UIButton *aboutBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    aboutBtn.frame=CGRectMake(view_width/3, cancelBtn.frame.origin.y, view_width/3, btn_height);
    aboutBtn.backgroundColor=[UIColor clearColor];
    aboutBtn.tag=3;
    [aboutBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [aboutBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(addHostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [aboutBtn setTitle:@"关于" forState:UIControlStateNormal];
    [self.view addSubview:aboutBtn];

    
    
    
    //确定按钮
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width*2/3, cancelBtn.frame.origin.y, view_width/3, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(addHostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];

    
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)getHostData{
    
    modal=[HostModal new];
    modal=[DatabaseOperation queryHostData:self.hostId];
    
}

-(void)addHostBtnClick:(UIButton *)sender{
    
    
    
    
    [self.delegate hostSetting:hostNameText.text imei:imeiText.text.uppercaseString hostNetwork:networkText.text networkPort:networkPortText.text hostIntranet:intranetText.text intranetPort:intranetPortText.text tag:sender.tag];
    

    
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
