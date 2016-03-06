//
//  WelcomeViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/12/22.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MsgPlaySound.h"
#import "MyMD5.h"
#import "MainViewController.h"
#import<CommonCrypto/CommonDigest.h>
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    NSString *appStatus=[appDelegate.appDefault objectForKey:@"appStatus"];//获取是否成功进入主菜单
    
    if ([appStatus isEqualToString:@"notFirst"]){
    //已经进入过app
        
         passText=@"";
        
    }else{
    
    NSString *strRandom = @"";
    
    for(int i=0; i<15; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSLog(@"随机数: %@", strRandom);
    passText=strRandom;

    
    }
    
   
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imgView.backgroundColor=[UIColor clearColor];
    imgView.image=[UIImage imageNamed:@"lock_screen_bg"];
    [self.view addSubview:imgView];
    
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/6, SCREEN_WIDTH/2, 2*SCREEN_HEIGHT/3)];
    backView.userInteractionEnabled=YES;
    backView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.15];
    [backView.layer setMasksToBounds:YES];
    [backView.layer setCornerRadius:10.0];
       [self.view addSubview:backView];

    long pading=5;
    long sectionHeight=(backView.frame.size.height-4*pading)/3;
    long btnHeight=(2*sectionHeight-3*pading)/4;
    long btnWidth=btnHeight*177/90;
    long margin=(backView.frame.size.width-3*btnWidth)/4;
    long logoHeight=sectionHeight-btnHeight;
    long logoWidth=logoHeight*539/176;
   
    
    
    
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake((backView.frame.size.width-logoWidth)/2, pading, logoWidth, logoHeight)];
    logoImgView.backgroundColor=[UIColor clearColor];
    logoImgView.image=[UIImage imageNamed:@"ic_lock_screen_w"];
    [backView addSubview:logoImgView];
    
    long deleteBtnWidth=btnWidth/2;
    long textWidth=backView.frame.size.width-2*margin-pading-deleteBtnWidth;
    CGFloat text_y=CGRectGetMaxY(logoImgView.frame)+pading;
    UIImageView *inputImgView=[[UIImageView alloc]initWithFrame:CGRectMake(margin, text_y, textWidth, btnHeight)];
    inputImgView.userInteractionEnabled=YES;
    inputImgView.backgroundColor=[UIColor clearColor];
    inputImgView.image=[UIImage imageNamed:@"文本框"];
    [backView addSubview:inputImgView];
    
    inputText=[[UITextField alloc]initWithFrame:CGRectMake(3, 0, textWidth-3, btnHeight)];
    inputText.backgroundColor=[UIColor clearColor];
    inputText.userInteractionEnabled=YES;
    
    inputText.text=passText;
    [inputImgView addSubview:inputText];
    
    CGFloat delete_x=CGRectGetMaxX(inputImgView.frame)+pading;
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteBtn.backgroundColor=[UIColor clearColor];
    deleteBtn.frame=CGRectMake(delete_x, text_y, deleteBtnWidth, btnHeight);
    [deleteBtn addTarget:self action:@selector(deleteInput) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除选中"] forState:UIControlStateNormal];
    [backView addSubview:deleteBtn];
    
    CGFloat btn_y=CGRectGetMaxY(inputImgView.frame)+pading;
    
    long n=0;
    NSArray *array=[NSArray arrayWithObjects:@"1选中",@"2选中",@"3选中",@"4选中",@"5选中",@"6选中",@"7选中",@"8选中",@"9选中",@"ic_ok",@"0选中",@"ic_cancle", nil];
    for (int i=0; i<4; i++) {
        
        if (n>12) {
            return;
        }
        for (int j=0; j<3; j++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame=CGRectMake(margin+j*(margin+btnWidth), btn_y+i*(pading+btnHeight), btnWidth, btnHeight);
            btn.backgroundColor=[UIColor clearColor];
            btn.tag=n+1;
            [btn addTarget:self action:@selector(keyboardClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:array[n]] forState:UIControlStateNormal];
            [backView addSubview:btn];
            
            n++;
        }
        
       
        
    }
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}


-(void)deleteInput{
    NSMutableString* mutableString = [[NSMutableString alloc] initWithFormat:@"%@", inputText.text];
    if ([mutableString length] >= 1) {
        NSRange tmpRange;
        tmpRange.location = [mutableString length] - 1;
        tmpRange.length = 1;
        [mutableString deleteCharactersInRange:tmpRange];
    }
    inputText.text = mutableString;
}


-(void)keyboardClick:(UIButton *)sender{
    
    long number;
    if (sender.tag==10) {
        //取消
        inputText.text=@"";
    }else if (sender.tag==11){
        number=0;
        NSMutableString *textString = [[NSMutableString alloc] initWithFormat:@"%@%ld",inputText.text,number];
        inputText.text = textString;

    }else if (sender.tag==12){
        //确定
        [self checkCode:inputText.text];
        
    }else{
        number=sender.tag;
    
    NSMutableString *textString = [[NSMutableString alloc] initWithFormat:@"%@%ld",inputText.text,number];
    inputText.text = textString;
    
    
    }
    
    
   
    
}


-(void)checkCode:(NSString *)str{
    
    NSString *appStatus=[appDelegate.appDefault objectForKey:@"appStatus"];//获取是否成功进入主菜单
    
    if ([appStatus isEqualToString:@"notFirst"]){
    
    
     NSString *oldPassword=[appDelegate.appDefault objectForKey:@"password"];
    
        if (![inputText.text isEqualToString:oldPassword]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"密码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
 
        }else{
            
            MainViewController *mainVc=[[MainViewController alloc]init];
            [self presentViewController:mainVc animated:YES completion:nil];
            
            
        }
    
        
    }else{
    
    
   
    
    long value1=[[passText substringWithRange:NSMakeRange(8, 7)] integerValue];
    long value2=[[passText substringWithRange:NSMakeRange(2, 3)] integerValue];
    long value3=[[passText substringWithRange:NSMakeRange(5, 3)] integerValue];
    long value4=[[passText substringToIndex:2] integerValue];
    
    
        
        NSString *newStr=[NSString stringWithFormat:@"%ld-%ld-%ld-%ld",value1+13243,value2+253,value3+253,value4+253];
    
        if ([str isEqualToString:newStr]) {
            MainViewController *mainVc=[[MainViewController alloc]init];
            [self presentViewController:mainVc animated:YES completion:nil];
        
        }else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"密码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            
        }
    
    
    
   
    
    
    

        
}
    
  
    
}
-(NSString *)getCurrentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
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
