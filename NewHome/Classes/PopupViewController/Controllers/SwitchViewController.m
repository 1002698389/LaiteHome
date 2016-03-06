//
//  SwitchViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/10/23.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "SwitchViewController.h"

@interface SwitchViewController ()

@end

@implementation SwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    long view_heiht=SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    
    
    
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
    
    
    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/6;
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/2, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"开关";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    
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
