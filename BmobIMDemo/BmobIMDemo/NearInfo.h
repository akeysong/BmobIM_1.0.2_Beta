//
//  NearInfo.h
//  BmobIMDemo
//
//  Created by Bmob on 14-7-26.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearInfo : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *lastTime;
@property (copy, nonatomic) NSString *avatarString;
@property (copy, nonatomic) NSString *objectId;
@property (assign)BOOL sex;
@end
