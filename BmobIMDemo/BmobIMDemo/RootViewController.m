//
//  RootViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "RootViewController.h"
#import "RecentViewController.h"
#import "ContactsViewController.h"
#import "SettingViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>
@end

@implementation RootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
//    [self.tabBar setHidden:YES];
//
//    self.delegate = self;
    
    
    
    
    UIImageView *barImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, 320, 49)];
    barImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    barImageView.userInteractionEnabled = true;
    barImageView.backgroundColor = [UIColor blueColor];
    barImageView.image = [UIImage imageNamed:@"foot_bar"];
    [self.tabBar addSubview:barImageView];
    
    [self performSelector:@selector(setUpViews) withObject:nil afterDelay:0.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpViews{
    
    [self.tabBar setHidden:NO];
    

    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(320/3*i, 0, 320/3, 49);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab_icon%d",(i+1)]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab_icon%d_",(i+1)]] forState:UIControlStateSelected];
        btn.tag = i+100;
        
        btn.exclusiveTouch = true;
        btn.userInteractionEnabled = YES;
        [[btn titleLabel] setTextAlignment:1];
        [btn setTitleColor:RGB(142.0f, 146.0f, 148.0f, 1.0f) forState:UIControlStateNormal];
        [btn setTitleColor:RGB(86.0f, 162.0f, 246.0f, 1.0f) forState:UIControlStateSelected];
        [[btn titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [btn addTarget:self action:@selector(didTapTabbar:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            btn.selected = YES;
            
        }
        
        [self.tabBar addSubview:btn];
    }
}

#pragma mark - button

-(void)didTapTabbar:(UIButton * )sender{

    for (int i= 0; i<3; i++) {
        UIButton  *btn = (UIButton*)[self.tabBar viewWithTag:100+i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    
    [self setSelectedIndex:sender.tag -100];
}



//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//   
//    
//    
//    UINavigationController *navigationViewController = (UINavigationController*)viewController;
//    
//    for (int i= 0; i<3; i++) {
//        UIButton  *btn = (UIButton*)[self.tabBar viewWithTag:100+i];
//        btn.selected = NO;
//        btn.userInteractionEnabled = YES;
//    }
//    
//    if ([[navigationViewController topViewController] isKindOfClass:[RecentViewController class]]) {
//        
//        UIButton  *btn = (UIButton*)[self.tabBar viewWithTag:100+0];
//        btn.selected = YES;
//        btn.userInteractionEnabled = NO;
//    }else if([[navigationViewController topViewController] isKindOfClass:[ContactsViewController class]]){
//        UIButton  *btn = (UIButton*)[self.tabBar viewWithTag:100+1];
//        btn.selected = YES;
//        btn.userInteractionEnabled = NO;
//    }else if([[navigationViewController topViewController] isKindOfClass:[SettingViewController class]]){
//        UIButton  *btn = (UIButton*)[self.tabBar viewWithTag:100+2];
//        btn.selected = YES;
//        btn.userInteractionEnabled = NO;
//    }
//    
//    
//}
@end
