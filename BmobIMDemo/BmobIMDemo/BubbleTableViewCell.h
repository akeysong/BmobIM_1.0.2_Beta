//
//  BubbleTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 14-6-30.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) UIImageView *bubbleView;
@property (nonatomic,strong) UILabel     *contentLabel;
@property (assign)           BOOL        fromSelf;
@property (assign)           NSInteger   type;

@end
