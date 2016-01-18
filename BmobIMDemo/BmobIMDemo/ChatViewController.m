//
//  ChatViewController.m
//  XueHang
//
//  Created by Bmob on 14-6-5.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "ChatViewController.h"
#import "CommonUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import <BmobIM/BmobDB.h>
#import <BmobIM/BmobChatManager.h>
#import "BubbleTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "EmojiView.h"
#import "ChatFootbarView.h"
#import "LocationViewController.h"
#import "LocateViewController.h"


@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,EmojiViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITableView             *_chatTableView;
    EmojiView               *_emojiView;//表情
    ChatFootbarView         *_footbarView;//照片，照相，地理位置
    
    UITextField             *_chatTextField;
    UIView                  *_bottomView;//底部
    
    NSMutableArray          *_chatArray;
    BOOL                    _isFished;
    NSUInteger              _page;
    NSUInteger              _totalCount;
    
//    NSString                *_otherUid;
//    NSString                *_otherUsername;
    
    NSMutableDictionary     *_infoDic;
    BmobChatUser            *_chatUser;
}

@end

@implementation ChatViewController

#define kHideButtonTag 800000
#define kTimeLimit 60*60*24*2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithUserDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        _infoDic = [[NSMutableDictionary alloc] init];
        if (dic) {
            [_infoDic setDictionary:dic];
        }
        _chatUser = [[BmobChatUser alloc] init];
        _chatUser.objectId = [[dic objectForKey:@"uid"] description];
        _chatUser.username = [dic objectForKey:@"name"];
        _chatUser.avatar   = [dic objectForKey:@"avatar"];
        if (_chatUser.username) {
            self.navigationItem.titleView          = [CommonUtil navigationTitleViewWithTitle:_chatUser.username];
        }else{
            self.navigationItem.titleView          = [CommonUtil navigationTitleViewWithTitle:@"聊天"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor        =  [CommonUtil setColorByR:241 G:242 B:246];
    _chatTableView                = [[UITableView alloc] initWithFrame:CGRectMake(0, ViewOriginY, 320, ScreenHeight-64-44) style:UITableViewStylePlain];
    _chatTableView.dataSource     = self;
    _chatTableView.delegate       = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.backgroundColor =[UIColor clearColor];
    _chatTableView.backgroundView = nil;
    [self.view addSubview:_chatTableView];
    //建立子view
    [self setupViews];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:@"DidRecieveUserMessage" object:nil];
    //
    _chatArray  = [[NSMutableArray alloc] init];
    _page       = 0;
    _totalCount = 0;
    _isFished   = NO;
    //查询本地的消息
    [self performSelector:@selector(searchMessages) withObject:nil afterDelay:0.3f];
    
   
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
   
}

-(void)goback{
    
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidRecieveUserMessage" object:nil];
    [super goback];
    _chatTableView.dataSource = nil;
    _chatTableView.delegate   = nil;
    _chatArray                = nil;
    _chatUser                 = nil;
}



#pragma mark - someaction

