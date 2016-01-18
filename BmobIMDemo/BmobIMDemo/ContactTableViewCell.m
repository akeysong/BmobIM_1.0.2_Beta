//
//  ContactTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-26.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "CommonUtil.h"


@implementation ContactTableViewCell

@synthesize addButton       = _addButton;
@synthesize nameLabel       = _nameLabel;
@synthesize lineImageView   = _lineImageView;
@synthesize avatarImageView = _avatarImageView;
@synthesize statueLabel     = _statueLabel;

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

-(UIButton*)addButton{
    if (!_addButton) {
        _addButton= [UIButton buttonWithType:UIButtonTypeCustom];
        
        [[_addButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
        [_addButton setTitleColor:RGB(71, 156, 245, 1.0) forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
    }
    
    return  _addButton;
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
-(UILabel*)statueLabel{
    if (!_statueLabel) {
        _statueLabel                 = [[UILabel alloc] init];
        _statueLabel.backgroundColor = [UIColor clearColor];
        _statueLabel.font            = [CommonUtil setFontSize:13];
        _statueLabel.textAlignment   = NSTextAlignmentLeft;
        _statueLabel.textColor       = RGB(136, 136, 136, 1.0f);//[CommonUtil setColorByR:136 G:136 B:136];
        [self.contentView addSubview:_statueLabel];
    }
    return _statueLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.addButton.frame = CGRectMake(220, 16, 80, 22);
    self.nameLabel.frame = CGRectMake(20, 16, 100, 22);
    
    self.lineImageView.frame = CGRectMake(0, self.frame.size.height-1, 320, 1);
    
    self.avatarImageView.frame = CGRectMake(20, 15, 50, 50);
    self.statueLabel.frame    = CGRectMake(220, 16, 60, 15);
}

@end
