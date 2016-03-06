//
//  CemeraView.h
//  IntelligentHome
//
//  Created by 小热狗 on 15/4/16.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/Camera.h>
#import <IOTCamera/Monitor.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import "CameraShowGLView.h"
typedef enum
{
    AUDIO_MODE_OFF          = 0,
    AUDIO_MODE_SPEAKER      = 1,
    AUDIO_MODE_MICROPHONE   = 2,
}ENUM_AUDIO_MODE;

@interface CemeraView : UIView<CameraDelegate, MonitorTouchDelegate,UIGestureRecognizerDelegate>
{
    BOOL isTalking;
    BOOL isListening;
    UIActivityIndicatorView *loadingViewPortrait;
    NSTimer *cameraTimer;
    UILabel *alertLabel;
}
@property (nonatomic, assign) BOOL bStopShowCompletedLock;
@property (nonatomic, assign) unsigned short mCodecId;
@property (nonatomic, assign) CGSize mSizePixelBuffer;
@property (nonatomic, retain) CameraShowGLView *glView;
@property CVPixelBufferPoolRef mPixelBufferPool;
@property CVPixelBufferRef mPixelBuffer;
@property (nonatomic, retain) Camera *camera;
//@property CVPixelBufferPoolRef mPixelBufferPool;
@property ENUM_AUDIO_MODE selectedAudioMode;;
@property(nonatomic,strong)Monitor *monitor;


-(id)initWithFrame:(CGRect)frame cameraUid:(NSString *)uid userName:(NSString *)userName passWord:(NSString *)password;
-(void)stopCamera;

@end
