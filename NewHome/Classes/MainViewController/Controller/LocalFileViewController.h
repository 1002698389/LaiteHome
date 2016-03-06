//
//  LocalFileViewController.h
//  NewHome
//
//  Created by 小热狗 on 16/1/5.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
@protocol localFileDelegate <NSObject>

-(void)importLocalSqlite:(NSString *)sqliteName;
@end

@interface LocalFileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    long currentIndex;
    BOOL indexSelect;
}

@property(nonatomic,assign)long transStyle; //1:导入 2:导出
@property(nonatomic,retain)id <localFileDelegate> delegate;
@end
