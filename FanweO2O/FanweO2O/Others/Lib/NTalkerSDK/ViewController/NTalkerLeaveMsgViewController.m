//
//  UIXNLeaveMsgViewController.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/5/1.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//



#import "NTalkerLeaveMsgViewController.h"
#import "XNHPGrowingTextView.h"
#import "XNUserBasicInfo.h"
#import "XNHttpManager.h"
#import "XNFirstHttpService.h"
#import "XNUtilityHelper.h"
#import "XNGetflashserverDataModel.h"
#import "XNSDKCore.h"
#import "XNStatisticsHelper.h"
#import "XNLeaveMsgConfigureModel.h"
#import "XNLeaveMsgDetailModel.h"


#define NOTIFICATION_XN_LEAVEMEAASGENOTIFICATION @"NOTIFICATION_XN_LEAVEMEAASGENOTIFICATION"

#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define IOS7DEVICE [UIDevice currentDevice].systemVersion.floatValue >= 7.0

#define leaveMesageBackGroundColor             [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]

#define NTalkSTR(str) str?:@""

/*!留言界面*/
@interface NTalkerLeaveMsgViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>{
    
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
    UIButton *submitBtn;
    
}
/*!显示公告*/
@property (strong, nonatomic) UILabel *noticeLabel;
/*!留言输入框*/
@property (strong, nonatomic) UITextView *messageTextView;
/*!名称输入框*/
@property (strong, nonatomic) UITextField *nameTextField;
/*!电话号输入框*/
@property (strong, nonatomic) UITextField *phoneNumTextField;
/*!邮箱输入框*/
@property (strong, nonatomic) UITextField *emailTextField;
/*!提示label*/
@property (strong, nonatomic) UILabel *promptView;
/*!自定义占位提示语*/
@property (strong, nonatomic) NSString *leaveMsgPlaceHold;

@end

@implementation NTalkerLeaveMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
    autoSizeScaleY=kFWFullScreenHeight>736?kFWFullScreenHeight/736:1.0;
    iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
    iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
    
    [self.view setBackgroundColor:leaveMesageBackGroundColor];
    
    [XNStatisticsHelper XNStatistics:@"22"
                      isOpenChatCtrl:NO
                           sessionId:nil
                           settingId:_settingId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillAppearence:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netStatusChanged:)
                                                 name:NOTIFINAME_XN_NETSTATUS
                                               object:nil];
    
    self.title = NSLocalizedStringFromTable(@"leaveMessageTitle", @"XNLocalizable", nil);
    
    [self configureNavigate];
    
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    if (basicInfo.leaveMsgConfigureModel.detailArr.count) {
        [self configuresubviews];
    }else{
        [self defaultConfigure];
    }
    [self configureRightBar];
    
    [self setPromptView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBar.translucent) {
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
}

#pragma mark =====================configure=====================
/*!设置提示View*/
- (void)setPromptView
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    
    self.promptView = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kFWFullScreenWidth, 30)];
    self.promptView.backgroundColor = [self colorWithHexString:@"fff6ca"];
    self.promptView.text = NSLocalizedStringFromTable(@"netWorkStatus", @"XNLocalizable", nil);
    self.promptView.textAlignment = NSTextAlignmentCenter;
    self.promptView.textColor = [self colorWithHexString:@"666666"];
    //可折行 iOS7
    [self setMultilineLabel:self.promptView WithWidth:kFWFullScreenWidth*1.26 Text:self.promptView.text andFont:18.0];
    [self.view addSubview:_promptView];
    
    if (basicInfo.netType.length) {
        self.promptView.hidden = YES;
    }
    
}
/*!设置导航栏界面的返回控件*/
- (void)configureNavigate
{
    UIImage *backBtnImg=[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_back_btn.png"];
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc] initWithImage:backBtnImg style:0 target:self action:@selector(backButton)];
    [backButtonItem setTintColor:[UIColor colorWithPatternImage:backBtnImg]];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

