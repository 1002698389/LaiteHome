
//
//  MainViewController.m
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UpView.h"
#import "MainView.h"
#import "BottomView.h"
#import "PoppueSettingController.h"
#import "DatabaseOperation.h"
#import "PoppupBtnController.h"
#import "QRCodeReaderViewController.h"
#import "CemeraView.h"
#import "LogViewController.h"
#import "NumberBtn.h"
#import "BDVRViewController.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRSettingViewController.h"
#import "BDVRSConfig.h"
#import "BDVRCustomRecognitonViewController.h"
#import "BDVRUIPromptTextCustom.h"
#import "BDVRLogger.h"
#import "RoomEditViewController.h"
#import "LGSocketServe.h"
#import "UIWindow+YzdHUD.h"
#import "LocalFileViewController.h"
#import "ControlRank.h"
@interface MainViewController ()

@property(nonatomic,strong)MainView *mainView;
@property(nonatomic,strong)BottomView *bottomView;
@property(nonatomic,strong)UpView *upView;
@end

//#define API_KEY @"12dWHj03NKcSasN4ryWijt4H" // 请修改为您在百度开发者平台申请的API_KEY
//#define SECRET_KEY @"7b36c330eb2a5b8e32d4ecc9fc48bf22" // 请修改您在百度开发者平台申请的SECRET_KEY
#define API_KEY @"UsalFDYGATMWmdcWsmzfsIUR" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"79a2a0a55eb31083092d9c738f81a744" // 请修改您在百度开发者平台申请的SECRET_KEY



@implementation MainViewController


//主机数组
- (NSMutableArray *)modalsHostArrM {
    if (!_modalsHostArrM) {
        _modalsHostArrM = [[NSMutableArray alloc] init];
    }
    return _modalsHostArrM;
}
//数据数组
-(NSMutableArray *)modalsPresetArrM{
    if (!_modalsPresetArrM) {
        _modalsPresetArrM = [[NSMutableArray alloc] init];
    }
    return _modalsPresetArrM;

    
    
}
-(void)viewWillAppear:(BOOL)animated{
#pragma mark 查询主机并连接
    
    if (photoSelect==YES) {
        
        
    }else if (photoSelect==NO){
         [self queryCurrentHost]; //查询主机状态
        
    }
    
    
    
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog( @"网络不可用");
            [CurrentTableName shared].netStatus=@"netOff";
           
            
            [_upView showNetConnectStatus:@"连接断开"];
            break;
        case ReachableViaWiFi:
            self.netStatus=@"wifi";
            [CurrentTableName shared].netStatus=@"wifi";
          NSLog( @"当前通过wifi连接,当前主机id:%ld",(long)self.currentHostId);
              [self connetHost];
            break;
        case ReachableViaWWAN:
            self.netStatus=@"wwan";
            [CurrentTableName shared].netStatus=@"wwan";
            [self connetHost];
            NSLog( @"当前通过GPRS连接,当前主机id:%ld",(long)self.currentHostId);
            break;
            
        default:
            break;
    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    hostIsConnect=NO;
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    
    
     playSound=[[MsgPlaySound alloc]initSystemShake];
    [appDelegate.appDefault setObject:@"notFirst" forKey:@"appStatus"];
[appDelegate.appDefault setObject:@"played" forKey:@"welcomeVoice"];   //存储已经播放过欢迎音乐
    
    [BDVRLogger setLogLevel:BDVR_LOG_DEBUG];//语音日志级别

    
    
    
    
#pragma mark ************************************************************************************
#pragma mark 注册通知 
//按钮
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(editCurrentBtn:) name: @"editBtn" object: nil];//编辑按钮
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteCurrentBtn:) name: @"deleteBtn" object: nil];//删除按钮
    
//摄像头
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(editCurrentCamera:) name: @"editCamera" object: nil];//编辑摄像头
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteCurrentCamera:) name: @"deleteCamera" object: nil];//删除摄像头
//遥控板
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteremote:) name: @"deleteremote" object: nil];
 
//开关
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(editSwitch:) name: @"editSwitch" object: nil];//编辑开关
    
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteCurrentSwitch:) name: @"deleteSwitch" object: nil];//删除开关
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(swipeQuerySwith:) name: @"swipeQuerySwith" object: nil];
    
//数值
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(editNumber:) name: @"editNumber" object: nil];//编辑数值
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteCurrentNumber:) name: @"deleteNumber" object: nil];//删除数值
   

//IO
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(editIo:) name: @"editIo" object: nil];//编辑数值
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteCurrentIo:) name: @"deleteIo" object: nil];//删除数值
//收到结果震动
 [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(voiceShake) name: @"voiceShake" object: nil];
   //拖动摇摆
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(btnShakeStart) name: @"btnShakeStart" object: nil];
    //拖动摇摆关闭
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(btnShakeStop) name: @"btnShakeStop" object: nil];
    //关闭摄像头
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(stopCameraShow) name: @"holdCamera" object: nil];
   
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hostViewDisMiss) name: @"hostViewDisMiss" object: nil];
    
    //时间校正
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(timeCheck:) name: @"timeCheck" object: nil];

    
#pragma mark 网络通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(chekeSocket) name: @"chekeSocket" object: nil];//检测socket连接
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(netChange) name: @"netChange" object: nil];//检测socket连接
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showNetIcon:) name: @"showNetIcon" object: nil];//展示网络连接图标
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(netOff) name: @"netOff" object: nil];//断开连接
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reconnect) name: @"reconnect" object: nil];//重连
   
  

    
//麦克风
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startVoice) name: @"checkVoice" object: nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startVoice) name: @"openVoice" object: nil];
// 
    
#pragma mark 语音操作
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(presetDataClick:) name: @"presetData" object: nil];//查询模版数据
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(presetDataSynClick:) name: @"presetData_syn" object: nil];//查询同步后数据
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(remoteBtnClick:) name: @"remoteBtnClick" object: nil];//遥控板
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(roomChange:) name: @"roomChange" object: nil];//房间切换
  [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(clickSwitch:) name: @"switchClick" object: nil];//开关点击
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(clickNumber:) name: @"numberClick" object: nil];//数值点击

     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(clickIo:) name: @"ioClick" object: nil];//io点击
    
#pragma mark socket收到结果通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showStatusOfSwitch:) name: @"switchStatus" object: nil];//开关状态
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showStatusOfnumber:) name: @"numberStatus" object: nil];//数值状态
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showStautsOfIo:) name: @"ioStatus" object: nil];//io状态
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showTemWet:) name: @"temAndwet" object: nil];//温湿度
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(synHost:) name: @"hostSyn" object: nil];//更新主机

   

     [CurrentTableName shared].operBtnState=@"add";//初始 操作按钮状态
    [CurrentTableName shared].operRoomState=@"add";
    
   // [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
     self.counting=0;

    
    
#pragma mark ************************************************************************************
#pragma mark 加载视图
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.bottomView];//底部视图
    
    [self.view addSubview:self.upView];//顶部视图
      


}

#pragma mark 初始化子视图


//底部视图
-(UIView *)bottomView{
    
    _bottomView=[[BottomView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-Navi_height-8, SCREEN_WIDTH-10, Navi_height)];
    _bottomView.backgroundColor=[UIColor clearColor];
    _bottomView.delegate=self;
    [self.view bringSubviewToFront:_bottomView];
    return _bottomView;

}

//主视图
-(UIView *)mainView{
    
    _mainView=[[MainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainView.backgroundColor=[UIColor clearColor];
    _mainView.delegate=self;
    return _mainView;
  
}
//顶部视图
-(UIView *)upView{
    
    _upView=[[UpView alloc]initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH-20, Navi_height)];
    _upView.backgroundColor=[UIColor clearColor];
    _upView.delegate=self;
    [self.view bringSubviewToFront:_upView];
    return _upView;
    
}







#pragma mark 房间设置
//房间添加界面
-(void)showAddRoomView{
    
    self.roomState=AddRoomState;
    self.displayState=DisplayRoomState;
    self.room_background=nil;
    BOOL hostStauts=[DatabaseOperation queryHostStatus];
    if (hostStauts) {
            addRoomView=nil;
            addRoomView=[[PoppueAddRoomViewController alloc]init];
            addRoomView.delegate=self;
        
           [self presentPopupViewController:addRoomView animationType:MJPopupViewAnimationFade];
    }else{
        NSString *message=@"您还未选择主机";
        [self.view makeToast:message];
        
    }
}

//添加房间选图片
-(void)upLoadImg{
    
    [self uploadImgFromLocal];

}

//房间编辑选图片
-(void)upLoadImgEdit{
    [self uploadImgFromLocal];

    
}


//新建房间设备分组选择
-(void)equimentGroupSelect:(int)imgTag{
    
    self.room_icon=imgTag;
    
}

//添加房间（确定，取消）
-(void)addRoom:(NSString *)room_name room_icon:(NSInteger)room_icon room_type:(NSInteger)room_type tag:(long)tag{
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        if (self.room_background==nil) {
            self.room_background=@"default";
        }
        
        
        
        //添加房间
        RoomModal *roomModal=[RoomModal roomModalWith:room_name roomIcon:room_icon roomBackground:self.room_background roomHaveCamera:0 cameraAddress:0 cameraUsername:0 cameraPassword:0 hostId:self.currentHostId roomType:room_type roomId:0];
        
        
        if ([roomModal.room_name isEqualToString:@""]) {
            
            NSString *message=@"请填写房间名字";
            [self.view makeToast:message];
            
        }else{
           
            if (self.roomState==AddRoomState) {
            BOOL isInsert=[DatabaseOperation insertRoomModal:roomModal hostId:self.currentHostId];
            if (isInsert) {
                NSLog(@"房间添加成功");
                NSString *message=@"房间添加成功";
               [self.view makeToast:message];
               
                NSArray *modals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:room_type];
               
                RoomModal *modalRoom=[modals lastObject];
                
                if (room_type==1) {
                     //普通房间
                     [_bottomView setBottomItems:modals];
                    
                }else if(room_type==2){
                                      
                        //设备分组
                     [_bottomView setEquipmentItems:modals];
                   
                    
                }
                [_bottomView loadRoomSelect:modalRoom._id];
                
                [self changeRoom:modalRoom._id];
                  [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                
            }else{
                NSLog(@"房间添加失败");
            }
                
            
            }
    
        }
        
        
        }



}


//房间选择
-(void)changeRoom:(long)roomId{
    NSLog(@"选择房间%ld",roomId);

    if (roomId==self.currentRoomId) {
        if (isHostSelect==YES) {
            [self loadMainViewControls:roomId];//重载房间视图
            isHostSelect=NO;
        }else if(photoSelect==NO){
            
             [self loadMainViewControls:roomId];//重载房间视图
            
        }
    }else{
    
    self.currentRoomId=roomId;
    
    [self loadMainViewControls:self.currentRoomId];//重载房间视图
    }
    
}
//切换房间（语音）
-(void)roomChange:(NSNotification*) notification{
    
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        long roomId=[notification.object integerValue];
                self.currentRoomId=roomId;
                [_bottomView loadRoomSelect:roomId];
                [self loadMainViewControls:self.currentRoomId];
    });
    
    
    
}


//编辑房间

