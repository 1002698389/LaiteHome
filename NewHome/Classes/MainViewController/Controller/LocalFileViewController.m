//
//  LocalFileViewController.m
//  NewHome
//
//  Created by 小热狗 on 16/1/5.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import "LocalFileViewController.h"
#import "AppDelegate.h"
@interface LocalFileViewController ()
{
     UITableView *readTable;
}

@property(nonatomic,strong)NSMutableArray *dirArray;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@end

@implementation LocalFileViewController
- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    long y;
    switch ( [UIDevice iPhonesModel]) {
        case iPhone4:
            y=0;
            break;
        case iPhone5:
            y=0;
            break;
        case iPhone6:
            y=0;
            break;
        case iPhone6Plus:
            y=0;
            break;
        case UnKnown:
            y=44.0;
            break;
            
            
        default:
            break;
    }

    self.automaticallyAdjustsScrollViewInsets=NO;
    indexSelect=NO;
    self.title=@"莱特智能家居";
        self.automaticallyAdjustsScrollViewInsets=NO;
       readTable=[[UITableView alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    readTable.delegate=self;
    readTable.dataSource=self;
    [self.view addSubview:readTable];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
    bottomView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:bottomView];
    
    
    if (self.transStyle==1) {
        //导入
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.frame=CGRectMake(0, 10, SCREEN_WIDTH/2, 30);
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelBtn];
 
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        sureBtn.backgroundColor=[UIColor clearColor];
        sureBtn.frame=CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 30);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureImport) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:sureBtn];

        
        
        
    }else if (self.transStyle==2){
        //导出
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.backgroundColor=[UIColor clearColor];
        cancelBtn.frame=CGRectMake(0, 10, self.view.frame.size.width, 30);
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelBtn];

    }
    
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    //	NSLog(@"------------------------%@",fileList);
    self.dirArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList)
    {
        [self.dirArray addObject:file];
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    
    
    
    [readTable reloadData];

    // Do any additional setup after loading the view.
}
-(void)sureImport{
    
   

        NSString *fileName=self.dirArray[currentIndex];
     [appDelegate.appDefault setObject:fileName forKey:@"dataName"];
        NSArray* foo = [fileName componentsSeparatedByString: @"."];
        NSString* str1 = [foo objectAtIndex: 1];
        if ([str1 isEqualToString:@"sqlite"]) {
            [self.delegate importLocalSqlite:fileName];
             [self dismissModalViewControllerAnimated:YES];
        }else{
            
            NSString *message=@"所选文件类型不正确";
            [self.view makeToast:message];
        }
        
    
    
    
}
-(void)cancelView{
    
      [self dismissModalViewControllerAnimated:YES];
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *cellIndexPath = [readTable indexPathForRowAtPoint:[longPressGesture locationInView:readTable]];
        
        NSURL *fileURL;
        if (cellIndexPath.section == 0)
        {
            // for section 0, we preview the docs built into our app
            fileURL = [self.dirArray objectAtIndex:cellIndexPath.row];
        }
        else
        {
            // for secton 1, we preview the docs found in the Documents folder
            fileURL = [self.dirArray objectAtIndex:cellIndexPath.row];
        }
        self.docInteractionController.URL = fileURL;
        
        [self.docInteractionController presentOptionsMenuFromRect:longPressGesture.view.frame
                                                           inView:longPressGesture.view
                                                         animated:YES];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellName = @"CellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        if (self.transStyle==1) {
            //导入
             cell.accessoryType = UITableViewCellAccessoryNone;
                }else if (self.transStyle==2){
                    //导出
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
    }
    
    NSURL *fileURL= nil;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    
    [self setupDocumentControllerWithURL:fileURL];
    cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image =[UIImage imageNamed:@"icon"];
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell.imageView addGestureRecognizer:longPressGesture];
    cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dirArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    indexSelect=YES;

    
    if (self.transStyle==1) {
        //导入
        if(indexPath.row==currentIndex){
            
            return;
        }
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex
                                                       inSection:0];
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        currentIndex=indexPath.row;
    
    
    
    
    
    }else if (self.transStyle==2){
        //导出
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = indexPath.row;
    [[self navigationController] pushViewController:previewController animated:YES];
    //	[self presentViewController:previewController animated:YES completion:nil];
    }
    
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.transStyle==1) {
    if(indexPath.row==currentIndex){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }

    }

    return 0;
}


#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    //    NSInteger numToPreview = 0;
    //
    //	numToPreview = [self.dirArray count];
    //
    //    return numToPreview;
    return [self.dirArray count];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    [previewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"click.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [readTable indexPathForSelectedRow];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
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
