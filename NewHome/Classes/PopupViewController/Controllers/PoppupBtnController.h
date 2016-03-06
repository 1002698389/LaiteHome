//
//  PoppupBtnController.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddButtonView.h"
#import "AddCameraView.h"
#import "AddRemoteView.h"
#import "AddSwitchView.h"
#import "AddNumberView.h"
#import "AddIOView.h"
@protocol addButtonViewDelegate <NSObject>

-(void)upLoadButtonImg;//上传按钮图片
-(void)addButton:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag buttonType:(int)buttontype defaultIcon:(NSInteger)defaultIcon width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;//添加按钮(确定，取消）
-(void)addCamera:(NSString *)camear_name uid:(NSString *)uid user_name:(NSString *)user_name password:(NSString *)password tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;
-(void)addRemoteView:(long)tag;
-(void)scanCameraUid;

-(void)addSwitch:(NSString *)switchName switchAddr:(NSString *)swithAddr switchIcon:(int)switchIcon tag:(long)tag swtichLine:(int)swtichLine;

-(void)addNumber:(NSString *)numberName numberAddr:(NSString *)numberAddr numberOne:(NSString *)numberOne tag:(long)tag numberTwo:(NSString *)numberTwo width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;

-(void)addIo:(NSString *)ioName tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;


@end
@interface PoppupBtnController : UIViewController<UIScrollViewDelegate,addButtonDelegate,addCameraDelegate,addRemoteDelegate,addSwitchDelegate,addNumberDelegate,addIoDelegate>
{
    
    UIScrollView *myScrollView;
}
@property(nonatomic,retain)id <addButtonViewDelegate> delegate;
@property(nonatomic,assign)long currentHostId;
@property(nonatomic,strong)NSString *showState;
@property(nonatomic,assign)long btnId;


@end
