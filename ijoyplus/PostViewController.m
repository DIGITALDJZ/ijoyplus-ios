//
//  PostViewController.m
//  ijoyplus
//
//  Created by joyplus1 on 12-9-25.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "PostViewController.h"
#import "CustomBackButtonHolder.h"
#import "CustomBackButton.h"
#import "UIUtility.h"
#import "CMConstants.h"
#import "ContainerUtility.h"
#import "SinaLoginViewController.h"
#import "TecentViewController.h"
#import "AFSinaWeiboAPIClient.h"
#import "CacheUtility.h"

#define  TEXT_MAX_COUNT 140

@interface PostViewController (){
    UIButton *btn1;
    int btn1ClickedNum;
    UIButton *btn2;
    int btn2ClickedNum;
}
@property (strong, nonatomic) IBOutlet UILabel *textCount;

@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (void)startObservingNotifications;
- (void)stopObservingNotifications;
- (void)didReceiveTextDidChangeNotification:(NSNotification*)notification;
- (void)updateCount;
@end

@implementation PostViewController
@synthesize textCount;
@synthesize tipLabel;
@synthesize toolBar;
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"share", nil);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    CustomBackButtonHolder *backButtonHolder = [[CustomBackButtonHolder alloc]initWithViewController:self];
    CustomBackButton* backButton = [backButtonHolder getBackButton:NSLocalizedString(@"go_back", nil)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"post", nil) style:UIBarButtonSystemItemSearch target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self initToolBar];
}

- (void)viewDidUnload
{
    btn1 = nil;
    btn2 = nil;
    [self setTextView:nil];
    [self setToolBar:nil];
    [self setTextCount:nil];
    [self stopObservingNotifications];
    [self setTipLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    self.textCount.text = [NSString stringWithFormat:@"%i", TEXT_MAX_COUNT];
    [self updateCount];
    [self startObservingNotifications];
    [self.textView becomeFirstResponder];
}

- (void)closeSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initToolBar
{
    UIImage *toobarImage = [UIUtility createImageWithColor:[UIColor blackColor]];
    [self.toolBar setBackgroundImage:toobarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setFrame:CGRectMake(0, 0, 78, self.toolBar.frame.size.height)];
    [btn1 setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [UIUtility addTextShadow:btn1.titleLabel];
    btn1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [btn1 setBackgroundImage:[[UIImage imageNamed:@"reg_btn_normal"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(sinaLoginScreen)forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setFrame:CGRectMake(80, 0, 78, self.toolBar.frame.size.height)];
    [btn2 setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [UIUtility addTextShadow:btn2.titleLabel];
    btn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [btn2 setBackgroundImage:[[UIImage imageNamed:@"log_btn_normal"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(tencentLoginScreen)forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:btn2];
}

- (void)startObservingNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)stopObservingNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveTextDidChangeNotification:(NSNotification*)notification
{
    [self updateCount];
}

- (void)updateCount
{
    NSUInteger count = [self.textView.text length];
    self.textCount.text = [NSString stringWithFormat:@"%d", TEXT_MAX_COUNT-count];
    
    if(count > TEXT_MAX_COUNT){
        self.tipLabel.text = NSLocalizedString(@"tip_text", nil);
        self.textCount.textColor = [UIColor redColor];
        self.textCount.text =  [NSString stringWithFormat:@"%d", -TEXT_MAX_COUNT+count];
    }
    
}

- (void)sinaLoginScreen
{
    NSNumber *num = (NSNumber *)[[ContainerUtility sharedInstance]attributeForKey:kSinaUserLoggedIn];
    if([num boolValue]){
        if(btn1ClickedNum % 2 == 0){
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        } else {
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
        btn1ClickedNum++;
    } else{
        SinaLoginViewController *viewController = [[SinaLoginViewController alloc]init];
        viewController.fromController = @"PostViewController";
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)tencentLoginScreen
{
    NSNumber *num = (NSNumber *)[[ContainerUtility sharedInstance]attributeForKey:kTencentUserLoggedIn];
    if([num boolValue]){
        if(btn2ClickedNum % 2 == 1){
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        } else {
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[[UIImage imageNamed:@"log_btn_active"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
        btn2ClickedNum++;
    } else{
        TecentViewController *viewController = [[TecentViewController alloc] init];
        viewController.fromController = @"PostViewController";
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)post
{
    if(btn1ClickedNum % 2 == 1){
        WBEngine *engineer = [[CacheUtility sharedCache] getSinaWeiboEngineer];
        [engineer sendWeiBoWithText:self.textView.text image:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(btn2ClickedNum % 2 == 1){
        
    }
}
@end
