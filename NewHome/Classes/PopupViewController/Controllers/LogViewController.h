//
//  LogViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/12/4.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol logDelegate <NSObject>


-(void)logClick:(long)tag;

@end
@interface LogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *logTabel;
}
@property(nonatomic,assign)long hostId;
@property(nonatomic,strong)NSArray *modalArray;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,retain)id <logDelegate> delegate;
@end
