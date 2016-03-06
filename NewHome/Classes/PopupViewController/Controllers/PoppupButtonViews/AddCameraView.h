//
//  AddCameraView.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol addCameraDelegate <NSObject>

@end
@interface AddCameraView : UIView
@property(nonatomic,retain)id <addCameraDelegate> delegate;
@end
