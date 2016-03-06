//
//  AppDelegate.m
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseOperation.h"
#import "BDVRViewController.h"
#import "WelcomeViewController.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UMCheckUpdate.h"
#import "MobClick.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:@"56d6d18767e58e85e200075a" reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    
    
    //时间同步
    [self performSelector:@selector(timeCheck) withObject:nil afterDelay:25.0f];

//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    CFShow(CFBridgingRetain(infoDic));
//
//    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    long verson=[appVersion integerValue];
//    if (verson<) {
//        <#statements#>
//    }
#pragma mark 版本更新
      [UMCheckUpdate checkUpdate:@"更新" cancelButtonTitle:@"取消" otherButtonTitles:@"去更新" appkey:@"56d6d18767e58e85e200075a" channel:nil];

    
    
    
    
       
    
    
    
    
    //这样就获取到当前运行的app的版本了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
     [self autoKeyboard];//键盘自动适应
    
    
    appDelegate.appDefault = [NSUserDefaults standardUserDefaults];
    NSString *dataName=[appDelegate.appDefault objectForKey:@"dataName"];
    if (dataName==nil) {
        [DatabaseOperation createSqlite:@"sysdata.sqlite"];
    }else{
        [DatabaseOperation createSqlite:dataName];
    }
    
    
    
    
    
     [Camera initIOTC];
        //注册苹果的通知
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
        
   
    
    
    
    
       [appDelegate.appDefault setObject:@"first" forKey:@"pushStatus"];//推送默认开启
    

   [appDelegate.appDefault setObject:@"no" forKey:@"findNick"];//是否
    
    
     [appDelegate.appDefault setObject:@"no" forKey:@"wakeUp"]; //语音助手是否唤醒
    
    
    
    
//播放欢迎语音
    NSString *voicePlay=[appDelegate.appDefault objectForKey:@"welcomeVoice"];//获取是否第一次运行app（欢迎音乐）
   
    

    if (![voicePlay isEqualToString:@"played"]) {
        //获取文件路径
       NSString * soundFilePath = [[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"mp3"];
        NSURL * fileURL = [NSURL fileURLWithPath: soundFilePath];
       
        //实例化播放器
         AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
       
        
        player.delegate = self;
        if  (!player.playing){
            [player play];
            NSLog(@"播放成功！");
            NSLog(@"%f seconds played so  far",player.currentTime);
        }
        else{
            
            [player pause];
            NSLog(@"播放暂停！"); 
        }
   
    
    }
    
    
    
    
    NSString *appStatus=[appDelegate.appDefault objectForKey:@"appStatus"];//获取是否成功进入主菜单
    NSString *passwordStatus=[appDelegate.appDefault objectForKey:@"passwordStatus"];//获取是否设置密码

    
//    if ([appStatus isEqualToString:@"notFirst"]) {
//        if ([passwordStatus isEqualToString:@"close"]||passwordStatus==nil) {
            MainViewController *mainVC=[[MainViewController alloc]init];
            self.window.rootViewController=mainVC;
//        }else{
//            WelcomeViewController *welcomVC=[[WelcomeViewController alloc]init];
//            self.window.rootViewController=welcomVC;
//
//        }
//        
//    }else{
//    
//    WelcomeViewController *welcomVC=[[WelcomeViewController alloc]init];
//    self.window.rootViewController=welcomVC;
//    
//    }
    

    
    
#pragma mark 网络判断
      
    
    
    
    return YES;
}

