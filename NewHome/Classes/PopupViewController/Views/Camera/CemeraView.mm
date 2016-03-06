//
//  CemeraView.m
//  IntelligentHome
//
//  Created by 小热狗 on 15/4/16.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "CemeraView.h"
#import <IOTCamera/AVFRAMEINFO.h>
#import <IOTCamera/ImageBuffInfo.h>
#import <sys/time.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define TimeOut	10.0f
#define Bottom_height 35
unsigned int _getTickCount() {
    
    struct timeval tv;
    
    if (gettimeofday(&tv, NULL) != 0)
        return 0;
    
    return (tv.tv_sec * 1000 + tv.tv_usec / 1000);
}



@implementation CemeraView






-(id)initWithFrame:(CGRect)frame cameraUid:(NSString *)uid userName:(NSString *)userName passWord:(NSString *)password
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
       
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cameraOper) name: @"cameraOpetate" object: nil];
        
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cameraVoice) name: @"cameraVoice" object: nil];
         //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startTalking) name: @"startTalking" object: nil];
         //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(endTalking) name: @"startTalking" object: nil];
        
     [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cameraOpenVoice) name: @"cameraOpenVoice" object: nil];
        
        loadingViewPortrait=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((frame.size.width-5*frame.size.height/18)/2, (5*frame.size.height/6-5*frame.size.height/18)/2, 5*frame.size.height/18, 5*frame.size.height/18)];
        
        [self addSubview:loadingViewPortrait];
        [loadingViewPortrait setHidden:NO];
        [loadingViewPortrait startAnimating];
        
        
        alertLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (5*frame.size.height/6-5*frame.size.height/18)/2, frame.size.width-20, 5*frame.size.height/18)];
        alertLabel.textAlignment=NSTextAlignmentCenter;
        alertLabel.textColor=[UIColor whiteColor];
        alertLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:alertLabel];
        alertLabel.hidden=YES;
        
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-Bottom_height, self.frame.size.width, Bottom_height)];
        bottomView.backgroundColor=RGBACOLOR(51.0, 204.0, 255.0, 1);
        float btn_width=bottomView.frame.size.width/3;
        float btn_height=Bottom_height;
        
        
        UIButton *listenBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        listenBtn.tag=1;
        listenBtn.frame=CGRectMake(0, 0, btn_width, btn_height);
        [listenBtn setBackgroundImage:[UIImage imageNamed:@"监听4"] forState:UIControlStateNormal];

        [listenBtn setBackgroundImage:[UIImage imageNamed:@"监听1选中"] forState:UIControlStateHighlighted];
        [listenBtn addTarget:self action:@selector(cameraOpenVoice) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:listenBtn];
        
        UIButton *talkBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        talkBtn.frame=CGRectMake(btn_width, 0, btn_width, btn_height);
        talkBtn.tag=2;
//        [talkBtn addTarget:self action:@selector(startTalking) forControlEvents:UIControlEventTouchDown];
//
//        [talkBtn addTarget:self action:@selector(endTalking) forControlEvents:UIControlEventTouchUpInside];
//        [talkBtn addTarget:self action:@selector(endTalking) forControlEvents:UIControlEventTouchUpOutside];
        
        
        [talkBtn setBackgroundImage:[UIImage imageNamed:@"对讲1选中"] forState:UIControlStateHighlighted];

        [talkBtn setBackgroundImage:[UIImage imageNamed:@"对讲4"] forState:UIControlStateNormal];
        [bottomView addSubview:talkBtn];
        
                 UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(speekLongPress:)];
                longPress.delegate = self;
        
               [talkBtn addGestureRecognizer:longPress];
        
        
        
        UIButton *muteBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        muteBtn.frame=CGRectMake(2*btn_width, 0, btn_width, btn_height);
        muteBtn.tag=3;
        [muteBtn addTarget:self action:@selector(cameraVoice) forControlEvents:UIControlEventTouchUpInside];
        [muteBtn setBackgroundImage:[UIImage imageNamed:@"静音4"] forState:UIControlStateNormal];
        
        [muteBtn setBackgroundImage:[UIImage imageNamed:@"静音1选中"] forState:UIControlStateHighlighted];
        [bottomView addSubview:muteBtn];

        
        [self addSubview:bottomView];
         cameraTimer =[NSTimer scheduledTimerWithTimeInterval:TimeOut target:self selector:@selector(cameraTimeOut) userInfo:nil repeats:YES];
        
        isListening = NO;
        isTalking = NO;
        
