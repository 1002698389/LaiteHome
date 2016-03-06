//
//  PoppueLockViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/12/1.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "PoppueLockViewController.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"
@interface PoppueLockViewController ()

@end

@implementation PoppueLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    

    
    
    
    long btn_width=self.view.frame.size.width/3;
    long btn_height=self.view.frame.size.height/6;
    long contentView_height=view_heiht-2*btn_height;  //内容高度
    long padding=(contentView_height-3*textField_height)/4;//y间距
    long label_width=40;                                //标题长度
   // long textfield_width=(view_width-2*label_width-5*margin)/2;   //输入框长度
    
       
    
    
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"锁屏设置";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    CGFloat img_y=CGRectGetMaxY(titleView.frame);
    long img_widith=self.view.frame.size.width/3;
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, img_y, img_widith*294/350, contentView_height)];
    imgView.image=[UIImage imageNamed:@"lockImg"];
    [self.view addSubview:imgView];
    
    long margin=10;
    NSArray *array=[NSArray arrayWithObjects:@"原始密码",@"新密码",@"密码确认", nil];
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(margin+img_widith*294/350, img_y+padding+i*(textField_height+padding), img_widith*294/350-2*padding, textField_height)];
        label.backgroundColor=[UIColor clearColor];
        label.text=array[i];
        label.textColor=Text_color;
        label.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
   
    self.oldPass=[[UITextField alloc]initWithFrame:CGRectMake(2*img_widith*294/350, img_y+padding, img_widith*294/350-margin, textField_height)];
    self.oldPass.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:self.oldPass];
    
    
    self.anotherPasa=[[UITextField alloc]initWithFrame:CGRectMake(2*img_widith*294/350, img_y+padding+padding+textField_height, img_widith*294/350-margin, textField_height)];
    self.anotherPasa.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:self.anotherPasa];

    
    self.checkPass=[[UITextField alloc]initWithFrame:CGRectMake(2*img_widith*294/350, img_y+padding+2*(padding+textField_height), img_widith*294/350-margin, textField_height)];
    self.checkPass.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:self.checkPass];

    
    
    
    
    
    
    
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame=CGRectMake(0, self.view.frame.size.height-btn_height, btn_width-0.5, btn_height);
    [addBtn addTarget:self action:@selector(lockClick:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"启动锁屏" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    addBtn.tag=1;
    [self.view addSubview:addBtn];
    
    UIButton *importBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    importBtn.frame=CGRectMake(btn_width, self.view.frame.size.height-btn_height, btn_width-0.5, btn_height);
    [importBtn addTarget:self action:@selector(lockClick:) forControlEvents:UIControlEventTouchUpInside];
    [importBtn setTitle:@"解除锁屏" forState:UIControlStateNormal];
     [importBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [importBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [importBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    importBtn.tag=2;
    [self.view addSubview:importBtn];
    
    UIButton *exportBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    exportBtn.frame=CGRectMake(2*btn_width, self.view.frame.size.height-btn_height, btn_width-0.5, btn_height);
    [exportBtn addTarget:self action:@selector(lockClick:) forControlEvents:UIControlEventTouchUpInside];
    [exportBtn setTitle:@"更改密码" forState:UIControlStateNormal];
      [exportBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [exportBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [exportBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    exportBtn.tag=3;
    [self.view addSubview:exportBtn];

    // Do any additional setup after loading the view.
}
-(void)lockClick:(UIButton *)sender{
    if (sender.tag==1) {

  NSString *statusPass=[appDelegate.appDefault objectForKey:@"password"];
        if (statusPass==nil) {
            if ([self.anotherPasa.text isEqualToString:@""]) {
                NSString *message=@"新密码不能为空";
                [self.view makeToast:message];
 
            }else if (![self.anotherPasa.text isEqualToString:self.checkPass.text]) {
                NSString *message=@"两次输入密码不一致";
                [self.view makeToast:message];
            }else{
                //存储密码
                [appDelegate.appDefault setObject:self.anotherPasa.text forKey:@"password"];//推送默认开启
                [appDelegate.appDefault setObject:@"open" forKey:@"passwordStatus"];//锁屏状态
                
//                
//                NSString *message=@"您已经启动锁屏";
//                [self.view makeToast:message];
                WelcomeViewController *welcomVC=[[WelcomeViewController alloc]init];
                [self presentViewController:welcomVC animated:YES completion:nil];

                 
            }
            
        }else{
            
          NSString *oldPassword=[appDelegate.appDefault objectForKey:@"password"];
            if (![self.oldPass.text isEqualToString:oldPassword]) {
                
                NSString *message=@"原始密码不正确";
                [self.view makeToast:message];

            }else if ([self.anotherPasa.text isEqualToString:@""]){
                NSString *message=@"新密码不能为空";
                [self.view makeToast:message];
                
            }else if (![self.anotherPasa.text isEqualToString:self.checkPass.text]) {
                NSString *message=@"两次输入密码不一致";
                [self.view makeToast:message];
            }else{
                
                NSString *oldPassword=[appDelegate.appDefault objectForKey:@"password"];
                if (![self.oldPass.text isEqualToString:oldPassword]) {
                    
                    NSString *message=@"原始密码不正确";
                    [self.view makeToast:message];
                    
                }else{
                
                //存储密码
                [appDelegate.appDefault setObject:self.anotherPasa.text forKey:@"password"];//推送默认开启
                [appDelegate.appDefault setObject:@"open" forKey:@"passwordStatus"];//锁屏状态
                
                
                NSString *message=@"您已经启动锁屏";
                [self.view makeToast:message];
                }
          }
            
        }
        
   

    
    }else if (sender.tag==2){
        
        [appDelegate.appDefault setObject:nil forKey:@"password"];//锁屏状态
        [appDelegate.appDefault setObject:@"close" forKey:@"passwordStatus"];//锁屏状态
        NSString *message=@"您已经解除锁屏锁屏";
        [self.view makeToast:message];
    }else if (sender.tag==3){
        
        NSString *oldPassword=[appDelegate.appDefault objectForKey:@"password"];
        if (![self.oldPass.text isEqualToString:oldPassword]) {
            
            NSString *message=@"原始密码不正确";
            [self.view makeToast:message];
            
        }else if ([self.anotherPasa.text isEqualToString:@""]){
            NSString *message=@"新密码不能为空";
            [self.view makeToast:message];
            
        }else if (![self.anotherPasa.text isEqualToString:self.checkPass.text]) {
            NSString *message=@"两次输入密码不一致";
            [self.view makeToast:message];
        }else{
            //存储密码
            [appDelegate.appDefault setObject:self.anotherPasa.text forKey:@"password"];
            NSString *message=@"更改密码成功";
            [self.view makeToast:message];
        }
        
        
        
    }
    
    
    
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