- (void)tik{
    
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0)
    {
        [self longTimeTask];
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    
}
- (void)longTimeTask
{
    
    
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"SlientAudio" ofType:@"wav"]; //创建音乐文件路径
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];
    
    if (_myBackMusic == nil)
    {
        AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        //创建播放器
        self.myBackMusic = thePlayer; //赋值给自己定义的类变量
    }
    [self.myBackMusic prepareToPlay];
    //[self.myBackMusic setVolume:1]; //设置音量大小
    // thePlayer.numberOfLoops = -1;//设置音乐播放次数 -1为一直循环
    [self.myBackMusic play]; //播放
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"holdCamera" object:nil];
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)volumeChanged:(NSNotification *)notification
{
    float volume =
    [[[notification userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    
    NSLog(@"current volume = %f", volume);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"进入后台");
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(tik) userInfo:nil repeats:YES];

    NSString *message=@"播放无声音频";
   // [self localNotify:message];

    
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //取消所有通知
    [application cancelAllLocalNotifications];
    
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // 直接打开app时，图标上的数字清零
    
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [Camera uninitIOTC];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskAll;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
        //取消通知
    for (UILocalNotification *noti in [application scheduledLocalNotifications]) {
        NSString *notiID = [noti.userInfo objectForKey:@"nfkey"];
        if ([notiID isEqualToString:@"notification"]) {
            [application cancelLocalNotification:noti];
        }
    }}

#pragma mark 键盘自动适应
-(void)autoKeyboard{
    
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:0];
    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
    
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //Giving permission to modify TextView's frame
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    
}
-(void)localNotify:(NSString *)content{
    
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:0.2];
        // 设置提醒的文字内容
        notification.alertBody   = content;
        notification.alertAction = NSLocalizedString(@"查看", nil);
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
        [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
        // 设定通知的userInfo，用来标识该通知
        
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"notification",@"nfkey",nil];
        [notification setUserInfo:dict];
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    
    
}

-(void)timeCheck{
    
    [self setClockNotify];
    [NSTimer scheduledTimerWithTimeInterval:86400 target:self selector:@selector(setClockNotify) userInfo:nil repeats:YES];

    
}
-(void)setClockNotify{
    //获取日期
   
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    int hour=[comps hour];
    int minute=[comps minute];
    int second=[comps second];
    
    NSString *weekStr;
    if(week==1)
    {
        weekStr=@"07";//星期天
    }else if(week==2){
        weekStr=@"01";//星期一
        
    }else if(week==3){
        weekStr=@"02";//星期二
        
    }else if(week==4){
        weekStr=@"03";//星期三
        
    }else if(week==5){
        weekStr=@"04";//星期四
        
    }else if(week==6){
        weekStr=@"05";//星期五
        
    }else if(week==7){
        weekStr=@"06";//星期六
        
    }
    else {
        NSLog(@"error!");
    }
    
    int allYear=[[[NSString stringWithFormat:@"%d",year] substringFromIndex:2] integerValue];
    
    NSString *sixYear=[self tenToSixteen:allYear];
    NSString *sixMouth=[self tenToSixteen:month];
    NSString *sixDay=[self tenToSixteen:day];
    NSString *sixHour=[self tenToSixteen:hour];
    NSString *sixMimute=[self tenToSixteen:minute];
    NSString *sixSecond=[self tenToSixteen:second];

    
     NSLog(@"16进制 ：：：：：%@年%@月%@号%@点%@分%@秒 %@",sixYear,sixMouth,sixDay,sixHour,sixMimute,sixSecond,weekStr);
    
    
    NSString *headStr=@"F0BB7852";
    NSString *dateStr=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",sixHour,sixMimute,sixSecond,sixYear,sixMouth,sixDay,weekStr];
    NSString *footStr=@"23E8";
    NSString *compStr=[NSString stringWithFormat:@"%@%@%@",headStr,dateStr,footStr];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeCheck" object:compStr];

    
    
    
    
    
    
    NSLog(@"%d年%d月%d号%d点%d分%d秒 %d",year,month,day,hour,minute,second,week);
}


-(NSString *)tenToSixteen:(int)ten{
    
    
    
    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",ten]];
    if (hexString.length<2) {
        hexString=[NSString stringWithFormat:@"0%@",hexString];
    }
    return hexString.uppercaseString;
}


@end
