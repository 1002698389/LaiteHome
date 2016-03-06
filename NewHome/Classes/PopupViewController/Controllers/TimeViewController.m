//
//  TimeViewController.m
//  NewHome
//
//  Created by 小热狗 on 16/3/1.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import "TimeViewController.h"
#import "TimeCollecCell.h"
#import "UIViewController+MJPopupViewController.h"

@interface TimeViewController ()

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    [self.collectionView registerClass:[TimeCollecCell class] forCellWithReuseIdentifier:@"TimeCollecCell"];
    self.collectionView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.3];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.backImgView.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    
    [self.backImgView addGestureRecognizer:tapGesture];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)Actiondo{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return 128;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UINib *nib = [UINib nibWithNibName:@"TimeCollecCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"TimeCollecCell"];
        TimeCollecCell *cell = (TimeCollecCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCollecCell" forIndexPath:indexPath];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timeCellClick:)];
    longPressGr.minimumPressDuration = 1.0;
    cell.tag=indexPath.row;
    [cell addGestureRecognizer:longPressGr];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 68);
}


-(void)timeCellClick:(UILongPressGestureRecognizer *)gesture
{
    
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
        NSLog(@"%ld",(long)indexPath.row);
        timeSetView=nil;
        timeSetView=[[TimeSetViewController alloc]init];
        
        [self presentPopupViewController:timeSetView animationType:MJPopupViewAnimationFade];

        
        
    }
    
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
