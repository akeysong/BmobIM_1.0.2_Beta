//
//  NextViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController

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
        self.navigationItem.hidesBackButton   = YES;
        UIButton *leftBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame                         = CGRectMake(0, 0, 50, 44);
        leftBtn.showsTouchWhenHighlighted     = YES;
        [leftBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
        
        UIBarButtonItem *leftBarButtonItem    = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        
        if (IS_iOS7) {
            [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