-(void)editRoom:(long)roomId{
   self.displayState=DisplayEditRoomState;

    
    editRoomView=nil;
    editRoomView=[[RoomEditViewController alloc]init];
    self.operationRoomId=roomId;
    editRoomView.roomId=roomId;
    editRoomView.hostId=self.currentHostId;
    
    editRoomView.delegate=self;

    [self presentPopupViewController:editRoomView animationType:MJPopupViewAnimationFade];

    
}

//编辑房间（点击确定数据处理）
-(void)editRoomName:(NSString *)roomName tag:(long)tag{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        if (self.room_background==nil) {
            self.room_background=@"default";
        }
        
        
        BOOL modify=[DatabaseOperation modifyRoomName:roomName roomBackgroud:self.room_background roomId:self.operationRoomId];
        if (modify) {
            NSLog(@"房间更新成功");
            NSString *message=@"房间更新成功";
            NSArray *modals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:1];
            
            
            [_bottomView setBottomItems:modals];
            
            
            
            [_bottomView loadRoomSelect:self.operationRoomId];
            [self changeRoom:self.operationRoomId];
            [self.view makeToast:message];
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            
        }else{
            NSLog(@"房间更新失败");
        }
        
        
        
    }
    
}

//编辑设备分组
-(void)editEquiRoom:(long)roomId{
   
    
    self.displayState=DisplayEditRoomState;
    
    
    editEquiRomm=nil;
    editEquiRomm=[[EditEquiRoomViewController alloc]init];
    self.operationRoomId=roomId;
    editEquiRomm.roomId=roomId;
    editEquiRomm.hostId=self.currentHostId;
    
    editEquiRomm.delegate=self;
    
    [self presentPopupViewController:editEquiRomm animationType:MJPopupViewAnimationFade];
    
    
}

//编辑设备分组（点击确定数据处理）
-(void)editRoomName:(NSString *)roomName roomIcon:(NSInteger)roomeIcon tag:(long)tag{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        if (self.room_background==nil) {
            self.room_background=@"default";
        }
        
        
        BOOL modify=[DatabaseOperation modifyEquipRoomName:roomName roomBackgroud:self.room_background roomIcon:roomeIcon roomId:self.operationRoomId];
        
        if (modify) {
            NSLog(@"分组房间更新成功");
            NSString *message=@"分组房间更新成功";
                       NSArray *modals1=[DatabaseOperation queryRoomsData:self.currentHostId roomType:2];
            
            [_bottomView setEquipmentItems:modals1];
            [_bottomView loadRoomSelect:self.operationRoomId];
            [self changeRoom:self.operationRoomId];
            
            [self.view makeToast:message];
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            
        }else{
            NSLog(@"分组房间失败");
        }
        
        
        
    }

}

//删除房间
-(void)deleteRoom:(long)roomId{
    
 
    BOOL delete=[DatabaseOperation deleteRoom:roomId];
    if (delete) {
        
        
        NSArray *modals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:1];
         NSArray *modals1=[DatabaseOperation queryRoomsData:self.currentHostId roomType:2];
    
        
                
        //普通房间
            [_bottomView setBottomItems:modals];
    
            
            //设备分组
            [_bottomView setEquipmentItems:modals1];
            
        
        if (modals.count!=0) {
            
            RoomModal *modal=modals[0];
            
            [_bottomView loadRoomSelect:modal._id];
            
            [self changeRoom:modal._id];
        
        }else{
            if (modals1.count!=0) {
                
                RoomModal *modal=modals1[0];
                
                [_bottomView loadRoomSelect:modal._id];
                
                [self changeRoom:modal._id];
            
            
            }else{
                
                
                
            }
            
            
        }
        
               NSLog(@"房间删除成功");
        NSString *message=@"房间删除成功";
        [self.view makeToast:message];
       
    }
    
}





#pragma mark 后台设置（主机）

//主机设置界面
-(void)showHostSettingView{
    settingView=nil;
    settingView=[[PoppueSettingController alloc]init];
    settingView.delegate=self;
    [self presentPopupViewController:settingView animationType:MJPopupViewAnimationFade];

}


//主机添加界面
-(void)popAddHostClick:(long)hostId{
    
    if (hostId==0) {
        self.hostState=AddHostState;
    }else{
        self.hostState=EditHostState;
    }
    
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    addHostView=nil;
    addHostView=[[AddHostViewController alloc]init];
    addHostView.delegate=self;
    addHostView.hostId=hostId;
    [self presentPopupViewController:addHostView animationType:MJPopupViewAnimationFade];
    
    
}

//导入数据库
-(void)importLocalSqlite:(NSString *)sqliteName{
    
    self.currentRoomId=0;
   
    [DatabaseOperation importSqlite:sqliteName];
    [self queryCurrentHost]; //查询主机状态
    
}

//导出
-(void)exportSq{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    LocalFileViewController *localFile=[[LocalFileViewController alloc]init];
    localFile.delegate=self;
    localFile.transStyle=2;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:localFile];
    [self presentModalViewController:nav animated:YES];

}
//导入
-(void)induceSq{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    LocalFileViewController *localFile=[[LocalFileViewController alloc]init];
    localFile.delegate=self;
    localFile.transStyle=1;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:localFile];
    [self presentModalViewController:nav animated:YES];

    

}
//锁屏
-(void)popLockScreen{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    lockScreenView=nil;
    lockScreenView=[[PoppueLockViewController alloc]init];
   // lockScreenView.delegate=self;
   [self presentPopupViewController:lockScreenView animationType:MJPopupViewAnimationFade];
    
    
}
//主机设置（确定，取消）

-(void)hostSetting:(NSString *)hostName imei:(NSString *)imei hostNetwork:(NSString *)hostNetwork networkPort:(NSString *)networkPort hostIntranet:(NSString *)hostIntranet intranetPort:(NSString *)intranetPort tag:(long)tag{
    
  
    
    if (tag==1) {
       
      
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
       
        [self showHostSettingView];
        
        
        
    }else if (tag==3){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.laitecn.com/?cat=6"]]; 
        
    }else if(tag==2){
        
        
                //添加主机
         HostModal *hostModal=[HostModal hostModalWith:hostName imei:imei hostNetwork:hostNetwork hostIntranet:hostIntranet networkPort:networkPort intranetPort:intranetPort Type:0 hostId:0];
        
        
        if ([hostModal.host_name isEqualToString:@""]||[hostModal.imei isEqualToString:@""]||[hostModal.host_network isEqualToString:@""]||[hostModal.network_port isEqualToString:@""]||[hostModal.host_intranet isEqualToString:@""]||[hostModal.intranet_port isEqualToString:@""]) {
            [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
            NSString *message=@"请填完主机信息";
            [self.view makeToast:message];
            
        }else{
            if (self.hostState==AddHostState) {
                
              BOOL isInsert=[DatabaseOperation insertHostModal:hostModal];
                if (isInsert) {
                    
                    
                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                [self.view.window showHUDWithText:@"主机创建中..." Type:ShowLoading Enabled:YES];     
                    
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                      //子线程中开始网络请求数据
                        
                    //更新数据模型
                        [self getHostsArr];
                        HostModal *addModal=[HostModal new];
                        addModal=[_modalsHostArrM lastObject];//获得最后一个添加模型
                        NSString *hostId=[NSString stringWithFormat:@"%ld",(long)addModal._id];//获得最新的hostId
                        [DatabaseOperation createPresetData:hostId];//创建这个主机下的表格
                        [self getPresetArr];//获取数据数组
                        for (PresetData *presetData in _modalsPresetArrM) {
                            
                            [DatabaseOperation insertPresetModal:presetData tableName:hostId];//数据插入新表
                        }

                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                         //在主线程中更新UI代码
                            
                           
                            
                            [self showHostSettingView];
                      [self.view.window showHUDWithText:@"创建成功" Type:ShowPhotoYes Enabled:YES];
                       
                        
                        });
                        
                    });
                    
                    
                    
//                    NSString *message=@"主机添加成功";
//                    [self.view makeToast:message];
                    
                    
                    
                    
                }else{
                 [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
                }

            }else if (self.hostState==EditHostState){
                BOOL modify=[DatabaseOperation modifyHostData:hostModal hostId:self.editHostId];
                if (modify) {
                    NSLog(@"主机更新成功");
                    NSString *message=@"主机更新成功";
                    [self.view makeToast:message];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//                    [settingView reloadDataSource:self.modalsHostArrM];
                    [self showHostSettingView];
                }else{
                    NSLog(@"主机更新失败");
                }
 
                
                
                
            }
            
        
        }
    }
}

//主机选择
-(void)hostSelect:(NSInteger)hostId{
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chekeSocket" object:nil];
     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self openFeedBack];
    isHostSelect=YES;
    
    NSArray *views = [_mainView subviews];
    for(UIView* view in views)
    {
        
            [view removeFromSuperview];
        
    }

    [_mainView removeFromSuperview];
    _mainView=nil;
    NSLog(@"子试图%@",[_mainView subviews]);
    [self.view addSubview:self.mainView];//主视图
    [self.view bringSubviewToFront:_bottomView];
      [self.view bringSubviewToFront:_upView];
    
    [DatabaseOperation changeHost:hostId];//切换主机
    HostModal *hostModal=[HostModal new];
    hostModal=[DatabaseOperation queryConnectHost];
    NSString *message=[NSString stringWithFormat:@"切换到%@",hostModal.host_name];
    [self.view makeToast:message];
    self.currentHostId=hostId;
    [CurrentTableName shared].hostId=hostId;
    [CurrentTableName shared].tableName=[NSString stringWithFormat:@"%ld",(long)hostId];
    self.currentMachineCode=hostModal.imei;
    [self getHostsArr];
    [settingView reloadDataSource:self.modalsHostArrM];
    [self queryCurrentHost];
    [self connetHost];
    [self getEnvironmentData];

    
}


//获取主机数
-(void)getHostsArr{
    [self.modalsHostArrM removeAllObjects];
    NSArray *modals = [DatabaseOperation queryHostsData:nil];
    [_modalsHostArrM addObjectsFromArray:modals];
   

}




//查询主机状态
-(void)queryCurrentHost{
    BOOL hostStauts=[DatabaseOperation queryHostStatus];
    if (hostStauts) {
        HostModal *hostModal=[DatabaseOperation queryConnectHost];
        self.currentHostId=hostModal._id;//获取当前主机id
        [CurrentTableName shared].tableName=[NSString stringWithFormat:@"%ld",(long)hostModal._id];
        self.currentMachineCode=hostModal.imei;
        [CurrentTableName shared].hostId=hostModal._id;
        NSArray *roomModals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:1]; //获取房间数组
        NSArray *equiModals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:2]; //获取设备分组数组
        NSArray *quickModals=[DatabaseOperation queryQuick:self.currentHostId];//获取快捷键数组
        [_bottomView setBottomItems:roomModals];  //加载房间导航条
        [_bottomView setEquipmentItems:equiModals];//加载设备分组
        [_upView loadItems:quickModals];//加载快捷键
        self.firstRoomId=[DatabaseOperation getFirstRoomId:self.currentHostId];//获取第一个房间Id
       
            [self changeRoom:self.firstRoomId];//加载主页面上的控件

        
    }else{
        NSArray *roomModals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:1]; //获取房间数组
        NSArray *equiModals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:2]; //获取设备分组数组
        NSArray *quickModals=[DatabaseOperation queryQuick:self.currentHostId];//获取快捷键数组
        [_bottomView setBottomItems:roomModals];  //加载房间导航条
        [_bottomView setEquipmentItems:equiModals];//加载设备分组
        [_upView loadItems:quickModals];//加载快捷键
        [self loadMainViewControls:self.currentRoomId];//重载房间视图
          [_mainView setBackgroundImg:@"default"];
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您还未选择主机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
    }
    
}



