//
//  AddHostViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostModal.h"
@protocol popAddHostlDelegate <NSObject>

-(void)hostSetting:(NSString *)hostName imei:(NSString *)imei hostNetwork:(NSString *)hostNetwork networkPort:(NSString *)networkPort hostIntranet:(NSString *)hostIntranet intranetPort:(NSString *)intranetPort tag:(long)tag;//添加主机(取消，确定）


@end

@interface AddHostViewController : UIViewController<UITextFieldDelegate>
{
    HostModal *modal;//主机模型
    UITextField *hostNameText;//主机名
    UITextField *imeiText;//机器码
    UITextField *intranetText; //内网地址
    UITextField *intranetPortText;//内网端口
    UITextField *networkText;//外网地址
    UITextField *networkPortText;//外网端口
    float textField_height;

}
@property(nonatomic,retain)id <popAddHostlDelegate> delegate;
@property(nonatomic,assign)long hostId;
@end
