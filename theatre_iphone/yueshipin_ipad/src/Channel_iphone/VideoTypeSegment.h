//
//  VideoTypeSegment.h
//  theatreiphone
//
//  Created by Rong on 13-5-14.
//  Copyright (c) 2013年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoTypeSegmentDelegate <NSObject>
<<<<<<< HEAD
-(void)segmentDidSelectedAtIndex:(int)index;
=======
-(void)videoTypeSegmentDidSelectedAtIndex:(int)index;
>>>>>>> iphone code commit
@end


@interface VideoTypeSegment : UIView
@property (nonatomic, weak) id <VideoTypeSegmentDelegate>delegate;

-(void)setSelectAtIndex:(int)index;
@end

