//
//  BubbleTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-30.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "BubbleTableViewCell.h"
#import "CommonUtil.h"
#import <BmobIM/BmobIM.h>

@implementation BubbleTableViewCell

@synthesize timeLabel           = _timeLabel;
@synthesize headImageView       = _headImageView;
@synthesize contentLabel        = _contentLabel;
@synthesize bubbleView          = _bubbleView;
@synthesize fromSelf            = _fromSelf;
@synthesize contentImageView    = _contentImageView;

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

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [CommonUtil setFontSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.frame = CGRectMake(0, 8, 320, 15);
//        _timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[message.msgTime integerValue]] timeAgoWithLimit:kTimeLimit dateFormat:NSDateFormatterMediumStyle andTimeFormat:NSDateFormatterShortStyle];
        _timeLabel.textColor = [CommonUtil setColorByR:136 G:136 B:136];
        [self.contentView addSubview:_timeLabel];
    }
    
    return _timeLabel;
}

-(UIImageView*)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [_headImageView.layer setMasksToBounds:YES];
        [_headImageView.layer setCornerRadius:24];
        [self.contentView addSubview:_headImageView];
    }
    
    return _headImageView;
}


-(UIImageView *)bubbleView{
    if (!_bubbleView) {
        _bubbleView = [[UIImageView alloc] init];
        [self.contentView addSubview: _bubbleView ];
    }
    
    return _bubbleView;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [CommonUtil setFontSize:16];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    
    return _contentLabel;
}

-(UIImageView *)contentImageView{
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_contentImageView];
    }
    
    return _contentImageView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.type == MessageTypeText) {
        NSString    *text = [CommonUtil turnStringToEmojiText:self.contentLabel.text];
        CGSize  contentSize = [text sizeWithFont:[CommonUtil setFontSize:16] constrainedToSize:CGSizeMake(135, 1000) lineBreakMode:1];
        
        if (self.fromSelf) {
            [self.contentLabel setTextColor:[UIColor whiteColor]];
            self.bubbleView.frame =  CGRectMake(320-72-(contentSize.width + 33), 11+17, contentSize.width + 33, contentSize.height + 20+17);
            self.contentLabel.frame     = CGRectMake(self.bubbleView.frame.origin.x + 13, self.bubbleView .frame.origin.y + 8, self.bubbleView.frame.size.width - 30, self.bubbleView.frame.size.height-15);
            self.headImageView.frame   = CGRectMake(260, self.bubbleView.frame.size.height-15, 48.0f, 48.0f);
        }else{
            [self.contentLabel setTextColor:[CommonUtil setColorByR:55 G:59 B:60]];
            self.bubbleView.frame = CGRectMake(71, 11+17, contentSize.width + 33, contentSize.height + 20+17);
            self.contentLabel.frame     = CGRectMake(self.bubbleView.frame.origin.x + 15, self.bubbleView.frame.origin.y + 10, self.bubbleView.frame.size.width - 30, self.bubbleView.frame.size.height-15);
            self.headImageView.frame   = CGRectMake(13, self.bubbleView.frame.size.height -15 , 48.0f, 48.0f);
        }
    }
    
    if (self.type == MessageTypeImage || self.type == MessageTypeLocation) {
        CGSize  contentSize = CGSizeMake(120, 120);
        if (self.fromSelf) {
            [self.contentLabel setTextColor:[UIColor whiteColor]];
            self.bubbleView.frame =  CGRectMake(320-72-(contentSize.width + 33), 11+17, contentSize.width + 33, contentSize.height + 20+17);
            self.contentImageView.frame     = CGRectMake(self.bubbleView.frame.origin.x + 13, self.bubbleView .frame.origin.y + 18, 120, 120);
            self.headImageView.frame   = CGRectMake(260, self.bubbleView.frame.size.height-15, 48.0f, 48.0f);
        }else{
            [self.contentLabel setTextColor:[CommonUtil setColorByR:55 G:59 B:60]];
            self.bubbleView.frame = CGRectMake(71, 11+17, contentSize.width + 33, contentSize.height + 20+17);
            self.contentImageView.frame     = CGRectMake(self.bubbleView.frame.origin.x + 15, self.bubbleView.frame.origin.y + 18, 120, 120);
            self.headImageView.frame   = CGRectMake(13, self.bubbleView.frame.size.height -15 , 48.0f, 48.0f);
        }
    }
    
}

@end
