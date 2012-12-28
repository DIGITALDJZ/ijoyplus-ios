//
//  IphoneShowViewController.m
//  yueshipin
//
//  Created by 08 on 12-12-28.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "IphoneShowDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AFServiceAPIClient.h"
#import "ServiceConstants.h"
#import "CacheUtility.h"
#import "CMConstants.h"
#import "MediaPlayerViewController.h"
#import "AppDelegate.h"
#import "ProgramViewController.h"

@interface IphoneShowDetailViewController ()

@end

@implementation IphoneShowDetailViewController

@synthesize infoDic = infoDic_;
@synthesize videoInfo = videoInfo_;
@synthesize episodesArr = episodesArr_;
@synthesize videoType = videoType_;
@synthesize summary = summary_;
@synthesize scrollView = scrollView_;
@synthesize next = next_;
@synthesize pre = pre_;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.infoDic objectForKey:@"prod_name"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}

-(void)loadData{
    
    NSString *key = [NSString stringWithFormat:@"%@%@", @"show", [self.infoDic objectForKey:@"prod_id"]];
    id cacheResult = [[CacheUtility sharedCache] loadFromCache:key];
    if(cacheResult != nil){
        
    }
    else{
        
        
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [self.infoDic objectForKey:@"prod_id"], @"prod_id", nil];
    [[AFServiceAPIClient sharedClient] getPath:kPathProgramView parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        [[CacheUtility sharedCache] putInCache:key result:result];
        videoInfo_ = (NSDictionary *)[result objectForKey:@"show"];
        episodesArr_ = [videoInfo_ objectForKey:@"episodes"];
        NSLog(@"episodes count is %d",[episodesArr_ count]);
        summary_ = [videoInfo_ objectForKey:@"summary"];
        [self.tableView reloadData];
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 87, 129)];
            [imageView setImageWithURL:[NSURL URLWithString:[self.infoDic objectForKey:@"prod_pic_url"]] placeholderImage:[UIImage imageNamed:@"video_placeholder"]];
            [cell addSubview:imageView];
            
            NSString *directors = [self.infoDic objectForKey:@"directors"];
            NSString *actors = [self.infoDic objectForKey:@"stars"];
            NSString *date = [self.infoDic objectForKey:@"publish_date"];
            NSString *area = [self.infoDic objectForKey:@"area"];
            UILabel *actorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 59, 200, 15)];
            actorsLabel.text = [NSString stringWithFormat:@"主演: %@",actors];
            [cell addSubview:actorsLabel];
            
            NSString *labelText = [NSString stringWithFormat:@"地区: %@\n编剧: %@\n年代: %@",area,directors,date];
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, 75, 200, 70)];
            infoLabel.text = labelText;
            infoLabel.lineBreakMode = UILineBreakModeWordWrap;
            infoLabel.numberOfLines = 0;
            [cell addSubview:infoLabel];
            
            UIButton *play = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            play.frame = CGRectMake(115, 28, 87, 27);
            play.tag = 10001;
            [play setTitle:@"播放视频" forState:UIControlStateNormal];
            [play addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:play];
            
            UIButton *addFav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            addFav.frame = CGRectMake(14, 152, 142, 27);
            addFav.tag = 10002;
            [addFav setTitle:[NSString stringWithFormat:@"收藏（%@）",[self.infoDic objectForKey:@"favority_num" ]]  forState:UIControlStateNormal];
            [addFav addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:addFav];
            
            UIButton *support = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            support.frame = CGRectMake(165, 152, 142, 27);
            support.tag = 10003;
            [support setTitle:[NSString stringWithFormat:@"顶（%@）",[self.infoDic objectForKey:@"support_num" ]] forState:UIControlStateNormal];
            [support addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:support];
            
            break;
        }
        case 1:{
           UIView *view = [self showEpisodesplayView];
            [cell addSubview:view];
            break;
        }
            
        case 2:{
            UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, [self heightForString:summary_ fontSize:14 andWidth:271])];
            summary.text = [NSString stringWithFormat:@"    %@",summary_];
            summary.numberOfLines = 0;
            summary.lineBreakMode = UILineBreakModeWordWrap;
            summary.font = [UIFont systemFontOfSize:14];
            [cell addSubview:summary];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return sizeToFit.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    if (row == 0) {
        return 181;
    }
    else if(row == 1){
        return 125;
    }
    else if(row == 2){
        return [self heightForString:summary_ fontSize:14 andWidth:271];
    }
    return 0;
    
}

