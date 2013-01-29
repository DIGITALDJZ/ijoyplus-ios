//
//  allListViewController.m
//  yueshipin
//
//  Created by 08 on 12-12-24.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "allListViewController.h"
#import "AFServiceAPIClient.h"
#import "ServiceConstants.h"
#import "AllListViewCell.h"
#import "UIImageView+WebCache.h"
#import "ListDetailViewController.h"
#import "MBProgressHUD.h"
#import "CacheUtility.h"
#import "IphoneSettingViewController.h"
#import "SearchPreViewController.h"
#import "UIUtility.h"
#import "UIImage+Scale.h"
#import "IphoneDownloadViewController.h"
#define pageSize 20
#define MOVIE_TYPE 9001
@interface allListViewController ()

@end

@implementation allListViewController
@synthesize listArray = listArray_;
@synthesize tableList = tableList_;
@synthesize pullToRefreshManager = pullToRefreshManager_;
@synthesize refreshHeaderView = refreshHeaderView_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)parseTopsListData:(id)result
{
    self.listArray = [[NSMutableArray alloc]initWithCapacity:pageSize];
    NSString *responseCode = [result objectForKey:@"res_code"];
    if(responseCode == nil){
        NSArray *tempTopsArray = [result objectForKey:@"tops"];
        if(tempTopsArray.count > 0){
           [[CacheUtility sharedCache] putInCache:@"top_list" result:result];
            [ self.listArray addObjectsFromArray:tempTopsArray];
        }
    }
    else {
      
    }
    
    [self.tableList reloadData];
}


-(void)loadData{
    MBProgressHUD *tempHUD;
    id cacheResult = [[CacheUtility sharedCache] loadFromCache:@"top_list"];
    if(cacheResult != nil){
        [self parseTopsListData:cacheResult];
    } else {
        if(tempHUD == nil){
            tempHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:tempHUD];
            tempHUD.labelText = @"加载中...";
            tempHUD.opacity = 0.5;
            [tempHUD show:YES];
        }
    }

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"1", @"page_num", [NSNumber numberWithInt:pageSize], @"page_size", nil];
    [[AFServiceAPIClient sharedClient] getPath:kPathTops parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        [self parseTopsListData:result];
        [tempHUD hide:YES];
        
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if(self.listArray == nil){
            self.listArray = [[NSMutableArray alloc]initWithCapacity:10];
        }
        [tempHUD hide:YES];
    }];


}

- (void)viewWillAppear:(BOOL)animated {
    
   // [(TabBarViewController*)self.tabBarController setTabBarHidden:NO];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_common.png"]];
    backGround.frame = CGRectMake(0, 0, 320, kFullWindowHeight);
    [self.view addSubview:backGround];
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(90, 0, 60, 50)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    [titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleText setText:@"悦视频"];
    self.navigationItem.titleView=titleText;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 40, 30);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"top_search_common.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 50, 44);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"downloadicon.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"download_icon_s.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-88) style:UITableViewStylePlain];
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableList];
    [self loadData];
    
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:480.0f tableView:tableList_ withClient:self];
    reloads_ = 2;
    if (refreshHeaderView_ == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableList_.bounds.size.height, self.view.frame.size.width, tableList_.bounds.size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        [tableList_ addSubview:view];
        refreshHeaderView_ = view;
        
    }
    [refreshHeaderView_ refreshLastUpdatedDate];
    
}

-(void)search:(id)sender{
    SearchPreViewController *searchViewCotroller = [[SearchPreViewController alloc] init];
    searchViewCotroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewCotroller animated:YES];

}

-(void)setting:(id)sender{
//    IphoneSettingViewController *iphoneSettingViewController = [[IphoneSettingViewController alloc] init];
//    iphoneSettingViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:iphoneSettingViewController animated:YES];
    
    IphoneDownloadViewController *downloadViewController = [[IphoneDownloadViewController alloc] init];
    downloadViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:downloadViewController animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    AllListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AllListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];   
    }
    NSDictionary *item = [self.listArray objectAtIndex:indexPath.row];
    NSMutableArray *items = [item objectForKey:@"items"];
    cell.label.text = [item objectForKey:@"name"];
    for (int i = 0; i< [items count];i++) {
        switch (i) {
            case 0:
                cell.label1.text = [[items objectAtIndex:0] objectForKey:@"prod_name" ];
                break;
            case 1:
                cell.label2.text = [[items objectAtIndex:1] objectForKey:@"prod_name" ];
                break;
            case 2:
                cell.label3.text = [[items objectAtIndex:2] objectForKey:@"prod_name" ];
                break;
            case 3:
                cell.label4.text = [[items objectAtIndex:3] objectForKey:@"prod_name" ];
                break;
            case 4:
                cell.label5.text = [[items objectAtIndex:4] objectForKey:@"prod_name" ];
                break;
                
            default:
                break;
        }
    }
   
    [cell.imageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"pic_url"]] placeholderImage:[UIImage imageNamed:@"video_placeholder"]];
    
    NSString *typeStr = [item objectForKey:@"prod_type"];
    if ([typeStr isEqualToString:@"1"]) {
        cell.typeImageView.image = [UIImage imageNamed:@"tab1_movieflag.png"];
    }
    else if ([typeStr isEqualToString:@"2"]){
        cell.typeImageView.image = [UIImage imageNamed:@"tab1_seriesflag.png"];
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    NSDictionary *item = [self.listArray objectAtIndex:indexPath.row];
    ListDetailViewController *listDetailViewController = [[ListDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    listDetailViewController.Type = MOVIE_TYPE;
    listDetailViewController.topicId = [item objectForKey:@"id"];
    listDetailViewController.title = [item objectForKey:@"name"];
    listDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listDetailViewController animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{


}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate {
    
        [refreshHeaderView_ egoRefreshScrollViewDidEndDragging:aScrollView];
         [pullToRefreshManager_ tableViewReleased];

}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    reloads_ = 2;
    [self loadData];
    reloading_ = YES;
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return reloading_; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)MNMBottomPullToRefreshManagerClientReloadTable {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:reloads_], @"page_num", [NSNumber numberWithInt:pageSize], @"page_size", nil];
    [[AFServiceAPIClient sharedClient] getPath:kPathTops parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        NSString *responseCode = [result objectForKey:@"res_code"];
        NSArray *tempTopsArray;
        if(responseCode == nil){
            tempTopsArray = [result objectForKey:@"tops"];
            if(tempTopsArray.count > 0){
                [self.listArray addObjectsFromArray:tempTopsArray];
                reloads_ ++;
            }
        } else {
            
        }
        [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.0f];
        if(tempTopsArray.count < pageSize){
            [pullToRefreshManager_ setPullToRefreshViewVisible:NO];
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        [self performSelector:@selector(loadTable) withObject:nil afterDelay:0.0f];
    }];
}

- (void)loadTable {
    [tableList_ reloadData];
    [pullToRefreshManager_ tableViewReloadFinished];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	reloading_ = NO;
	[refreshHeaderView_ egoRefreshScrollViewDataSourceDidFinishedLoading:tableList_];
	
}

@end