/*!设置留言界面子控件*/
- (void)configuresubviews
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    
    UIView *view = nil;
    
    XNLeaveMsgConfigureModel *configureModel = basicInfo.leaveMsgConfigureModel;
    //显示公告
    if ([configureModel.isannounce isEqualToString:@"0"]) {
        [self configureNoticeLabel:CGRectMake(10, 64 + 40/2 * (configureModel.leavewords.length?1.0:0) * autoSizeScaleY, kFWFullScreenWidth - 20, 1000) text:configureModel.leavewords];
        //不显示公告
    }else{
        NSString *announceText = @"";
        [self configureNoticeLabel:CGRectMake(10, 64 + 40 * (announceText.length?1.0:0) * autoSizeScaleY, kFWFullScreenWidth - 20, 1000) text:announceText];
    }
    UILabel *noticeLabel = (UILabel *)[self.view viewWithTag:2301];
    self.noticeLabel = noticeLabel;
    
    view = noticeLabel;
    
    for (XNLeaveMsgDetailModel *detail in configureModel.detailArr) {
        if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMessageTitle", @"XNLocalizable", nil)]) {
            
            if ([detail.show isEqualToString:@"1"]) {
                _leaveMsgPlaceHold = detail.title;
               if ([detail.required isEqualToString:@"1"]) {
                    _leaveMsgPlaceHold = [NSString stringWithFormat:@"%@(%@)",detail.title,NSLocalizedStringFromTable(@"Required", @"XNLocalizable", nil)];
                }
                view = [self addLeaveMessageView:CGRectGetMaxY(view.frame) placeHolder:_leaveMsgPlaceHold];
            }
            
        } else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgName", @"XNLocalizable", nil)]) {
            NSString *placeHolder = detail.title;
            if ([detail.required isEqualToString:@"1"]) {
                placeHolder = [NSString stringWithFormat:@" %@(%@)",detail.title,NSLocalizedStringFromTable(@"Required", @"XNLocalizable", nil)];
            }
            if ([detail.show isEqualToString:@"1"]) {
                view = [self addNameView:CGRectGetMaxY(view.frame) placeHolder:placeHolder];
            }
            
        } else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgPhoneNum", @"XNLocalizable", nil)]) {
            NSString *placeHolder = detail.title;
            if ([detail.required isEqualToString:@"1"]) {
                placeHolder = [NSString stringWithFormat:@" %@(%@)",detail.title,NSLocalizedStringFromTable(@"Required", @"XNLocalizable", nil)];
            }
            if ([detail.show isEqualToString:@"1"]) {
                view = [self addPhoneNumView:CGRectGetMaxY(view.frame) placeHolder:placeHolder];
            }
            
        } else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgEmail", @"XNLocalizable", nil)]) {
            NSString *placeHolder = detail.title;
            if ([detail.required isEqualToString:@"1"]) {
                placeHolder = [NSString stringWithFormat:@" %@(%@)",detail.title,NSLocalizedStringFromTable(@"Required", @"XNLocalizable", nil)];
            }
            if ([detail.show isEqualToString:@"1"]) {
                view = [self addEmailView:CGRectGetMaxY(view.frame) placeHolder:placeHolder];
            }
            
        }
    }
    
}
/*!设置公告显示*/
- (void)configureNoticeLabel:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.tag = 2301;
    label.backgroundColor = [UIColor clearColor];
    label.text = text?:@"";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    
    label.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [self heightOfLabelWithText:label.text andFontSize:15.0]);
    
    [self.view addSubview:label];
}
/*!留言默认显示界面*/
- (void)defaultConfigure
{
    //公告
    //留言
    UIView *view = nil;
    view = [self addLeaveMessageView:84 placeHolder:NSLocalizedStringFromTable(@"leaveMessageTitle", @"XNLocalizable", nil)];
    
    //姓名
    view = [self addNameView:CGRectGetMaxY(view.frame) placeHolder:NSLocalizedStringFromTable(@"leaveMsgName", @"XNLocalizable", nil)];
    
    //电话
    view = [self addPhoneNumView:CGRectGetMaxY(view.frame) placeHolder:NSLocalizedStringFromTable(@"leaveMsgPhoneNum", @"XNLocalizable", nil)];
    
    //邮箱
    view = [self addEmailView:CGRectGetMaxY(view.frame) placeHolder:NSLocalizedStringFromTable(@"leaveMsgEmail", @"XNLocalizable", nil)];
    
}
/*!设置导航栏的提交控件*/
- (void)configureRightBar
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.tag = 2401;
    submitButton.enabled = YES;
    submitButton.frame = CGRectMake(0, 0, 50, 25);
    [submitButton setBackgroundColor:[self colorWithHexString:@"32a8f5"]];
    [submitButton setTitle:NSLocalizedStringFromTable(@"submit", @"XNLocalizable", nil) forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (UIView *)addLeaveMessageView:(CGFloat)offsetHeight placeHolder:(NSString *)placeHolder
{
    [self configureTextView:CGRectMake(10, 10 * autoSizeScaleY + offsetHeight, kFWFullScreenWidth - 20, 140*autoSizeScaleY) placeHolder:placeHolder];
    
    UITextView *messageTV = (UITextView *)[self.view viewWithTag:2101];
    
    self.messageTextView = messageTV;
    return messageTV;
}
/*!设置输入框方法封装*/
- (void)configureTextView:(CGRect)frame placeHolder:(NSString *)placeHolder
{
    UITextView *placeholderTV = [[UITextView alloc] initWithFrame:frame];
    placeholderTV.backgroundColor = [UIColor whiteColor];
    placeholderTV.text = @"";
    placeholderTV.textColor = [self colorWithHexString:@"666666"];
    placeholderTV.font = [UIFont systemFontOfSize:16 * autoSizeScaleY];
    placeholderTV.delegate = self;
    placeholderTV.tag = 2100;
    [self.view addSubview:placeholderTV];
    
    UITextView *placeHolderTextView = [[UITextView alloc] initWithFrame:frame];
    placeHolderTextView.tag = 2102;
    placeHolderTextView.text = placeHolder?:@"";
    placeHolderTextView.font = [UIFont systemFontOfSize:16 * autoSizeScaleY];
    placeHolderTextView.textColor = [self colorWithHexString:@"666666"];
    //    placeHolderTextView.textColor = [UIColor colorWithRed:204.0/255.0 green:205.0/255.0 blue:209.0/255.0 alpha:1.0];
    placeHolderTextView.delegate = self;
    [self.view addSubview:placeHolderTextView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.backgroundColor = [UIColor clearColor];
    //设置边框
    textView.layer.borderWidth = 0.5f;
    textView.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
    textView.delegate = self;
    textView.tag = 2101;
    textView.returnKeyType = UIReturnKeyDone;
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16 * autoSizeScaleY];
    
    [self.view addSubview:textView];
    
}
/*!设置名称输入框*/
- (UIView *)addNameView:(CGFloat)offsetHeight placeHolder:(NSString *)placeHolder
{
    UITextField *nameTF = nil;
    [self addtextField:&nameTF
                 frame:CGRectMake(10, offsetHeight + 10 * autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)
        andPlaceHolder:placeHolder
           andFontSize:14 * autoSizeScaleY
          andTextColor:[UIColor blackColor]
                inView:self.view];
    self.nameTextField = nameTF;
    return nameTF;
}
/*!设置电话号码输入框*/
- (UIView *)addPhoneNumView:(CGFloat)offsetHeight placeHolder:(NSString *)placeHolder
{
    UITextField *phoneTF = nil;
    [self addtextField:&phoneTF
                 frame:CGRectMake(10, offsetHeight + 10 * autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)
        andPlaceHolder:placeHolder
           andFontSize:14 * autoSizeScaleY
          andTextColor:[UIColor blackColor]
                inView:self.view];
    self.phoneNumTextField = phoneTF;
    return phoneTF;
}
/*!设置邮箱地址输入框*/
- (UIView *)addEmailView:(CGFloat)offsetHeight placeHolder:(NSString *)placeHolder
{
    UITextField *emailTF = nil;
    [self addtextField:&emailTF
                 frame:CGRectMake(10, offsetHeight + 10 * autoSizeScaleY, kFWFullScreenWidth - 20, 40 * autoSizeScaleY)
        andPlaceHolder:placeHolder
           andFontSize:14 * autoSizeScaleY
          andTextColor:[UIColor blackColor]
                inView:self.view];
    self.emailTextField = emailTF;
    return emailTF;
}
- (CGFloat)heightOfLabelWithText:(NSString *)text andFontSize:(CGFloat)fontSize{
    CGSize size = CGSizeZero;
    if (IOS7DEVICE) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName,nil];
        size = [text boundingRectWithSize:CGSizeMake(kFWFullScreenWidth - 20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:Nil].size;
    }
    else
    {
        size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(kFWFullScreenWidth - 20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping | UILineBreakModeTailTruncation];
    }
    
    if (size.height > 55) {
        size.height = 55;
    }
    
    return size.height;
}
/*!设置提交留言控件显示*/
- (void)configureSubmitButton:(CGRect)frame
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.tag = 2401;
    submitButton.enabled = YES;
    submitButton.frame = frame;
    [submitButton setBackgroundColor:[self colorWithHexString:@"32a8f5"]];
    [submitButton setTitle:NSLocalizedStringFromTable(@"submit", @"XNLocalizable", nil) forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

#pragma mark ==================UITextViewDelegate==============

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag != 2101) {
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 2101)
    {
        for (UIView *view in [self.view subviews]) {
            if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                view.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
                
            }
        }
        textView.layer.borderColor = [[self colorWithHexString:@"32a8f5"] CGColor];
        
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 2101) {
        if (!textView.text.length) {
            UITextView *placeHolderTV = (UITextView *)[self.view viewWithTag:2102];
            placeHolderTV.text = _leaveMsgPlaceHold?:NSLocalizedStringFromTable(@"leaveMsg", @"XNLocalizable", nil);
        } else {
            UITextView *placeHolderTV = (UITextView *)[self.view viewWithTag:2102];
            placeHolderTV.text = @"";
        }
    } else {
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
        }
    }
    //字数限制 0515
    textView = (UITextView *)[self.view viewWithTag:2101];
    UILabel *wordLimitTip = (UILabel*)[self.view viewWithTag:2103];
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger remainTextNum = 200;
    //计算剩下多少文字可以输入
    NSString * nsTextContent = temp;
    NSInteger existTextNum = [nsTextContent length];
    remainTextNum = 200-existTextNum;
    wordLimitTip.text = [NSString stringWithFormat:@"%ld",(long)remainTextNum];
    if (remainTextNum>10) {
        wordLimitTip.hidden = YES;
    }else{
        wordLimitTip.hidden = NO;
        if (remainTextNum<0) {
            wordLimitTip.textColor = [UIColor redColor];
        }else{
            wordLimitTip.textColor = [UIColor grayColor];
        }
    }
    return YES;
}
//检查留言是否超了
-(BOOL)CheckLeaveTextWordNumLimit:(NSString*)text{
    NSInteger existTextNum = [text length];
    if (existTextNum>400) {
        if (![self.view viewWithTag:2104]) {
        NSString *limitTipMsg = NSLocalizedStringFromTable(@"limitMsgTipText", @"XNLocalizable", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil)
                                                            message:limitTipMsg
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)
                                                  otherButtonTitles:nil, nil];
        alertView.tag = 2104;
            [alertView show];
        }
        return YES;
    }else {
        return NO;
    }
}
//检查姓名是否超了
-(BOOL)CheckNameTextWordNumLimit:(NSString*)text{
    NSInteger existTextNum = [text length];
    if (existTextNum>200) {
        if (![self.view viewWithTag:2104]) {
            NSString *limitTipMsg = NSLocalizedStringFromTable(@"limitNameTipText", @"XNLocalizable", nil);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil)
                                                                message:limitTipMsg
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)
                                                      otherButtonTitles:nil, nil];
            alertView.tag = 2105;
            [alertView show];
            
        }
        return YES;
    }else {
        return NO;
    }
}