-(void)searchMessages{
    NSString *targetId = _chatUser.objectId;
    NSArray *array = [[BmobDB currentDatabase] queryMessagesWithUid:targetId page:0];
    if (array && [array count] > 0) {
        [_chatArray setArray:array];
        [_chatTableView reloadData];
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    //总数
    _totalCount = [[BmobDB currentDatabase] queryChatTotalCountWithUid:targetId];
}

-(void)loadNext{

    //总数
    _totalCount = [[BmobDB currentDatabase] queryChatTotalCountWithUid:_chatUser.objectId];
    if ([_chatArray count] > _totalCount) {
        return;
    }
    if (_isFished == YES) {
        return;
    }
    _isFished          = YES;
    NSString *targetId = _chatUser.objectId;
    
    NSArray *array = [[BmobDB currentDatabase] queryMessagesWithUid:targetId page:_page +1];
    if (array && [array count] > 0) {
        [_chatArray setArray:array];
        [_chatTableView reloadData];
        
        if ([_chatArray count] < _totalCount) {
            _isFished = NO;
            _page ++;
        }else{
            _isFished = YES;
        }
    }
    
}



-(void)setupViews{
    CGFloat bottomViewOrginY = 0.0f;
    
    if (IS_iOS7) {
        bottomViewOrginY = ScreenHeight-44;
    }else{
        bottomViewOrginY = ScreenHeight -64-44;
    }
    
    _bottomView                           = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewOrginY, 320, 144)];
    [self.view addSubview:_bottomView];

    UIImageView *backgroundImageView      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    backgroundImageView.image             = [UIImage imageNamed:@"chat_db_bar"];
    [_bottomView addSubview:backgroundImageView];

    //表情
    UIButton    *emojiButton              = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiButton.tag                       = 100;
    [emojiButton setFrame:CGRectMake(5, 0, 50, 44)];
    [emojiButton addTarget:self action:@selector(showBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [emojiButton setImage:[UIImage imageNamed:@"chat_icon2"] forState:UIControlStateNormal];
    [emojiButton setImage:[UIImage imageNamed:@"chat_icon2_"] forState:UIControlStateHighlighted];
    [_bottomView addSubview:emojiButton];

    //照相、相册、地理位置
    UIButton    *barButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.tag                         = 101;
    [barButton setFrame:CGRectMake(50, 0, 50, 44)];
    [barButton addTarget:self action:@selector(showBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [barButton setImage:[UIImage imageNamed:@"chat_icon1"] forState:UIControlStateNormal];
    [barButton setImage:[UIImage imageNamed:@"chat_icon1_"] forState:UIControlStateHighlighted];
    [_bottomView addSubview:barButton];

    UIImageView *inputBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 8, 170, 30)];
    inputBackgroundImageView.image        = [UIImage imageNamed:@"chat_input"];
    [_bottomView addSubview:inputBackgroundImageView];

    //输入框
    _chatTextField                        = [[UITextField alloc] initWithFrame:CGRectMake(98, 13, 150, 25)];
    _chatTextField.font                   = [CommonUtil setFontSize:15];
    _chatTextField.delegate               = self;
    _chatTextField.returnKeyType          = UIReturnKeySend;
    [_bottomView addSubview:_chatTextField];

    //表情
    UIButton    *voiceButton              = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.tag                       = 100;
    [voiceButton setFrame:CGRectMake(260, 0, 50, 44)];
    [voiceButton addTarget:self action:@selector(showBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButton setImage:[UIImage imageNamed:@"chat_icon3"] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:@"chat_icon3_"] forState:UIControlStateHighlighted];
    [_bottomView addSubview:voiceButton];
    
    //表情
    _emojiView                            = [[EmojiView alloc] initWithFrame:CGRectMake(0, 44, 320, 100)];
    _emojiView.backgroundColor            = [UIColor whiteColor];
    _emojiView.delegate                   = self;
    [_emojiView createEmojiView];
    [_bottomView addSubview:_emojiView];

    //选项
    _footbarView                          = [[ChatFootbarView alloc] initWithFrame:CGRectMake(0, 44, 320, 100)];
    _footbarView.backgroundColor          = [UIColor whiteColor];
    [_bottomView addSubview:_footbarView];
    [_footbarView.libButton addTarget:self action:@selector(photoLib) forControlEvents:UIControlEventTouchUpInside];
    _footbarView.libLabel.text            = @"相册";
    [_footbarView.takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    _footbarView.takeLabel.text           = @"照相";
    [_footbarView.locationButton addTarget:self action:@selector(sendPosition) forControlEvents:UIControlEventTouchUpInside];
    _footbarView.locationLabel.text       = @"位置";

    //隐藏
    UIButton *hideKeyBoardButton          = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyBoardButton.frame              = CGRectMake(0, ViewOriginY, 320, _bottomView.frame.origin.y-ViewOriginY);
    hideKeyBoardButton.tag                = kHideButtonTag;
    hideKeyBoardButton.alpha              = 0.0f;
    [hideKeyBoardButton addTarget:self action:@selector(hideBottomView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideKeyBoardButton];


    MBProgressHUD *hud                    = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag                               = kMBProgressTag;
    [self.view addSubview:hud];
    
}


-(void)showBottomView:(UIButton*)sender{
    
    if (sender.tag == 100) {
        _emojiView.hidden   = NO;
        _footbarView.hidden = YES;
    }else{
        _emojiView.hidden   = YES;
        _footbarView.hidden = NO;
    }
    
    [self showBottomView];
    
}


-(void)showBottomView{
    
    [self.view endEditing:YES];
    CGFloat bottomViewOrginY = 0.0f;
    if (IS_iOS7) {
        bottomViewOrginY = ScreenHeight-144;
    }else{
        bottomViewOrginY = ScreenHeight - 64-144;
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        [_bottomView setFrame:CGRectMake(0, bottomViewOrginY, 320, 144)];
    }];

    UIButton *hideKeyBoardButton =(UIButton*) [self.view viewWithTag:kHideButtonTag];
    hideKeyBoardButton.alpha = 1.0f;
    hideKeyBoardButton.frame = CGRectMake(0, ViewOriginY, 320, _bottomView.frame.origin.y-ViewOriginY);
}

-(void)hideBottomView{
    [self.view endEditing:YES];
    CGFloat bottomViewOrginY = 0.0f;
    if (IS_iOS7) {
        bottomViewOrginY = ScreenHeight-44;
    }else{
        bottomViewOrginY = ScreenHeight - 64-44;
    }
    [UIView animateWithDuration:0.4f animations:^{
        [_bottomView setFrame:CGRectMake(0, bottomViewOrginY, 320, 144)];
    }];
    
    UIButton *hideKeyBoardButton =(UIButton*) [self.view viewWithTag:kHideButtonTag];
    hideKeyBoardButton.alpha = 0.0f;
    hideKeyBoardButton.frame = CGRectMake(0, ViewOriginY, 320, _bottomView.frame.origin.y-ViewOriginY);
}

//浮动编辑框
-(void)keyboardFrameChange:(NSNotification*)noti{
    
    if (noti) {
        NSValue *keyboardBoundsValue = [[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
        
        CGFloat bottomViewOrginY = 0.0f;
        if (IS_iOS7) {
            bottomViewOrginY = ScreenHeight-44-keyboardEndRect.size.height;
        }else{
            bottomViewOrginY = ScreenHeight-64-44-keyboardEndRect.size.height;
        }
        
        [UIView animateWithDuration:0.4f animations:^{
            [_bottomView setFrame:CGRectMake(0, bottomViewOrginY, 320, 200)];
        }];
        
        UIButton *hideKeyBoardButton =(UIButton*) [self.view viewWithTag:kHideButtonTag];
        hideKeyBoardButton.alpha = 1.0f;
        hideKeyBoardButton.frame = CGRectMake(0, ViewOriginY, 320, _bottomView.frame.origin.y-ViewOriginY);
    }
    
}

#pragma mark chat
//接收到消息
-(void)didReceiveNewMessage:(NSNotification *)noti{
    
    NSDictionary *userInfo = [noti object];
    
    if ([[[userInfo objectForKey:PUSH_KEY_TARGETID] description] isEqualToString:_chatUser.objectId] && [[[userInfo objectForKey:PUSH_KEY_TOID] description] isEqualToString:[BmobUser getCurrentUser].objectId]) {
        BmobMsg *msg             = [[BmobMsg alloc] init];
        msg.belongAvatar         = [[_infoDic objectForKey:@"avatar"] description];
        msg.belongId             = [[userInfo objectForKey:PUSH_KEY_TARGETID] description];
        msg.belongNick           =[[userInfo objectForKey:PUSH_KEY_TARGETNICK] description];
        msg.belongUsername       = [[userInfo objectForKey:PUSH_KEY_TARGETUSERNAME] description];
        msg.content              = [userInfo objectForKey:PUSH_KEY_CONTENT];
        msg.isReaded             = STATE_UNREAD;
        NSString *conversationId = [NSString stringWithFormat:@"%@&%@",msg.belongId,[BmobUser getCurrentUser].objectId];
        msg.conversationId       = conversationId;
        msg.msgTime              = [userInfo objectForKey:PUSH_KEY_MSGTIME];
        if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
            msg.msgType = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
        }
        msg.status = STATUS_RECEIVER_SUCCESS;
        
        [_chatArray addObject:msg];
        [_chatTableView reloadData];
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}

//
-(void)updateTableViewBySendMessageContent:(NSString *)text{

    [self sendMessageWithContent:text  type:MessageTypeText];
}


//发送消息(文本/位置)
-(void)sendMessageWithContent:(NSString *)content type:(NSInteger)type{
    BmobMsg *msg             = [BmobMsg createAMessageWithType:type statue:STATUS_SEND_SUCCESS content:content targetId:_chatUser.objectId];
    
    [_chatArray addObject:msg];
    [_chatTableView reloadData];
    
    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self hideBottomView];
    msg.status = STATUS_SEND_SUCCESS;
    [[BmobChatManager currentInstance] sendMessageWithUser:_chatUser
                                                   message:msg
                                                     block:^(BOOL isSuccessful, NSError *error) {
 
                                                     }];
}

#pragma mark footbar
//相册
-(void)photoLib{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}
//拍照
-(void)takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing            = YES;
    picker.delegate                 = self;
    [self performSelector:@selector(presentImagePickerController:) withObject:picker afterDelay:.5f];
}
//发送位置
-(void)sendPosition{
    LocateViewController *lvc = [[LocateViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
    [self hideBottomView];
}


-(void)location:(CLLocationCoordinate2D)coor address:(NSString *)address{
   
    NSString *content = [NSString stringWithFormat:@"%@&%f&%f",address,coor.latitude,coor.longitude];
    [self sendMessageWithContent:content type:MessageTypeLocation];
//    NSLog(@"address:%@",address);
}


-(void)presentImagePickerController:(UIImagePickerController *)picker{
    [self.navigationController presentViewController:picker animated:YES completion:^{
        [self hideBottomView];
    }];
}

#pragma mark emojiview delegate

-(void)didSelectEmojiView:(EmojiView *)view emojiText:(NSString *)text{
    [self.view endEditing:YES];
    [_chatTextField setTextColor:[UIColor blackColor]];

    _chatTextField.text = [_chatTextField.text stringByAppendingString:text];
//    _chatTextField.text = [CommonUtil turnStringToEmojiText:_chatTextField.text];
}

#pragma mark textField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIButton *hideKeyBoardButton =(UIButton*) [self.view viewWithTag:kHideButtonTag];
    hideKeyBoardButton.alpha = 1.0f;
    hideKeyBoardButton.frame = CGRectMake(0, ViewOriginY, 320, _bottomView.frame.origin.y-ViewOriginY);
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self updateTableViewBySendMessageContent:textField.text];

    textField.text = @"";
    return YES;
}

#pragma mark - UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobMsg  *dic       =(BmobMsg*) [_chatArray objectAtIndex:indexPath.row];
    if (dic.msgType == MessageTypeText) {
        NSString *text      = [CommonUtil turnStringToEmojiText:dic.content];
        CGSize  contentSize = [text sizeWithFont:[CommonUtil setFontSize:16] constrainedToSize:CGSizeMake(135, 1000) lineBreakMode:1];
        return contentSize.height+75;
    }else if (dic.msgType == MessageTypeImage){
        return 195;
    }else if (dic.msgType == MessageTypeLocation){
        return 195;
    }
   
    return 145;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chatArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    BubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell                             = [[BubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle              = UITableViewCellSelectionStyleNone;
        cell.backgroundColor             = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    BmobMsg *message = ( BmobMsg *)[_chatArray objectAtIndex:indexPath.row];
    BOOL fromSelf =NO;
    NSArray *nameArray = [message.conversationId componentsSeparatedByString:@"&"];
    if ([[nameArray firstObject] isEqualToString:[BmobUser getCurrentUser].objectId]) {
        fromSelf = YES;
    }else{
        fromSelf = NO;
    }
    cell.type = message.msgType;
    cell.fromSelf = fromSelf;
    if (fromSelf ) {
        message.belongAvatar = [[BmobUser getCurrentUser] objectForKey:@"avatar"];
        cell.bubbleView.image = [[UIImage imageNamed:@"chat_self"] stretchableImageWithLeftCapWidth:18.5 topCapHeight:15];
    }else{
        message.belongAvatar = [[_infoDic objectForKey:@"avatar"] description];
        cell.bubbleView.image = [[UIImage imageNamed:@"chat_other"] stretchableImageWithLeftCapWidth:22 topCapHeight:15];
    }
    
    if (message.msgType == MessageTypeText) {
        cell.contentImageView.image = nil;
         cell.contentLabel.text = [CommonUtil turnStringToEmojiText:message.content];
    }else if(message.msgType == MessageTypeImage){
        cell.contentLabel.text = nil;
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:message.content] placeholderImage:[UIImage imageWithContentsOfFile:message.content]];
    }else if (message.msgType == MessageTypeLocation){
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:message.content] placeholderImage:[UIImage imageNamed:@"location_default"]];
        cell.contentLabel.text = @"";
    }
    
    cell.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[message.msgTime integerValue]] timeAgoWithLimit:kTimeLimit dateFormat:NSDateFormatterMediumStyle andTimeFormat:NSDateFormatterShortStyle];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:message.belongAvatar]
                  placeholderImage:[UIImage imageNamed:@"setting_head"]
                           options:SDWebImageLowPriority
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             
                         }];
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoLocationViewController:indexPath];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentSize.height > ScreenHeight) {
        if (scrollView.contentOffset.y < -30) {
            [self loadNext];
        }
    }
}


