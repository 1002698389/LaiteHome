//
//  LogViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/12/4.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "LogViewController.h"
#import "DatabaseOperation.h"
#import "LogModal.h"
#define margin 10
@interface LogViewController ()

@end

@implementation LogViewController


-(void)viewWillAppear:(BOOL)animated{
    
    self.dataArray=[DatabaseOperation queryLogData:self.hostId];
    self.modalArray = [[self.dataArray reverseObjectEnumerator] allObjects];
    [logTabel reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.view.backgroundColor=[UIColor whiteColor];
    //弹出视图大小
    long view_heiht=2*SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
    
    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/6;
    
    long contentView_height=view_heiht-2*btn_height;  //内容高度
    
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, btn_height, self.view.frame.size.width, 25)];
    headView.backgroundColor=BACKGROUND_COLOR;
    [self.view addSubview:headView];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 2*headView.frame.size.width/3, 25)];
    timeLabel.text=@"时间";
    timeLabel.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:timeLabel];
    
    UILabel *accientLabel=[[UILabel alloc]initWithFrame:CGRectMake(2*headView.frame.size.width/3, 0, headView.frame.size.width/3, 25)];
    accientLabel.text=@"事件";
    accientLabel.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:accientLabel];

    
    CGFloat table_y=CGRectGetMaxY(headView.frame);
    CGFloat table_height=contentView_height-25;
    logTabel=[[UITableView alloc]initWithFrame:CGRectMake(0, table_y, self.view.frame.size.width, table_height) style:UITableViewStylePlain];
    logTabel.delegate=self;
    logTabel.dataSource=self;
    [self.view addSubview:logTabel];
    
    
    
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"日志";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    
    
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame=CGRectMake(0, view_heiht-btn_height, view_width*2/3, btn_height);
    cancelBtn.backgroundColor=[UIColor clearColor];
    cancelBtn.tag=1;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(logClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width*2/3, cancelBtn.frame.origin.y, view_width/3, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(logClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"清除" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    
    
    // Do any additional setup after loading the view.
}


-(void)logClick:(UIButton *)sender{
    
    [self.delegate logClick:sender.tag];

}

//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//返回标题数组中元素的个数来确定分区的个数
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modalArray.count;
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *reuseIdetify = @"SvTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify];
        
    
    }
    LogModal *modal=[self.modalArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=modal.createTime;
    cell.detailTextLabel.text=modal.content;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
