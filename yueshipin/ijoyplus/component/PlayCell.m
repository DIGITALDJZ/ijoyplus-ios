//
//  PlayCell.m
//  ijoyplus
//
//  Created by joyplus1 on 12-9-11.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "PlayCell.h"

@implementation PlayCell
@synthesize filmImageView;
@synthesize filmTitleLabel;
@synthesize introuctionBtn;
@synthesize publicLabel;
@synthesize scoreImageView;
@synthesize likeImageView;
@synthesize watchedImageView;
@synthesize collectionImageView;
@synthesize scoreLabel;
@synthesize likeLabel;
@synthesize watchedLabel;
@synthesize collectionLabel;
@synthesize playBtn;
@synthesize playImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