-(void)queryRoomStatus{
    
    
    
    
    
    
    
    
}

//编辑主机
-(void)editHost:(long)hostId{
    
   
    self.editHostId=hostId;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    [self popAddHostClick:hostId];


}
//删除主机
-(void)deleteHost:(long)hostId indexRow:(long)indexRow{
    
    [self getHostsArr];
    BOOL delete=[DatabaseOperation deleteHostData:hostId];
    if (delete) {
        [_modalsHostArrM removeObjectAtIndex:indexRow];
        NSLog(@"主机删除成功");
        NSString *message=@"主机删除成功";
        [self.view makeToast:message];
        [settingView reloadDataSource:_modalsHostArrM];
        
    }else{
        NSLog(@"主机删除失败");
    }
}

//主机同步
-(void)synchro:(long)hostId{
   
    if (hostIsConnect==NO) {
        NSString *message=@"您还未连接上主机";
        [self.view makeToast:message];
    }else{

    
    
    
    if (hostId==self.currentHostId) {
        self.synchroId=hostId;
        [self getPresetArr];
        BOOL hostStauts=[DatabaseOperation queryHostStatus];
        if (hostStauts) {
            
             [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            settingView=nil;
             [CurrentTableName shared].hostIsSyn =@"sysYes";
                         [self showProgressView];
            [self hostSyn:hostId];

      
            
        
        }else{
            NSString *message=@"您还未选择主机";
            [self.view makeToast:message];
        }
    }else{
        NSString *message=@"请先连接你要同步数据的主机";
        [self.view makeToast:message];
    }

}
}


//选择的主机同步
-(void)hostSyn:(long)hostId{
   
    
    if (self.counting>=807) {
         [self.view.window showHUDWithText:@"同步数据成功" Type:ShowPhotoYes Enabled:YES];
         [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
        [self hostViewDisMiss];
        return;
    }else{
 
    
      [CurrentTableName shared].hostSynStatus=@"send";


              self.synchroId=hostId;
        PresetData *preset=[_modalsPresetArrM objectAtIndex:self.counting];
        NSLog(@"发送计数%ld",self.counting);
        NSString *code=preset.data;
        NSArray *array=[code componentsSeparatedByString:@" "];
        NSString *newData=[array componentsJoinedByString:@""];
        NSString *str=[newData substringToIndex:6];
        NSString *sendStr=[str stringByAppendingString:@"1101"];
        NSString *str1=[self.currentMachineCode stringByAppendingString:sendStr];
        [socketServe sendMessage:str1];
        NSLog(@"开启计时器");
        hostTimer =[[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkHostSyn:) userInfo:nil repeats:NO] retain];
//        //加入主循环池中
//        [[NSRunLoop mainRunLoop]addTimer:hostTimer forMode:NSDefaultRunLoopMode];
//        //开始循环
//        [hostTimer fire];
       
}


}

-(void)checkHostSyn:(long)count{
    
   NSLog(@"判断计数%ld",self.counting);
   
   
    if ([[CurrentTableName shared].hostSynStatus isEqual:@"willrecive"]) {
   //收到影响，没执行再次发送
   
                [self hostSyn:self.synchroId];
                // [self synchro:self.synchroId];
        
    }
    
   else if ([[CurrentTableName shared].hostSynStatus isEqual:@"send"]) {
        //没收到
       if (self.counting>=807) {
                     
           return;
       }else{
        PresetData *preset=[PresetData new];
        preset=[_modalsPresetArrM objectAtIndex:self.counting];
        
           
            self.counting++;
            
            
            NSString *str=[NSString stringWithFormat:@"%ld/%@",self.counting,@"808"];
            [progressView showLabel:str];
            NSLog(@"跳过后计数:%ld",self.counting);
            
            
            
            BOOL modify=[DatabaseOperation modifyPresetName:preset.name presetId:preset._id hostId:self.currentHostId];
            
            
            if (modify) {
                
                NSLog(@"数据更新成功:%@",preset.name);
                
            }else{
                
                NSLog(@"数据更新失败");
            }
            
            if (self.counting>=807) {
                 [self.view.window showHUDWithText:@"同步数据成功" Type:ShowPhotoYes Enabled:YES];
                 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
                [CurrentTableName shared].hostIsSyn =@"sysNo";

              
                [self hostViewDisMiss];
                return;
            }else{
                
                float number=1 /(float)_modalsPresetArrM.count;
                progress+=number;
                [progressView animationProgress:progress];
                self.synJudgeStr=@"send";
                [self hostSyn:self.synchroId];
                // [self synchro:self.synchroId];
            }
           
       }
   }
    
    
}

-(void)synHost:(NSNotification*) notification{
      [CurrentTableName shared].hostSynStatus=@"recive";
         //停止定时器
   
    if (hostTimer) {
        
        [hostTimer invalidate];
        
        hostTimer=nil;
        
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"永久停止计时器");

    
    NSLog(@"收到计数%ld",self.counting);
    self.synJudgeStr=@"recive";
    
    [appDelegate.appDefault setObject:@"success" forKey:@"hostSynStatus"];
    NSString *chine=notification.object;
   if (self.counting<807) {
    PresetData *preset=[PresetData new];
    preset=[_modalsPresetArrM objectAtIndex:self.counting];
   
    if ([preset.syn isEqualToString:@"N"]) {
        self.counting++;
        NSString *str=[NSString stringWithFormat:@"%ld/%@",self.counting,@"808"];
        [progressView showLabel:str];
        NSLog(@"跳过后计数:%ld",self.counting);
        
        
        
        BOOL modify=[DatabaseOperation modifyPresetName:preset.name presetId:preset._id hostId:self.currentHostId];
        
        
        if (modify) {
            
            NSLog(@"数据更新成功:%@",preset.name);
            
        }else{
            
            NSLog(@"数据更新失败");
        }
        
        if (self.counting>=807) {
             [self.view.window showHUDWithText:@"同步数据成功" Type:ShowPhotoYes Enabled:YES];
             [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
            [CurrentTableName shared].hostIsSyn =@"sysNo";

             [self hostViewDisMiss];
            return;
        }else{
            
            float number=1 /(float)_modalsPresetArrM.count;
            progress+=number;
            [progressView animationProgress:progress];
            self.synJudgeStr=@"send";
            [self hostSyn:self.synchroId];
            // [self synchro:self.synchroId];
        }
        
    }else{
        
        
        
        BOOL modify=[DatabaseOperation modifyPresetName:chine presetId:preset._id hostId:self.currentHostId];
        
        
        if (modify) {
            
            NSLog(@"数据更新成功:%@",chine);
            NSString *str=[NSString stringWithFormat:@"%ld/%@",self.counting+1,@"808"];
            [progressView showLabel:str];
            self.counting++;
            if (self.counting>=807) {
                 [self.view.window showHUDWithText:@"同步数据成功" Type:ShowPhotoYes Enabled:YES];
                 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
                [CurrentTableName shared].hostIsSyn =@"sysNo";

               [self hostViewDisMiss];
                return;
            }else{
                
                float number=1 /(float)_modalsPresetArrM.count;
                progress+=number;
                [progressView animationProgress:progress];
                self.synJudgeStr=@"send";
                [self hostSyn:self.synchroId];
                // [self synchro:self.synchroId];
            }
            
        }else{
            //停用计时器
            
            // [time invalidate];
            NSLog(@"数据更新失败");
            NSString *str=[NSString stringWithFormat:@"%ld/%@",self.counting+1,@"808"];
            [progressView showLabel:str];
            self.counting++;
            if (self.counting>=807) {
                [self.view.window showHUDWithText:@"同步数据成功" Type:ShowPhotoYes Enabled:YES];
                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
                [CurrentTableName shared].hostIsSyn =@"sysNo";
                
                [self hostViewDisMiss];
                return;
            }else{
                
                float number=1 /(float)_modalsPresetArrM.count;
                progress+=number;
                [progressView animationProgress:progress];
                self.synJudgeStr=@"send";
                [self hostSyn:self.synchroId];
                // [self synchro:self.synchroId];
            }

        
        
        
        
        
        
        
        }
    }
   }
 self.checkCount=self.counting;
}

-(void)hostViewDisMiss{
    
    [CurrentTableName shared].hostIsSyn =@"sysNo";
    
    if (hostTimer) {
        
        [hostTimer invalidate];
        
        hostTimer=nil;
        
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSLog(@"永久停止计时器");
   
    self.counting=0;
    progress=0;
 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void)timeCheck:(NSNotification*) notification{
    NSString *timeCheckStr=notification.object;
    [socketServe sendMessage:timeCheckStr];
    
    

}
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}




#pragma mark 按钮(按钮,摄像头,遥控板)

#pragma mark 添加按钮
//按钮添加界面
-(void)showAddBtnView:(NSString *)state btnId:(long)btnId{
    if ([state isEqualToString:@"edit"]||[state isEqualToString:@"quickedit"]||[state isEqualToString:@"camera"]||[state isEqualToString:@"remote"]||[state isEqualToString:@"switch"]||[state isEqualToString:@"number"]||[state isEqualToString:@"io"]) {
        self.btnState=EditBtnState;
    }else if ([state isEqualToString:@"add"]){
        self.btnState=AddBtnState;
    }
    
    self.displayState=DisplayBtnState;
    NSArray *roomModals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:1]; //获取房间数组
    NSArray *equiModals=[DatabaseOperation queryRoomsData:self.currentHostId roomType:2]; //获取设备分组数组
    if (roomModals.count!=0||equiModals.count!=0) {
        addBtnView=nil;
        addBtnView=[[PoppupBtnController alloc]init];
        addBtnView.currentHostId=self.currentHostId;
        addBtnView.showState=state;
        addBtnView.btnId=btnId;
        addBtnView.delegate=self;
        
        [self presentPopupViewController:addBtnView animationType:MJPopupViewAnimationFade];
 
    }else{
        NSString *message=@"您还未添加房间";
        [self.view makeToast:message];
 
    }
    
    
}

//上传按钮图片
-(void)upLoadButtonImg{
    
    [self uploadImgFromLocal];
    
}

//添加按钮（确定，取消）
-(void)addButton:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag buttonType:(int)buttontype defaultIcon:(NSInteger)defaultIcon width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect
{
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        if (buttontype==2) {
        //快捷按钮
            QuickButton *quickModal=[QuickButton quickButtonModalWith:button_name presetDataId:preset_data_id hostId:self.currentHostId quickBtnId:0 net_data:net_data];
             if (self.btnState==AddBtnState) {
            
//            if ([quickModal.button_name isEqualToString:@""]) {
//                NSString *message=@"请填写按钮名字";
//                [self.view makeToast:message];
//            }else{
                BOOL isInsert=[DatabaseOperation insertQuickModal:quickModal];
                if (isInsert) {
                    NSLog(@"快捷键添加成功");
                    NSString *message=@"快捷键添加成功";
                    [self.view makeToast:message];
                    NSArray *modals=[DatabaseOperation queryQuick:self.currentHostId];
                    [_upView loadItems:modals];
                    
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                   
                    
                }else{
                    NSLog(@"快捷键添加失败");
                }

           // }
             }else if (self.btnState==EditBtnState){
                 
                 BOOL modify=[DatabaseOperation modifyQuickBtnData:quickModal quickId:self.operationQuickId];
                if (modify) {
                     NSLog(@"快捷键更新成功");
                     NSString *message=@"快捷键更新成功";
                    [self.view makeToast:message];

                    NSArray *modals=[DatabaseOperation queryQuick:self.currentHostId];
                    [_upView loadItems:modals];

                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                 }else{
                     NSLog(@"按钮更新失败");
                 }

                 
                 
                 
                 
             }
        }else if (buttontype==1){
        //普通按钮
              
            NSArray *btnModals=[DatabaseOperation queryButtonData:self.currentRoomId];//房间内的按钮
            NSArray *switchModals=[DatabaseOperation querySwitchData:self.currentRoomId];
            long numbers=btnModals.count + switchModals.count;
            NSDictionary *switchDic=[ControlRank throughItmes:numbers];
            NSString *x=[switchDic objectForKey:@"x"];
            NSString *y=[switchDic objectForKey:@"y"];
            self.button_x=[x integerValue];
            self.button_y=[y integerValue];

            
            
            
            ButtonModal *btnModal=[ButtonModal buttonModalWith:self.currentRoomId buttonName:button_name buttonIcon:self.button_icon presetDataId:preset_data_id netData:net_data buttonX:self.button_x buttonY:self.button_y width:btnWidth.floatValue height:btnHeight.floatValue  defaultIcon:defaultIcon customSelect:customSelect buttonId:0];
            

            
            if (self.btnState==AddBtnState) {
//            if ([btnModal.button_name isEqualToString:@""]) {
//                NSString *message=@"请填写按钮名字";
//                [self.view makeToast:message];
//            }else
                if ([btnWidth isEqualToString:@""]||[btnHeight isEqualToString:@""]) {
                NSString *message=@"按钮宽高不能为空";
                [self.view makeToast:message];
               
            }else if ([btnWidth isEqualToString:@"0"]||[btnHeight isEqualToString:@"0"]) {
                NSString *message=@"按钮宽高不能为0";
                [self.view makeToast:message];
              
            }else{
                
                BOOL isInsert=[DatabaseOperation insertButtonModal:btnModal];
                if (isInsert) {
                    NSLog(@"按钮添加成功");
                    NSString *message=@"按钮添加成功";
                    [self.view makeToast:message];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                    [self loadMainViewControls:self.currentRoomId];
                    

//                    NSArray *btnArray=[DatabaseOperation queryButtonData:self.currentRoomId]; //获取房间内的按钮数组
//                    [_mainView setControlBtns:btnArray];//显示按钮
                    
                                    
                    }else{
                        NSLog(@"按钮添加失败");
                    }
            
            }
           
                
            }else if(self.btnState==EditBtnState){
                
                BOOL modify=[DatabaseOperation modifyBtnData:btnModal buttonId:self.operationBtnId];
             
                if (modify) {
                    NSLog(@"按钮更新成功");
                    NSString *message=@"按钮更新成功";
//                      NSArray *modals=[DatabaseOperation queryButtonData:self.currentRoomId];
//                           [_mainView setControlBtns:modals];
                    [self loadMainViewControls:self.currentRoomId];
                    

                            [self.view makeToast:message];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                }else{
                    NSLog(@"按钮更新失败");
                }

                
                
                
                
            }
        }
        
    }
    
    
    
}