//            CemeraView *view = (CemeraView *)[[NSBundle mainBundle] loadNibNamed:@"CameraView" owner:nil options:nil][0];
//            view.frame = frame;
        
        _camera=[[Camera alloc]init];
        [_camera setDelegate:self];
        [_camera connect:uid];
        [_camera start:0 viewAccount:userName viewPassword:password is_playback:FALSE];
        
        [_camera startShow:0 ScreenObject:self];
        
        [_camera startSoundToPhone:0];
        
        
        
        SMsgAVIoctrlGetAudioOutFormatReq *s = (SMsgAVIoctrlGetAudioOutFormatReq *)malloc(sizeof(SMsgAVIoctrlGetAudioOutFormatReq));
        s->channel = 0;
        [_camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ Data:(char *)s DataSize:sizeof(SMsgAVIoctrlGetAudioOutFormatReq)];
        free(s);
        
        SMsgAVIoctrlGetSupportStreamReq *s2 = (SMsgAVIoctrlGetSupportStreamReq *)malloc(sizeof(SMsgAVIoctrlGetSupportStreamReq));
        [_camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETSUPPORTSTREAM_REQ Data:(char *)s2 DataSize:sizeof(SMsgAVIoctrlGetSupportStreamReq)];
        free(s2);
        
        SMsgAVIoctrlTimeZone s3={0};
        s3.cbSize = sizeof(s3);
        [_camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GET_TIMEZONE_REQ Data:(char *)&s3 DataSize:sizeof(s3)];

        
       // [_camera startSoundToDevice:0];
        
        self.userInteractionEnabled=YES;
        _monitor=[[Monitor alloc]initWithFrame:CGRectMake(1, 1, frame.size.width-2,frame.size.height-Bottom_height-2)];
        
        [self addSubview:_monitor];
        [_monitor attachCamera:_camera];
        
        
        [self removeGLView:TRUE];
        NSLog( @"video frame {%d,%d}%dx%d", (int)self.monitor.frame.origin.x, (int)self.monitor.frame.origin.y, (int)self.monitor.frame.size.width, (int)self.monitor.frame.size.height);
        if( _glView == nil ) {
            _glView = [[CameraShowGLView alloc] initWithFrame:self.monitor.frame];
            [_glView setMinimumGestureLength:100 MaximumVariance:50];
            _glView.delegate = self;
            [_glView attachCamera:_camera];
        }
        else {
            [self.glView destroyFramebuffer];
            self.glView.frame = self.monitor.frame;
        }
        [self addSubview:_glView];
        
        if( _mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
            [self bringSubviewToFront:_monitor/*self.glView*/];
        }
        else {
            [self bringSubviewToFront:/*monitor*/self.glView];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cameraStopShowCompleted:) name: @"CameraStopShowCompleted" object: nil];
        
        
        
        
        
        
        
        
        
        
    }
    
    return self;
}


-(void)cameraTimeOut{
    
    [self cameraOper];
        [loadingViewPortrait stopAnimating];
   

    alertLabel.hidden=NO;
    alertLabel.text=@"网络超时...";

    [cameraTimer invalidate];
    cameraTimer = nil;




}
-(void)speekLongPress:(UILongPressGestureRecognizer *)sender

