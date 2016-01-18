//
//  EmojiView.h
//  BmobIMDemo
//
//  Created by Bmob on 14-6-30.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiViewDelegate;

@interface EmojiView : UIView{
    __weak id _delegate;
}

@property(weak,nonatomic)id <EmojiViewDelegate> delegate;


-(void)createEmojiView;

@end


@protocol EmojiViewDelegate <NSObject>

-(void)didSelectEmojiView:(EmojiView *)view emojiText:(NSString *)text;

@end