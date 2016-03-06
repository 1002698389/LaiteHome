//
//  AddIOView.h
//  NewHome
//
//  Created by 小热狗 on 15/12/2.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOModal.h"
@protocol addIoDelegate <NSObject>


-(void)addIo:(NSString *)ioName  tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;//添加按钮(确定，取消）

@end
@interface AddIOView : UIView
{
    IOModal *modal;
    UIButton *sizeBtn;
    UITextField *widthText;
    UITextField *heightText;
    BOOL customSelect;
  float textField_height;
}
@property(nonatomic,strong)UITextField *nameText;
@property(nonatomic,retain)id <addIoDelegate> delegate;
- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId;
@property(nonatomic,assign)int customSize;//按钮大小（1：默认 2:自定义）
@end