#pragma mark ==================UITextFieldDelegte=============

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            view.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
            
        }
    }
    textField.layer.borderColor = [[self colorWithHexString:@"32a8f5"] CGColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark =====================点击事件======================
/*!提交留言控件点击事件*/
- (void)submit:(UIButton*)sender
{
    sender.enabled = NO;
   //检查留言字数上限 
    BOOL isOutLimit = [self CheckLeaveTextWordNumLimit:_messageTextView.text];
//    BOOL nameIsOutLimit = [self CheckNameTextWordNumLimit:_nameTextField.text];
    
    if (isOutLimit) {
       sender.enabled = YES;
        return;
    }
    
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    
    if (![self check]) {
        sender.enabled = YES;
        return;
    };
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:NTalkSTR(_nameTextField.text) forKey:@"msg_name"];
    [dict setObject:NTalkSTR(_phoneNumTextField.text) forKey:@"msg_tel"];
    [dict setObject:NTalkSTR(_emailTextField.text) forKey:@"msg_email"];
    [dict setObject:NTalkSTR(_messageTextView.text) forKey:@"msg_content"];
    [dict setObject:@"UTF-8" forKey:@"charset"];
    [dict setObject:@"" forKey:@"parentpageurl"];
    [dict setObject:NTalkSTR(basicInfo.uid) forKey:@"myuid"];
    [dict setObject:NTalkSTR(_responseKefu) forKey:@"destuid"];
    [dict setObject:@"" forKey:@"ntkf_t2d_sid"];
    [dict setObject:@"" forKey:@"source"];
    [dict setObject:NTalkSTR(_pageTitle) forKey:@"parentpagetitle"];
    [dict setObject:NTalkSTR(_pageURLString) forKey:@"parentpageurl"];
    //加来源
    [dict setObject:@"IOSSDK" forKey:@"from"];
    [dict setObject:NTalkSTR(basicInfo.version) forKey:@"version"];
    
    NSString *URLString = [NSString stringWithFormat:@"%@/queryservice.php?m=Index&a=queryService&t=leaveMsg&siteid=%@",basicInfo.serverData.manageserver,_siteId];
    [[[XNHttpManager sharedManager] getFirstHttpService] postLeaveMessageWithURL:URLString andParam:dict withBlock:^(id response) {
        //收回键盘 iPhone6+
        [self.messageTextView resignFirstResponder];
        [self.nameTextField resignFirstResponder];
        [self.phoneNumTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        NSString *str = nil;
        if ([response isKindOfClass:[NSError class]]) {
            str = NSLocalizedStringFromTable(@"submitLeaveFail", @"XNLocalizable", nil);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil) message:str delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil) otherButtonTitles:nil, nil];
            [alertView show];
            sender.enabled = YES;
        } else {
            str = NSLocalizedStringFromTable(@"submitLeaveSuccess", @"XNLocalizable", nil);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil) message:str delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil) otherButtonTitles:nil, nil];
            [alertView show];
            sender.enabled = YES;
        }