{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"长按");
        [self startTalking];
    }else if (sender.state == UIGestureRecognizerStateEnded){
        
        NSLog(@"放开");
       [self endTalking];
    }
    
}
//静音
-(void)cameraVoice{
    _selectedAudioMode = AUDIO_MODE_OFF;
    [_camera stopSoundToPhone:0];
    [self unactiveAudioSession];
    
    isListening = NO;

}
//监听
-(void)cameraOpenVoice{
    _selectedAudioMode = AUDIO_MODE_SPEAKER;
    [self activeAudioSession];
    [_camera startSoundToPhone:0];
    
    isListening = YES;

}
//说话
-(void)startTalking{
    isTalking = YES;
    _selectedAudioMode = AUDIO_MODE_MICROPHONE;
    [_camera stopSoundToPhone:0];
    
    [self unactiveAudioSession];
    [self activeAudioSession];
    [_camera startSoundToDevice:0];
}
//放开
-(void)endTalking{
    if (isTalking){
        [_camera stopSoundToDevice:0];
        isTalking = NO;
        
        _selectedAudioMode = AUDIO_MODE_SPEAKER;
        [self unactiveAudioSession];
        [self activeAudioSession];
        [_camera startSoundToPhone:0];
    }
    
}
-(void)cameraOper{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

        // 该干嘛就干嘛
        NSLog(@"***********************我正在执行***************************");
        [self cameraDisconnect];
        
        [self.glView destroyFramebuffer];
        [_glView removeFromSuperview];
        [_monitor removeFromSuperview];
        _camera=nil;
        
        [_camera stopShow:0];
        [_camera stop:0];
        [_camera disconnect];
   
    
    
}
//-(void)loadCameraView{
//
//
//        _camera=[[Camera alloc]init];
//        [_camera setDelegate:self];
//        [_camera connect:@"FXSS88FYJPRRUNPWMRDJ"];
//        [_camera start:0 viewAccount:@"admin" viewPassword:@"47592" is_playback:FALSE];
//
//        [_camera startShow:0 ScreenObject:self];
//
//        //[camera startSoundToPhone:0];
//
//
//    _monitor=[[Monitor alloc]init];
//        [_monitor attachCamera:_camera];
//
//
//        [self removeGLView:TRUE];
//        NSLog( @"video frame {%d,%d}%dx%d", (int)self.monitor.frame.origin.x, (int)self.monitor.frame.origin.y, (int)self.monitor.frame.size.width, (int)self.monitor.frame.size.height);
//        if( _glView == nil ) {
//            _glView = [[CameraShowGLView alloc] initWithFrame:self.monitor.frame];
//            [_glView setMinimumGestureLength:100 MaximumVariance:50];
//            _glView.delegate = self;
//            [_glView attachCamera:_camera];
//        }
//        else {
//            [self.glView destroyFramebuffer];
//            self.glView.frame = self.monitor.frame;
//        }
//        [self addSubview:_glView];
//
//        if( _mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
//            [self bringSubviewToFront:_monitor/*self.glView*/];
//        }
//        else {
//            [self bringSubviewToFront:/*monitor*/self.glView];
//        }
//
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(cameraStopShowCompleted:) name: @"CameraStopShowCompleted" object: nil];
//
//
//
//
//
//}
//











-(void)stopCamera{
    
//    _camera=[[Camera alloc]init];
//    [_camera setDelegate:self];
//    [_camera stopShow:0];
    
//    [_camera startSoundToDevice:0];
//    [_camera startSoundToPhone:0];
//    
//    [_monitor deattachCamera];
//    _monitor = nil;
//    
//    [_camera stopSoundToPhone:0];
//    [_camera stopShow:0];
//    //        [self waitStopShowCompleted:DEF_WAIT4STOPSHOW_TIME];
//    [_camera stop:0];
//    [_camera disconnect];
//    [_camera setDelegate:nil];
//    _camera = nil;
    
   
}
-(void)dealloc {
   }
