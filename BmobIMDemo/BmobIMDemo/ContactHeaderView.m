//
//  ContactHeaderView.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-24.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "ContactHeaderView.h"

@implementation ContactHeaderView

@synthesize iconImageView = _iconImageView;
@synthesize titleLabel    = _titleLabel;
@synthesize lineImageView = _lineImageView;
@synthesize arrowImageView= _arrowImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView        = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font            = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment   = NSTextAlignmentLeft;
        _titleLabel.textColor       = RGB(60, 59, 57, 1.0f); //[CommonUtil setColorByR:60 G:59 B:57];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView        = [[UIImageView alloc] init];
        [self addSubview:_lineImageView];
    }
    
    return _lineImageView;
}

-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView        = [[UIImageView alloc] init];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconImageView.frame = CGRectMake(20, 11, 50, 50);
    self.titleLabel.frame    = CGRectMake(73, 27, 70, 17);
    self.lineImageView.frame = CGRectMake(0, 69, 320, 1);
    self.arrowImageView.frame= CGRectMake(301, 28, 9, 15);
}

@end
