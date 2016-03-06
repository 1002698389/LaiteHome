//
//  PoppueSettingController.h
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popHostSettinglDelegate <NSObject>

-(void)popAddHostClick:(long)hostId; //添加主机
-(void)popLockScreen;
-(void)hostSelect:(NSInteger)hostId; //选择主机
-(void)editHost:(long)hostId;//编辑主机
-(void)deleteHost:(long)hostId indexRow:(long)indexRow;//删除主机
-(void)synchro:(long)hostId;//主机同步数据
-(void)induceSq;
-(void)exportSq;
@end

@interface PoppueSettingController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
     UIMenuController * m_menuCtrl;
}
@property(nonatomic,retain)id <popHostSettinglDelegate> delegate;
@property(nonatomic,strong) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;//数据源
@property(nonatomic,assign)long currentIndex;
@property(nonatomic,assign)long operIndexRow;
-(void)reloadDataSource:(NSMutableArray *)hostModalArr;

@end
