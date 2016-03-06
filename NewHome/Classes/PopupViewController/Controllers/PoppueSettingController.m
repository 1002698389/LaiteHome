//
//  PoppueSettingController.m
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "PoppueSettingController.h"
#import "DatabaseOperation.h"
#import "AddHostViewController.h"
#import "MainViewController.h"
#import "HostCell.h"
#import "HostModal.h"

#define _CELL @ "CustomCollectionCell"
@interface PoppueSettingController ()

@end

@implementation PoppueSettingController

//主机数组
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}



-(void)viewWillAppear:(BOOL)animated{
       [self getHostsArr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    long view_heiht=2*SCREEN_HEIGHT/3;
    long view_width=2*SCREEN_WIDTH/3;
    
    
    
    self.view.frame=CGRectMake(view_width/2, view_heiht/2, view_width, view_heiht);
    
    
    
    long btn_width=self.view.frame.size.width/4;
    long btn_height=self.view.frame.size.height/6;
    
    
   
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, btn_height)];
    titleView.backgroundColor=PopView_TitleColor;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn_width/6, 5, 2*btn_width, btn_height-10)];
    titleLabel.text=@"后台设置";
    titleLabel.textColor=[UIColor colorWithRed:92.0/255.0 green:170.0/255.0 blue:247.0/255.0 alpha:1];
    [titleView addSubview:titleLabel];
    
    [self.view addSubview:titleView];
    
    
    
    [self setCollectionView]; //加载collectionView
    
        UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame=CGRectMake(0, self.view.frame.size.height-btn_height, btn_width-0.5, btn_height);
    [addBtn addTarget:self action:@selector(hostclick:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
     addBtn.tag=1;
    [self.view addSubview:addBtn];
    
    UIButton *importBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    importBtn.frame=CGRectMake(btn_width, self.view.frame.size.height-btn_height, btn_width-0.5, btn_height);
    [importBtn addTarget:self action:@selector(hostclick:) forControlEvents:UIControlEventTouchUpInside];
    [importBtn setTitle:@"导入" forState:UIControlStateNormal];
    [importBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [importBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [importBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
     importBtn.tag=2;
    [self.view addSubview:importBtn];
    
    UIButton *exportBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    exportBtn.frame=CGRectMake(2*btn_width, self.view.frame.size.height-btn_height, btn_width-0.5, btn_height);
    [exportBtn addTarget:self action:@selector(hostclick:) forControlEvents:UIControlEventTouchUpInside];
    [exportBtn setTitle:@"导出" forState:UIControlStateNormal];
    [exportBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [exportBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [exportBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
     exportBtn.tag=3;
    [self.view addSubview:exportBtn];
    
    UIButton *lockBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    lockBtn.frame=CGRectMake(3*btn_width, self.view.frame.size.height-btn_height, btn_width+1.5, btn_height);
    [lockBtn addTarget:self action:@selector(hostclick:) forControlEvents:UIControlEventTouchUpInside];
    [lockBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [lockBtn setTitle:@"锁屏" forState:UIControlStateNormal];
    [lockBtn setBackgroundImage:[UIImage imageNamed:@"确认选中-1"] forState:UIControlStateSelected];
    [lockBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
     lockBtn.tag=4;
    [self.view addSubview:lockBtn];

    
    
    // Do any additional setup after loading the view.
}




-(void)setCollectionView{
    
   
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    self.myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, (2*SCREEN_HEIGHT/3)/6, self.view.frame.size.width,2*SCREEN_HEIGHT/3-(2*SCREEN_HEIGHT/3)/3) collectionViewLayout:layout];
    [self.myCollectionView registerClass :[UICollectionViewCell class ] forCellWithReuseIdentifier : _CELL ];
    self.myCollectionView.scrollEnabled=YES;
    
    self.myCollectionView. backgroundColor=[UIColor clearColor];
    self.myCollectionView.delegate=self;
    self.myCollectionView.dataSource=self;
    self.myCollectionView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
    [self.view addSubview:self.myCollectionView];

    
}























//(添加，倒入，导出，锁屏）
-(void)hostclick:(UIButton *)sender{
   
    
    if (sender.tag==1) {
        
        //进入添加主机界面
        [self.delegate popAddHostClick:0];
        
        
    }else if (sender.tag==2){
        //导入
        [self.delegate induceSq];
        
    }else if (sender.tag==3){
        //导出
        [self.delegate exportSq];
        
    }
    else if (sender.tag==4){
        //进入锁屏界面
        [self.delegate popLockScreen];
        
    }
    
    
}




//获取主机数
-(void)getHostsArr{
    [self.dataSource removeAllObjects];
    NSArray *modals = [DatabaseOperation queryHostsData:nil];
    [self.dataSource addObjectsFromArray:modals];
    [self.myCollectionView reloadData];
}

//刷新主机
-(void)reloadDataSource:(NSMutableArray *)hostModalArr{
    
    [self.dataSource removeAllObjects];
    self.dataSource=[hostModalArr mutableCopy] ;
    [self.myCollectionView reloadData];
    
}








#pragma collectionDelegate


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section

{
    
    return self.dataSource.count;
    
}
-( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath

{
    UINib *nib = [UINib nibWithNibName:@"HostCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HostCell"];
    HostCell *cell = (HostCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"HostCell" forIndexPath:indexPath];
    HostModal *modal=[self.dataSource objectAtIndex:indexPath.row];
    if (modal.type==0) {
         cell.hostPic.image=[UIImage imageNamed:@"主机图标"];
    }else if (modal.type==1){
        cell.hostPic.image=[UIImage imageNamed:@"主机选中"];
    }
    cell.hostPicName.text=modal.host_name;
   
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    cell.tag=indexPath.row;
    [cell addGestureRecognizer:longPressGr];
    return cell;
    
    
}

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    

   
    HostModal *modal=[self.dataSource objectAtIndex:indexPath.row];
    
    
    [self.delegate hostSelect:modal._id];
    
    
    
}

//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath

{
    
    return YES ;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
        return CGSizeMake ( 120 , 50 );
    
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    
    return UIEdgeInsetsMake ( 10 , 30 , 10 , 30 );
    
}



//长按点击事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
    HostModal *modal=[self.dataSource objectAtIndex:indexPath.row];
    self.operIndexRow=indexPath.row;
    self.currentIndex=modal._id;
   
    NSLog(@"%ld",(long)indexPath.row);
    UICollectionViewCell *cell = [self.myCollectionView cellForItemAtIndexPath:indexPath];
    
      
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"good" message:@"longpress" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //        [alert show];
        //
        //add your code here
        
        
        [self becomeFirstResponder];
        //self.hostId=gesture.view.tag;
        m_menuCtrl = [UIMenuController sharedMenuController];
        
        
        
        UIMenuItem *itemEdit = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editBtn)];
        UIMenuItem *itemSynchro=[[UIMenuItem alloc] initWithTitle:@"同步" action:@selector(synchro)];
        UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteBtn)];
        
        
        [m_menuCtrl setMenuItems:[NSArray arrayWithObjects:itemEdit,itemSynchro, itemDelete, nil]];
        [m_menuCtrl setTargetRect:cell.contentView.frame inView: cell.contentView];
        [m_menuCtrl setMenuVisible:YES animated:YES];

    }
    
    
    
    
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    
    if (action == @selector(editBtn)){
        return YES;
    }else if (action == @selector(synchro)){
        return YES;
    }else if (action == @selector(deleteBtn)){
        return YES;
    }

    
    
    
    return NO;
    
}

-(void)editBtn{
    
    
    [self.delegate editHost:self.currentIndex];
    
}

-(void)synchro{
    
    [self.delegate synchro:self.currentIndex];
    
}
-(void)deleteBtn{
    [self.delegate deleteHost:self.currentIndex indexRow:self.operIndexRow];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