//普通按钮点击事件
-(void)BtnClick:(long)buttonId{
    
    
    NSString *netData=[DatabaseOperation queryBtnData:buttonId];
    NSArray *array=[netData componentsSeparatedByString:@" "];
    NSString *newData=[array componentsJoinedByString:@""];
    NSString *str=[self.currentMachineCode stringByAppendingString:newData];
     [socketServe sendMessage:str];
    [playSound play];

    
    
}
//快捷按钮点击事件
-(void)quickButtonClick:(long)buttonId{
    NSString *netData=[DatabaseOperation queryQuickBtnData:buttonId];
    NSArray *array=[netData componentsSeparatedByString:@" "];
    NSString *newData=[array componentsJoinedByString:@""];
    NSString *str=[self.currentMachineCode stringByAppendingString:newData];
     [socketServe sendMessage:str];

    [playSound play];

    
    
}

//编辑按钮
-(void)editCurrentBtn:(NSNotification*) notification{
    
   
    
    
    
    self.operationBtnId=[notification.object integerValue];
    
   
    [CurrentTableName shared].operBtnState=@"edit";
    
    [self showAddBtnView:@"edit" btnId:self.operationBtnId];
    




}

//删除按钮
-(void)deleteCurrentBtn:(NSNotification*) notification{
    
    long  buttonId=[notification.object integerValue];

   
    
    
    BOOL delete=[DatabaseOperation deleteBtn:buttonId];
    
    if (delete) {
              NSLog(@"按钮删除成功");
        NSString *message=@"按钮删除成功";
        [self.view makeToast:message];
         [self loadMainViewControls:self.currentRoomId];      
   
    }
    
    
    
}


//编辑快捷
-(void)editQuick:(long)quickId{
    
    
    self.operationQuickId=quickId;
    
    
    [CurrentTableName shared].operBtnState=@"quickedit";
    
    [self showAddBtnView:@"quickedit" btnId:self.operationQuickId];






}

//删除快捷
-(void)deleteQuick:(long)quickId{
    
    
    
    
    
    BOOL delete=[DatabaseOperation deleteQuickBtn:quickId];
    
    if (delete) {
        NSLog(@"按钮删除成功");
        NSString *message=@"按钮删除成功";
        [self.view makeToast:message];
        NSArray *modals=[DatabaseOperation queryQuick:self.currentHostId];
        [_upView loadItems:modals];
        
    }

    
}




#pragma mark 添加摄像头









-(void)addCamera:(NSString *)camear_name uid:(NSString *)uid user_name:(NSString *)user_name password:(NSString *)password tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        
        long camear_x=150;
       long camear_y=200;
        long definition=1;
        
        CameraModal *modal=[CameraModal cameraModalWith:camear_name uid:uid user_name:user_name password:password camear_x:camear_x camear_y:camear_y  width:btnWidth.floatValue height:btnHeight.floatValue customSelect:customSelect definition:definition room_id:self.currentRoomId _id:0];
            if (self.btnState==AddBtnState) {
                
                if ([modal.camear_name isEqualToString:@""]) {
                    NSString *message=@"请填写摄像头名字";
                    [self.view makeToast:message];
                }else{
                    BOOL isInsert=[DatabaseOperation insertCameraModal:modal];
                    if (isInsert) {
                        NSLog(@"摄像头添加成功");
                        NSString *message=@"摄像头添加成功";
                        [self.view makeToast:message];
                       
                        
                        [self loadMainViewControls:self.currentRoomId];

                        
//                        NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
//                        [_mainView setcamera:modals];
                        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                        
                    }else{
                        NSLog(@"摄像头添加失败");
                    }
                    
                }
            }else if (self.btnState==EditBtnState){
                
                BOOL modify=[DatabaseOperation modifyCameraData:modal cameraId:self.operationCameraId];
                if (modify) {
                    NSLog(@"摄像头更新成功");
                    NSString *message=@"摄像头更新成功";
                    [self.view makeToast:message];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadMainViewControls:self.currentRoomId];
                    });
                   
                    
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                }else{
                    NSLog(@"按钮更新失败");
                }
                
                
                
                
                
            }
    }
    
}

//摄像头扫描
-(void)scanCameraUid{
    
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
    
}

-(void)cameraOperation:(long)tag{
    if (tag==1) {
        //监听
        [self startCameraVoice];
        
    }else if (tag==2){
        //语音
        
         [self startTalking];
        
        
    }else if (tag==3){
        //静听
        [self stopCameraVoice];

    
    
    }

    
    
    
    
    
    
}

//QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraUid" object:result];

     
        
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//编辑摄像头
-(void)editCurrentCamera:(NSNotification*) notification{
    
    
    self.operationCameraId=[notification.object integerValue];
    
    
    [CurrentTableName shared].operBtnState=@"camera";
    
    [self showAddBtnView:@"camera" btnId:self.operationCameraId];




}
//删除摄像头
-(void)deleteCurrentCamera:(NSNotification*) notification{
  
    self.operationCameraId=[notification.object integerValue];

    BOOL delete=[DatabaseOperation deleteCamera:self.operationCameraId];
    
    if (delete) {
        NSLog(@"按钮删除成功");
        NSString *message=@"按钮删除成功";
        [self.view makeToast:message];
        [self loadMainViewControls:self.currentRoomId];
    }
    

}

- (void)dealloc {
    [super dealloc];  //非ARC中需要调用此句
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




#pragma mark 添加遥控设备

//编辑遥控buttonView
-(void)showEditRemoteView{
    remoteBtnView=nil;
    remoteBtnView=[[RemoteBtnViewController alloc]init];
    remoteBtnView.editBtnTag=self.operationReBtnId;
    remoteBtnView.currentHostId=self.currentHostId;
    remoteBtnView.delegate=self;
    [self presentPopupViewController:remoteBtnView animationType:MJPopupViewAnimationFade];
    
}



//添加遥控设备
-(void)addRemoteView:(long)tag{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        long remote_x=100;
        long remote_y=180;
        
        
        RemoteModal *modal=[RemoteModal remoteModalWith:0 remote_x:remote_x remote_y:remote_y room_id:self.currentRoomId];
              if (self.btnState==AddBtnState) {
            
           
                  [DatabaseOperation insertRemoteModal:modal];
                  
                    
                    [self loadMainViewControls:self.currentRoomId];
                    
                    
                    //                        NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                    //                        [_mainView setcamera:modals];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                }else{
                    NSLog(@"遥控板添加失败");
                }
                
        
        }else if (self.btnState==EditBtnState){
            
//            BOOL modify=[DatabaseOperation modifyCameraData:modal cameraId:self.operationCameraId];
//            if (modify) {
//                NSLog(@"摄像头更新成功");
//                NSString *message=@"摄像头更新成功";
//                [self.view makeToast:message];
//                
//                
//                [self loadMainViewControls:self.currentRoomId];
//                //                    NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
//                //
//                //                    [_mainView setcamera:modals];
//                
//                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//                
//            }else{
//                NSLog(@"按钮更新失败");
//            }
//                    
//            
//        }
    }

}

//编辑遥控按钮
-(void)editRomteBtn:(long)tag{
    
    
    self.operationReBtnId=tag;

    
    [CurrentTableName shared].operBtnState=@"remoteedit";
    
    [self showEditRemoteView];
 

}
//删除遥控板
-(void)deleteremote:(NSNotification*) notification{
    
    self.currentRemoteId=[notification.object integerValue];
    
    BOOL delete=[DatabaseOperation deleteRemote:self.currentRemoteId];
    
    if (delete) {
        NSLog(@"遥控板删除成功");
        NSString *message=@"遥控板删除成功";
        [self.view makeToast:message];
        [self loadMainViewControls:self.currentRoomId];
    }
    
    
}
//遥控器按钮点击事件
-(void)remoteButtonClick:(long)buttonId{
    RemoteBtn *modal=[RemoteBtn new];
    
    modal=[DatabaseOperation queryRemoteBtn:buttonId];
    
    NSString *netData=modal.preset_data;
    NSArray *array=[netData componentsSeparatedByString:@" "];
    NSString *newData=[array componentsJoinedByString:@""];
    NSString *str=[self.currentMachineCode stringByAppendingString:newData];
    [socketServe sendMessage:str];
    [playSound play];
    
    
    
}

