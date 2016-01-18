//
//  EmojiView.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-30.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "EmojiView.h"
#import "CommonUtil.h"

@implementation EmojiView{

    UIScrollView    *_scrollView; //存放表情

}

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)createEmojiView{

    _scrollView                      = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _scrollView.backgroundColor      = [UIColor whiteColor];
    _scrollView.contentSize          = CGSizeMake(640, 100);
    _scrollView.pagingEnabled        = YES;
    [self addSubview:_scrollView];

    [self addEmojiButton:_scrollView];
}



-(void)addEmojiButton:(UIScrollView *)scrollView{
    NSMutableArray  *emojiBtnArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 6; j++) {
            UIButton *eBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [eBtn setFrame:CGRectMake(320/6*j, 50*i, 320/6, 50)];
            [emojiBtnArray addObject:eBtn];
            [scrollView addSubview:eBtn];
        }
    }
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 6; j++) {
            UIButton *eBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [eBtn setFrame:CGRectMake(320+320/6*j, 50*i, 320/6, 50)];
            [emojiBtnArray addObject:eBtn];
            [scrollView addSubview:eBtn];
        }
    }
    
    NSMutableArray  *emojiArray = [NSMutableArray arrayWithObjects:
                                   @"\ue415",@"\ue056",@"\ue057",@"\ue414",@"\ue405",@"\ue106",@"\ue418",
                                   @"\ue417",@"\ue40d",@"\ue40a",@"\ue404",@"\ue105",@"\ue409",@"\ue40e",
                                   @"\ue402",@"\ue108",@"\ue403",@"\ue058",@"\ue407",@"\ue401",@"\ue40f",
                                   @"\ue40b",@"\ue406",@"\ue413",@"\ue411",@"\ue412",
//                                   @"\ue410",@"\ue107",
//                                   @"\ue059",@"\ue416",@"\ue408",@"\ue40c",@"\ue00e",@"\ue421",@"\ue41f",
                                   nil];
    
    for (int i = 0; i < [emojiBtnArray count]; i++) {
        UIButton *eBtn      = [emojiBtnArray objectAtIndex:i];
        NSString    *emojbS = [emojiArray objectAtIndex:i];
        [eBtn setTitle:emojbS forState:UIControlStateNormal];
//         [[eBtn titleLabel] setFont:[UIFont systemFontOfSize:18]];
        eBtn.tag            = i;
        [eBtn addTarget:self action:@selector(addEmoji:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)addEmoji:(UIButton*)sender{
    
    
    NSMutableArray  *emojiArray = [NSMutableArray arrayWithObjects:
                                   @"\ue415",@"\ue056",@"\ue057",@"\ue414",@"\ue405",@"\ue106",@"\ue418",
                                   @"\ue417",@"\ue40d",@"\ue40a",@"\ue404",@"\ue105",@"\ue409",@"\ue40e",
                                   @"\ue402",@"\ue108",@"\ue403",@"\ue058",@"\ue407",@"\ue401",@"\ue40f",
                                   @"\ue40b",@"\ue406",@"\ue413",@"\ue411",@"\ue412",
//                                   @"\ue410",@"\ue107",
//                                   @"\ue059",@"\ue416",@"\ue408",@"\ue40c",@"\ue00e",@"\ue421",@"\ue41f",
                                   nil];
    

    
    
    NSString    *string = [emojiArray objectAtIndex:sender.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectEmojiView:emojiText:)]) {
//        NSData *data        = [string dataUsingEncoding:NSNonLossyASCIIStringEncoding];
//        NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [_delegate didSelectEmojiView:self emojiText:[CommonUtil escapeUnicodeString:string]];
    }

}

@end
