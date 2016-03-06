//
//  MainViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomView.h"
#import "MainView.h"
#import "PoppueSettingController.h"
#import "PoppueAddRoomViewController.h"
#import "PoppueProgressViewController.h"
#import "PoppupBtnController.h"
#import "AddHostViewController.h"
#import "RoomModal.h"
#import "HostModal.h"
#import "ButtonModal.h"
#import "QuickButton.h"
#import "CameraModal.h"
#import "SwitchModal.h"
#import "NumberModal.h"
#import "IOModal.h"
#import "LogModal.h"
#import "LGSocketServe.h"
#import "UpView.h"
#import "AddButtonView.h"
#import "AsyncSocket.h"
#import "QRCodeReaderDelegate.h"
#import "RemoteBtnViewController.h"
#import "PoppueLockViewController.h"
#import "LogViewController.h"
#import "PushKeyViewController.h"

#import "RoomEditViewController.h"
#import "EditEquiRoomViewController.h"

#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRFileRecognizer.h"
#import "BDVRDataUploader.h"
#import "AppDelegate.h"
#import "BDVRCustomRecognitonViewController.h"
#import "MsgPlaySound.h"
#import "LocalFileViewController.h"
#import "TimeViewController.h"
//// 枚举
//enum TDemoButtonType
//{
//    EDemoButtonTypeSetting = 0,
//    EDemoButtonTypeVoiceRecognition,
//    EDemoButtonTypeSDKUI
//};

@class BDVRCustomRecognitonViewController;

typedef enum {
    DisplayRoomState, //添加房间浏览
    DisplayBtnState,//添加按钮浏览
    DisplayEditRoomState,
}DisplayImgState;

typedef enum {
    AddHostState, //添加主机
    EditHostState,//编辑主机
}HostState;
typedef enum {
    AddBtnState, //添加按钮
    EditBtnState,//编辑按钮
}ButtonState;
typedef enum {
    AddRoomState, //添加房间
    EditRoomState,//编辑房间
}RoomState;


typedef enum {
    sychoState, //同步状态
    btnClickState,

}SocketState;




@interface MainViewController : UIViewController<bottomDelegate,popHostSettinglDelegate,popAddHostlDelegate,popAddRoomlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,upDelegate,addButtonViewDelegate,mainViewDelegate,showProgressViewDelegate,QRCodeReaderDelegate,editRemoteViewDelegate,BDRecognizerViewDelegate, MVoiceRecognitionClientDelegate, BDVRDataUploaderDelegate,roomEditDelegate,roomEquiEditDelegate,pushKeyDelegate,logDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,cutomerDelegate,localFileDelegate>
{
    PoppueSettingController *settingView; //后台设置
    PoppueAddRoomViewController *addRoomView;//添加房间
    RoomEditViewController *editRoomView;//编辑房间
    EditEquiRoomViewController *editEquiRomm;//编辑设备分组房间
    PoppueProgressViewController *progressView;//进度条
    AddHostViewController *addHostView; //添加主机
    PoppupBtnController *addBtnView;//添加按钮
    PoppueLockViewController *lockScreenView;//锁屏
    RemoteBtnViewController *remoteBtnView;//编辑遥控btnView
    TimeViewController *timeView;
    LogViewController *logView;
    PushKeyViewController *pushKeyView;
    AsyncSocket *client;//实例化socket
    float progress;//进度条value
    LGSocketServe *socketServe;
    NSTimer *timer;
    //AVAudioPlayer *player;
     AVAudioPlayer *player1;
    MsgPlaySound *playSound;
    BOOL countChange;
    NSTimer *hostTimer;
    BOOL hostIsConnect;
    BOOL isHostSelect;
    BOOL photoSelect;
}





/*主机*/
@property(nonatomic,assign)NSInteger currentHostId; //当前主机ID
@property(nonatomic,assign)long editHostId; //编辑主机ID
@property(nonatomic,strong)NSString *currentMachineCode; //当前机器码
@property(nonatomic,assign)long synchroId;//同步主机ID
@property(nonatomic,strong)NSString *synJudgeStr;
/*房间*/
@property(nonatomic,assign)int room_icon;//设备分组房间图标
@property(nonatomic,strong)NSString *room_background;  //房间背景图片路径
@property(nonatomic,assign)NSInteger currentRoomId; //当前主机ID
@property(nonatomic,assign)long firstRoomId;//第一个房间Id
@property(nonatomic,assign)long operationRoomId;//当前操作的房间id
@property(nonatomic,strong)NSString *editState;


/*按钮*/
@property(nonatomic,strong)NSString *button_icon;//按钮图标路径
@property(nonatomic,assign)int button_x;//按钮x坐标
@property(nonatomic,assign)int button_y;//按钮y坐标
@property(nonatomic,assign)long operationBtnId;//当前操作的按钮id
@property(nonatomic,assign)long operationQuickId;//当前操作的按钮id
@property(nonatomic,assign)long operationCameraId;//当前操作的按钮id
@property(nonatomic,assign)long operationReBtnId;//当前操作的遥控按钮id
@property(nonatomic,assign)long operationSwitchId;//当前操作的开关按钮id
@property(nonatomic,assign)long operationNumberId;//当前操作的数值按钮id
@property(nonatomic,assign)long operationIOId;//当前操作的IO按钮id
@property(nonatomic,assign)long currentRemoteId;//当前遥控板id


/*弹出式图*/
@property(nonatomic,assign)int displayState; //弹出视图（浏览）
@property(nonatomic,assign)int hostState;//弹出视图(确定,取消)
@property(nonatomic,assign)int btnState;//弹出视图(确定,取消)
@property(nonatomic,assign)int roomState;//弹出视图(确定,取消)



@property(nonatomic,assign)int socketState;//弹出视图(socket状态)


/*数据源*/
@property (nonatomic, strong) NSMutableArray *modalsHostArrM;
@property(nonatomic,strong)NSMutableArray *modalsPresetArrM;
@property(nonatomic,assign)long counting;
@property(nonatomic,assign)long checkCount;


@property (nonatomic, retain) BDVRCustomRecognitonViewController *audioViewController;

@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
@property (nonatomic, retain) BDVRRawDataRecognizer *rawDataRecognizer;
@property (nonatomic, retain) BDVRFileRecognizer *fileRecognizer;
@property (nonatomic, retain) BDVRDataUploader *contactsUploader;
@property(nonatomic,strong)NSString *sendCode;

@property (nonatomic, strong) Reachability *conn;

@property(nonatomic,strong)NSString *netStatus;
// --log & result
- (void)logOutToContinusManualResut:(NSString *)aResult;
- (void)logOutToManualResut:(NSString *)aResult;
- (void)logOutToLogView:(NSString *)aLog;




//@property (strong, nonatomic) IBOutlet UIView *customRemoteView;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteUp;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteDown;
//
//
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteLeft;
//
//
//
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteRight;
//
//
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteOk;
//
//
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteBtn1;
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteBtn2;
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteBtn3;
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteBtn4;
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteBtn5;
//
//@property (weak, nonatomic) IBOutlet UIButton *remoteBtn6;




- (IBAction)circleClick:(UIButton *)sender;


- (IBAction)menuClick:(UIButton *)sender;






@end
