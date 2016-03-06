//
//  TimeViewController.h
//  NewHome
//
//  Created by 小热狗 on 16/3/1.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSetViewController.h"
@interface TimeViewController : UIViewController
{
    TimeSetViewController *timeSetView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;


@end
