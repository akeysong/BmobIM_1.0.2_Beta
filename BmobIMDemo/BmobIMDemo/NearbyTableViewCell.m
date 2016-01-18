//
//  NearbyTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "NearbyTableViewCell.h"
#import "CommonUtil.h"

@implementation NearbyTableViewCell

@synthesize avatarImageView = _avatarImageView;
@synthesize nameLabel       = _nameLabel;
@synthesize distanceLabel   = _distanceLabel;
@synthesize lastTimeLabel   = _lastTimeLabel;
@synthesize lineImageView   = _lineImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel*)nameLabel{
    if (!_nameLabel) {
        _nameLabel                 = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor       = RGB(60, 60, 60, 1.0f);
        _nameLabel.font            = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

-(UIImageView*)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_lineImageView];
    }
    
    return _lineImageView;
}


-(UIImageView*)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:10];
        [self.contentView addSubview:_avatarImageView];
    }
    
    return _avatarImageView;
}
-(UILabel*)lastTimeLabel{
    if (!_lastTimeLabel) {
        _lastTimeLabel                 = [[UILabel alloc] init];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
        _lastTimeLabel.font            = [CommonUtil setFontSize:13];
        _lastTimeLabel.textAlignment   = NSTextAlignmentLeft;
        _lastTimeLabel.textColor       = RGB(136, 136, 136, 1.0f);//[CommonUtil setColorByR:136 G:136 B:136];
        [self.contentView addSubview:_lastTimeLabel];
    }
    return _lastTimeLabel;
}

-(UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel                 = [[UILabel alloc] init];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.font            = [CommonUtil setFontSize:13];
        _distanceLabel.textAlignment   = NSTextAlignmentRight;
        _distanceLabel.textColor       = RGB(30, 30, 30, 1.0f);//[CommonUtil setColorByR:136 G:136 B:136];
        [self.contentView addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.nameLabel.frame       = CGRectMake(90, 16, 100, 22);
    self.distanceLabel.frame   = CGRectMake(200, 16, 100, 22);
    self.lineImageView.frame   = CGRectMake(0, self.frame.size.height-1, 320, 1);
    self.avatarImageView.frame = CGRectMake(20, 15, 50, 50);
    self.lastTimeLabel.frame   = CGRectMake(90, 50, 200, 15);
}

@end