////        [self hideActivityViewWithTag:10001 inView:self.view];
        self.view.userInteractionEnabled = YES;
    }];
//    [self showActivityViewWithFrame:CGRectMake((kFWFullScreenWidth - 50)/2, (kFWFullScreenHeight - 50)/2, 50, 50) andTag:10001 inView:self.view];
    self.view.userInteractionEnabled = NO;
}
/*!设置返回控件点击事件放=*/
- (void)backButton {
    //收回键盘
    [self.messageTextView resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.phoneNumTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [XNStatisticsHelper XNStatistics:@"23"
                      isOpenChatCtrl:YES
                           sessionId:nil
                           settingId:_settingId];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark =====================other========================

- (void)addtextField:(UITextField **)tField frame:(CGRect)frame andPlaceHolder:(NSString *)placeholder andFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor inView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    UIView *zeroViewName = [[UIView alloc] initWithFrame:CGRectMake(0,0,5,CGRectGetHeight(frame))];
    textField.leftView = zeroViewName;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderWidth = 0.5;
    textField.delegate = self;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.textColor = textColor;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor whiteColor];
    [superView addSubview:textField];
    textField.layer.borderColor = [[self colorWithHexString:@"dfdfdd"] CGColor];
    
    if (tField) {
        *tField = textField;
    }
}

