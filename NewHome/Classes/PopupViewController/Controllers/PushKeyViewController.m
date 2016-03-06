//
//  PushKeyViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/12/4.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "PushKeyViewController.h"
#define margin 10
@interface PushKeyViewController ()

@end

@implementation PushKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pushSelect=@"NO";
    
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
    long padding=(contentView_height-3*textField_height)/5;//y间距
     long number_width=20;
    long text_width=(self.view.frame.size.width-3*margin-2*number_width)/2;
    long value=1;
    
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"pushKey.plist"];
      NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    for (int i=0; i<3; i++) {
        for (int j=0; j<2; j++) {
            if (value==6) {
                break;
            }
            
            UILabel *numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(margin+j*(margin+text_width+number_width), btn_height+padding+i*(padding+textField_height), number_width, textField_height)];
            numberLabel.text=[NSString stringWithFormat:@"%ld",value];
            numberLabel.textColor=Text_color;
            [self.view addSubview:numberLabel];
            CGFloat keyText_x=CGRectGetMaxX(numberLabel.frame);
            UITextField *keyText=[[UITextField alloc]initWithFrame:CGRectMake(keyText_x, numberLabel.frame.origin.y, text_width, textField_height)];
            keyText.tag=value;
            keyText.text=[data1 objectForKey:[NSString stringWithFormat:@"key%ld",value]];
            keyText.backgroundColor=BACKGROUND_COLOR;
            [self.view addSubview:keyText];
            value++;
            
        }
        
       
    }
    
    
    
    CGFloat open_x=margin+margin+text_width+number_width;
    CGFloat open_y=btn_height+padding+2*(padding+textField_height);
    UILabel *openLabel=[[UILabel alloc]initWithFrame:CGRectMake(open_x, open_y, 2*number_width, textField_height)];
    openLabel.text=@"开启";
    openLabel.textColor=Text_color;
    [self.view addSubview:openLabel];
    
    
    
    CGFloat selectBtn_X=CGRectGetMaxX(openLabel.frame);
    selectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBtn.frame=CGRectMake(selectBtn_X, open_y+textField_height/4, textField_height/2, textField_height/2);
    selectBtn.backgroundColor=[UIColor clearColor];
    
    pushSelect=[data1 objectForKey:@"openPushKey"];
    
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if ([pushSelect isEqualToString:@"YES"]) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"方框选中"] forState:UIControlStateNormal];
    }else{
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
 
    }
    
    
    
        [selectBtn addTarget:self action:@selector(selectOpen:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setSelected:NO];
    selectBtn.tintColor=[UIColor clearColor];
    [self.view addSubview:selectBtn];
    
    
    
    
    
    
    //标题栏
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/2, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"推送关键词设置";
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
    [cancelBtn addTarget:self action:@selector(pushKeyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *okBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame=CGRectMake(view_width*2/3, cancelBtn.frame.origin.y, view_width/3, btn_height);
    okBtn.backgroundColor=[UIColor clearColor];
    okBtn.tag=2;
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(pushKeyClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    
    
    // Do any additional setup after loading the view.
}


-(void)pushKeyClick:(UIButton *)sender{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"keyWords" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);//直接打印数据。
    //打印出字典里的数据

    if ([pushSelect isEqualToString:@"YES"]) {
        long value=1;
               for (int i=0; i<3; i++) {
            for (int j=0; j<2; j++) {
                if (value==6) {
                    break;
                }
            UITextField *keyText=(UITextField *)[self.view viewWithTag:value];
            [data setObject:keyText.text forKey:[NSString stringWithFormat:@"key%ld",value]];
           
            value++;
                
            }
         
        }

    }else{
        pushSelect=@"NO";
        
    }

    [data setObject:pushSelect forKey:@"openPushKey"];
    [self.delegate settingPushkey:data openPushKey:pushSelect tag:sender.tag];
    
   


}


-(void)selectOpen:(UIButton *)sender{
    if ([pushSelect isEqualToString:@"YES"]) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"未标题-1"] forState:UIControlStateNormal];
        pushSelect=@"NO";
    }else{
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"方框选中"] forState:UIControlStateNormal];
    pushSelect=@"YES";
        
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
