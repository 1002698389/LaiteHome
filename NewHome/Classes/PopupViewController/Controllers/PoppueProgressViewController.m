//
//  PoppueProgressViewController.m
//  NewHome
//
//  Created by 冉思路 on 15/8/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "PoppueProgressViewController.h"


#define DEFAULT_BLUE [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
@interface PoppueProgressViewController ()
@property (nonatomic) CGFloat progress;

@property (nonatomic, strong) NSArray *progressViews;
@end

@implementation PoppueProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    long view_heiht=SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    
    
    
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
    
    
    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/5;

    
    
    
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"主机同步";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];

    
    CGFloat label1_y=CGRectGetMaxY(titleView.frame);
 
    
    proLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, label1_y, self.view.frame.size.width-20, 30)];
//    proLabel.text=@"1/808";
    [self.view addSubview:proLabel];
    
    CGFloat progressView_y=CGRectGetMaxY(proLabel.frame);
    
    
    pgv=[[ProgressGradientView alloc] initWithFrame:CGRectMake(30, progressView_y, self.view.frame.size.width-60, 30)];
    [self.view addSubview:pgv];

    
    
   //
//    progressView.transform = transform;
//    progressView.frame=CGRectMake(30, progressView_y, self.view.frame.size.width-60, 30);
//    progressView.progressViewStyle = UIProgressViewStyleDefault;
//    progressView.trackTintColor = [UIColor blueColor];
//    progressView.progressTintColor = [UIColor whiteColor];
//    progressView.progress = 0.0;
//    [self.view addSubview:progressView];
    
    
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width/2, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(operationProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width/2, cancelBtn.frame.origin.y, view_width/2, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(operationProgress:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"继续" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];

        // Do any additional setup after loading the view.
}



-(void)animationProgress:(float)number{
   
    
        [pgv setProgress:number];
    
    
}


-(void)showLabel:(NSString *)progressNub{
    
    proLabel.text=progressNub;
    
    
    
}

//进度条
-(void)operationProgress:(UIButton *)sender{
    
    
    [self.delegate showProgress:sender.tag];





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