-(void)gotoLocationViewController:(NSIndexPath *)indexPath{
    BmobMsg *message = ( BmobMsg *)[_chatArray objectAtIndex:indexPath.row];
    if (message.msgType == MessageTypeLocation) {
        if ([message.content length] > 0) {
            NSArray *array = [message.content componentsSeparatedByString:@"&"];
            LocationViewController *lvc = [[LocationViewController alloc] initWithLocationArray:array];
            [self.navigationController pushViewController:lvc animated:YES];
        }
    }
}

#pragma mark imagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(160, 160)];
    NSString *currentTimeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] ];
    NSString *imagePath         = [NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil filepath],currentTimeString];
    
    if ([CommonUtil saveImage:cutImage filepath:imagePath]) {
        //发送图片
        BmobMsg *tmpMsg = [BmobMsg createAMessageWithType:MessageTypeImage statue:STATUS_SEND_FAIL content:imagePath targetId:_chatUser.objectId];
        [_chatArray addObject:tmpMsg];
        [_chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_chatArray.count -1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
        [[BmobChatManager currentInstance] sendImageMessageWithImagePath:imagePath
                                                                    user:_chatUser
                                                                   block:^(BOOL isSuccessful, NSError *error) {
                                                                       
                                                                   }];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [originImage drawInRect:CGRectMake(0, 0, size.height, size.width)]; //newImageRect指定了图片绘制区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