//遥控板（语音）
-(void)remoteBtnClick:(NSNotification*) notification{
    
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *netData=notification.object;
        NSArray *array=[netData componentsSeparatedByString:@" "];
        NSString *newData=[array componentsJoinedByString:@""];
        NSString *str=[self.currentMachineCode stringByAppendingString:newData];
        [socketServe sendMessage:str];
        

        
        
    });

    
    
}

-(void)addRemoteBtn:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag{
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        RemoteBtn *reBtnModal=[RemoteBtn new];
        reBtnModal=[RemoteBtn remoteModalWith:button_name preset_data:net_data remoteBtnId:self.operationReBtnId remoteId:0];
        if ([reBtnModal.button_name isEqualToString:@""]) {
            NSString *message=@"请填写按钮名字";
            [self.view makeToast:message];
        }else{
        
        BOOL modify=[DatabaseOperation modifyRemoteBtnData:reBtnModal btnId:self.operationReBtnId];
        
        if (modify) {
            NSLog(@"按钮更新成功");
            NSString *message=@"按钮更新成功";
            [self loadMainViewControls:self.currentRoomId];
            
            
            [self.view makeToast:message];
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
            
        }else{
            NSLog(@"按钮更新失败");
        }
    

        }
    
    }
    
}


#pragma mark 添加开关设备


-(void)addSwitch:(NSString *)switchName switchAddr:(NSString *)swithAddr switchIcon:(int)switchIcon tag:(long)tag swtichLine:(int)swtichLine{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        
        NSArray *btnModals=[DatabaseOperation queryButtonData:self.currentRoomId];//房间内的按钮
        NSArray *switchModals=[DatabaseOperation querySwitchData:self.currentRoomId];
        long numbers=btnModals.count + switchModals.count;
        NSDictionary *switchDic=[ControlRank throughItmes:numbers];
        
        
       
        
        NSString *x=[switchDic objectForKey:@"x"];
        NSString *y=[switchDic objectForKey:@"y"];
        float switch_x=[x floatValue];
        float switch_y=[y floatValue];
        
        
        SwitchModal *modal=[SwitchModal switchModalWith:switchName switchAddr:[swithAddr lowercaseString] switchIcon:switchIcon switchLine:swtichLine room_id:self.currentRoomId switch_x:switch_x switch_y:switch_y _id:0];
        
        if (self.btnState==AddBtnState) {
            
//            if ([modal.switchName isEqualToString:@""]) {
//                NSString *message=@"请填写开关名字";
//                [self.view makeToast:message];
//            }else
            if ([modal.switchAddr isEqualToString:@""]){
                NSString *message=@"请填写开关地址";
                [self.view makeToast:message];
            }else{
                BOOL isInsert=[DatabaseOperation insertSwitchModal:modal];
                if (isInsert) {
                    NSLog(@"开关添加成功");
                    NSString *message=@"开关添加成功";
                    [self.view makeToast:message];
                    
                    
                    [self loadMainViewControls:self.currentRoomId];
                    
                    
                    //                        NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                    //                        [_mainView setcamera:modals];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                }else{
                    NSLog(@"开关添加失败");
                }
                
            }
        }else if (self.btnState==EditBtnState){
            
            BOOL modify=[DatabaseOperation modifySwitchData:modal switchId:self.operationSwitchId];
            
            if (modify) {
                NSLog(@"开关更新成功");
                NSString *message=@"开关更新成功";
                [self.view makeToast:message];
                
                
                [self loadMainViewControls:self.currentRoomId];
                //                    NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                //
                //                    [_mainView setcamera:modals];
                
                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                
            }else{
                NSLog(@"按钮更新失败");
            }
            
            
            
            
            
        }
    }

    
}

//开关点击事件
-(void)switchClick:(long)switchId{
    
    SwitchModal *modal=[SwitchModal new];
    modal=[DatabaseOperation querySwitch:switchId/100];
    NSString *switchLine;
    switch (modal.switchLine) {
        case 1:
            switchLine=@"0000";
            break;
        case 2:
            switchLine=@"0001";
            break;
        case 3:
            switchLine=@"0002";
            break;
        case 4:
            switchLine=@"0003";
            break;
        case 5:
            switchLine=@"0004";
            break;
        case 6:
            switchLine=@"0005";
            break;
        case 7:
            switchLine=@"0006";
            break;
        case 8:
            switchLine=@"0007";
            break;
        case 9:
            switchLine=@"0008";
            break;
        case 10:
            switchLine=@"0009";
            break;
        case 11:
            switchLine=@"000a";
            break;
        case 12:
            switchLine=@"000b";
            break;
        case 13:
            switchLine=@"000c";
            break;
        case 14:
            switchLine=@"000d";
            break;
        case 15:
            switchLine=@"000e";
            break;
        case 16:
            switchLine=@"000f";
            break;
            
        default:
            break;
    }

    NSString *queryId=[NSString stringWithFormat:@"%ld",(long)modal._id];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"querySwitch" object:queryId];
    
        NSString *str1=@"CDB8B4AB";
        NSString *str2=[modal.switchAddr stringByAppendingString:switchLine];
        NSString *str3=@"020F";
        NSString *sendStr=[[str1 stringByAppendingString:str2] stringByAppendingString:str3];

    self.sendCode=[str1 stringByAppendingString:modal.switchAddr];
    
    NSString *str=[self.currentMachineCode stringByAppendingString:sendStr];
    [socketServe sendMessage:str];
      [playSound play];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    
    

}


-(void)switchQuery:(long)switchId{
    
    SwitchModal *modal=[SwitchModal new];
    modal=[DatabaseOperation querySwitch:switchId/100];
    NSString *switchLine;
    switch (modal.switchLine) {
        case 1:
            switchLine=@"0000";
            break;
        case 2:
            switchLine=@"0001";
            break;
        case 3:
            switchLine=@"0002";
            break;
        case 4:
            switchLine=@"0003";
            break;
        case 5:
            switchLine=@"0004";
            break;
        case 6:
            switchLine=@"0005";
            break;
        case 7:
            switchLine=@"0006";
            break;
        case 8:
            switchLine=@"0007";
            break;
        case 9:
            switchLine=@"0008";
            break;
        case 10:
            switchLine=@"0009";
            break;
        case 11:
            switchLine=@"000a";
            break;
        case 12:
            switchLine=@"000b";
            break;
        case 13:
            switchLine=@"000c";
            break;
        case 14:
            switchLine=@"000d";
            break;
        case 15:
            switchLine=@"000e";
            break;
        case 16:
            switchLine=@"000f";
            break;
            
        default:
            break;
    }
    
    NSString *queryId=[NSString stringWithFormat:@"%ld",(long)modal._id];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"querySwitch" object:queryId];
    
    NSString *str1=@"CDB8B4AB";
    NSString *str2=[modal.switchAddr stringByAppendingString:switchLine];
    NSString *str3=@"020F";
    NSString *sendStr=[[str1 stringByAppendingString:str2] stringByAppendingString:str3];
    
    self.sendCode=[str1 stringByAppendingString:modal.switchAddr];
    
    
    
    

    NSString *str=[self.currentMachineCode stringByAppendingString:[self.sendCode stringByAppendingString:@"8686860F"]];
    
    [socketServe sendMessage:str];

    
    [playSound play];
    
    
    
    
}

-(void)clickSwitch:(NSNotification*) notification{
    
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSArray *array=notification.object;
        long line=[array[2] integerValue];
        NSString *switchLine;
        switch (line) {
            case 1:
                switchLine=@"0000";
                break;
            case 2:
                switchLine=@"0001";
                break;
            case 3:
                switchLine=@"0002";
                break;
            case 4:
                switchLine=@"0003";
                break;
            case 5:
                switchLine=@"0004";
                break;
            case 6:
                switchLine=@"0005";
                break;
            case 7:
                switchLine=@"0006";
                break;
            case 8:
                switchLine=@"0007";
                break;
            case 9:
                switchLine=@"0008";
                break;
            case 10:
                switchLine=@"0009";
                break;
            case 11:
                switchLine=@"000a";
                break;
            case 12:
                switchLine=@"000b";
                break;
            case 13:
                switchLine=@"000c";
                break;
            case 14:
                switchLine=@"000d";
                break;
            case 15:
                switchLine=@"000e";
                break;
            case 16:
                switchLine=@"000f";
                break;
                
            default:
                break;
        }
        
        
        NSString *queryId=array[0];
        NSString *switchAddr=array[1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"querySwitch" object:queryId];
        
        NSString *str1=@"CDB8B4AB";
        NSString *str2=[switchAddr stringByAppendingString:switchLine];
        NSString *str3=@"020F";
        NSString *sendStr=[[str1 stringByAppendingString:str2] stringByAppendingString:str3];
        
        self.sendCode=[str1 stringByAppendingString:switchAddr];
        
        NSString *str=[self.currentMachineCode stringByAppendingString:sendStr];
        [socketServe sendMessage:str];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.38 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
        
        
        
    });

    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
-(void)timerFired{
    
    NSString *str=[self.currentMachineCode stringByAppendingString:[self.sendCode stringByAppendingString:@"8686860F"]];
                  
    [socketServe sendMessage:str];

    [timer invalidate];
    //这行代码很关键
    timer=nil;
    
}

//编辑开关
-(void)editSwitch:(NSNotification*) notification{
    self.operationSwitchId=[notification.object integerValue];
    
    
    [CurrentTableName shared].operBtnState=@"switch";
    
    [self showAddBtnView:@"switch" btnId:self.operationSwitchId];
    
    

    
}

//删除开关
-(void)deleteCurrentSwitch:(NSNotification*) notification{
    self.operationSwitchId=[notification.object integerValue];
    
    BOOL delete=[DatabaseOperation deleteSwitch:self.operationSwitchId];
    
    if (delete) {
        NSLog(@"开关删除成功");
        NSString *message=@"开关删除成功";
        [self.view makeToast:message];
        [self loadMainViewControls:self.currentRoomId];
    }

    
}

-(void)swipeQuerySwith:(NSNotification*) notification{

    NSString *switchId=notification.object;
    
    SwitchModal *modal=[DatabaseOperation querySwitch:[switchId integerValue]/100];
    NSString *str1=@"CDB8B4AB";
   
   self.sendCode=[str1 stringByAppendingString:modal.switchAddr];
   
    
       NSString *str=[self.currentMachineCode stringByAppendingString:[self.sendCode stringByAppendingString:@"8686860F"]];
    
    [socketServe sendMessage:str];


}


