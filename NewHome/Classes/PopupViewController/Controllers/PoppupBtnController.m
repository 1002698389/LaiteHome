//
//  PoppupBtnController.m
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "PoppupBtnController.h"
#import "AddButtonView.h"
#import "AddCameraView.h"
#import "AddRemoteView.h"
#import "AddSwitchView.h"
#import "AddNumberView.h"
#import "AddIOView.h"
#define margin 10
@interface PoppupBtnController ()
@property(nonatomic,strong)AddButtonView *addButtonView;
@property(nonatomic,strong)AddCameraView *addCameraView;
@property(nonatomic,strong)AddRemoteView *addRemoteView;
@property(nonatomic,strong)AddSwitchView *addSwitchView;
@property(nonatomic,strong)AddNumberView *addNumberView;
@property(nonatomic,strong)AddIOView *addIOView;
@end

@implementation PoppupBtnController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    //弹出视图大小
    long view_heiht=2*SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    NSLog(@"-----------%@",self.showState);
    
    myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, view_width, view_heiht)];
    myScrollView.delegate=self;
    myScrollView.pagingEnabled=YES;
    myScrollView.showsHorizontalScrollIndicator=NO;
   
    [self.view addSubview:myScrollView];
    
    
    if ([self.showState isEqualToString:@"add"]) {
        [myScrollView addSubview:self.addButtonView];
        [myScrollView addSubview:self.addCameraView];
        [myScrollView addSubview:self.addRemoteView];
        [myScrollView addSubview:self.addSwitchView];
        [myScrollView addSubview:self.addNumberView];
          [myScrollView addSubview:self.addIOView];
         myScrollView.contentSize=CGSizeMake(view_width*6, 0);
    }else if ([self.showState isEqualToString:@"edit"]||[self.showState isEqualToString:@"quickedit"]){
        [myScrollView addSubview:self.addButtonView];
        myScrollView.contentSize=CGSizeMake(view_width, 0);

    }else if ([self.showState isEqualToString:@"camera"]){
        [myScrollView addSubview:self.addCameraView];
        myScrollView.contentSize=CGSizeMake(view_width, 0);

    }else if([self.showState isEqualToString:@"remote"]){
        
         [myScrollView addSubview:self.addRemoteView];
        myScrollView.contentSize=CGSizeMake(view_width, 0);

    }else if([self.showState isEqualToString:@"switch"]){
        
        [myScrollView addSubview:self.addSwitchView];
        myScrollView.contentSize=CGSizeMake(view_width, 0);
        
    }else if([self.showState isEqualToString:@"number"]){
        
        [myScrollView addSubview:self.addNumberView];
        myScrollView.contentSize=CGSizeMake(view_width, 0);
        
    }else if([self.showState isEqualToString:@"io"]){
        
        [myScrollView addSubview:self.addIOView];
        myScrollView.contentSize=CGSizeMake(view_width, 0);
        
    }
   
    
       // Do any additional setup after loading the view.
}




#pragma mark ScrollView  subViews


//添加按钮
-(UIView *)addButtonView{
    
    
 
    _addButtonView=[[AddButtonView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
   
        _addButtonView.delegate=self;
        _addButtonView.backgroundColor=[UIColor clearColor];
       
    
    return _addButtonView;
}

//添加摄像头
-(UIView *)addCameraView{
    
      if ([self.showState isEqualToString:@"add"]) {
    _addCameraView=[[AddCameraView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId];
      }else{
         _addCameraView=[[AddCameraView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId];
          
      }
    _addCameraView.delegate=self;
    _addCameraView.backgroundColor=[UIColor clearColor];
    return _addCameraView;
    
    
}
//添加遥控板
-(UIView *)addRemoteView{
    if ([self.showState isEqualToString:@"add"]) {

    _addRemoteView=[[AddRemoteView alloc]initWithFrame:CGRectMake(2*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }else{
        _addRemoteView=[[AddRemoteView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    }
    _addRemoteView.delegate=self;
    _addRemoteView.backgroundColor=[UIColor clearColor];
    return _addRemoteView;
    
}

//添加开关
-(UIView *)addSwitchView{
    if ([self.showState isEqualToString:@"add"]) {
        
        _addSwitchView=[[AddSwitchView alloc]initWithFrame:CGRectMake(3*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
        
        
    }else{
       _addSwitchView=[[AddSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
        
    }
    _addSwitchView.delegate=self;
    _addSwitchView.backgroundColor=[UIColor clearColor];
    return _addSwitchView;
    
}

//添加数值
-(UIView *)addNumberView{
    if ([self.showState isEqualToString:@"add"]) {
        
        _addNumberView=[[AddNumberView alloc]initWithFrame:CGRectMake(4*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
    }else{
        _addNumberView=[[AddNumberView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
        
    }
   _addNumberView.delegate=self;
    _addNumberView.backgroundColor=[UIColor clearColor];
    return _addNumberView;
    
}
//添加IO
-(UIView *)addIOView{
    if ([self.showState isEqualToString:@"add"]) {
        
        _addIOView=[[AddIOView alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
    }else{
        _addIOView=[[AddIOView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) buttonId:self.btnId hostId:self.currentHostId];
        
    }
     _addIOView.delegate=self;
    _addIOView.backgroundColor=[UIColor clearColor];
    return _addIOView;
    
}


//上传按钮图片
-(void)upLoadBtnImg{
    
    [self.delegate upLoadButtonImg];
    
}


//添加按钮（确定，取消）
-(void)addButton:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag buttonType:(int)buttontype defaultIcon:(NSInteger)defaultIcon width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    [self.delegate addButton:button_name preset_data_id:preset_data_id net_data:net_data tag:tag buttonType:buttontype defaultIcon:defaultIcon width:btnWidth height:btnHeight customSelect:customSelect];
    
}





#pragma mark 摄像头
-(void)scanCamera{
    
    [self.delegate scanCameraUid];
}



-(void)addCamera:(NSString *)camear_name uid:(NSString *)uid user_name:(NSString *)user_name password:(NSString *)password tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    
    [self.delegate addCamera:camear_name uid:uid user_name:user_name password:password tag:tag width:btnWidth height:btnHeight customSelect:customSelect];
    
    

}


#pragma mark 遥控
-(void)showRemote:(long)tag{
    
    [self.delegate addRemoteView:tag];
}


#pragma mark 开关
-(void)addSwitch:(NSString *)switchName switchAddr:(NSString *)swithAddr switchIcon:(int)switchIcon tag:(long)tag swtichLine:(int)swtichLine{
    
    
    [self.delegate addSwitch:switchName switchAddr:swithAddr switchIcon:switchIcon tag:tag swtichLine:swtichLine];
    
    
}
#pragma mark 数值
-(void)addNumber:(NSString *)numberName numberAddr:(NSString *)swithAddr numberOne:(NSString *)numberOne tag:(long)tag numberTwo:(NSString *)numberTwo width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    
    [self.delegate addNumber:numberName numberAddr:swithAddr numberOne:numberOne tag:tag numberTwo:numberTwo width:btnWidth height:btnHeight customSelect:customSelect];
}


#pragma mark IO
-(void)addIo:(NSString *)ioName tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    
    [self.delegate addIo:ioName tag:tag width:btnWidth height:btnHeight customSelect:customSelect];
    
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