- (BOOL)check
{
 //模糊匹配 0514
 //匹配号段：130、131、132、133、134、135、136、137、138、139、147、150、151、152、153、155、156、157、158、159、170、171、173（新）、180、181（新）182、183（新）、184（新）、185、186、187、188、189
 //17.18采用放宽匹配方式
//    NSString * MOBILE = @"^1(3[0-9]|4[7]|5[0-35-9]|7[0-9]|8[0-9])\\d{8}$";
    //进一步放宽电话正则
//    NSString * MOBILE = @"^([0-9])([0-9-]{5,11})([0-9]$)";
    //1开头的11位数字
    NSString * MOBILE = @"^1[0-9]{10}$";

    //用于检测手机号的 NSPredicate
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //用于校验邮箱的正则表达式
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //用于校验邮箱的 NSPredicate
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    NSString *promtString = nil;
    
    // 无网络提交留言提示
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    
    XNLeaveMsgConfigureModel *configureModel = basicInfo.leaveMsgConfigureModel;
    
    if (!basicInfo.netType.length) {
        promtString = NSLocalizedStringFromTable(@"unsubmitByNet", @"XNLocalizable", nil);
    } else if (configureModel) {
        promtString = [self proptStringByConfigureInfo:regextestmobile emailPredicate:emailTest];
    } else {
        promtString = [self proptStringByDefaultConfigureInfo:regextestmobile emailPredicate:emailTest];
    }

    if (promtString.length) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil)
                                                            message:promtString
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        UIButton *btn = (UIButton *)[self.view viewWithTag:2401];
        btn.enabled = YES;
        return NO;
    }
    return YES;
}

