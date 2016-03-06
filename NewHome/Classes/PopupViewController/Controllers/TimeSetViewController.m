//
//  TimeSetViewController.m
//  NewHome
//
//  Created by 小热狗 on 16/3/1.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import "TimeSetViewController.h"

@interface TimeSetViewController ()

@end

@implementation TimeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //弹出视图大小
   
    long view_heiht=2*SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    long btn_width=146;
    long btn_height=42;

    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
      
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"主机设置";
    titleLabel.textColor=RGBACOLOR(92, 170, 247, 1);
    
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    
    
    
    
  
    
    
    
    
    
    
    
    
    
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

    

    // Do any additional setup after loading the view from its nib.
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
