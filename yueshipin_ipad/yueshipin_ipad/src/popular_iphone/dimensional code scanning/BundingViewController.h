//
//  BundingViewController.h
//  yueshipin
//
//  Created by 08 on 13-4-9.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FayeClient.h"
@interface BundingViewController : UIViewController <FayeClientDelegate>
{
    FayeClient * sendClient;
    FayeClient * listenClient;
    
    NSString   * userId;
}
@property (nonatomic, strong) NSString * strData;
@end