#pragma mark ====================keyBoard==================

- (void)keyBoardWillAppearence:(NSNotification *)sender
{
    for (UIView *view in [self.view subviews]) {
        if ([view isFirstResponder]) {
            CGFloat keyBoardOrigin = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
            
            CGFloat respondsMaxY = 0;
            if (self.view.frame.origin.y != 0) {
                respondsMaxY = CGRectGetMaxY(view.frame) + self.view.frame.origin.y;
            } else {
                respondsMaxY = CGRectGetMaxY(view.frame);
            }
            
            if (keyBoardOrigin < respondsMaxY) {
                CGRect frame = self.view.frame;
                frame.origin.y = frame.origin.y + keyBoardOrigin - respondsMaxY;
                self.view.frame = frame;
            }
        }
    }
}

- (void)keyBoardWillHidden:(NSNotification *)sender
{
    if (self.view.frame.origin.y != 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }
}
#pragma mark =====================UIAlertViewDelegate===================

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ==========================other===========================

- (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(1.0)];
}

- (NSString *)proptStringByConfigureInfo:(NSPredicate *)phoneRredicate emailPredicate:(NSPredicate *)emailPredicate
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    
    XNLeaveMsgConfigureModel *configureModel = basicInfo.leaveMsgConfigureModel;
    
    NSString *promtString = @"";
    
    for (XNLeaveMsgDetailModel *detail in configureModel.detailArr) {
        if ([detail.required isEqualToString:@"1"]) {
            if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMessageTitle", @"XNLocalizable", nil)] && [detail.show isEqualToString:@"1"]) {
                if (!_messageTextView.text.length)
                {
                    promtString = NSLocalizedStringFromTable(@"noleaveMsgTip", @"XNLocalizable", nil);
                    break;
                }
            } else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgName", @"XNLocalizable", nil)] && [detail.show isEqualToString:@"1"]) {
                if (!_nameTextField.text.length)
                {
                    promtString = NSLocalizedStringFromTable(@"noLeaveNameTip", @"XNLocalizable", nil);
                    break;
                }
            } else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgPhoneNum", @"XNLocalizable", nil)] && [detail.show isEqualToString:@"1"]) {
                if (![phoneRredicate evaluateWithObject:_phoneNumTextField.text])
                {
                    promtString = NSLocalizedStringFromTable(@"phoneNumErrorTip", @"XNLocalizable", nil);
                    break;
                }
            } else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgEmail", @"XNLocalizable", nil)] && [detail.show isEqualToString:@"1"]) {
                if (![emailPredicate evaluateWithObject:_emailTextField.text]) {
                    promtString = NSLocalizedStringFromTable(@"EmailErrorTip", @"XNLocalizable", nil);
                    break;
                }
            }
        }
        //非必填也得加权限
        else{
            if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgPhoneNum", @"XNLocalizable", nil)]&&[_phoneNumTextField.text length]) {
                if (![phoneRredicate evaluateWithObject:_phoneNumTextField.text])
                {
                    promtString = NSLocalizedStringFromTable(@"phoneNumErrorTip", @"XNLocalizable", nil);
                    break;
                }//
                
            }else if ([detail.title isEqualToString:NSLocalizedStringFromTable(@"leaveMsgEmail", @"XNLocalizable", nil)]&&[_emailTextField.text length]){
                
                if (![emailPredicate evaluateWithObject:_emailTextField.text]) {
                    promtString = NSLocalizedStringFromTable(@"EmailErrorTip", @"XNLocalizable", nil);
                    break;
                }
                
            }
        }
    }

    return promtString;
}