//查询开关状态
-(void)querySwitchStatus:(NSString *)swithcLine switchAddr:(NSString *)swichAddr{
     NSLog(@"＊＊＊＊＊＊＊＊查询开关＊＊＊＊＊＊＊＊");
    NSString *str1=@"CDB8B4AB";
    NSString *str2=[swichAddr stringByAppendingString:swithcLine];
    NSString *str3=@"020F";
    NSString *sendStr=[[str1 stringByAppendingString:str2] stringByAppendingString:str3];
    self.sendCode=[str1 stringByAppendingString:swichAddr];

//    NSString *str=[self.currentMachineCode stringByAppendingString:sendStr];
//    [socketServe sendMessage:str];
    NSString *str=[self.currentMachineCode stringByAppendingString:[self.sendCode stringByAppendingString:@"8686860F"]];
    
    [socketServe sendMessage:str];
   // timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    

}


-(void)showStatusOfSwitch:(NSNotification*) notification{
    NSArray *array=notification.object;
     [_mainView showSwitchStatus:array[0] newStr:array[1] currentRoomId:self.currentRoomId];
  
    
}


#pragma mark 添加数值设备


-(void)addNumber:(NSString *)numberName numberAddr:(NSString *)numberAddr numberOne:(NSString *)numberOne tag:(long)tag numberTwo:(NSString *)numberTwo width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        
        long number_x=SCREEN_WIDTH/2;
        long number_y=SCREEN_HEIGHT/2;
        
        
        NumberModal *modal=[NumberModal numberModalWith:numberName numberAddr:numberAddr numberOne:numberOne numberTwo:numberTwo room_id:self.currentRoomId number_x:number_x number_y:number_y width:btnWidth.floatValue height:btnHeight.floatValue customSelect:customSelect _id:0];
        
        
        if (self.btnState==AddBtnState) {
            
//            if ([modal.numberName isEqualToString:@""]) {
//                NSString *message=@"请填写数值名字";
//                [self.view makeToast:message];
//            }else
            if ([modal.numberAddr isEqualToString:@""]){
                NSString *message=@"请填写数值地址";
                [self.view makeToast:message];
            }else if ([modal.numberOne isEqualToString:@""]){
                NSString *message=@"请填写数值一";
                [self.view makeToast:message];
            }else if ([modal.numberTwo isEqualToString:@""]){
                NSString *message=@"请填写数值二";
                [self.view makeToast:message];
            }else{
                BOOL isInsert=[DatabaseOperation insertNumberModal:modal];
                if (isInsert) {
                    NSLog(@"数值添加成功");
                    NSString *message=@"数值添加成功";
                    [self.view makeToast:message];
                    
                    
                    [self loadMainViewControls:self.currentRoomId];
                    
                    
                    //                        NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                    //                        [_mainView setcamera:modals];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                }else{
                    NSLog(@"数值添加失败");
                }
                
            }
        }else if (self.btnState==EditBtnState){
            
            BOOL modify=[DatabaseOperation modifyNumberData:modal numberId:self.operationNumberId];
            
            if (modify) {
                NSLog(@"数值更新成功");
                NSString *message=@"数值更新成功";
                [self.view makeToast:message];
                
                
                [self loadMainViewControls:self.currentRoomId];
                //                    NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                //
                //                    [_mainView setcamera:modals];
                
                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                
            }else{
                NSLog(@"按钮更新失败");
            }
            
            
            
            
            
        }
    }
    
    
}


//数值点击事件
-(void)numberClick:(long)numberId{
    
    NumberModal *modal=[NumberModal new];
    modal=[DatabaseOperation queryNumber:numberId/1000];
    NSString *str1=@"CDB8B4AB";
    
    NSString *str2=@"8686860F";
    NSString *sendStr=[[str1 stringByAppendingString:modal.numberAddr] stringByAppendingString:str2];
    
    NSString *str=[self.currentMachineCode stringByAppendingString:sendStr];
    [socketServe sendMessage:str];
    [playSound play];
  //  NSString *str=[self.currentMachineCode stringByAppendingString:@"CDB8B4AB1a2234481a8686860F"];
    
    
}
-(void)clickNumber:(NSNotification*) notification{
    
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *numAddr=notification.object;
        NSString *str1=@"CDB8B4AB";
        
        NSString *str2=@"8686860F";
        NSString *sendStr=[[str1 stringByAppendingString:numAddr] stringByAppendingString:str2];
        
        NSString *str=[self.currentMachineCode stringByAppendingString:sendStr];
        [socketServe sendMessage:str];

        
    });
    
    
}
//编辑数值
-(void)editNumber:(NSNotification*) notification{
    self.operationNumberId=[notification.object integerValue];
    
    
    [CurrentTableName shared].operBtnState=@"number";
    
    [self showAddBtnView:@"number" btnId:self.operationNumberId];
    
    
    
    
}

//删除数值
-(void)deleteCurrentNumber:(NSNotification*) notification{
    self.operationNumberId=[notification.object integerValue];
    
    BOOL delete=[DatabaseOperation deleteNumber:self.operationNumberId];
    
    if (delete) {
        NSLog(@"数值删除成功");
        NSString *message=@"数值删除成功";
        [self.view makeToast:message];
        [self loadMainViewControls:self.currentRoomId];
    }
    
    
}

//查询数值的value
-(void)queryNumberValue:(NSString *)numberAddr{
    
    NSLog(@"＊＊＊＊＊＊＊＊查询数值＊＊＊＊＊＊＊＊");
    
    NSString *str1=@"CDB8B4AB";
    
    NSString *str2=@"8686860F";
    NSString *sendStr=[[str1 stringByAppendingString:numberAddr] stringByAppendingString:str2];
    
    NSString *str=[self.currentMachineCode stringByAppendingString:sendStr];
     [socketServe sendMessage:str];
    
}


//数值状态
-(void)showStatusOfnumber:(NSNotification*) notification{
    NSArray *array=notification.object;
     [_mainView showNumberText1:array[0] color1:array[1] text2:array[2] color2:array[3] numberAddr:array[4]];
    
}
#pragma mark 添加IO设备
-(void)addIo:(NSString *)ioName tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect{
    
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        
        long io_x=SCREEN_WIDTH/2;
        long io_y=SCREEN_HEIGHT/2;
        
        
        IOModal *modal=[IOModal ioModalWith:ioName room_id:self.currentRoomId io_x:io_x io_y:io_y width:btnWidth.floatValue height:btnHeight.floatValue customSelect:customSelect _id:0];
        
        if (self.btnState==AddBtnState) {
            
//            if ([modal.ioName isEqualToString:@""]) {
//                NSString *message=@"请填写IO名字";
//                [self.view makeToast:message];
//            }else{
                BOOL isInsert=[DatabaseOperation insertIOModal:modal];
                if (isInsert) {
                    NSLog(@"IO添加成功");
                    NSString *message=@"IO添加成功";
                    [self.view makeToast:message];
                    
                    
                    [self loadMainViewControls:self.currentRoomId];
                    
                    
                    //                        NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                    //                        [_mainView setcamera:modals];
                    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                    
                }else{
                    NSLog(@"IO添加失败");
                }
                
            //}
        }else if (self.btnState==EditBtnState){
            
            BOOL modify=[DatabaseOperation modifyIoData:modal ioId:self.operationIOId];
           
            
            if (modify) {
                NSLog(@"IO更新成功");
                NSString *message=@"IO更新成功";
                [self.view makeToast:message];
                
                
                [self loadMainViewControls:self.currentRoomId];
                //                    NSArray *modals=[DatabaseOperation queryCameraData:self.currentRoomId];
                //
                //                    [_mainView setcamera:modals];
                
                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                
            }else{
                NSLog(@"按钮更新失败");
            }
            
            
            
            
            
        }
    }
    

    
    
    
    
}

//IO点击事件
-(void)IOClick:(long)ioId{
    
    NSString *str=[self.currentMachineCode stringByAppendingString:@"AB00003301"];
     [socketServe sendMessage:str];
      [playSound play];
    
}

-(void)clickIo:(NSNotification*) notification{
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *str=[self.currentMachineCode stringByAppendingString:@"AB00003301"];
        [socketServe sendMessage:str];
    });

    
   
    
}
//编辑IO
-(void)editIo:(NSNotification*) notification{
    self.operationIOId=[notification.object integerValue];
    
    
    [CurrentTableName shared].operBtnState=@"io";
    
    [self showAddBtnView:@"io" btnId:self.operationIOId];
    
    
    
    
}

//删除IO
-(void)deleteCurrentIo:(NSNotification*) notification{
    self.operationIOId=[notification.object integerValue];
    
    BOOL delete=[DatabaseOperation deleteIo:self.operationIOId];
    
    if (delete) {
        NSLog(@"io删除成功");
        NSString *message=@"io删除成功";
        [self.view makeToast:message];
        [self loadMainViewControls:self.currentRoomId];
    }
    
    
}




//查询io的value
-(void)queryIoVaule{
     NSLog(@"＊＊＊＊＊＊＊＊查询IO＊＊＊＊＊＊＊＊");
    NSString *str=[self.currentMachineCode stringByAppendingString:@"AB00003301"];
     [socketServe sendMessage:str];
}
//查询io状态
-(void)showStautsOfIo:(NSNotification*) notification{
    NSString *str=notification.object;
    [_mainView showIoStatus:str];
}



#pragma mark
-(void)timeClick{
    timeView=[[TimeViewController alloc]init];
    [self presentViewController:timeView animated:YES completion:nil];
    
    
}
//主机设置界面
-(void)showTimeView{
  
    
}

#pragma mark 日志
-(void)checkLog{
    logView=nil;
    logView=[[LogViewController alloc]init];
    logView.delegate=self;
    logView.hostId=self.currentHostId;
  [self presentPopupViewController:logView animationType:MJPopupViewAnimationFade];

}

-(void)openMessagePush{
    [self openFeedBack];
    [appDelegate.appDefault setObject:@"pushOpen" forKey:@"pushStatus"];
    
    NSString *message=@"您已经开启推送通知";
    [self.view makeToast:message];

   
}

-(void)closeMessagePush{
    
    [appDelegate.appDefault setObject:@"pushClose" forKey:@"pushStatus"];

    
    NSString *message=@"您已经关闭推送通知";
    [self.view makeToast:message];

}

-(void)setLog{
    pushKeyView=nil;
    pushKeyView=[[PushKeyViewController alloc]init];
    pushKeyView.delegate=self;
    [self presentPopupViewController:pushKeyView animationType:MJPopupViewAnimationFade];
    
    
}






#pragma mark  语音


#pragma mark - Button Action

- (void)setButtonUnenabledWithType:(int)type
{
    //	settingButton.enabled = NO;
    //	voiceRecognitionButton.enabled = NO;
    //    voiceRecognitionSDKUIButton.enabled = NO;
    
    //	switch (type)
    //	{
    //		case EDemoButtonTypeSetting:
    //		{
    ////			settingButton.enabled = YES;
    //			break;
    //		}
    //		case EDemoButtonTypeVoiceRecognition:
    //		{
    //			//voiceRecognitionButton.enabled = YES;
    //			break;
    //		}
    //        case EDemoButtonTypeSDKUI:
    //		{
    //			voiceRecognitionSDKUIButton.enabled = YES;
    //			break;
    //		}
    //		default:
    //			break;
    //	}
    
}
- (void)setAllButtonEnabled
{
    //	settingButton.enabled = YES;
    //	voiceRecognitionButton.enabled = YES;
}











-(void)stopVoiceClick{
    
    [self startCameraVoice];
}


