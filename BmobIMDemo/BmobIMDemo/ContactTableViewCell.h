//
//  ContactTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 14-6-26.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell


@property(nonatomic,strong)UIImageView      *avatarImageView;
@property(nonatomic,strong)UIButton         *addButton;
@property(nonatomic,strong)UILabel          *nameLabel;
@property(nonatomic,strong)UIImageView      *lineImageView;
@property(nonatomic,strong)UILabel          *statueLabel;

@end