- (NSString *)proptStringByDefaultConfigureInfo:(NSPredicate *)phoneRredicate emailPredicate:(NSPredicate *)emailPredicate
{
    NSString *promtString = @"";
    
    if (!_messageTextView.text.length)
    {
        promtString = NSLocalizedStringFromTable(@"noleaveMsgTip", @"XNLocalizable", nil);
    }
    else if (!_nameTextField.text.length)
    {
        promtString = NSLocalizedStringFromTable(@"noLeaveNameTip", @"XNLocalizable", nil);
        
    }
    else if (![phoneRredicate evaluateWithObject:_phoneNumTextField.text] && ![emailPredicate evaluateWithObject:_emailTextField.text]){
        
        promtString = NSLocalizedStringFromTable(@"phoneOrEmailErrorTip", @"XNLocalizable", nil);
    }
    return promtString;
}

- (void)showActivityViewWithFrame:(CGRect)rect andTag:(NSInteger)tag inView:(UIView *)superView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    activityView.center = CGPointMake((superView.frame.size.width - 25)/2, (superView.frame.size.height - 25)/2);
    
    [activityView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    
    [activityView.layer setCornerRadius:5.0f];
    [activityView.layer setMasksToBounds:YES];
    [activityView setAlpha:1.0f];
    
    activityView.tag = tag;
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityView startAnimating];
    [superView addSubview:activityView];
}

- (void)hideActivityViewWithTag:(NSInteger)tag inView:(UIView *)superView
{
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)[superView viewWithTag:tag];
    [view stopAnimating];
    [view removeFromSuperview];
}

- (void)netStatusChanged:(NSNotification *)sender
{
    NSString *netStatus = sender.object;
    
    if (netStatus.length) {
        self.promptView.hidden = YES;
    } else {
        self.promptView.hidden = NO;
    }
}
/*
 设置label内容可折行
 textWidth :label 宽度
 textString :label内容
 fontSize :字体大小
 promptLabel :目标label
 */
-(void)setMultilineLabel:(UILabel *)promptLabel WithWidth:(CGFloat)textWidth Text:(NSString *)textString andFont:(CGFloat)fontSize{
    if (!fontSize) {
        fontSize = 18.0;
    }
    UIFont * textfont = [UIFont systemFontOfSize:fontSize];
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize textSize =CGSizeMake(textWidth,CGFLOAT_MAX);
    //获取当前文本的属性
    NSDictionary * textDic = [NSDictionary dictionaryWithObjectsAndKeys:textfont,NSFontAttributeName,nil];
    //iOS7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[textString boundingRectWithSize:textSize options: NSStringDrawingUsesLineFragmentOrigin attributes:textDic context:nil].size;
    
    promptLabel.numberOfLines = 0;
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    promptLabel.frame = CGRectMake(promptLabel.frame.origin.x,promptLabel.frame.origin.y, promptLabel.frame.size.width,actualsize.height);
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