-(void)VoiceClick{
    
   
    [self stopCameraVoice];
    
     NSString *voiceNick=[appDelegate.appDefault objectForKey:@"voiceNick"];//设置唤醒昵称
         if (voiceNick==nil) {
        
        
        //获取文件路径
        NSString * soundFilePath = [[NSBundle mainBundle] pathForResource:@"welcome_yy" ofType:@"mp3"];
        NSURL * fileURL = [NSURL fileURLWithPath: soundFilePath];
        
        //实例化播放器
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        
        
        player.delegate = self;
        if  (!player.playing){
            [player play];
            NSLog(@"播放成功！");
            NSLog(@"%f seconds played so  far",player.currentTime);
            
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"语音助手设置" message:@"请输入语音助手唤醒词" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            //[[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
            [dialog show];
        }
        else{
            
            [player pause];
            NSLog(@"播放暂停！");
        }
 
        
    
    }else{
    
    
    
    
    
    [self clean];
    
    // 设置开发者信息
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    // 设置语音识别模式，默认是输入模式
    [[BDVoiceRecognitionClient sharedInstance] setPropertyList:@[[BDVRSConfig sharedInstance].recognitionProperty]];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    [[BDVoiceRecognitionClient sharedInstance] setCityID: 1];
    
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:[BDVRSConfig sharedInstance].isNeedNLU];
    
    // 开启联系人识别
    //    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"enable_contacts" withFlag:YES];
    
    // 设置识别语言
    [[BDVoiceRecognitionClient sharedInstance] setLanguage:[BDVRSConfig sharedInstance].recognitionLanguage];
    
//    // 是否打开语音音量监听功能，可选
//    if ([BDVRSConfig sharedInstance].voiceLevelMeter)
//    {
//        BOOL res = [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
//        
//        if (res == NO)  // 如果监听失败，则恢复开关值
//        {
//            [BDVRSConfig sharedInstance].voiceLevelMeter = NO;
//        }
//    }
//    else
//    {
        [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
   // }
    
    // 设置播放开始说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:[BDVRSConfig sharedInstance].playStartMusicSwitch];
    // 设置播放结束说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:[BDVRSConfig sharedInstance].playEndMusicSwitch];
    
    // 创建语音识别界面，在其viewdidload方法中启动语音识别
    BDVRCustomRecognitonViewController *tmpAudioViewController = [[BDVRCustomRecognitonViewController alloc] initWithNibName:nil bundle:nil];
        tmpAudioViewController.delegate=self;
    tmpAudioViewController.clientSampleViewController = self;
    self.audioViewController = tmpAudioViewController;
        self.audioViewController.view.hidden=YES;
    [tmpAudioViewController release];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_audioViewController.view];
    
    
    
    
    
    

    }
    
}


- (void)fileReadThreadFunc
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString* recordFile = [bundle pathForResource:@"example_localRecord" ofType:@"pcm" inDirectory:nil];
    
    int hasReadFileSize = 0;
    
    // 每次向识别器发送的数据大小，建议不要超过4k，这里通过计算获得：采样率 * 时长 * 采样大小 / 压缩比
    // 其中采样率支持16000和8000，采样大小为16bit，压缩比为8，时长建议不要超过1s
    int sizeToRead = 16000 * 0.080 * 16 / 8;
    while (YES) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:recordFile];
        [fileHandle seekToFileOffset:hasReadFileSize];
        NSData* data = [fileHandle readDataOfLength:sizeToRead];
        [fileHandle closeFile];
        hasReadFileSize += [data length];
        if ([data length]>0)
        {
            [self.rawDataRecognizer sendDataToRecognizer:data];
        }
        else
        {
            [self.rawDataRecognizer allDataHasSent];
            break;
        }
    }
}



- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFinish:
        {
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
            {
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                for (int i=0; i<[audioResultData count]; i++)
                {
                    [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
                }
                //  self.resultView.text = nil;
                [self logOutToManualResut:tmpString];
                //[tmpString release];
            }
            else
            {
                // self.resultView.text = nil;
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                [self logOutToManualResut:tmpString];
            }
            [self logOutToLogView:@"识别完成"];
            break;
        }
        case EVoiceRecognitionClientWorkStatusFlushData:
        {
            NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
            
            [tmpString appendFormat:@"%@",[aObj objectAtIndex:0]];
            //  self.resultView.text = nil;
            [self logOutToManualResut:tmpString];
            // [tmpString release];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] == EVoiceRecognitionPropertyInput)
            {
                //                self.resultView.text = nil;
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                [self logOutToManualResut:tmpString];
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    
}

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    
}


#pragma mark - BDRecognizerViewDelegate

- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerView withResults:(NSArray *)aResults
{
    //_resultView.text = nil;
    
    if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
    {
        // 搜索模式下的结果为数组，示例为
        // ["公园", "公元"]
        NSMutableArray *audioResultData = (NSMutableArray *)aResults;
        
        
        NSLog(@"¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥我说话的结果%@",audioResultData);
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i=0; i < [audioResultData count]; i++)
        {
            [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
        }
        
        
        
        
        
        //        _resultView.text = [_resultView.text stringByAppendingString:tmpString];
        //        _resultView.text = [_resultView.text stringByAppendingString:@"\n"];
        
        [tmpString release];
    }
    else
    {
        // 输入模式下的结果为带置信度的结果，示例如下：
        //  [
        //      [
        //         {
        //             "百度" = "0.6055192947387695";
        //         },
        //         {
        //             "摆渡" = "0.3625582158565521";
        //         },
        //      ]
        //      [
        //         {
        //             "一下" = "0.7665404081344604";
        //         }
        //      ],
        //   ]
        //        NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aResults];
        //
        //        _resultView.text = [_resultView.text stringByAppendingString:tmpString];
        //        _resultView.text = [_resultView.text stringByAppendingString:@"\n"];
    }
    
    //语音结果查询
    for (NSString *str in aResults) {
        
        
        [DatabaseOperation queryVoiceKey:str hostId:self.currentHostId];
        
    }
  //  [self startCameraVoice];
   
}

#pragma mark - clean

- (void)clean
{
    //    _logCatView.text = nil; //  清除logview，避免打印过慢，影响UI
    //    _resultView.text = nil;// 清除result和_resultView，避免结果与log不对应
}

- (void)cleanResultViewAfter:(int)length
{
    //    _resultView.text = [_resultView.text substringToIndex:length];
}

#pragma mark - log & result

- (void)logOutToContinusManualResut:(NSString *)aResult
{
//    _resultView.text = aResult;
}
//
- (void)logOutToManualResut:(NSString *)aResult
{
//    NSString *tmpString = _resultView.text;
//
//    if (tmpString == nil || [tmpString isEqualToString:@""])
//    {
//        _resultView.text = aResult;
//    }
//    else
//    {
//        _resultView.text = [_resultView.text stringByAppendingString:aResult];
//    }
//}
//
//- (void)logOutToLogView:(NSString *)aLog
//{
//    NSString *tmpString = _logCatView.text;
//
//    if (tmpString == nil || [tmpString isEqualToString:@""])
//    {
//        _logCatView.text = aLog;
//    }
//    else
//    {
//        _logCatView.text = [_logCatView.text stringByAppendingFormat:@"\r\n%@", aLog];
//    }
}



#pragma mark 本地获取图片
-(void)uploadImgFromLocal{
    
    photoSelect=YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    
}



#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    
    
        photoSelect=NO;
}];
   
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *width=[NSString stringWithFormat:@"%f",image.size.width];
    NSString *height=[NSString stringWithFormat:@"%f",image.size.height];
    
    NSArray *array=[NSArray arrayWithObjects:width,height, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"iconFrame" object:array];
  
    
    NSDate* date = [NSDate date];//获取当前时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMSS"];
    NSString* timeString = [formatter stringFromDate:date];
    NSString *imgName=[timeString stringByAppendingString:@".png"];//时间戳命名图片
    
    NSLog(@"******************选取了照片***********************");
    if (self.displayState==DisplayRoomState){
        
         [addRoomView setImage:image];
        
    }else if (self.displayState==DisplayEditRoomState){
        
        [editRoomView setImage:image];
        
      
        
        [editEquiRomm setImage:image];
    }
   
    
    // 保存图片至本地
    [self saveImage:image withName:imgName];
    
    }
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    // 获取沙盒目录
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    
    
    if (self.displayState==DisplayBtnState) {
        self.button_icon=filePath;//获取按钮图片的路径
        
    }else if (self.displayState==DisplayRoomState||self.displayState==DisplayEditRoomState){
        
        self.room_background=filePath; //获取房间背景图片路径
        
    }
    
    [imageData writeToFile:filePath atomically:NO];
    
    
}

#pragma mark 其他
//拖动振动
-(void)btnShakeStart{
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    
    NSArray *btnModals=[DatabaseOperation queryButtonData:_currentRoomId];//房间内的按钮
    for(id obj in btnModals)
    {
        [newArray addObject: obj];
    }
    
    
    NSArray *cameraModals=[DatabaseOperation queryCameraData:_currentRoomId];//房间内的摄像头
    for(id obj in cameraModals)
    {
        [newArray addObject: obj];
    }
   
    
    NSArray *remoteModals=[DatabaseOperation queryRemoteData:self.currentRoomId];//房间内的遥控板
    for(id obj in remoteModals)
    {
        [newArray addObject: obj];
    }
    
    NSArray *switchModals=[DatabaseOperation querySwitchData:self.currentRoomId];//房间内的开关
    for(id obj in switchModals)
    {
        [newArray addObject: obj];
    }
    
    
    
    NSArray *numberModals=[DatabaseOperation queryNumbedrData:self.currentRoomId];//房间内的数值
    for(id obj in numberModals)
    {
        [newArray addObject: obj];
    }
    
    
    NSArray *ioModals=[DatabaseOperation queryIOData:self.currentRoomId];//房间内的io
    for(id obj in ioModals)
    {
        [newArray addObject: obj];
    }

     [[NSNotificationCenter defaultCenter] postNotificationName:@"allShake" object:newArray];
    
    
    
}


