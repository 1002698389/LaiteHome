//
//  RoomEditViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/12/20.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomModal.h"
@protocol roomEditDelegate <NSObject>

-(void)upLoadImgEdit;//上传房间图片
-(void)editRoomName:(NSString *)roomName tag:(long)tag;
@end

@interface RoomEditViewController : UIViewController
{
     RoomModal *modal;//房间模型
    UITextField *roomNameText;
    UIImageView *disPlayImgView;//浏览图片
     float textField_height;
}
@property(nonatomic,assign)long roomId;
@property(nonatomic,assign)long hostId;
@property(nonatomic,retain)id <roomEditDelegate> delegate;
//浏览图片
-(void)setImage:(UIImage *)image;
@end
