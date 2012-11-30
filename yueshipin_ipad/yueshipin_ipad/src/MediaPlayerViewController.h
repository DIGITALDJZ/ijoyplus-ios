//
//  MediaPlayerViewController.h
//  ijoyplus
//
//  Created by joyplus1 on 12-10-31.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceListView.h"

@interface MediaPlayerViewController : UIViewController <DeviceListViewDelegate>

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *subname;
@property (nonatomic, assign)int type;
@property (nonatomic, strong)NSString *videoUrl;

@end