-(void)btnShakeStop{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    
    NSArray *btnModals=[DatabaseOperation queryButtonData:_currentRoomId];//房间内的按钮
    for(id obj in btnModals)
    {
        [newArray addObject: obj];
    }
    
    
    NSArray *cameraModals=[DatabaseOperation queryCameraData:_currentRoomId];//房间内的摄像头
    for(id obj in cameraModals)
    {
        [newArray addObject: obj];
    }
    
    
    NSArray *remoteModals=[DatabaseOperation queryRemoteData:self.currentRoomId];//房间内的遥控板
    for(id obj in remoteModals)
    {
        [newArray addObject: obj];
    }
    
    NSArray *switchModals=[DatabaseOperation querySwitchData:self.currentRoomId];//房间内的开关
    for(id obj in switchModals)
    {
        [newArray addObject: obj];
    }
    
    
    
    NSArray *numberModals=[DatabaseOperation queryNumbedrData:self.currentRoomId];//房间内的数值
    for(id obj in numberModals)
    {
        [newArray addObject: obj];
    }
    
    
    NSArray *ioModals=[DatabaseOperation queryIOData:self.currentRoomId];//房间内的io
    for(id obj in ioModals)
    {
        [newArray addObject: obj];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allStop" object:newArray];
    
    
    
    
}




//收到结果震动
-(void)voiceShake{
    [playSound play];
    
}
//展示网络连接图标
-(void)showNetIcon:(NSNotification*) notification{
    NSString *str=notification.object;
    hostIsConnect=YES;
    if ([str isEqualToString:@"wifi"]) {
        
        [_upView showNetConnectStatus:@"内网连接"];
    
    }else if ([str isEqualToString:@"wwan"]){
        [_upView showNetConnectStatus:@"互联网连接"];
    }
    
    [self getEnvironmentData];
}

-(void)netOff{
 
    [_upView showNetConnectStatus:@"连接断开"];
}

//检测socket连接
-(void)chekeSocket{
  //  [self getEnvironmentData];
    NSString *str=[self.currentMachineCode stringByAppendingString:@"AB00003301"];
    [socketServe sendMessage:str];

    //[[NSNotificationCenter defaultCenter] postNotificationName:@"haveRecive" object:nil];

    
    
}

//切换到外网连接
-(void)netChange{
    
    self.netStatus=@"wifiNet";
    [CurrentTableName shared].netStatus=@"wifiNet";

    
    HostModal *host=[DatabaseOperation queryHostData:self.currentHostId];
    socketServe = [LGSocketServe sharedSocketServe];
    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
    [socketServe cutOffSocket];
    socketServe.socket.userData = SocketOfflineByServer;
    [socketServe startConnectSocket:host.host_network port:host.network_port hostId:self.currentHostId];//连接主机
    NSLog(@"wifi已经切换到外网连接");
    
}
//网络连接
- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    
    if(![reach isReachable])
    {
        [CurrentTableName shared].netStatus=@"netOff";

         [_upView showNetConnectStatus:@"连接断开"];
    
    }else if ([reach isReachableViaWiFi]) {
        self.netStatus=@"wifi";
        [CurrentTableName shared].netStatus=@"wifi";
        NSLog( @"当前通过wifi连接,当前主机id:%ld",(long)self.currentHostId);
             [self connetHost];
    }else  if ([reach isReachableViaWWAN]) {
         self.netStatus=@"wwan";
        [CurrentTableName shared].netStatus=@"wwan";
        NSLog( @"当前通过GPRS连接,当前主机id:%ld",(long)self.currentHostId);
             [self connetHost];
      
    
    
    
    }
}

-(void)connetHost{
   
    if ([ [CurrentTableName shared].netStatus isEqualToString:@"wifi"]) {
        
        HostModal *host=[DatabaseOperation queryHostData:self.currentHostId];
        socketServe = [LGSocketServe sharedSocketServe];
        //socket连接前先断开连接以免之前socket连接没有断开导致闪退
        [socketServe cutOffSocket];
        socketServe.socket.userData = SocketOfflineByServer;
        [socketServe startConnectSocket:host.host_intranet port:host.intranet_port hostId:self.currentHostId];//连接主机

      
    
    }else{
        HostModal *host=[DatabaseOperation queryHostData:self.currentHostId];
        socketServe = [LGSocketServe sharedSocketServe];
        //socket连接前先断开连接以免之前socket连接没有断开导致闪退
        [socketServe cutOffSocket];
        socketServe.socket.userData = SocketOfflineByServer;
        [socketServe startConnectSocket:host.host_network port:host.network_port hostId:self.currentHostId];
        
        
    }
    
    
 }


-(void)reconnect{
    
    [self connetHost];
    
    
}
-(void)showVoiceStr:(NSString *)voiceStr{
    
    [_mainView showVoiceLabel:voiceStr];
    
}
// 好的(语音执行）
-(void)playOkVoice{
    
    
    // 获取文件路径
    NSString * soundFilePath = [[NSBundle mainBundle] pathForResource:@"ok" ofType:@"mp3"];
    NSURL * fileURL = [NSURL fileURLWithPath: soundFilePath];
    
    //实例化播放器
    player1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    
    player1.delegate = self;
    if  (!player1.playing){
        [player1 play];
        NSLog(@"播放成功！");
        NSLog(@"%f seconds played so  far",player1.currentTime);
        
    }
    else{
        
        [player1 pause];
        NSLog(@"播放暂停！");
    }
    
    
    
}
-(void)reopenVoice{
    [appDelegate.appDefault setObject:@"yes" forKey:@"findNick"];

    [self VoiceClick];
    
    
}
//语音唤醒词设置
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        //确认
        NSString *nickName=[alertView textFieldAtIndex:0].text;
        if ([nickName isEqualToString:@""]) {
            NSString *message=@"唤醒昵称不能为空";
            [self.view makeToast:message];
        }else{
            NSString *message=@"昵称设置成功";
            [self.view makeToast:message];
        [appDelegate.appDefault setObject:nickName forKey:@"voiceNick"];//设置唤醒昵称
   
        }
    }else if (buttonIndex==1){
       //取消
       
    }
    
    
    
}
//设防,撤防
-(void)defenseClick:(BOOL)Status{
    
    if (Status==YES) {
        NSString *str=[self.currentMachineCode stringByAppendingString:@"1100010001"];
        [socketServe sendMessage:str];
    }else{
        
        NSString *str=[self.currentMachineCode stringByAppendingString:@"1100010101"];
        [socketServe sendMessage:str];
   
    }
    
    
   

}

//点击查询温湿度
-(void)queryTempAndWet{
    
    [self getEnvironmentData];
    
}
//日志查看操作
-(void)logClick:(long)tag{
    if (tag==1) {
               
        
    }else if(tag==2){
        
        
      
        
        BOOL delete=[DatabaseOperation deleteLog:self.currentHostId];
        
        if (delete) {
            NSLog(@"日志清除成功");
            NSString *message=@"日志清除成功";
            [self.view makeToast:message];
        }else{
            NSString *message=@"日志清除失败";
            [self.view makeToast:message];
        }

        
        
        
        
        
       

    }

 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

}

//推送设置
-(void)settingPushkey:(NSDictionary *)data openPushKey:(NSString *)open tag:(long)tag{
    if (tag==1) {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"pushKey.plist"];
       
   
        [data writeToFile:filename atomically:YES];
        
        if ([open isEqualToString:@"YES"]) {
            NSString *message=@"您已经开启推送过滤";
            [self.view makeToast:message];

        }
        
        
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }
    
 
    
    
    
    
}
//模版数据查询点击（语音）
-(void)presetDataClick:(NSNotification*) notification{
    
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *netData=notification.object;
        NSArray *array=[netData componentsSeparatedByString:@" "];
        NSString *newData=[array componentsJoinedByString:@""];
        NSString *str=[self.currentMachineCode stringByAppendingString:newData];
        [socketServe sendMessage:str];

    });
    

    
    
    
    
    
}
//同步后数据查询点击（语音）
-(void)presetDataSynClick:(NSNotification*) notification{
    [self performSelector:@selector(playOkVoice) withObject:nil afterDelay:2.0f];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *netData=notification.object;
        NSArray *array=[netData componentsSeparatedByString:@" "];
        NSString *newData=[array componentsJoinedByString:@""];
        NSString *str=[self.currentMachineCode stringByAppendingString:newData];
        [socketServe sendMessage:str];

        
    });

    
    
    
    
}

//温湿度
-(void)showTemWet:(NSNotification*) notification{
    
    NSArray *array=notification.object;
    [_upView setTemperature:[array[0] integerValue] Wet:[array[1] integerValue]];
    
    NSString *defenseStr=array[2];
    [_upView loadDefenceStatus:defenseStr];
    
}
//停止摄像头
-(void)stopCameraShow{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraOpetate" object:nil];
    
}


-(void)stopCameraVoice{
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraVoice" object:nil];
   
}

-(void)startCameraVoice{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraOpenVoice" object:nil];
    
}
//-(void)startTalking{
//    
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"startTalking" object:nil];
//}




-(void)speekTouchBegin{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startTalking" object:nil];

    
}

-(void)speekTouchEnd{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endTalking" object:nil];

}
//切换房间（重加载）
-(void)loadMainViewControls:(long)currentRoomId{
    
    
    
    [self stopCameraShow];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSArray *views = [_mainView subviews];
        for(UIView* view in views)
        {
            
            [view removeFromSuperview];
            
        }

        [_mainView removeFromSuperview];
        _mainView=nil;
        [self.view addSubview:self.mainView];
        
        RoomModal *roomModal=[RoomModal new];
        roomModal=[DatabaseOperation queryRoom:currentRoomId hostId:self.currentHostId];
        
        
        [_mainView setBackgroundImg:roomModal.room_background];//加载房间背景图片
        NSArray *btnModals=[DatabaseOperation queryButtonData:roomModal._id];//房间内的按钮
        
        [_mainView setControlBtns:btnModals];
        NSArray *cameraModals=[DatabaseOperation queryCameraData:roomModal._id];
        
        [_mainView setcamera:cameraModals];
        
        NSArray *remoteModals=[DatabaseOperation queryRemoteData:roomModal._id];
        [_mainView setRomte:remoteModals];
        
        NSArray *switchModals=[DatabaseOperation querySwitchData:roomModal._id];
        [_mainView setSwitchBtns:switchModals];
        
        
        
        NSArray *numberModals=[DatabaseOperation queryNumbedrData:roomModal._id];
        [_mainView setNumberBtns:numberModals];
        
        
        NSArray *ioModals=[DatabaseOperation queryIOData:roomModal._id];
        [_mainView setIOBtns:ioModals];
        
        
        [self.view bringSubviewToFront:_upView];
        [self.view bringSubviewToFront:_bottomView];

    });
    
    
    
    
    
}


//获取数据数组
-(void)getPresetArr{
    [self.modalsPresetArrM removeAllObjects];
    NSArray *modals = [DatabaseOperation queryPreset:nil];
    [_modalsPresetArrM addObjectsFromArray:modals];
    
}

//查询 温度 湿度 设防
-(void)getEnvironmentData{
    
    NSString *testStr=@"3300000201";
    NSString *str=[self.currentMachineCode stringByAppendingString:testStr];
    [socketServe sendMessage:str];
    
}

//反馈设置
-(void)openFeedBack{
    
    NSString *testStr=@"44000001";
    NSString *str=[self.currentMachineCode stringByAppendingString:testStr];
    [socketServe sendMessage:str];
    
}

-(void)closeFeedBack{
    
    NSString *testStr=@"44000000";
    NSString *str=[self.currentMachineCode stringByAppendingString:testStr];
    [socketServe sendMessage:str];
    
    
}

//进度条
-(void)showProgressView{
    progressView=nil;
    progressView=[[PoppueProgressViewController alloc]init];
    progressView.delegate=self;
    [self presentPopupViewController:progressView animationType:MJPopupViewAnimationSlideBottomBottom];
    
}


//进度条（取消,确定）
-(void)showProgress:(long)tag{
    
    if (tag==1) {
        
        
          [CurrentTableName shared].hostIsSyn =@"sysNo";
        [self hostViewDisMiss];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
        
        
    }else if(tag==2){
        if (hostTimer) {
            
            [hostTimer invalidate];
            
            hostTimer=nil;
            
        }

        [self hostSyn:self.synchroId];
        
    }
    
    
}


#pragma UIImagePickerController(支持横屏）
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation ==  UIInterfaceOrientationLandscapeLeft || interfaceOrientation ==  UIInterfaceOrientationLandscapeRight );
}





-(NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate {
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
