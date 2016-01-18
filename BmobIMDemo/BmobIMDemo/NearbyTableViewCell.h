//
//  NearbyTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 14-7-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (strong, nonatomic) UILabel     *distanceLabel;
@property (strong, nonatomic) UILabel     *lastTimeLabel;
@property (nonatomic, strong) UIImageView *lineImageView;

@end
