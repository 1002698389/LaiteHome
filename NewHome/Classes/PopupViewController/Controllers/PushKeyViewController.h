//
//  PushKeyViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/12/4.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol pushKeyDelegate <NSObject>

-(void)upLoadImgEdit;//上传房间图片
-(void)settingPushkey:(NSDictionary*)data openPushKey:(NSString *)open tag:(long)tag;

@end
@interface PushKeyViewController : UIViewController
{
    UIButton *selectBtn;
    NSString *pushSelect;
     float textField_height;
}
@property(nonatomic,retain)id <pushKeyDelegate> delegate;
@end
