//
//  EditEquiRoomViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/12/20.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomModal.h"

@protocol roomEquiEditDelegate <NSObject>

-(void)upLoadImgEdit;//上传房间图片
-(void)editRoomName:(NSString *)roomName roomIcon:(NSInteger)roomeIcon tag:(long)tag;

@end
@class MLTableAlert;
@interface EditEquiRoomViewController : UIViewController
{
    RoomModal *modal;//房间模型
    UITextField *roomNameText;
    UIImageView *disPlayImgView;//浏览图片
    UIButton*iconBtn;
    float textField_height;
}
@property(nonatomic,assign)int roomIcon;//房间图标
@property(nonatomic,assign)long roomId;
@property(nonatomic,assign)long hostId;
@property(nonatomic,retain)id <roomEquiEditDelegate> delegate;
@property (strong, nonatomic) MLTableAlert *alert;
//浏览图片
-(void)setImage:(UIImage *)image;
@end
