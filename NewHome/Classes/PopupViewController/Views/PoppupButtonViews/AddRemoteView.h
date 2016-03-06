//
//  AddRemoteView.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol addRemoteDelegate <NSObject>
-(void)showRemote:(long)tag;
@end
@interface AddRemoteView : UIView
{
    float textField_height;
}
@property(nonatomic,retain)id <addRemoteDelegate> delegate;
@end