-(void)Play:(int)number{
    NSArray *videoUrlArray = [[episodesArr_ objectAtIndex:number] objectForKey:@"down_urls"];
    if(videoUrlArray.count > 0){
        NSString *videoUrl = nil;
        for(NSDictionary *tempVideo in videoUrlArray){
            if([LETV isEqualToString:[tempVideo objectForKey:@"source"]]){
                videoUrl = [self parseVideoUrl:tempVideo];
                break;
            }
        }
        if(videoUrl == nil){
            videoUrl = [self parseVideoUrl:[videoUrlArray objectAtIndex:0]];
        }
        if(videoUrl == nil){
            [self showPlayWebPage:number];
        } else {
            MediaPlayerViewController *viewController = [[MediaPlayerViewController alloc]initWithNibName:@"MediaPlayerViewController" bundle:nil];
            viewController.videoUrl = videoUrl;
            viewController.type = 1;
            viewController.name = [videoInfo_ objectForKey:@"name"];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }else {
        [self showPlayWebPage:number];
    }
}
-(void)action:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10001:{
            [self Play:1];
            break;
        }
        case 10002:{
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [self.infoDic objectForKey:@"prod_id"], @"prod_id", nil];
            [[AFServiceAPIClient sharedClient] postPath:kPathProgramFavority parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
                NSString *responseCode = [result objectForKey:@"res_code"];
                if([responseCode isEqualToString:kSuccessResCode]){
                    
                } else {
                    
                }
                
            } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            
            break;
        }
        case 10003:{
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [self.infoDic objectForKey:@"prod_id"], @"prod_id", nil];
            [[AFServiceAPIClient sharedClient] postPath:kPathSupport parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
                NSString *responseCode = [result objectForKey:@"res_code"];
                if([responseCode isEqualToString:kSuccessResCode]){
                    
                } else {
                    
                }
            } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            
            break;
        }
            
        default:
            break;
    }
}

- (void)showPlayWebPage:(int)num
{
    ProgramViewController *viewController = [[ProgramViewController alloc]initWithNibName:@"ProgramViewController" bundle:nil];
    NSDictionary *episode = [episodesArr_ objectAtIndex:num];
    NSArray *videoUrls = [episode objectForKey:@"video_urls"];
    viewController.programUrl = [[videoUrls objectAtIndex:0] objectForKey:@"url"];
    viewController.title = [videoInfo_ objectForKey:@"name"];
    viewController.type = 1;
    viewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    
}

- (NSString *)parseVideoUrl:(NSDictionary *)tempVideo
{
    NSString *videoUrl;
    NSArray *urlArray =  [tempVideo objectForKey:@"urls"];
    for(NSDictionary *url in urlArray){
        if([GAO_QING isEqualToString:[url objectForKey:@"type"]]){
            videoUrl = [url objectForKey:@"url"];
            break;
        }
    }
    if(videoUrl == nil){
        for(NSDictionary *url in urlArray){
            if([BIAO_QING isEqualToString:[url objectForKey:@"type"]]){
                videoUrl = [url objectForKey:@"url"];
                break;
            }
        }
    }
    if(videoUrl == nil){
        for(NSDictionary *url in urlArray){
            if([LIU_CHANG isEqualToString:[url objectForKey:@"type"]]){
                videoUrl = [url objectForKey:@"url"];
                break;
            }
        }
    }
    if(videoUrl == nil){
        for(NSDictionary *url in urlArray){
            if([CHAO_QING isEqualToString:[url objectForKey:@"type"]]){
                videoUrl = [url objectForKey:@"url"];
                break;
            }
        }
    }
    if(videoUrl == nil){
        if(urlArray.count > 0){
            videoUrl = [[urlArray objectAtIndex:0] objectForKey:@"url"];
        }
    }
    return videoUrl;
}

-(UIView *)showEpisodesplayView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 293, 125)];
    int count = [episodesArr_ count];
    
    pageCount_ = (count%4 == 0 ? (count/4):(count/4)+1);
    
    scrollView_= [[UIScrollView alloc] initWithFrame:CGRectMake(22, 0, 240, 125)];
    scrollView_.contentSize = CGSizeMake(320*(count/15), 125);
    scrollView_.pagingEnabled = YES;
    scrollView_.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake((i/4)*240, (i%4)*29, 240, 27);
        button.tag = i+1;
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(episodesPlay:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView_ addSubview:button];
    }
    currentPage_ = 1;
    next_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    next_.frame = CGRectMake( 273, 0, 20, 125);
    [next_ setTitle:@"PRE" forState:UIControlStateNormal];
    [next_ addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [view  addSubview:next_];
    if (pageCount_ == 1) {
        next_.enabled = NO;
    }

    pre_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pre_.frame = CGRectMake(0, 0, 20, 125);
    if (currentPage_ == 1) {
        pre_.enabled = NO;
    }
    [pre_ setTitle:@"NEXT" forState:UIControlStateNormal];
    [pre_ addTarget:self action:@selector(pre:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pre_];
   
    [view addSubview:scrollView_];
    return view;
    
}

-(void)next:(id)sender{
    currentPage_++;
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.scrollView setContentOffset:CGPointMake(240.0f*(currentPage_-1), 0.0f) animated:YES];
    
    [UIView commitAnimations];
    if (currentPage_ == pageCount_ ) {
        next_.enabled = NO;
    }
    else{
        next_.enabled = YES;
    
    }
    
    if (currentPage_ == 1 ) {
        pre_.enabled = NO;
    }
    else{
        pre_.enabled = YES;
        
    }
    
}
-(void)pre:(id)sender{
    currentPage_--;
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.scrollView setContentOffset:CGPointMake(240.0f*(currentPage_-1), 0.0f) animated:YES];
    
    [UIView commitAnimations];
    if (currentPage_ == pageCount_ ) {
        next_.enabled = NO;
    }
    else{
        next_.enabled = YES;
        
    }
    if (currentPage_ == 1 ) {
        pre_.enabled = NO;
    }
    else{
        pre_.enabled = YES;
        
    }
    
}
-(void)episodesPlay:(id)sender{
    int playNum = ((UIButton *)sender).tag;
    
    [self Play:playNum-1];
    
}
@end