- (void)cameraDisconnect
{
    @synchronized(self)
    {
        if (_camera)
        {
            [_monitor deattachCamera];
            _monitor = nil;
            
            [_camera stopSoundToPhone:0];
            [_camera stopShow:0];
            //        [self waitStopShowCompleted:DEF_WAIT4STOPSHOW_TIME];
            [_camera stop:0];
            [_camera disconnect];
            [_camera setDelegate:nil];
            _camera = nil;
            
            //_toastLabel = nil;
            
            if (_glView)
            {
                [_glView tearDownGL];
            }
            
            CVPixelBufferRelease(_mPixelBuffer);
            CVPixelBufferPoolRelease(_mPixelBufferPool);
            
            [self removeGLView:YES];
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Camera Delegate
- (void)camera:(Camera *)camera didChangeChannelStatus:(NSInteger)channel ChannelStatus:(NSInteger)status
{
    switch (status) {
        case CONNECTION_STATE_CONNECTED:
            break;
            
        case CONNECTION_STATE_CONNECTING:
            break;
            
        case CONNECTION_STATE_DISCONNECTED:
            break;
            
        case CONNECTION_STATE_CONNECT_FAILED:
            break;
            
        case CONNECTION_STATE_TIMEOUT:
            break;
            
        case CONNECTION_STATE_UNKNOWN_DEVICE:
            break;
            
        case CONNECTION_STATE_UNSUPPORTED:
            break;
            
        case CONNECTION_STATE_WRONG_PASSWORD:
            break;
            
        default:
            break;
    }
}

- (void)camera:(Camera *)camera didChangeSessionStatus:(NSInteger)status
{
    switch (status) {
        case CONNECTION_STATE_CONNECTED:
            break;
            
        case CONNECTION_STATE_CONNECTING:
            break;
            
        case CONNECTION_STATE_DISCONNECTED:
            break;
            
        case CONNECTION_STATE_CONNECT_FAILED:
            break;
            
        case CONNECTION_STATE_TIMEOUT:
            break;
            
        case CONNECTION_STATE_UNKNOWN_DEVICE:
            break;
            
        case CONNECTION_STATE_UNSUPPORTED:
            break;
            
        case CONNECTION_STATE_WRONG_PASSWORD:
            break;
            
        default:
            break;
    }
}

- (void)camera:(Camera *)camera didReceiveFrameInfoWithVideoWidth:(NSInteger)videoWidth VideoHeight:(NSInteger)videoHeight VideoFPS:(NSInteger)fps VideoBPS:(NSInteger)videoBps AudioBPS:(NSInteger)audioBps OnlineNm:(NSInteger)onlineNm FrameCount:(unsigned long)frameCount IncompleteFrameCount:(unsigned long)incompleteFrameCount
{
    
}

- (void)camera:(Camera *)camera didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    if (type == IOTYPE_USER_IPCAM_GETSTREAMCTRL_RESP) {
        /* do something you want */
    }
    
    /* ... */
}

- (void)camera:(Camera *)camera didReceiveJPEGDataFrame:(const char *)imgData DataSize:(NSInteger)size
{
        /*
     * You may use the code snippet as below to get an image.
     
     NSData *data = [NSData dataWithBytes:imgData length:size];
     self.image = [UIImage imageWithData:data];
     
     */
}

- (void)camera:(Camera *)camera didReceiveRawDataFrame:(const char *)imgData VideoWidth:(NSInteger)width VideoHeight:(NSInteger)height
{
    /* You may use the code snippet as below to get an image. */
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgData, width * height * 3, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = CGImageCreate(width, height, 8, 24, width * 3, colorSpace, kCGBitmapByteOrderDefault, provider, NULL, true,  kCGRenderingIntentDefault);
    
    UIImage *img = [[UIImage alloc] initWithCGImage:imgRef];
    
    [cameraTimer invalidate];
    cameraTimer = nil;
    [loadingViewPortrait stopAnimating];

    /* Set "img" to your own image object. */
    // self.image = img;
    
    
    
    if (imgRef != nil) {
        CGImageRelease(imgRef);
        imgRef = nil;
    }
    
    if (colorSpace != nil) {
        CGColorSpaceRelease(colorSpace);
        colorSpace = nil;
    }
    
    if (provider != nil) {
        CGDataProviderRelease(provider);
        provider = nil;
    }
}

- (void)removeGLView :(BOOL)toPortrait
{
    if( _glView ) {
        BOOL bRemoved = FALSE;
        
        for (UIView *subView in self.subviews) {
            
            if ([subView isKindOfClass:[CameraShowGLView class]]) {
                
                [subView removeFromSuperview];
                NSLog( @"glView has been removed from view <OK>" );
                bRemoved = TRUE;
                break;
            }
        }
        if( !bRemoved ) {
            for (UIView *subView in self.subviews) {
                
                if ([subView isKindOfClass:[CameraShowGLView class]]) {
                    
                    [subView removeFromSuperview];
                    NSLog( @"glView has been removed from view <OK>" );
                    bRemoved = TRUE;
                    break;
                }
            }
        }
    }
}

- (void)glFrameSize:(NSArray*)param
{
    CGSize* pglFrameSize_Original = (CGSize*)[(NSValue*)[param objectAtIndex:0] pointerValue];
    CGSize* pglFrameSize_Scaling = (CGSize*)[(NSValue*)[param objectAtIndex:1] pointerValue];
    
    
    *pglFrameSize_Scaling = *pglFrameSize_Original;
}

- (void)reportCodecId:(NSValue*)pointer
{
    unsigned short *pnCodecId = (unsigned short *)[pointer pointerValue];
    
    _mCodecId = *pnCodecId;
    
    if( _mCodecId == MEDIA_CODEC_VIDEO_MJPEG ) {
        [self bringSubviewToFront:_monitor/*self.glView*/];
    }
    else {
        [self bringSubviewToFront:/*monitor*/self.glView];
    }
}

- (void)updateToScreen:(NSValue*)pointer
{
    LPSIMAGEBUFFINFO pScreenBmpStore = (LPSIMAGEBUFFINFO)[pointer pointerValue];
    if( _mPixelBuffer == nil ||
       _mSizePixelBuffer.width != pScreenBmpStore->nWidth ||
       _mSizePixelBuffer.height != pScreenBmpStore->nHeight ) {
        
        if(_mPixelBuffer) {
            CVPixelBufferRelease(_mPixelBuffer);
            CVPixelBufferPoolRelease(_mPixelBufferPool);
        }
        
        NSMutableDictionary* attributes;
        attributes = [NSMutableDictionary dictionary];
        [attributes setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
        [attributes setObject:[NSNumber numberWithInt:pScreenBmpStore->nWidth] forKey: (NSString*)kCVPixelBufferWidthKey];
        [attributes setObject:[NSNumber numberWithInt:pScreenBmpStore->nHeight] forKey: (NSString*)kCVPixelBufferHeightKey];
        
        CVReturn err = CVPixelBufferPoolCreate(kCFAllocatorDefault, NULL, (__bridge CFDictionaryRef) attributes, &_mPixelBufferPool);
        if( err != kCVReturnSuccess ) {
            NSLog( @"mPixelBufferPool create failed!" );
        }
        err = CVPixelBufferPoolCreatePixelBuffer (NULL, _mPixelBufferPool, &_mPixelBuffer);
        if( err != kCVReturnSuccess ) {
            NSLog( @"mPixelBuffer create failed!" );
        }
        _mSizePixelBuffer = CGSizeMake(pScreenBmpStore->nWidth, pScreenBmpStore->nHeight);
        NSLog( @"CameraLiveViewController - mPixelBuffer created %dx%d nBytes_per_Row:%d", pScreenBmpStore->nWidth, pScreenBmpStore->nHeight, pScreenBmpStore->nBytes_per_Row );
    }
    CVPixelBufferLockBaseAddress(_mPixelBuffer,0);
    
    UInt8* baseAddress = (UInt8*)CVPixelBufferGetBaseAddress(_mPixelBuffer);
    
    memcpy(baseAddress, pScreenBmpStore->pData_buff, pScreenBmpStore->nBytes_per_Row * pScreenBmpStore->nHeight );
    
    CVPixelBufferUnlockBaseAddress(_mPixelBuffer,0);
    
    [_glView renderVideo:_mPixelBuffer];
}

- (void)waitStopShowCompleted:(unsigned int)uTimeOutInMs
{
    unsigned int uStart = _getTickCount();
    while( self.bStopShowCompletedLock == FALSE ) {
        usleep(1000);
        unsigned int now = _getTickCount();
        if( now - uStart >= uTimeOutInMs ) {
            [loadingViewPortrait stopAnimating];
            NSLog( @"CameraLiveViewController - waitStopShowCompleted !!!TIMEOUT!!!" );
            break;
        }
    }
    
}

- (void)cameraStopShowCompleted:(NSNotification *)notification
{
    _bStopShowCompletedLock = TRUE;
}

#pragma mark - MonitorTouchDelegate Methods
/*
 - (void)monitor:(Monitor *)monitor gestureSwiped:(Direction)direction
 {
 }
 */

- (void)monitor:(Monitor *)monitor gesturePinched:(CGFloat)scale
{
    NSLog( @"CameraLiveViewController - Pinched scale:%f", scale );
    
}

- (void)activeAudioSession
{
    
#if 0
    OSStatus error;
    
    UInt32 category = kAudioSessionCategory_LiveAudio;
    
    if (selectedAudioMode == AUDIO_MODE_SPEAKER) {
        category = kAudioSessionCategory_LiveAudio;
        NSLog(@"kAudioSessionCategory_LiveAudio");
    }
    
    if (selectedAudioMode == AUDIO_MODE_MICROPHONE) {
        category = kAudioSessionCategory_PlayAndRecord;
        NSLog(@"kAudioSessionCategory_PlayAndRecord");
    }
    
    error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    if (error) printf("couldn't set audio category!");
    
    error = AudioSessionSetActive(true);
    if (error) printf("AudioSessionSetActive (true) failed");
    
#else
    
    NSString *audioMode = nil;
    if (_selectedAudioMode == AUDIO_MODE_SPEAKER) {
        NSLog(@"kAudioSessionCategory_LiveAudio");
        audioMode = AVAudioSessionCategoryPlayback;
    }
    
    else if (_selectedAudioMode == AUDIO_MODE_MICROPHONE) {;
        NSLog(@"kAudioSessionCategory_PlayAndRecord");
        audioMode = AVAudioSessionCategoryPlayAndRecord;
    }
    
    if ( nil == audioMode){
        return ;
    }
    
    //get your app's audioSession singleton object
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //error handling
    BOOL success;
    NSError* error;
    
    //set the audioSession category.
    //Needs to be Record or PlayAndRecord to use audioRouteOverride:
    
    success = [session setCategory:audioMode error:&error];
    
    if (!success)  NSLog(@"AVAudioSession error setting category:%@",error);
    
    //set the audioSession override
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                         error:&error];
    if (!success)  NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
    
    //activate the audio session
    success = [session setActive:YES error:&error];
    if (!success) NSLog(@"AVAudioSession error activating: %@",error);
    else NSLog(@"audioSession active");
    
    
#endif
}

- (void)unactiveAudioSession {
    
#if 0
    AudioSessionSetActive(false);
#else
    BOOL success;
    NSError* error;
    
    //get your app's audioSession singleton object
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //activate the audio session
    success = [session setActive:NO error:&error];
    if (!success) NSLog(@"AVAudioSession error deactivating: %@",error);
    else NSLog(@"audioSession deactive");
    
#endif
}


@end
