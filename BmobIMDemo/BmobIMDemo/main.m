//
//  main.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-24.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <BmobIM/BmobChat.h>
    
int main(int argc, char * argv[])
{
#warning 填入自己应用appkey 
    [BmobChat registerAppWithAppKey:@"bb503e4e9939b5424c6a3d437d82a3f8"];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
