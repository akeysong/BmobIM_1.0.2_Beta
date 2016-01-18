//
//  AppDelegate.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-24.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobIM/BmobChat.h>
#import <BmobIM/BmobDB.h>
#import <BmobIM/BmobChatManager.h>
#import <BmobIM/BmobIM.h>
#import "RecentViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"
#import "RootViewController.h"
#import <BmobSDK/BmobGPSSwitch.h>
#import "BMapKit.h"

#import "CommonUtil.h"


@interface AppDelegate (){

    BMKMapManager *_mapManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (IS_iOS8) {
        //iOS8推送
        UIMutableUserNotificationCategory*categorys = [[UIMutableUserNotificationCategory alloc]init];
        categorys.identifier=@"BmobIMDemo";
        UIUserNotificationSettings*userNotifiSetting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound)
                                                                                         categories:[NSSet setWithObjects:categorys,nil]];
        [[UIApplication sharedApplication]registerUserNotificationSettings:userNotifiSetting];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }else{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    [[NSUserDefaults standardUserDefaults ] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    
    //用户存在就创建数据库
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        BmobDB *db = [BmobDB currentDatabase];
        [db createDataBase];
    }else{
    
    }
    
    if (IS_iOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    [BmobGPSSwitch gpsSwitch:NO];
    
    RecentViewController *rvc            = [[RecentViewController alloc] init];
    UINavigationController *rnc          = [[UINavigationController alloc] initWithRootViewController:rvc];
    ContactsViewController *cvc          = [[ContactsViewController alloc] init];
    UINavigationController *cnc          = [[UINavigationController alloc] initWithRootViewController:cvc];
    SettingViewController *svc           = [[SettingViewController alloc] init];
    UINavigationController *snc          = [[UINavigationController alloc] initWithRootViewController:svc];

    RootViewController *tabBarController = [[RootViewController alloc] init];

    if (IS_iOS7) {
        [rnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
        [cnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
        [snc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [rnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar1"] forBarMetrics:UIBarMetricsDefault];
        [cnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar1"] forBarMetrics:UIBarMetricsDefault];
        [snc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar1"] forBarMetrics:UIBarMetricsDefault];
    }
    [tabBarController setViewControllers:@[rnc,cnc,snc]];
    self.window.rootViewController       = tabBarController;
    [self.window makeKeyAndVisible];
    //百度地图
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"6xlUDIyKNzThyF84lV9zfsTp" generalDelegate:nil];
    if (!ret) {
        //        NSLog(@"manager start failed!");
    }
    

    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark remote notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken %@",deviceToken);
    
    [BmobChat regisetDeviceWithDeviceToken:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"selfDeviceToken"];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo is :%@",[userInfo description]);
    
    if ([userInfo objectForKey:@"tag"]) {
        if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@"add"]) {
            [self saveInviteMessageWithAddTag:userInfo];
            [BmobPush handlePush:userInfo];
        } else if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@"agree"]) {
            [self saveInviteMessageWithAgreeTag:userInfo];
        } else if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@""]) {
            [self saveMessageWith:userInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecieveUserMessage" object:userInfo];
        }
    }
    
}

#pragma mark save
-(void)saveInviteMessageWithAddTag:(NSDictionary *)userInfo{
    BmobInvitation *invitation = [[BmobInvitation alloc] init];
    invitation.avatar          = [[userInfo objectForKey:PUSH_ADD_FROM_AVATAR] description];
    invitation.fromId          = [[userInfo objectForKey:PUSH_ADD_FROM_ID] description];
    invitation.fromname        = [[userInfo objectForKey:PUSH_ADD_FROM_NAME] description];
    invitation.nick            = [[userInfo objectForKey:PUSH_ADD_FROM_NICK] description];
    invitation.time            = [[userInfo objectForKey:PUSH_ADD_FROM_TIME] integerValue];
    invitation.statue          = STATUS_ADD_NO_VALIDATION;
    [[BmobDB currentDatabase] saveInviteMessage:invitation];
}

-(void)saveInviteMessageWithAgreeTag:(NSDictionary *)userInfo{
    BmobInvitation *invitation = [[BmobInvitation alloc] init];
    invitation.avatar          = [[userInfo objectForKey:PUSH_ADD_FROM_AVATAR] description];
    invitation.fromId          = [[userInfo objectForKey:PUSH_ADD_FROM_ID] description];
    invitation.fromname        = [[userInfo objectForKey:PUSH_ADD_FROM_NAME] description];
    invitation.nick            = [[userInfo objectForKey:PUSH_ADD_FROM_NICK] description];
    invitation.time            = [[userInfo objectForKey:PUSH_ADD_FROM_TIME] integerValue];
    invitation.statue          = STATUS_ADD_AGREE;
    
    [[BmobDB currentDatabase] saveInviteMessage:invitation];
    [[BmobDB currentDatabase] saveContactWithMessage: invitation];
    
    //添加到用户的好友关系中
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        BmobUser *friendUser   = [BmobUser objectWithoutDatatWithClassName:@"User" objectId:invitation.fromId];
        BmobRelation *relation = [BmobRelation relation];
        [relation addObject:friendUser];
        [user addRelation:relation forKey:@"contacts"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                NSLog(@"\n error is :%@",[error description]);
            }
        }];
    }
    
}

-(void)saveMessageWith:(NSDictionary *)userInfo{
    
    BmobChatUser *user = [[BmobDB currentDatabase] queryUserWithUid:[[userInfo objectForKey:PUSH_KEY_TARGETID] description]];
    
    NSString *content = [userInfo objectForKey:PUSH_KEY_CONTENT];
    NSString *toid    = [[userInfo objectForKey:PUSH_KEY_TOID] description];
    int type          = MessageTypeText;
    if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
        type = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
    }
    
     
    BmobMsg *msg      = [BmobMsg createReceiveWithUser:user
                                          content:content
                                             toId:toid
                                             time:[[userInfo objectForKey:PUSH_KEY_MSGTIME] description]
                                             type:type status:STATUS_RECEIVER_SUCCESS];
    
    [[BmobDB currentDatabase] saveMessage:msg];
    
    //更新最新的消息
    BmobRecent *recent = [BmobRecent recentObejectWithAvatarString:user.avatar
                                                           message:msg.content
                                                              nick:user.nick
                                                          targetId:msg.belongId
                                                              time:[msg.msgTime integerValue]
                                                              type:msg.msgType
                                                        targetName:user.username];
    
    [[BmobDB currentDatabase] performSelector:@selector(saveRecent:) withObject:recent afterDelay:0.3f];
}

@end
