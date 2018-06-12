
//
//  UIXNChatViewController.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/4/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//
//type=1:文本消息；
//type=2:图片消息；
//type=4:文件消息；
//type=5:系统消息；subtype=2:发起页/subtype=5:商品详情/subtype=7:ERP+语言消息
//type=6:语音消息；
//

#import "NTalkerChatViewController.h"

#import "NTalkerTextLeftTableViewCell.h"//
#import "NTalkerTextRightTableViewCell.h"
#import "NTalkerVoiceLeftTableViewCell.h"
#import "NTalkerVoiceRightTableViewCell.h"
#import "NTalkerImageLeftTableViewCell.h"
#import "NTalkerImageRightTableViewCell.h"//
#import "XNVideoRightTableViewCell.h"

#import "XNHPGrowingTextView.h"
#import "NTalkerEmojiScrollView.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
//==========================================
#import "XNUserBasicInfo.h"
#import "XNUtilityHelper.h"
#import "NTalkerLeaveMsgViewController.h"
#import "XNSDKCore.h"
#import "XNChatLaunchPageMessage.h"
#import "XNTextMessage.h"
#import "XNImageMessage.h"
#import "XNVoiceMessage.h"
#import "XNVideoMessage.h"
#import "XNEvaluateMessage.h"
#import "XNProductionMessage.h"
#import "XNErpMessage.h"
#import "XNFullMediaMessage.h"
#import "XNUtilityMessage.h"
#import "XNEvaluateView.h"
#import "XNGoodsInfoView.h"
#import "XNGoodsInfoModel.h"
#import "XNChatBasicUserModel.h"
#import "XNChatKefuUserModel.h"

#import "XNShowBigView.h"
#import "XNEvaluateCell.h"
#import "XNUtilityCell.h"

#import "XNShowProductWebController.h"
#import "XNHistoryTipTableViewCell.h"
#import "XNFullMediaLeftTableCell.h"
#import "XNLeaveMsgConfigureModel.h"
#import "XNRecordViewController.h"
#import "XNVideoPlayerController.h"
#import <SafariServices/SafariServices.h>//SF
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "XNDeviceManager.h"

#import "FWO2OJumpModel.h"
#import "FWO2OJump.h"
#import "IQKeyboardManager.h"

//设置版本号

#define kFWChangeServerChating  @"kFWChangeServerChatingNotification"
#define kFWFullScreenHeight     [UIScreen mainScreen].bounds.size.height
#define kFWFullScreenWidth      [UIScreen mainScreen].bounds.size.width

#define margonX    6.4  //tabbar控件水平间隙宽度

//留言界面背景
#define leaveMesageBackGroundColor             [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]

//inputTextView  picLabel  cameraLabel  usefulLabel  evaluationLabel titleImage
#define ntalker_textColor                [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]
//recordButton  lineView
#define ntalker_textColor2               [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
//lineView1  lineView2   lineView3
#define ntalker_lineColor                [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]
#define chatFunctionBackgroundColor      [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]
/*!
 聊天界面类
 */
@interface NTalkerChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate,XNHPGrowingTextViewDelegate,UIXNEmojiScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,XNNotifyInterfaceDelegate,XNEvaluateDelagate,XNResendTextMsgDelegate,XNResendVoiceMsgDelegate,XNResendImageMsgDelegate,XNResendVideoMsgDelegate,XNJumpProductDelegate,XNUtilityCellDelegate,XNTapSuperLinkDeleate,XNTapSuperFullMediaDeleate,XNVideoRecordControllerDelegate,XNDeviceManagerProximitySensorDelegate>
{
    //全局参数
    float autoSizeScaleX;
    float autoSizeScaleY;
    BOOL iphone6P;
    BOOL iphone6;
    //聊天主界面元素
    UILabel *titleLabel;
    UITableView *chatTableView;
    NSMutableArray *chatArray;
    UILabel *VersionLable;//显示版本号
    NSMutableArray *picUploadArray;
    BOOL scrollToBottom;
    //输入框界面元素
    UIView *inputView;
    UIView *robotInputView; // 机器人输入框
    UIView *defaultInputView; // 默认输入框
    UIImageView *inputTextViewBg;
    XNHPGrowingTextView *inputTextView;
    UIButton *robotChangeBtn;//机器人转人工按钮
    UIButton *voiceButton;//语音
    UIButton *voiceButtonS;//语音选中
    UIButton *faceButton;//表情
    UIButton *faceButtonS;//表情选中
    UIButton *functionKeyButton;//其他功能
    UIView *functionView;//其他功能的视图
    NTalkerEmojiScrollView *emojiScrollView;//表情的视图
    BOOL reactionKeyboard;//判断键盘时机
    BOOL keyBoardHide;
    float inputTextHeight;
    NSString *_alreadyText;
    NSString *_alreadyTextV;
    //录制语音界面元素和参数
    UIButton *recordButton;
    UIImageView *voiceRecordImageView;
    UIImageView *voiceRecordTooShort;
    NSTimer *recordTimer;
    NSString *_voiceMsgID;
    BOOL cancelRecord;
    BOOL voiceSendAlready;
    BOOL canRecordNow;
    float recordAudioTime;
    int startRecordButton;
    int canRemoveTipView;
    BOOL upAlready;
    //播放语音的参数
    NSTimer *voiceTimer;
    int currentVoiceImage;
    
    NSMutableDictionary *holdingMessageIDsDic;//去重
#pragma mark - 评价 字符串与存储数组
    NSString *remarkStr;
    NSArray *remarkArray;
    UIButton *evaluationButton;//评价按钮
    UIWebView *goodsWebView;
    NSMutableArray *dbArray;//
    
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, retain)AVAudioPlayer *audioPlayer;
@property (nonatomic, retain)AVAudioRecorder *audioRecorder;
@property (nonatomic, retain)NSString *alreadyText;
@property (nonatomic, retain)NSString *alreadyTextV;
@property (nonatomic, retain)NSString *voiceMsgID;
@property (nonatomic, strong) UIView *unknowHeaderView;
//=======================================================
@property (nonatomic, strong) UILabel *promptView;

@property (nonatomic, assign) BOOL needPop;
@property (nonatomic, assign) BOOL evaluated;
@property (nonatomic, assign) BOOL couldEvaluted;
@property (nonatomic, assign) BOOL enableevaluation;
@property (nonatomic, assign) BOOL alreadyShowEvaTag;
@property (nonatomic, strong) NSMutableArray *messageArray;//

//连接状态
@property (nonatomic, assign) NSInteger currentStatus;
@property (nonatomic, strong) NSString *currentKufuId;//当前客服
@property (nonatomic, assign) BOOL isInQueue;       //是否正在排队;
@property (nonatomic, strong) NSString *isShowHistoryTip;//是否显示历史消息提示 历史提示"1"显示  其他不显示
@property (nonatomic, strong) NSString *lastBaseMessageID;//最后一条基本消息的msgid
@property (nonatomic, strong) NSString *needReflashLastBaseMessageID;//是否刷新最后一条信息id
@property (nonatomic, assign) NSUInteger TipIndex;//历史提示

@property (nonatomic, strong) NSMutableDictionary *judgeDupDict;

@property (nonatomic, strong) XNProductionMessage *productMessage;
@property (nonatomic, strong) XNChatLaunchPageMessage *launchPageMessage;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) XNUtilityMessage *utilMessage;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleView;
//连接成功过
@property (nonatomic, assign) BOOL successConnected;
//
@property (nonatomic, assign) BOOL connectError;
//记录刷新前的Title (消息预知)
@property (nonatomic,strong)NSString *oldTitle;
//客服类型 0:人工 1:机器人 nil 没有机器人
@property (nonatomic, assign) NSInteger KefuUserType;
//点击边界
@property (nonatomic, assign) NSInteger borderNumber;
//输入框宽度
@property (nonatomic, assign) CGFloat inputTextViewWith;

@end

@implementation NTalkerChatViewController
@synthesize audioPlayer;
@synthesize audioRecorder;
@synthesize voiceMsgID=_voiceMsgID;
@synthesize alreadyText=_alreadyText;
@synthesize alreadyTextV=_alreadyTextV;

- (id)init{
    if (self=[super init]) {
        
        self.settingid = @"";
        
        self.pushOrPresent=YES;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        autoSizeScaleX=kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
        autoSizeScaleY=kFWFullScreenHeight>680?kFWFullScreenHeight/568:1.0;
        
        scrollToBottom = YES;
        upAlready=YES;
        
        chatArray = [[NSMutableArray alloc] init];
        self.messageArray = [[NSMutableArray alloc] init];
        picUploadArray = [[NSMutableArray alloc] init];
        
        iphone6P=CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size);
        iphone6=CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size);
        inputTextHeight = 34;
        
        holdingMessageIDsDic=[[NSMutableDictionary alloc] init];
        reactionKeyboard=NO;
        canRecordNow=YES;
        startRecordButton=0;
        canRemoveTipView=0;
        
        self.utilMessage = [[XNUtilityMessage alloc] init];
    }
    return self;
}
/**
 @brief 设置返回按钮
 */
- (void)configureBackButton
{
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_back_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(chatEnterBackground)];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}
/**
 @brief 返回按钮方法
 */
- (void)chatEnterBackground
{
    //如果正在录音则不执行返回操作
    if (audioRecorder.isRecording) {
        return;
    }
    
    if (_currentStatus != 9) {
        if (_isInQueue) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:(NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil))
                                                                message:(NSLocalizedStringFromTable(@"isGiveUp", @"XNLocalizable", nil))
                                                               delegate:self
                                                      cancelButtonTitle:(NSLocalizedStringFromTable(@"no", @"XNLocalizable", nil))
                                                      otherButtonTitles:(NSLocalizedStringFromTable(@"yes", @"XNLocalizable", nil)), nil];;//统一
            alertView.tag = 19090;
            [alertView show];
        } else {
            [self endChat];
        }
        return;
    }
    
    [[XNSDKCore sharedInstance] chatIntoBackGround:_settingid];
    [self backFoward];
}
/**
 @brief 设置关闭按钮
 */
- (void)configureCancelButton
{
    UIBarButtonItem *closeBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_close_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelChat)];
    self.navigationItem.rightBarButtonItem = closeBtnItem;
}
/**
 @brief 关闭按钮方法
*/
- (void)cancelChat
{
    //如果正在录音则不执行返回操作
    if (audioRecorder.isRecording) {
        return;
    }
    //网络不好时，不弹出强制评价
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    if (_enableevaluation && _currentStatus ==9 && basicInfo.netType.length) {
        if ([inputTextView isFirstResponder]) {
            [inputTextView resignFirstResponder];
        }
        [XNEvaluateView addEvaluateViewWithFrame:CGRectMake(10, 75, kFWFullScreenWidth - 20, kFWFullScreenHeight - 130) delegate:self];
        
        _needPop = YES;
    } else {
        //排队提示  统一
        if (_isInQueue) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:(NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil))
                                                                message:(NSLocalizedStringFromTable(@"isGiveUp", @"XNLocalizable", nil))
                                                               delegate:self
                                                      cancelButtonTitle:(NSLocalizedStringFromTable(@"no", @"XNLocalizable", nil))
                                                      otherButtonTitles:(NSLocalizedStringFromTable(@"yes", @"XNLocalizable", nil)), nil];
            alertView.tag = 19090;
            [alertView show];
        } else {
            [self endChat];
        }
    }
}
/**
 @brief 设置商品展示界面
*/
- (void)configureGoodsInfo
{
    if ([_productInfo.appGoods_type isEqualToString:@"0"] ||
        !_productInfo.appGoods_type.length) {
        return;
    }
    
    if (!_productInfo.goods_imageURL.length &&
        !_productInfo.goodsPrice.length &&
        !_productInfo.goodsTitle.length &&
        !_productInfo.goods_id.length &&
        !_productInfo.goods_showURL.length) {
        return;
    }
    
    XNGoodsInfoView * goodsInfoView = [[XNGoodsInfoView alloc] initWithFrame:CGRectMake(3, 64, CGRectGetWidth(self.view.frame) - 6, 90) andGoodsInfoModel:_productInfo andDelegate:self];
    goodsInfoView.tag = 9090;
    if ([_productInfo.appGoods_type isEqualToString:@"3"]) {
        goodsInfoView.backgroundColor = [UIColor whiteColor];
    } else {
        goodsInfoView.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:goodsInfoView];
   
}
/*!
 @brief 设置商品展示界面加载失败
 @discusstion XNJumpProductDelegate的代理方法之一
 */
- (void)productInfoShowFailed
{
    UIView *goodsView = [self.view viewWithTag:9090];
    chatTableView.tableHeaderView = goodsView;
    [chatTableView reloadData];
}
/*!
 @brief 设置商品展示界面加载成功
 @discusstion XNJumpProductDelegate的代理方法之一
 */
- (void)productInfoSuccess
{
    UIView *goodsView = [self.view viewWithTag:9090];
    if (goodsView) {
        goodsView.backgroundColor = [UIColor whiteColor];
    }
}
/*!
 @brief 点击商品界面跳转的方法
 @discusstion XNJumpProductDelegate的代理方法之一
 */
- (void)jumpByProductURL
{
    //SF
    
    FWO2OJumpModel *jump = [FWO2OJumpModel new];
    jump.type = 0;
    jump.url = _productInfo.goods_URL;
    jump.isHideTabBar = YES;
    jump.isHideNavBar = YES;
    [FWO2OJump didSelect:jump];

    
    return;
    
    if (_productInfo.goods_URL.length) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
            SFSafariViewController *webView = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:_productInfo.goods_URL]];
            [self.navigationController pushViewController:webView animated:YES];
        }else{
            XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
            ctrl.productURL = _productInfo.goods_URL;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
}
/*!
 @brief 设置旋转效果按钮
 */
- (void)configureIndicatorView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 300, 30)];
    self.titleLabel.text = NSLocalizedStringFromTable(@"chatTitle",@"XNLocalizable" , nil);
    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel sizeToFit];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + 25, CGRectGetHeight(_titleLabel.frame))];
    [self.titleView addSubview:_indicatorView];
    [self.titleView addSubview:_titleLabel];
    self.navigationItem.titleView = _titleView;
    
    [self.titleLabel addObserver:self
                      forKeyPath:@"frame"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    CGRect frame = [change[@"new"] CGRectValue];
    
    if (_titleLabel.frame.size.width > (kFWFullScreenWidth - 170)) {
        self.titleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMinY(_titleLabel.frame), kFWFullScreenWidth - 170, CGRectGetHeight(_titleLabel.frame));
    }
    
    self.titleView.frame = CGRectMake((kFWFullScreenWidth-(CGRectGetWidth(_titleLabel.frame) + 25))/2, _titleView.frame.origin.y, CGRectGetWidth(_titleLabel.frame) + 25, CGRectGetHeight(_titleLabel.frame));
}
/*!
 @brief 咨询界面加载完成
 */
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netStatusChanged:)
                                                 name:NOTIFINAME_XN_NETSTATUS
                                               object:nil];
    
    //初始化全局基本变量
    self.view.backgroundColor = [self colorWithHexString:@"f3f3f7"];
    [self initData];
    //历史提示 数据初始化
    [self addHistoryTip];
    
    [self configureBackButton];
    [self configureCancelButton];
    
    [self configureIndicatorView];
    
    [self initBasicInfo];
    
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, kFWFullScreenHeight-49) style:UITableViewStylePlain];
    [chatTableView setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
    chatTableView.delegate = self;
    
    chatTableView.dataSource = self;
    [chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:chatTableView];
    //初始化输入框(转人工按钮)
    //[self initInputBar];
//    self.KefuUserType = 1; //0:人工 1:机器人 nil 没有机器人
    [self setInputBarIsRobot:self.KefuUserType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinishedAndNoSend:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self configureGoodsInfo];
    [self setPromptView];
    
    [XNSDKCore sharedInstance].delegate = self;
    [self connectToChat];
    [self initUIWithFMDB];
    
    
    self.fd_interactivePopDisabled = YES;
}
/*!
 @brief 设置输入框
 @discusstion 初始化输入框设置(机器人客服接待、人工客服接待，inputView显示有所区别)
 */
-(void)setInputBarIsRobot:(NSInteger)isRobot{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppearance:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (isRobot == 1) {
        [self setupRobotInputView];
        inputView = robotInputView;
    } else {
        [self setupDefaultInputView];
        inputView = defaultInputView;
    }
}
/*!
 @brief 设置默认输入框
 @discusstion 初始化输入框设置(人工客服接待)
 */
-(void)setupDefaultInputView{
    defaultInputView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight-49, kFWFullScreenWidth,49)];
    [defaultInputView setUserInteractionEnabled:YES];
    [defaultInputView setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
    [self.view addSubview:defaultInputView];
    
    UIView *inputlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, 0.5)];
    [inputlineView setBackgroundColor:ntalker_textColor2];
    [defaultInputView addSubview:inputlineView];
    //不加这个，多行文字时切换工具栏会出错
    inputTextHeight = 34;//
    //语音按钮
    voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(margonX, 11, 28, 28)];
    voiceButton.hidden=NO;
    [voiceButton addTarget:self action:@selector(voiceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_voice_btn.png"] forState:UIControlStateNormal];
    [defaultInputView addSubview:voiceButton];
    
    voiceButtonS = [[UIButton alloc] initWithFrame:CGRectMake(margonX, 11, 28, 28)];
    voiceButtonS.hidden=YES;
    [voiceButtonS addTarget:self action:@selector(voiceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButtonS setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_keyboard_btn.png"] forState:UIControlStateNormal];
    [defaultInputView addSubview:voiceButtonS];
    
    voiceRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kFWFullScreenWidth-151*autoSizeScaleX)/2,(kFWFullScreenHeight-151*autoSizeScaleX-49)/2, 151*autoSizeScaleX, 151*autoSizeScaleX)];
    voiceRecordTooShort = [[UIImageView alloc] initWithFrame:CGRectMake((kFWFullScreenWidth-151*autoSizeScaleX)/2,(kFWFullScreenHeight-151*autoSizeScaleX-49)/2, 151*autoSizeScaleX, 151*autoSizeScaleX)];
    [voiceRecordTooShort setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_tooShort.png"]];
    //说话太短
    CGFloat scayX = kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
    CGFloat sacyY = kFWFullScreenHeight>480?kFWFullScreenHeight/480:1.1;
    CGFloat font = kFWFullScreenHeight>660?16.0:13.0;
    CGRect tipLabelFrame = CGRectMake(10.0*scayX, voiceRecordImageView.frame.size.height-38.0*sacyY, (voiceRecordImageView.frame.size.width-20.0*scayX), 20.0*sacyY);
    UILabel *tooShortLabel = nil;
    [self setTipLabelToSuperView:voiceRecordTooShort withFrame:tipLabelFrame Text:NSLocalizedStringFromTable(@"talkerTooShort", @"XNLocalizable", nil) textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:font] textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] NumOflines:1 labelTag:10001001 andSelfLabel:&tooShortLabel];
    //文本输入框背景
    CGFloat inputTextViewW = kFWFullScreenWidth-116.0;
    _inputTextViewWith = inputTextViewW;//
    inputTextViewBg=[[UIImageView alloc] initWithFrame:CGRectMake((28.0+2*margonX), 7.0, inputTextViewW ,36.0)];
    UIImage *stretchImage = [[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_btn.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:16];
    UIImage *stretchSelectedImage = [[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_btn_selected.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:16];
    [inputTextViewBg setImage:stretchImage];
    [defaultInputView addSubview:inputTextViewBg];
    //文本输入框
    inputTextView = [[XNHPGrowingTextView alloc] initWithFrame:CGRectMake((28+2*margonX), 7, inputTextViewW  ,36.0)];
    [inputTextView setBackgroundColor:[UIColor clearColor]];
    inputTextView.delegate = self;
    [inputTextView setReturnKeyType:UIReturnKeySend];
    inputTextView.enablesReturnKeyAutomatically = YES;
    inputTextView.minNumberOfLines = 1;
    inputTextView.maxHeight = 84;
    inputTextView.font = [UIFont systemFontOfSize:16];
    
    if (!inputTextView.text.length) {
        inputTextView.text = @"";
    }
    [inputTextView setTextColor:ntalker_textColor];
    [defaultInputView addSubview:inputTextView];
    //按住说话
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake((28.0+2*margonX), 7.0, inputTextViewW ,inputTextView.minHeight>36.0?inputTextView.minHeight:36.0)];//录音 文本框不吻合
    recordButton.hidden=YES;
    [recordButton setBackgroundImage:stretchImage forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchSelectedImage forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(recordStarting:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordWillGoOnAndSend:) forControlEvents:UIControlEventTouchDragEnter];
    [recordButton addTarget:self action:@selector(recordWillFinishedAndNoSend:) forControlEvents:UIControlEventTouchDragExit];
    [recordButton addTarget:self action:@selector(recordFinishedAndSend:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordFinishedAndNoSend:) forControlEvents:UIControlEventTouchUpOutside];
    
    [recordButton setTitle:NSLocalizedStringFromTable(@"recordBtnTitleNomal", @"XNLocalizable", nil) forState:UIControlStateNormal];
    [recordButton setTitle:NSLocalizedStringFromTable(@"recordBtnTitleHlight", @"XNLocalizable", nil) forState:UIControlStateHighlighted];
    [recordButton setTitleColor:ntalker_textColor2 forState:UIControlStateNormal];
    [recordButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    recordButton.exclusiveTouch=YES;
    [defaultInputView addSubview:recordButton];
    //表情+键盘
    faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inputTextView.frame)+margonX, 11, 28, 28)];
    
    faceButton.hidden= NO;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_face_btn.png"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(faceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [defaultInputView addSubview:faceButton];
    
    faceButtonS = [[UIButton alloc] initWithFrame:CGRectMake(faceButton.frame.origin.x, 11, 28, 28)];
    faceButtonS.hidden=YES;
    [faceButtonS setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_keyboard_btn.png"] forState:UIControlStateNormal];
    [faceButtonS addTarget:self action:@selector(faceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [defaultInputView addSubview:faceButtonS];
    //加号按钮
    functionKeyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(faceButton.frame)+margonX, 11, 28, 28)];
    functionKeyButton.hidden=NO;
    [functionKeyButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_more_btn.png"] forState:UIControlStateNormal];
    [functionKeyButton addTarget:self action:@selector(functionKey:) forControlEvents:UIControlEventTouchUpInside];
    [defaultInputView addSubview:functionKeyButton];
    
    emojiScrollView = [[NTalkerEmojiScrollView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight, kFWFullScreenWidth, (225.0/736.0)*kFWFullScreenHeight)];//tiao  216*autoSizeScaleY (280.0/736.0)
    emojiScrollView.emojiDelegate=self;
    emojiScrollView.backgroundColor = [self colorWithHexString:@"f3f3f7"];
    [self.view addSubview:emojiScrollView];
    
    //功能拓展View
    [self setFunctionView];
    
}
/*!
 @brief 设置机器人输入框
 @discusstion 初始化输入框设置(机器人客服接待)
 */
-(void)setupRobotInputView{
    robotInputView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight-49, kFWFullScreenWidth,49)];
    [robotInputView setUserInteractionEnabled:YES];
    [robotInputView setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
    [self.view addSubview:robotInputView];
    
    inputTextHeight = 34;
    //最上面的线
    UIView *inputlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, 0.5)];
    [inputlineView setBackgroundColor:ntalker_textColor2];
    [robotInputView addSubview:inputlineView];
    //转人工按钮
    [self setRobotChangeBtn:CGRectMake(margonX,10.0-3.0,30,36.0)];
    //文本输入框背景
    CGFloat inputTextViewW = kFWFullScreenWidth-116.0;
    _inputTextViewWith = inputTextViewW;//
    inputTextViewBg=[[UIImageView alloc] initWithFrame:CGRectMake((28.0+2*margonX), 7.0, inputTextViewW ,36.0)];
    UIImage *stretchImage = [[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_btn.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:16];
    [inputTextViewBg setImage:stretchImage];
    [robotInputView addSubview:inputTextViewBg];
    //文本输入框
    inputTextView = [[XNHPGrowingTextView alloc] initWithFrame:CGRectMake((28+2*margonX), 7, inputTextViewW  ,36.0)];
    [inputTextView setBackgroundColor:[UIColor clearColor]];
    inputTextView.delegate = self;
    [inputTextView setReturnKeyType:UIReturnKeySend];
    inputTextView.enablesReturnKeyAutomatically = YES;
    inputTextView.minNumberOfLines = 1;
    inputTextView.maxHeight = 84;
    inputTextView.font = [UIFont systemFontOfSize:16];
    
    if (!inputTextView.text.length) {
        inputTextView.text = @"";
    }
    [inputTextView setTextColor:ntalker_textColor];
    [robotInputView addSubview:inputTextView];
    //表情+键盘按钮
    faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inputTextView.frame)+margonX, 11, 28, 28)];
    faceButton.exclusiveTouch = YES;
    faceButton.hidden=NO;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_face_btn.png"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(faceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [robotInputView addSubview:faceButton];
    
    faceButtonS = [[UIButton alloc] initWithFrame:CGRectMake(faceButton.frame.origin.x, 11, 28, 28)];
    faceButtonS.exclusiveTouch = YES;
    faceButtonS.hidden=YES;
    [faceButtonS setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_keyboard_btn.png"] forState:UIControlStateNormal];
    [faceButtonS addTarget:self action:@selector(faceButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [robotInputView addSubview:faceButtonS];
    //加号按钮
    functionKeyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(faceButton.frame)+margonX, 11, 28, 28)];
    functionKeyButton.exclusiveTouch = YES;
    functionKeyButton.hidden=NO;
    [functionKeyButton setBackgroundImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_more_btn.png"] forState:UIControlStateNormal];
    [functionKeyButton addTarget:self action:@selector(functionKey:) forControlEvents:UIControlEventTouchUpInside];
    [robotInputView addSubview:functionKeyButton];
    
    emojiScrollView = [[NTalkerEmojiScrollView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight, kFWFullScreenWidth, (225.0/736.0)*kFWFullScreenHeight)];//tiao  (280.0/736.0)
    emojiScrollView.emojiDelegate=self;
    emojiScrollView.backgroundColor = [self colorWithHexString:@"f3f3f7"];
    [self.view addSubview:emojiScrollView];
    //功能拓展View
    [self setFunctionView];
}
/*!
 @brief 设置”+“按钮打开的功能拓展页面
 @discusstion 可修改代码，添加项目， 拓展新功能。
 */
-(void)setFunctionView{
    
    NSString * picture = NSLocalizedStringFromTable(@"pictureLabel", @"XNLocalizable", nil);
    NSString * camera = NSLocalizedStringFromTable(@"cameraLabel", @"XNLocalizable", nil);
    //视频(放开即有视频功能，其他不用修改）
//    NSString * video = NSLocalizedStringFromTable(@"videoLabel", @"XNLocalizable", nil);
    NSString * evalue = NSLocalizedStringFromTable(@"evalueLabel", @"XNLocalizable", nil);

    NSArray *arr = @[
                     @{@"bgImage":@"ntalker_pic_btn.png",
                       @"hBgImage":@"ntalker_pic_btn_selected.png",
                       @"SEL":@"picFunction:",
                       @"title":picture},
                     
                     @{@"bgImage":@"ntalker_camera_btn.png",
                       @"hBgImage":@"ntalker_camera_btn_selected.png",
                       @"SEL":@"cameraFunction:",
                       @"title":camera},
                      //视频（放开即有视频功能，其他不用修改）
//                     @{@"bgImage":@"ntalker_video_btn.png",
//                       @"hBgImage":@"ntalker_video_btn_selected.png",
//                       @"SEL":@"videoFunction:",
//                       @"title":video},
                     
                     @{@"bgImage":@"ntalker_value_btn.png",
                       @"hBgImage":@"ntalker_value_btn_selected.png",
                       @"SEL":@"evaluationFunction:",
                       @"title":evalue},
                     ];
    
    int totalloc = 3;//每行4列
    int rows = ((int)arr.count)/(totalloc+1)+1;//行数
    CGFloat functionViewH = (140.0/736.0)*kFWFullScreenHeight;
    if (rows>1) {
        functionViewH = (emojiScrollView.frame.size.height>0)?(emojiScrollView.frame.size.height):((243.0/736.0)*kFWFullScreenHeight);
    }
    functionView = [[UIView alloc] initWithFrame:CGRectMake(0, kFWFullScreenHeight, kFWFullScreenWidth,functionViewH)];
    CGFloat picButtonW = 60.0;
    CGFloat picButtonH = 60.0;
    CGFloat marginX = (kFWFullScreenWidth-picButtonW*totalloc)/(totalloc+1);//横向间距
    CGFloat titleLabelH = 14.0;//标签高度
    CGFloat titleMarginY = 4.0;//图片距标签间距
    CGFloat marginY =  (functionView.frame.size.height -(picButtonH+titleLabelH+titleMarginY)*rows)/(rows+1);//纵向间隙
    for (int i = 0; i < arr.count; i++) {
        int row = i/totalloc;//行号
        int loc = i%totalloc;//列号
        CGFloat picButtonX = marginX +(marginX+picButtonW)*loc;
        CGFloat picButtonY = marginY +(marginY+picButtonH+titleLabelH+titleMarginY)*row;
        NSDictionary *dict = arr[i];
        //图片
        UIButton *picButton = [[UIButton alloc]initWithFrame:CGRectMake(picButtonX, picButtonY, picButtonW, picButtonH)];
        [picButton setImage:[UIImage imageNamed:[@"NTalkerUIKitResource.bundle" stringByAppendingPathComponent:dict[@"bgImage"]]] forState:UIControlStateNormal];
        [picButton setImage:[UIImage imageNamed:[@"NTalkerUIKitResource.bundle" stringByAppendingPathComponent:dict[@"hBgImage"]]] forState:UIControlStateHighlighted];
        [picButton addTarget:self action:NSSelectorFromString(dict[@"SEL"]) forControlEvents:UIControlEventTouchUpInside];
        [functionView addSubview:picButton];
        //标签
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(picButton.frame), CGRectGetMaxY(picButton.frame) +titleMarginY, CGRectGetWidth(picButton.frame), titleLabelH)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:(14.0/414.0)*kFWFullScreenWidth]];
        [nameLabel setTextColor:[self colorWithHexString:@"666666"]];
        nameLabel.text=dict[@"title"];
        [functionView addSubview:nameLabel];
        
        //i改变会影响评价按钮事件！！！！默认放在最后一项
        if (i == arr.count-1) {
            picButton.tag = 1090;

            nameLabel.tag = 1091;
            if (_evaluated) {
                nameLabel.text = NSLocalizedStringFromTable(@"haveEvaluedLabel", @"XNLocalizable", nil);
                picButton.enabled = NO;
            }else {
                nameLabel.text = NSLocalizedStringFromTable(@"evalueLabel", @"XNLocalizable", nil);
            }
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, 0.5)];
    [lineView setBackgroundColor:ntalker_textColor2];
    [functionView addSubview:lineView];
    
    functionView.backgroundColor = [self colorWithHexString:@"f3f3f7"];
     [self.view addSubview:functionView];
}
/*!
 @brief 设置机器人转人工按钮
 @param frame 转人工按钮在InputView 上的frame;
 @discusstion 机器人客服接待时才会显示转人工按钮。
 */
-(void)setRobotChangeBtn:(CGRect)frame{
    if (!robotChangeBtn) {
        robotChangeBtn = [[UIButton alloc]initWithFrame:frame];
    }
    robotChangeBtn.hidden = NO;
    robotChangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [robotChangeBtn setTitle:NSLocalizedStringFromTable(@"TurnManual", @"XNLocalizable", nil) forState:UIControlStateNormal];
    [robotChangeBtn setTitle:NSLocalizedStringFromTable(@"TurnManual", @"XNLocalizable", nil)  forState:UIControlStateHighlighted];
    [robotChangeBtn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:0.9] forState:UIControlStateNormal];
    robotChangeBtn.titleLabel.font = [UIFont systemFontOfSize:8.0];
    robotChangeBtn.tag = 300300;
    [robotChangeBtn addTarget:self action:@selector(robotChangeToManulServer:) forControlEvents:UIControlEventTouchUpInside];
    robotChangeBtn.selected = NO;//转人工按钮恢复可点击
    [robotChangeBtn setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_inputView_RobotChange.png"]forState:UIControlStateNormal];
    [robotChangeBtn setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_inputView_RobotChange_selected.png"] forState:UIControlStateHighlighted];
    [self layoutButton:robotChangeBtn TopImageTitleSpace:3.0];

    if (robotInputView) {
        [robotInputView addSubview:robotChangeBtn];
    }
}
/*!
 @brief 设置机器人转人工按钮排版（图片在上，文字在下）
 @param button 转人工按钮;
 @param space 图片与文字间距。
 */
- (void)layoutButton:(UIButton *)button TopImageTitleSpace:(CGFloat)space{
    //设置宽、高
    CGFloat imageWith = button.imageView.frame.size.width;
    CGFloat imageHeight =  button.imageView.frame.size.height;
    UIEdgeInsets imageEdgeInset = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInset = UIEdgeInsetsZero;
   
    imageEdgeInset = UIEdgeInsetsMake(-10.0,0.0,0.0,-button.titleLabel.bounds.size.width);
    titleEdgeInset = UIEdgeInsetsMake(imageHeight+space, -imageWith,0.0, 0.0);
    button.imageEdgeInsets = imageEdgeInset;
    button.titleEdgeInsets = titleEdgeInset;
}
/*!
 @brief 刷新输入框inputView UI显示
 @param isRobot 是否是机器人客服接待;
 */
- (void)refreshInputBarWhenRobot:(NSInteger)isRobot {
    
    self.KefuUserType = isRobot;
    if (isRobot == 1) {
        if (!robotInputView) {
            if (defaultInputView) {
                [self tapGestureFunction:nil];//
                [defaultInputView removeFromSuperview];
                defaultInputView = nil;
                
            }
            [self setupRobotInputView];
            inputView = robotInputView;
        }
    } else {
        
       if (!defaultInputView) {
           if (robotInputView) {
                [self tapGestureFunction:nil];//
                [robotInputView removeFromSuperview];
                robotInputView = nil;
                
            }
           [self setupDefaultInputView];
           inputView = defaultInputView;
        }
    }
}
/*!
 @brief 是否显示“以上为历史消息”提示标签的初始化
 */
-(void)addHistoryTip{
    NSString *uid = [XNUserBasicInfo sharedInfo].uid;
    NSString *isShowHistoryTipName = [NSString stringWithFormat:@"XN_%@_isShowHistoryTip_%@",self.settingid,uid];
    NSString *lastBaseMsgIdName = [NSString stringWithFormat:@"XN_%@_LastBaseMessageID_%@",self.settingid,uid];
    NSString *needRefreshlastBaseMsgIdName = [NSString stringWithFormat:@"XN_%@_needRefreshLastBaseMessageID_%@",self.settingid,uid];
    NSString * isShowHistoryTip = [[NSUserDefaults standardUserDefaults] objectForKey:isShowHistoryTipName];
    NSString *lastBaseMsgId = [[NSUserDefaults standardUserDefaults]objectForKey:lastBaseMsgIdName];
    NSString *isNeedRefreshlastMsgIdName = [[NSUserDefaults standardUserDefaults]objectForKey:needRefreshlastBaseMsgIdName];
    
    _isShowHistoryTip = isShowHistoryTip;
    _lastBaseMessageID = lastBaseMsgId;
    _needReflashLastBaseMessageID = isNeedRefreshlastMsgIdName;
}
/*!
 @brief 设置弹出提示的VIew
 */
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

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [goodsWebView loadRequest:request];
}
/*!
 @brief 给控件设置tap手势
 */
- (void)tapGestureFunction:(id)sender {
    
    if (keyBoardHide) {
        if (functionKeyButton.selected || faceButton.hidden) {
            [chatTableView reloadData];
            functionKeyButton.selected= NO;
            faceButton.hidden=NO;
            faceButtonS.hidden=YES;
            __block CGRect inputViewFrame=inputView.frame;
            CGPoint offset=[chatTableView contentOffset];
            CGRect tableFrame =  chatTableView.frame;
            float height = tableFrame.size.height;
            tableFrame.size.height = kFWFullScreenHeight-inputViewFrame.size.height;
            chatTableView.frame = tableFrame;
            chatTableView.contentOffset = offset;
            
            [UIView animateWithDuration:0.25 animations:^{
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(tableFrame.size.height-height)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(tableFrame.size.height-height));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
                
                CGRect emojiViewFrame = emojiScrollView.frame;
                emojiViewFrame.origin.y = kFWFullScreenHeight;
                emojiScrollView.frame = emojiViewFrame;
                
                CGRect functionViewFrame = functionView.frame;
                functionViewFrame.origin.y = kFWFullScreenHeight;
                functionView.frame=functionViewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    } else if([inputTextView isFirstResponder]){
        [chatTableView reloadData];
        [inputTextView resignFirstResponder];
    }
    //消除复制按钮
    NSArray *cellArr = [chatTableView visibleCells];
    for (UIView *view in cellArr) {
        if ([view isKindOfClass:[NTalkerTextLeftTableViewCell class]]) {
            NTalkerTextLeftTableViewCell *leftTextCell = (NTalkerTextLeftTableViewCell *)view;
            if (!leftTextCell.publicButton.hidden) {
                [leftTextCell.publicButton removeFromSuperview];
            }
        } else if ([view isKindOfClass:[NTalkerTextRightTableViewCell class]]) {
            NTalkerTextRightTableViewCell *rightTextCell = (NTalkerTextRightTableViewCell *)view;
            if (!rightTextCell.publicButton.hidden) {
                [rightTextCell.publicButton removeFromSuperview];
            }
        }
    }
}
// 键盘将要弹出通知方法
- (void)keyboardWillAppearance:(NSNotification *)notification{
    
    keyBoardHide = NO;
    if (faceButton.hidden) {
        faceButton.hidden=NO;
        faceButtonS.hidden=YES;
    } else if (functionKeyButton.selected){
        functionKeyButton.selected=NO;
    }
    
    CGRect keyboardBounds;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    float keyboardHeight = keyboardBounds.size.height;
    int goUp=0;
    __block CGRect tableFrame = chatTableView.frame;
    __block CGRect inputViewFrame = inputView.frame;
    CGPoint offset = chatTableView.contentOffset;
    float height=tableFrame.size.height;
    float aheight=kFWFullScreenHeight-keyboardHeight-inputViewFrame.size.height;
    if (height<aheight) {
        goUp=0;
    } else if(height>aheight){
        goUp = 1;
    } else{
        goUp = 2;
    }
    
    if (0==goUp) {
        tableFrame.size.height = aheight;
        chatTableView.frame=tableFrame;
        [chatTableView setContentOffset:offset];
    }
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        if (0==goUp) {
            inputViewFrame.origin.y = kFWFullScreenHeight-keyboardHeight-inputViewFrame.size.height;
            inputView.frame = inputViewFrame;
            
            if (offset.y-(aheight-height)>=0) {
                chatTableView.contentOffset=CGPointMake(0, offset.y-(aheight-height));
            } else {
                chatTableView.contentOffset=CGPointMake(0, 0);
            }
        } else if (1==goUp) {
            inputViewFrame.origin.y = kFWFullScreenHeight-keyboardHeight-inputViewFrame.size.height;
            inputView.frame = inputViewFrame;
            
            CGSize contentSize = chatTableView.contentSize;
            if (contentSize.height<=0) {
                
            } else if (offset.y+height<=contentSize.height) {
                chatTableView.contentOffset=CGPointMake(0, offset.y+height-aheight);
            } else if (contentSize.height>=aheight){
                chatTableView.contentOffset=CGPointMake(0, contentSize.height-aheight);
            } else {
                
            }
            //iOS7键盘
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
                CGRect tableFrame =  chatTableView.frame;
                tableFrame.size.height = aheight;
                chatTableView.frame = tableFrame;
            }
        } else {
          
            
        }
        
        CGRect emojiViewFrame = emojiScrollView.frame;
        emojiViewFrame.origin.y =kFWFullScreenHeight ;
        emojiScrollView.frame = emojiViewFrame;
        
        CGRect functionViewFrame = functionView.frame;
        functionViewFrame.origin.y = kFWFullScreenHeight;        functionView.frame=functionViewFrame;
    } completion:^(BOOL finished) {
        if (1==goUp) {
            //iOS7键盘
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
                CGRect tableFrame =  chatTableView.frame;
                tableFrame.size.height = aheight;
                chatTableView.frame = tableFrame;
            }
        }
    }];
}
//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification{
    if (!keyBoardHide) {
        __block CGRect inputViewFrame=inputView.frame;
        CGPoint offset=[chatTableView contentOffset];
        CGRect tableFrame =  chatTableView.frame;
        float height = tableFrame.size.height;
        tableFrame.size.height = kFWFullScreenHeight-inputViewFrame.size.height;
        chatTableView.frame = tableFrame;
        chatTableView.contentOffset = offset;
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height;
            inputView.frame = inputViewFrame;
            
            if (offset.y-(tableFrame.size.height-height)>=0) {
                chatTableView.contentOffset=CGPointMake(0, offset.y-(tableFrame.size.height-height));
            } else {
                chatTableView.contentOffset=CGPointMake(0, 0);
            }
        } completion:^(BOOL finished) {
//            CGRect tableFrame =  chatTableView.frame;
//            float height = tableFrame.size.height;
//            tableFrame.size.height = kFWFullScreenHeight-inputViewFrame.size.height;
//            chatTableView.frame = tableFrame;
            //留言返回未滑到底层bug
            [self scrollToTableViewBottom:NO];
        }];
    }
}
/*!
 @brief 输入框（表情/键盘）按钮点击事件方法
 @param  sender 响应点击事件的按钮
 @discusstion 表情/键盘共用这一方法
 */
- (void)faceButtonFunction:(UIButton *)sender{
    
    if ([chatArray containsObject:_utilMessage] || !_successConnected) {
        [self showPromptView];
        return;
    } else if (_currentStatus == -1) {
        [self connectToChat];
        return;//
    }
    
    if (voiceButton.hidden) {
        voiceButton.hidden = NO;
        voiceButtonS.hidden = YES;
        recordButton.hidden=YES;
        if (self.alreadyTextV!=nil && ![self.alreadyTextV isEqualToString:@""]) {
            inputTextView.text = self.alreadyTextV;
            self.alreadyTextV=@"";
        }
    } else if (functionKeyButton.selected) {
        functionKeyButton.selected=NO;
    }
    if (sender == faceButton) {
        faceButton.hidden=YES;
        faceButtonS.hidden=NO;
        keyBoardHide = YES;
        [inputTextView resignFirstResponder];
        int goUp=0;
        __block CGRect inputViewFrame=inputView.frame;
        __block CGRect tableFrame = chatTableView.frame;
        float bHeight = tableFrame.size.height;
        float aHeight = kFWFullScreenHeight-inputViewFrame.size.height-emojiScrollView.frame.size.height;
        if (bHeight<aHeight) {
            goUp=0;
        } else if(bHeight>=aHeight){//=
            goUp = 1;
        } else{
            goUp = 2;
        }
        if (0==goUp) {
            CGPoint offset = [chatTableView contentOffset];
            tableFrame.size.height = aHeight;
            chatTableView.frame=tableFrame;
            [chatTableView setContentOffset:offset];
        }
       
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint offset = chatTableView.contentOffset;
            
            CGRect emojiViewFrame = emojiScrollView.frame;
            
            if (0==goUp) {
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-emojiViewFrame.size.height;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(aHeight-bHeight)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(aHeight-bHeight));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
            } else if(1==goUp){
                
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-emojiViewFrame.size.height;
                inputView.frame = inputViewFrame;
                
                CGSize contentSize = chatTableView.contentSize;
                
                if (contentSize.height<=0) {
                    
                } else if (offset.y+bHeight<=contentSize.height) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y+bHeight-aHeight);
                } else if (contentSize.height>=aHeight){
                    chatTableView.contentOffset=CGPointMake(0, contentSize.height-aHeight);
                } else {
                    
                }
            }
            emojiViewFrame.origin.y = kFWFullScreenHeight-emojiViewFrame.size.height;
            emojiScrollView.frame = emojiViewFrame;
         
            CGRect functionViewFrame = functionView.frame;
            functionViewFrame.origin.y = kFWFullScreenHeight;
            functionView.frame=functionViewFrame;
        } completion:^(BOOL finished) {
            if (1==goUp) {
                tableFrame.size.height = aHeight;
                chatTableView.frame=tableFrame;
            }
        }];
    } else {
        faceButtonS.hidden=YES;
        faceButton.hidden = NO;
        [inputTextView becomeFirstResponder];
    }
}
/*!
 @brief 输入框（“+”号）按钮点击事件方法
 @param  sender 响应点击事件的按钮
 */
- (void)functionKey:(UIButton *)sender{
    
    if ([chatArray containsObject:_utilMessage] || !_successConnected) {
        [self showPromptView];
        return;
    } else if (_currentStatus == -1) {
        [self connectToChat];
        return;//
    }
    
    if (voiceButton.hidden) {
        voiceButton.hidden = NO;
        voiceButtonS.hidden=YES;
        recordButton.hidden=YES;
        if (self.alreadyTextV!=nil && ![self.alreadyTextV isEqualToString:@""]) {
            inputTextView.text = self.alreadyTextV;
            self.alreadyTextV=@"";
        }
    } else if (faceButton.hidden) {
        faceButton.hidden = NO;
        faceButtonS.hidden=YES;
    }
    functionKeyButton.selected=!functionKeyButton.selected;
    if (functionKeyButton.selected) {
        keyBoardHide = YES;
        [inputTextView resignFirstResponder];
        int goUp=0;
        CGRect inputViewFrame=inputView.frame;
        __block CGRect tableFrame = chatTableView.frame;
        float bHeight = tableFrame.size.height;
        float aHeight =  kFWFullScreenHeight-inputViewFrame.size.height-functionView.frame.size.height;
        if (bHeight<aHeight) {
            goUp = 0;
        } else if(bHeight>=aHeight){
            goUp = 1;
        } else{
            goUp = 2;
        }
        if (0==goUp) {
            CGPoint offset = [chatTableView contentOffset];
            tableFrame.size.height = aHeight;
            chatTableView.frame=tableFrame;
            [chatTableView setContentOffset:offset];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint offset = chatTableView.contentOffset;
            
            CGRect emojiViewFrame = emojiScrollView.frame;
            
            if (0==goUp) {
                CGRect inputViewFrame = inputView.frame;
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-functionView.frame.size.height;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(aHeight-bHeight)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(aHeight-bHeight));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
            } else if(1==goUp){
                CGRect inputViewFrame = inputView.frame;
                inputViewFrame.origin.y = kFWFullScreenHeight-inputViewFrame.size.height-functionView.frame.size.height;
                inputView.frame = inputViewFrame;
                
                CGSize contentSize = chatTableView.contentSize;
                if (contentSize.height<=0) {
                    
                } else if (offset.y+bHeight<=contentSize.height) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y+bHeight-aHeight);
                } else if (contentSize.height>=aHeight){
                    chatTableView.contentOffset=CGPointMake(0, contentSize.height-aHeight);
                } else {
                    
                }
            }
            emojiViewFrame.origin.y = kFWFullScreenHeight;
            emojiScrollView.frame = emojiViewFrame;
            
            
            CGRect functionViewFrame = functionView.frame;
            functionViewFrame.origin.y = kFWFullScreenHeight-functionViewFrame.size.height;
            functionView.frame=functionViewFrame;
        } completion:^(BOOL finished) {
            if (goUp==1) {
                tableFrame.size.height = aHeight;
                chatTableView.frame=tableFrame;
            }
        }];
    } else {
        [inputTextView becomeFirstResponder];
    }
}
/*!
 @brief 图片按钮点击事件方法
 @param  sender 响应点击事件的按钮
 @discusstion 相册权限开启，会打开相册，权限未打开，点击按钮会弹出相应提示。
 */
- (void)picFunction:(UIButton *)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picture = [[UIImagePickerController alloc] init];
        picture.delegate = self;
        picture.allowsEditing=NO;//YES->NO
        picture.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picture animated:YES completion:^{
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedStringFromTable(@"deviceUnused", @"XNLocalizable", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil) otherButtonTitles: nil];
        [alertView show];
    }
}
/*!
 @brief 拍照按钮点击事件方法
 @param  sender 响应点击事件的按钮
 @discusstion 拍照权限开启，会打开相机，权限未打开，点击按钮会弹出相应提示。
 */
- (void)cameraFunction:(UIButton *)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil)
                                                            message:NSLocalizedStringFromTable(@"openCameraAuthority", @"XNLocalizable", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:camera animated:YES completion:^{
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedStringFromTable(@"deviceUnused", @"XNLocalizable", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)  otherButtonTitles: nil];
        [alertView show];
    }
}
//小视频
- (void)videoFunction:(UIButton *)sender
{
    [self obtainAuthorization];
}
- (void)evaluationFunction:(UIButton *)sender{
    
    if (_couldEvaluted) {
        
        [XNEvaluateView addEvaluateViewWithFrame:CGRectMake(10, 75, kFWFullScreenWidth - 20, kFWFullScreenHeight - 130) delegate:self];
    } else {
        // woo222
        [self showToastViewWithContent:NSLocalizedStringFromTable(@"notEvaluate", @"XNLocalizable", nil) andRect:CGRectMake((kFWFullScreenWidth * 0.2)/2, (kFWFullScreenHeight - 50)/2, kFWFullScreenWidth * 0.8, 30) andTime:2.0 andObject:self];
    }
}

/*!
 @brief 语音按钮点击事件方法
 @param  sender 响应点击事件的按钮
 @discusstion 点击语音按钮，输入框变成语音录制按钮，键盘收回，语音按钮变成键盘按钮
 */
- (void)voiceButtonFunction:(UIButton *)sender {
    
    if ([chatArray containsObject:_utilMessage] || !_successConnected) {
        [self showPromptView];
        return;
    } else if (_currentStatus == -1) {
        [self connectToChat];
        return;//
    }
    
    if (sender == voiceButton) {
        //语音
        voiceButton.hidden = YES;
        voiceButtonS.hidden = NO;
        if (![inputTextView.text isEqualToString:@""] && inputTextView.text!=nil) {
            self.alreadyTextV = inputTextView.text;
            inputTextView.text=@"";
        }
        if (inputTextView.isFirstResponder) {
            [chatTableView reloadData];
            keyBoardHide = NO;
            [inputTextView resignFirstResponder];
        } else if (faceButton.hidden || functionKeyButton.selected){
            [chatTableView reloadData];
            faceButton.hidden=NO;
            faceButtonS.hidden=YES;
            functionKeyButton.selected=NO;
            
            CGRect tableFrame = chatTableView.frame;
            float bHeight = tableFrame.size.height;
            float aHeight = kFWFullScreenHeight-49;
            CGPoint offset = [chatTableView contentOffset];
            tableFrame.size.height = aHeight;
            chatTableView.frame=tableFrame;
            [chatTableView setContentOffset:offset];
            [UIView animateWithDuration:0.25 animations:^{
                CGRect inputViewFrame=inputView.frame;
                inputViewFrame.origin.y = kFWFullScreenHeight-49;
                inputView.frame = inputViewFrame;
                
                if (offset.y-(aHeight-bHeight)>=0) {
                    chatTableView.contentOffset=CGPointMake(0, offset.y-(aHeight-bHeight));
                } else {
                    chatTableView.contentOffset=CGPointMake(0, 0);
                }
                
                CGRect emojiViewFrame = emojiScrollView.frame;
                emojiViewFrame.origin.y = kFWFullScreenHeight;
                emojiScrollView.frame = emojiViewFrame;
                
                CGRect functionViewFrame = functionView.frame;
                functionViewFrame.origin.y = kFWFullScreenHeight;
                functionView.frame=functionViewFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        recordButton.hidden=NO;
    } else {
        //键盘
        voiceButtonS.hidden=YES;
        voiceButton.hidden = NO;
        if (self.alreadyTextV!=nil && ![self.alreadyTextV isEqualToString:@""]) {
            inputTextView.text = self.alreadyTextV;
            self.alreadyTextV = @"";
        }
        [inputTextView becomeFirstResponder];
        recordButton.hidden=YES;
    }
}
//数据源方法
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chatArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <chatArray.count) {
        
        XNBaseMessage *chatObject = [chatArray objectAtIndex:indexPath.row];//
        BOOL hide=NO;
        
        if (indexPath.row>0) {
            XNBaseMessage *lastChat = [chatArray objectAtIndex:indexPath.row-1];
            long long cha = chatObject.msgtime - lastChat.msgtime;
            if (cha<120000) {
                hide=YES;
            }
        }
        
        if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
            if (MSG_TYPE_TEXT==chatObject.msgType) {
                //不复用了
                NTalkerTextLeftTableViewCell*cell = [[NTalkerTextLeftTableViewCell alloc]init];
                cell.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor clearColor]];
                //
                if (indexPath.row > _borderNumber) {
                    cell.canSelected = YES;
                } else {
                    cell.canSelected = NO;
                }
                
                
                [cell setChatTextMessageInfo:chatObject hidden:hide];
                
                return cell;
                
            }
            else if (MSG_TYPE_PICTURE == chatObject.msgType)
            {
                
                static NSString *leftImageCellIndentifier = @"leftImageCellIndentifierSelf";
                
                NTalkerImageLeftTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:leftImageCellIndentifier];
                
                if (!cell) {
                    
                    cell = [[ NTalkerImageLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftImageCellIndentifier];
                    
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                }
                
                cell.contentBtn.tag = indexPath.row;
                
                [cell.contentBtn addTarget:self action:@selector(viewBigPicture:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell setChatImageMessageInfo:chatObject hidden:hide];
                
                return cell;
                
            }
            else if (chatObject.msgType == MSG_TYPE_VOICE)
            {
                {
                    
                    static NSString *leftVoiceCellIndentifier = @"leftVoiceCellIndentifierSelf";
                    
                    
                    NTalkerVoiceLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftVoiceCellIndentifier];
                    
                    if (!cell) {
                        
                        cell = [[NTalkerVoiceLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftVoiceCellIndentifier];
                        
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
                        [cell setBackgroundColor:[UIColor clearColor]];
                        
                    }
                    
                    [cell setChatVoiceMessageCell:chatObject hidden:hide];
                    
                    cell.tapControl.tag = indexPath.row;
                    
                    [cell.tapControl addTarget:self action:@selector(turnOnVoice:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                    
                }
            }
            //历史消息提醒
            else if (chatObject.msgType == MSG_TYPE_SYSTEM_HISTORYTip){
                static NSString *XNHistoryMsgtipCellIndentifier = @"XNHistoryMsgtipCell";
                
                XNHistoryTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XNHistoryMsgtipCellIndentifier];
                
                if (!cell) {
                    cell = [[XNHistoryTipTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XNHistoryMsgtipCellIndentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell configureHistoryMessageTipCell:YES];
                return cell;
            }
            else if (chatObject.msgType == MSG_TYPE_FULLMEDIA)
            {
                static NSString *cellIndentifier = @"FULL_MEDIA_XN";
                
                XNFullMediaLeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                
                if (!cell) {
                    cell = [[XNFullMediaLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                }
                
                [cell setChatTextMessageInfo:chatObject hidden:hide];
                return cell;
            }
        } else {
            if (MSG_TYPE_TEXT==chatObject.msgType) {
                static NSString*rightTextCellIndentifier = @"rightTextCellIndentifierSelf";
                NTalkerTextRightTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:rightTextCellIndentifier];
                if (!cell) {
                    cell = [[ NTalkerTextRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightTextCellIndentifier];
                    cell.delegate = self;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    
                }
                
                [cell setChatTextMessageInfo:chatObject hidden:hide];
                
                return cell;
            }
            else if (MSG_TYPE_PICTURE == chatObject.msgType)
            {
                static NSString*rightImageCellIndentifier = @"rightImageCellIndentifierSelf";
                NTalkerImageRightTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:rightImageCellIndentifier];
                if (!cell) {
                    cell = [[ NTalkerImageRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightImageCellIndentifier];
                    cell.delegate = self;
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell setBackgroundColor:[UIColor clearColor]];
                }
                cell.contentBtn.tag = indexPath.row;
                [cell.contentBtn addTarget:self action:@selector(viewBigPicture:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell setChatImageMessageInfo:chatObject hidden:hide];
                
                return cell;
                
            }
            else if (chatObject.msgType == MSG_TYPE_VOICE)
            {
                {
                    //语音消息
                    static NSString *rightVoiceCellIndentifier = @"rightVoiceCellIndentifierSelf";
                    
                    NTalkerVoiceRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightVoiceCellIndentifier];
                    if (!cell) {
                        cell = [[NTalkerVoiceRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightVoiceCellIndentifier];
                        cell.delegate = self;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cell setBackgroundColor:[UIColor clearColor]];
                    }
                    [cell setChatVoiceMessageCell:chatObject hidden:hide];
                    cell.tapControl.tag = indexPath.row;
                    [cell.tapControl addTarget:self action:@selector(turnOnVoice:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
            }
            //小视频待完善
            else if (chatObject.msgType == MSG_TYPE_VIDEO){
                
                //            static NSString *videoCellIndentifier = @"XNVideoCell";
                //不复用了
                XNVideoRightTableViewCell*cell = [[XNVideoRightTableViewCell alloc]init];
                cell.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor clearColor]];
                [cell setChatVideoMessageCell:chatObject hidden:hide];
                return cell;
            }
            else if (chatObject.msgType == MSG_TYPE_SYSTEM_EVALUATE)
            {
                static NSString *evaluateCellIndentifier = @"XNEvaluateCell";
                XNEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:evaluateCellIndentifier];
                if (!cell) {
                    cell = [[XNEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:evaluateCellIndentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell configureAnything:chatObject];
                return cell;
            }
            else if ([chatObject isKindOfClass:[XNUtilityMessage class]])
            {
                static NSString *utiliCellIdentifier = @"utiliCellIdentifier";
                XNUtilityCell *cell = [tableView dequeueReusableCellWithIdentifier:utiliCellIdentifier];
                if (!cell) {
                    cell = [[XNUtilityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:utiliCellIdentifier];
                    [cell setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.delegate = self;
                }
                [cell setUtilityCell:chatObject];
                return cell;
            }
            //历史消息提醒
            else if (chatObject.msgType == MSG_TYPE_SYSTEM_HISTORYTip){
                static NSString *XNHistoryMsgtipCellIndentifier = @"XNHistoryMsgtipCell";
                
                XNHistoryTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XNHistoryMsgtipCellIndentifier];
                
                if (!cell) {
                    cell = [[XNHistoryTipTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XNHistoryMsgtipCellIndentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [cell configureHistoryMessageTipCell:YES];
                return cell;
            }
        }
        
    } else {
        static NSString *chatingIdentifier = @"NtalkerChatingIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatingIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatingIdentifier];
            [cell setBackgroundColor:[self colorWithHexString:@"f3f3f7"]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }
    return nil;
}

/*!
 @brief 点击图片放大
 @param  sender 响应点击事件的按钮
 */
- (void)viewBigPicture:(UIButton *)sender{
    if([inputTextView isFirstResponder]){
        [inputTextView resignFirstResponder];
    }
    [self stopPlayVoiceImage];
    [self stopRecordVoiceMsg];
    XNImageMessage *chatObject = [chatArray objectAtIndex:sender.tag];
    UIImageView *contImageView =[[UIImageView alloc] init];
    NSString *path = @"";
    // 得到documents目录下fileName文件的路径
    path = [XNUtilityHelper getConfigFile:[NSString stringWithFormat:@"%@.jpg",chatObject.msgid]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
     if(![chatObject.pictureSource isEqualToString:@""] && chatObject.pictureSource!=nil){
        path =[chatObject.pictureSource stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    }
    //用户发来信息
    CGFloat y = 0.0;
    if ([chatObject.userid rangeOfString:self.userId].location !=NSNotFound) {
        //右边图片
        NTalkerImageRightTableViewCell*ImageCell = (NTalkerImageRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        contImageView = ImageCell.contentImage;
        CGRect frame1 = [self.view convertRect:ImageCell.frame fromView:chatTableView];
        y = frame1.origin.y;
        CGRect frame = CGRectMake(contImageView.frame.origin.x, contImageView.frame.origin.y + y - 44 - 20, contImageView.frame.size.width, contImageView.frame.size.height);
        [XNShowBigView showBigWithFrames:frame andCtrl:0 andImageList:[NSArray arrayWithObjects:path, nil] andClickedIndex:0 andOffsetBlock:nil];
    }
    //客户发来信息
    else{
        //左图片
        NTalkerImageLeftTableViewCell *ImageCell = (NTalkerImageLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        contImageView = ImageCell.contentImage;
        path =[chatObject.pictureSource stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        CGRect frame1 = [self.view convertRect:ImageCell.frame fromView:chatTableView];
        y = frame1.origin.y;
        CGRect frame = CGRectMake(contImageView.frame.origin.x, contImageView.frame.origin.y + y - 44 - 20, contImageView.frame.size.width, contImageView.frame.size.height);
        [XNShowBigView showBigWithFrames:frame andCtrl:0 andImageList:[NSArray arrayWithObjects:path, nil] andClickedIndex:0 andOffsetBlock:nil];
    }
    
}

#pragma mark - UITableViewDelegate

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<chatArray.count) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
        
    } else {
        if (iphone6P) {
            return 20;
        } else if(iphone6){
            return 17;
        } else {
            return 15;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


/*!
 @brief 播放语音消息
 @param  sender 响应点击事件的按钮。
 */
- (void)turnOnVoice:(UIControl *)sender{
    
    [XNDeviceManager sharedInstance].delegate = self;
    [[XNDeviceManager sharedInstance] allowProximitySensor];
    
    XNBaseMessage *chatObject = [chatArray objectAtIndex:sender.tag];
    //客服发来语音
    if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
        //客服
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        UIImage *contentBgImageSelected =[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left_selected.png"];
        [voiceCell.tapControl setBackgroundImage:[contentBgImageSelected stretchableImageWithLeftCapWidth:17 topCapHeight:33] forState:UIControlStateHighlighted];
        //    用户发来语音
    }else{
        
    }
    
    [self performSelector:@selector(stopSelectedImage:) withObject:[NSNumber numberWithInteger:sender.tag] afterDelay:0.5];
    NSInteger row = [self stopPlayVoiceImage];
    if (sender.tag != row){
        //开始播放新的语音
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
        XNVoiceMessage *chatObject = [chatArray objectAtIndex:sender.tag];
        
        NSString *path = [XNUtilityHelper getConfigFile:[NSString stringWithFormat:@"%@.wav",chatObject.msgid]];
        NSFileManager *FileManager = [NSFileManager defaultManager];
        if ([FileManager fileExistsAtPath:path]) {
            NSError *error;
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:&error];
            if (error) {
                //                                     [OMGToast showWithText:@"音频文件播放失败" topOffset:kTipTopOffset duration:1.5];
                
            } else {
                player.numberOfLoops = 0;
                [player setVolume:1.0];
                self.audioPlayer = player;
                [self.audioPlayer setDelegate:self];
                [self.audioPlayer play];
                [self beginPlayVoice:sender.tag];
            }
        } else {
            if (![chatObject.mp3URL isEqualToString:@""] && chatObject.mp3URL !=nil) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    NSData *voiceData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[chatObject.mp3URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:NSDataReadingUncached error:&error];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (!error) {
                            NSError *playError;
                            //                            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:voiceData error:&playError];
                            //mp3 不能播放
                            AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithData:voiceData fileTypeHint:AVFileTypeMPEGLayer3 error:&playError];//ios7 以上方法!
                            
                            if (!playError) {
                                player.numberOfLoops = 0;
                                [player setVolume:1.0];
                                self.audioPlayer = player;
                                [self.audioPlayer setDelegate:self];
                                [self.audioPlayer play];
                                [self beginPlayVoice:sender.tag];
                            }
                        }
                    });
                });
            }
        }
    }else{
        
    }
}

//结束选中背景图片
- (void)stopSelectedImage:(id)tag{
    XNBaseMessage *chatObject = [chatArray objectAtIndex:[tag integerValue]];
    
    //客服发来信息
    if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
        
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[tag integerValue] inSection:0]];
        UIImage *contentBgImageSelected =[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_left.png"];
        [voiceCell.tapControl setBackgroundImage:[contentBgImageSelected stretchableImageWithLeftCapWidth:17 topCapHeight:33] forState:UIControlStateNormal];
        
        //用户发来信息
    }else{
        
        NTalkerVoiceRightTableViewCell *voiceCell = (NTalkerVoiceRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[tag integerValue] inSection:0]];
        UIImage *contentBgImageSelected =[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_chat_right.png"];
        [voiceCell.tapControl setBackgroundImage:[contentBgImageSelected stretchableImageWithLeftCapWidth:17 topCapHeight:33] forState:UIControlStateNormal];
        
    }
}

/*!
 @brief 开始播放语音消息
 @param  sender 响应点击事件的按钮。
 */
- (void)beginPlayVoice:(NSInteger)tag{
    
    [XNDeviceManager sharedInstance].delegate = self;
    [[XNDeviceManager sharedInstance] allowProximitySensor];
    
    currentVoiceImage = 2;
    voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(voiceMessageImageChanging) userInfo:[NSNumber numberWithInteger:tag] repeats:YES];
    XNBaseMessage *chatObject= [chatArray objectAtIndex:tag];
    //客服发来信息
    if ([chatObject.userid rangeOfString:self.userId].location ==NSNotFound&& ![[NSString stringWithFormat:@"%lu",chatObject.sendStatus] boolValue]) {
        
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag  inSection:0]];
        
        chatObject.sendStatus = 1;
        voiceCell.tipView.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentChatingViewChangedUnreadNum" object:chatObject];
    }
}

/*!
 @brief 播放语音时，语音图片动态改变
 @param  sender 响应点击事件的按钮。
 */
- (void)voiceMessageImageChanging{
    
    XNBaseMessage *chatObject =  [chatArray objectAtIndex:[(NSNumber *)voiceTimer.userInfo integerValue]];
    if (currentVoiceImage<0) {
        currentVoiceImage = 2;
    }else if(currentVoiceImage==3){
        currentVoiceImage = 2;
        currentVoiceImage--;
        return;
    }
    //客服发来语音
    if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
        
        //客服
        NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell*)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)voiceTimer.userInfo integerValue] inSection:0]];
        voiceCell.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"NTalkerUIKitResource.bundle/ntalker_left_sound%d.png",currentVoiceImage]];
        
        //用户发来语音
    }else{
        
        NTalkerVoiceRightTableViewCell *voiceCell = (NTalkerVoiceRightTableViewCell*)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[(NSNumber *)voiceTimer.userInfo integerValue] inSection:0]];
        
        //访客
        voiceCell.contentImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"NTalkerUIKitResource.bundle/ntalker_sound%d.png",currentVoiceImage]];
        
    }
    currentVoiceImage--;
}

#pragma mark - Record Voice Message
- (void)canRecordNowParam{
    
    canRecordNow=YES;
}
- (void)canRemoveShortTip:(NSNumber *)number{
    
    canRecordNow=NO;
    //录音太短
    canRemoveTipView--;
    //    if (canRemoveTipView<=number.intValue){
    if (canRemoveTipView == 0) {
        [voiceRecordTooShort removeFromSuperview];
        recordButton.userInteractionEnabled = YES;
        inputTextView.hidden = NO;
        [recordButton setHighlighted:NO];//
        // [recordButton setSelected:NO];
        //        recordButton.enabled=upAlready;
        recordButton.enabled = YES;//
        canRecordNow=YES;
    }
}
/*!
 @brief 开始录制语音消息
 @param  sender 响应点击事件的按钮。
 */
- (void)recordStarting:(UIButton *)sender{
    
    upAlready=NO;//0601
    recordButton.userInteractionEnabled = NO;
    if (canRecordNow) {
        startRecordButton=1;
        canRecordNow=NO;
        [self performSelector:@selector(canRecordNowParam) withObject:nil afterDelay:1.0];
        [self stopPlayVoiceImage];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        //
                        if (startRecordButton>0) {
                            //
                            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
                            [audioSession setActive:YES error:nil];
                            self.voiceMsgID = [self getNowTimeWithLongType];
                            NSString *path =[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
                            NSDictionary *setting=[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                                   nil];
                            //启动计时器
                            [self recordAudioTimerStart];
                            if (self.audioRecorder) {
                                //
                                if (self.audioRecorder.isRecording) {
                                    //
                                    [audioRecorder stop];
                                }
                                self.audioRecorder=nil;
                            }
                            audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:path]  settings:setting error:nil];
                            audioRecorder.meteringEnabled = YES;
                            [audioRecorder prepareToRecord];
                            //开始录音
                            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
                            [[AVAudioSession sharedInstance] setActive:YES error:nil];
                            [audioRecorder record];
                        }else{
                            
                            if (!voiceRecordTooShort.superview || voiceRecordTooShort.superview != self.view) {
                                [self.view addSubview:voiceRecordTooShort];
                                inputTextView.hidden = YES;
                                //录音
                                recordButton.userInteractionEnabled = NO;
                            }
                            canRemoveTipView++;
                            [self performSelector:@selector(canRemoveShortTip:) withObject:[NSNumber numberWithInt:canRemoveTipView] afterDelay:1.0];
                        }
                    }else{
                        
                        [[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"cantRecord", @"XNLocalizable", nil) message:NSLocalizedStringFromTable(@"openMicrophoneAuthority", @"XNLocalizable", nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil) otherButtonTitles:nil] show];
                        //录音
                        recordButton.userInteractionEnabled = YES;
                    }
                });
            }];
        } else {
            
            [self recordAudioTimerStart];
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [audioSession setActive:YES error:nil];
            self.voiceMsgID = [self getNowTimeWithLongType];
            NSString *path =[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
            
            NSDictionary *setting=[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
            if (audioRecorder) {
                if (audioRecorder.isRecording) {
                    [audioRecorder stop];
                }
                audioRecorder=nil;
            }
            audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:path]  settings:setting error:nil];
            audioRecorder.meteringEnabled = YES;
            [audioRecorder prepareToRecord];
            //开始录音
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [audioRecorder record];
        }
    }else{
        if (!voiceRecordTooShort.superview || voiceRecordTooShort.superview != self.view) {
            [self.view addSubview:voiceRecordTooShort];
            inputTextView.hidden = YES;
            //录音
            recordButton.userInteractionEnabled = NO;
        }
        canRemoveTipView++;
        [self performSelector:@selector(canRemoveShortTip:) withObject:[NSNumber numberWithInt:canRemoveTipView] afterDelay:1.0];
    }
}
/*!
 @brief 松开发送语音消息
 @param  sender 响应点击事件的按钮。
 */
- (void)recordFinishedAndSend:(UIButton *)sender{
    upAlready=YES;
    sender.enabled=YES;
    startRecordButton--;
    
    recordButton.userInteractionEnabled = YES;
    
    if (voiceSendAlready) {
        
    } else {
        
        voiceSendAlready=YES;
        if (self.audioRecorder) {
            
            if ([self.audioRecorder isRecording]) {
                [self.audioRecorder stop];
            }
            self.audioRecorder=nil;
        }
        if (recordTimer && recordTimer.isValid){
            
            [recordTimer invalidate];
            recordTimer=nil;
        }
        if (voiceRecordImageView.superview==self.view) {
            
            [voiceRecordImageView removeFromSuperview];
        }
        NSString *wavPath=[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
        
        
        NSString *amrPath=[self getConfigFile:[NSString stringWithFormat:@"%@c.amr",self.voiceMsgID]];
        
        //录音不到一秒
        if (recordAudioTime<0.9) {
            //删除文件
            if ([[NSFileManager defaultManager] fileExistsAtPath:wavPath]) {
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:wavPath error:&error];
                if (error) {
                    //                    XN_Log(@"remove voice file error:%@",[error description]);
                }
            }
            //#warning speak too short
            
            if (!voiceRecordTooShort.superview || voiceRecordTooShort.superview != self.view) {
                [self.view addSubview:voiceRecordTooShort];
                inputTextView.hidden = YES;
                //录音
                recordButton.userInteractionEnabled = NO;
                
            }
            canRemoveTipView++;
            [self performSelector:@selector(canRemoveShortTip:) withObject:[NSNumber numberWithInt:canRemoveTipView] afterDelay:1.0];
            return;
        }
        XNVoiceMessage *voiceMessage = [[XNVoiceMessage alloc] init];
        voiceMessage.voiceLength = (NSInteger)roundf(recordAudioTime);
        voiceMessage.voiceLocal = amrPath;
        voiceMessage.msgid = [NSString stringWithFormat:@"%@c",self.voiceMsgID];
        [VoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
        [self sendMessage:voiceMessage resend:NO];
        
    }
}
/*!
 @brief 取消录音
 @param  sender 响应点击事件的按钮。
 */
- (void)recordFinishedAndNoSend:(id)sender{
    upAlready=YES;
    startRecordButton--;
    if (voiceSendAlready) {
        
    } else {
        
        [self stopRecordVoiceMsg];
    }
}
- (void)recordWillFinishedAndNoSend:(UIButton *)sender{
    
    recordButton.userInteractionEnabled = YES;
    
    cancelRecord=YES;
    [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending.png"]];
    UILabel *tipLabel = nil;
    //屏幕适配
    CGFloat scayX = kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
    CGFloat sacyY = kFWFullScreenHeight>480?kFWFullScreenHeight/480:1.1;
    CGFloat font = kFWFullScreenHeight>660?16.0:13.0;
    [self setTipLabelToSuperView:voiceRecordImageView withFrame:CGRectMake(10.0*scayX, voiceRecordImageView.frame.size.height-38.0*sacyY, (voiceRecordImageView.frame.size.width-20.0*scayX), 20.0*sacyY) Text:NSLocalizedStringFromTable(@"recordEnding", @"XNLocalizable", nil) textColor:[UIColor whiteColor]  textFont:[UIFont systemFontOfSize:font] textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] NumOflines:1  labelTag:10001001 andSelfLabel:&tipLabel];
}

- (void)recordWillGoOnAndSend:(UIButton *)sender{
    
    cancelRecord = NO;
}
- (void)recordAudioTimerStart{
    
    if (recordTimer && recordTimer.isValid) {
        
        [recordTimer invalidate];
        recordTimer=nil;
    }
    cancelRecord = NO;
    voiceSendAlready = NO;
    recordAudioTime = 0.0;
    if (voiceRecordTooShort.superview == self.view) {
        
    }
    [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_volume1.png"]];
    [self.view addSubview:voiceRecordImageView];
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(recordTimerFunction) userInfo:nil repeats:YES];
}
- (void)recordTimerFunction{
    if (self.audioRecorder.isRecording) {
        recordAudioTime+=0.1;
        
        if (!cancelRecord && recordAudioTime<50) {
            [self.audioRecorder updateMeters];
            //-160表示完全安静，0表示最大输入值
            float metersValue = [self.audioRecorder peakPowerForChannel:0];
            int volume=0;
            if (metersValue>-3) {
                volume=7;
            }else if (metersValue>-5){
                volume=6;
            }else if (metersValue>-8){
                volume=5;
            }else if (metersValue>-11){
                volume=4;
            }else if (metersValue>-15){
                volume=3;
            }else if (metersValue>-20){
                volume=2;
            }else {
                volume=1;
            }
            [voiceRecordImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"NTalkerUIKitResource.bundle/ntalker_record_volume%d.png",volume]]];
            //
            UILabel *tipLabel = nil;
            CGFloat scayX = kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
            CGFloat sacyY = kFWFullScreenHeight>480?kFWFullScreenHeight/480:1.1;
            CGFloat font = kFWFullScreenHeight>660?16.0:13.0;
            [self setTipLabelToSuperView:voiceRecordImageView withFrame:CGRectMake(10.0*scayX, voiceRecordImageView.frame.size.height-38.0*sacyY, (voiceRecordImageView.frame.size.width-20.0*scayX), 20.0*sacyY)  Text:NSLocalizedStringFromTable(@"talkerEndToVolume", @"XNLocalizable", nil) textColor:[UIColor whiteColor]  textFont:[UIFont systemFontOfSize:font] textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] NumOflines:1  labelTag:10001001 andSelfLabel:&tipLabel];
            
        } else if(!cancelRecord){
            //
            UILabel *tipLabel = nil;
            CGFloat scayX = kFWFullScreenHeight>480?kFWFullScreenWidth/320:1.0;
            CGFloat sacyY = kFWFullScreenHeight>480?kFWFullScreenHeight/480:1.1;
            CGFloat font = kFWFullScreenHeight>660?16.0:13.0;
            
            [self setTipLabelToSuperView:voiceRecordImageView withFrame:CGRectMake(10.0*scayX, voiceRecordImageView.frame.size.height-38.0*sacyY, (voiceRecordImageView.frame.size.width-20.0*scayX), 20.0*sacyY) Text:NSLocalizedStringFromTable(@"talkerEndToVolume", @"XNLocalizable", nil) textColor:[UIColor whiteColor]  textFont:[UIFont systemFontOfSize:font] textAlignment:NSTextAlignmentCenter backGroundColor:[UIColor clearColor] NumOflines:1  labelTag:10001001 andSelfLabel:&tipLabel];
            
            if (recordAudioTime >= 50.0 && recordAudioTime<51.0) {
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending9.png"]];
            } else if (recordAudioTime >= 51.0 && recordAudioTime<52.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending8.png"]];
            } else if (recordAudioTime >= 52.0 && recordAudioTime<53.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending7.png"]];
            } else if (recordAudioTime >= 53.0 && recordAudioTime<54.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending6.png"]];
            } else if (recordAudioTime >= 54.0 && recordAudioTime<55.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending5.png"]];
            } else if (recordAudioTime >= 55.0 && recordAudioTime<56.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending4.png"]];
            } else if (recordAudioTime >= 56.0 && recordAudioTime<57.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending3.png"]];
            } else if (recordAudioTime >= 57.0 && recordAudioTime<58.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending2.png"]];
            } else if (recordAudioTime >= 58.0 && recordAudioTime<59.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending1.png"]];
            } else if (recordAudioTime >= 59.0 && recordAudioTime<60.0){
                [voiceRecordImageView setImage:[UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_record_ending0.png"]];
            } else {
                //                NSLog(@"超时，发送");
                [self recordFinishedAndSend:nil];
            }
        }
        //0707 超时发送
        else if (cancelRecord && recordAudioTime>=60){
            [self recordFinishedAndSend:nil];
        }
    }
}
//停止播放语音时的图片
- (NSInteger)stopPlayVoiceImage{
    NSInteger row=-1;
    if ([voiceTimer isValid] && voiceTimer) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
            self.audioPlayer.delegate = nil;
        }
        row = [(NSNumber *)voiceTimer.userInfo integerValue];
        [voiceTimer invalidate];
        voiceTimer = nil;
        currentVoiceImage = 0;
        
        //17hao
        XNBaseMessage *chatObject =[chatArray objectAtIndex:row];
        
        //客服
        if ([XNUtilityHelper isKefuUserid:chatObject.userid]) {
            //客服
            NTalkerVoiceLeftTableViewCell *voiceCell = (NTalkerVoiceLeftTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            voiceCell.contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_left_sound0.png"];
        }else {
            //用户发来信息
            NTalkerVoiceRightTableViewCell *voiceCell = (NTalkerVoiceRightTableViewCell *)[chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            voiceCell.contentImage.image = [UIImage imageNamed:@"NTalkerUIKitResource.bundle/ntalker_sound0.png"];
        }
        
    }
    return row;
}
- (void)stopRecordVoiceMsg{
    
    if (recordTimer && recordTimer.isValid) {
        
        [recordTimer invalidate];
        recordTimer=nil;
    }
    if (self.audioRecorder && self.audioRecorder.isRecording) {
        
        if (self.audioRecorder.isRecording) {
            [self.audioRecorder stop];
            NSString *wavPath=[self getConfigFile:[NSString stringWithFormat:@"%@c.wav",self.voiceMsgID]];
            //删除文件
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:wavPath]) {
                
                NSError *error;
                [[NSFileManager defaultManager] removeItemAtPath:wavPath error:&error];
                if (error) {
                }
            }
        }
        self.audioRecorder = nil;
    }
    cancelRecord=NO;
    voiceSendAlready=NO;
    recordAudioTime = 0.0;
    if (voiceRecordImageView.superview==self.view) {
        
        [voiceRecordImageView removeFromSuperview];
    }
}
-(void)changeAudioPlayModel:(BOOL)sender{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (sender) {
        //设置下扬声器模式
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    }else{
        //设置听筒模式
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    [audioSession setActive:YES error:nil];
}
#pragma mark - 发送视频代理方法

- (void)recordDidFinishedWithVideoURL:(NSURL *)videoURL displayImageURL:(NSURL *)displayImageURL recordViewController:(XNRecordViewController *)recordViewController{
    
    [recordViewController dismissViewControllerAnimated:YES completion:nil];
    
    XNVideoMessage *videoMessage = [[XNVideoMessage alloc]init];
    videoMessage.videoLocalPath = videoURL.absoluteString;
    videoMessage.imageLocalPath = displayImageURL.absoluteString;
    videoMessage.msgid = [NSString stringWithFormat:@"%@",[XNUtilityHelper getNowTimeInterval]];
    
    [self sendMessage:videoMessage resend:NO];
    [self.messageArray addObject:videoMessage];
    [chatArray addObject:videoMessage];
    [chatTableView reloadData];
    [self scrollToTableViewBottom:YES];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlayVoiceImage];
}
- (void)selectedEmoji:(NSString *)emoji{
    if (!emoji) {
        //发送
        if (inputTextView.text.length>0) {
            if (inputTextView.text.length>=4) {
                NSString *lastCharactorR = [inputTextView.text substringWithRange:NSMakeRange(inputTextView.text.length-1, 1)];
                NSString *lastCharactorL = [inputTextView.text substringWithRange:NSMakeRange(inputTextView.text.length-4, 1)];
                if ([lastCharactorR isEqualToString:@"]"] && [lastCharactorL isEqualToString:@"["]) {
                    NSString *emojiString = [inputTextView.text substringWithRange:NSMakeRange(inputTextView.text.length-4, 4)];
                    if ([[NTalkerEmojiScrollView getAllEmoji] containsObject:emojiString]) {
                        inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-4];
                    } else {
                        inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
                    }
                } else {
                    inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
                }
            }else{
                inputTextView.text = [inputTextView.text substringToIndex:inputTextView.text.length-1];
            }
        }
    }else {
        inputTextView.text = [NSString stringWithFormat:@"%@%@",inputTextView.text,emoji];
    }
}

-(void)sendEmoji{
    [self growingTextViewShouldReturn:inputTextView];
}

#pragma mark - navigationBar function
- (void)openMenuOfServerList{
    [self tapGestureFunction:nil];
    float offsetX = self.view.frame.origin.x;
    if (0 == offsetX) {
        offsetX = kFWFullScreenWidth;
        reactionKeyboard=NO;
    } else {
        offsetX = 0;
        reactionKeyboard=YES;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(offsetX, 0, kFWFullScreenWidth, kFWFullScreenHeight)];
    }];
}


#pragma mark - UIInputTextView

- (BOOL)growingTextViewShouldBeginEditing:(XNHPGrowingTextView *)growingTextView
{
    return YES;
}

- (void)growingTextViewDidChange:(XNHPGrowingTextView *)growingTextView{
    //发送消息预知
    [[XNSDKCore sharedInstance]predictMessage:growingTextView.text settingId:_settingid];
    self.alreadyText= growingTextView.text;
    if (self.alreadyText.length==0) {
        [emojiScrollView setSendBtnStatus:NO];
    } else {
        [emojiScrollView setSendBtnStatus:YES];
    }
}
- (BOOL)growingTextView:(XNHPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""] && range.length>0) {
        if (range.location+range.length==self.alreadyText.length && range.length==1) {
            if ([[self.alreadyText substringWithRange:NSMakeRange(self.alreadyText.length-1, 1)] isEqualToString:@"]"]) {
                if (self.alreadyText.length>=4 && [[self.alreadyText substringWithRange:NSMakeRange(self.alreadyText.length-4, 1)] isEqualToString:@"["]) {
                    NSString *emojiString = [self.alreadyText substringWithRange:NSMakeRange(self.alreadyText.length-4, 4)];
                    if ([[NTalkerEmojiScrollView getAllEmoji] containsObject:emojiString]) {
                        growingTextView.text = [self.alreadyText substringWithRange:NSMakeRange(0, self.alreadyText.length-3)];
                    }
                }
            }
        } else if (range.location+range.length==self.alreadyText.length){
            
        }
    }
    return YES;
}
- (void)growingTextView:(XNHPGrowingTextView *)growingTextView willChangeHeight:(float)height{
   
    if (height==34 || height==36 || height==37 || height==39) {
        height=36;
        CGRect textviewframe = growingTextView.frame;
        textviewframe.size.height=36;
        [growingTextView setFrame:textviewframe];
    }
    float offHeight = height-inputTextHeight;
    inputTextHeight = height;
    
    CGRect inputViewFrame = inputView.frame;
    inputViewFrame.origin.y = inputViewFrame.origin.y-offHeight;
    inputViewFrame.size.height = inputViewFrame.size.height+offHeight;
    inputView.frame = inputViewFrame;
    
    //[inputTextViewBg setFrame:CGRectMake(40.8, 7, kFWFullScreenWidth-116 , height)];//
    //保护输入框宽度
    if (_inputTextViewWith>0) {
        [inputTextViewBg setFrame:CGRectMake(40.8,7,_inputTextViewWith,height)];
    }else {
        //机器人
        if (self.KefuUserType==1) {
            CGFloat inputTextViewW = (kFWFullScreenWidth-(4*margonX+56));
            [inputTextViewBg setFrame:CGRectMake(40.8, 7,inputTextViewW, height)];//
        }else{
            [inputTextViewBg setFrame:CGRectMake(40.8, 7, kFWFullScreenWidth-116 , height)];//
        }
    }
    //****
    CGPoint offset = chatTableView.contentOffset;
    CGRect tableViewFrame=chatTableView.frame;
    if (offHeight>0) {
        //变小了
        CGSize contentSize = chatTableView.contentSize;
        if (contentSize.height<=0) {
        } else if (offset.y+tableViewFrame.size.height-offHeight<=contentSize.height) {
            chatTableView.contentOffset=CGPointMake(0, offset.y+offHeight);
        } else if (contentSize.height>=tableViewFrame.size.height-offHeight){
            chatTableView.contentOffset=CGPointMake(0, contentSize.height-tableViewFrame.size.height+offHeight);
        } else {
            
        }
        
        tableViewFrame.size.height = tableViewFrame.size.height-offHeight;
        chatTableView.frame=tableViewFrame;
    } else {
        //变大了
        tableViewFrame.size.height = tableViewFrame.size.height-offHeight;
        chatTableView.frame = tableViewFrame;
        if (offset.y+offHeight>=0) {
            chatTableView.contentOffset=CGPointMake(0, offset.y+offHeight);
        } else {
            chatTableView.contentOffset=CGPointMake(0, 0);
        }
    }
    
    //表情按钮下移 0518
     NSArray *subviewsArray;
    if (!robotChangeBtn&&voiceButton&&voiceButtonS&&faceButton&&faceButtonS&&functionKeyButton) {
     subviewsArray = @[voiceButton, voiceButtonS, faceButton, faceButtonS, functionKeyButton];
       }
    else if (robotChangeBtn && functionKeyButton&&faceButton&&faceButtonS) {
    subviewsArray = @[robotChangeBtn,functionKeyButton, faceButton, faceButtonS];
    }
    for (UIView *subview in subviewsArray) {
        CGRect originFrame = subview.frame;
        originFrame.origin.y += offHeight;
        subview.frame = originFrame;
    }
    
}

- (BOOL)growingTextViewShouldReturn:(XNHPGrowingTextView *)growingTextView{
    
    if ([chatArray containsObject:_utilMessage] || !_successConnected) {
        [self showPromptView];
        return YES;
    } else if (_currentStatus == -1) {
        [self connectToChat];
    }
    
    if (growingTextView.text.length > 400) {
        [self showToastViewWithContent:NSLocalizedStringFromTable(@"muchMoreTextTip", @"XNLocalizable", nil)
                               andRect:CGRectMake((kFWFullScreenWidth - 150)/2, (kFWFullScreenHeight - 50)/2, 150, 30)
                               andTime:1.0
                             andObject:self];
        return YES;
    }
    
    //发送
    //去除两端空格
    NSString *temptext =[growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![temptext isEqualToString:@""]) {
        NSString *content = growingTextView.text;
        growingTextView.text = @"";
        
        XNTextMessage *textMessage = [[XNTextMessage alloc] init];
        textMessage.textMsg = content;
        
        [self sendMessage:textMessage resend:NO];
        
    }else {
        //提示发送信息不能为空
        [self showToastViewWithContent:NSLocalizedStringFromTable(@"noTextTip", @"XNLocalizable", nil)
                               andRect:CGRectMake((kFWFullScreenWidth - 150)/2, (kFWFullScreenHeight - 50)/2, 150, 30)
                               andTime:1.0
                             andObject:self];
    }
    return YES;
}
/*!
 @brief 滑到最底层
 @param  animated 是否有动画。
 */
- (void)scrollToTableViewBottom:(BOOL)animated{
    if ([chatArray count]>0) {
        //        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[chatArray count] inSection:0];
        //        [chatTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        
        if (chatTableView.contentSize.height >= chatTableView.frame.size.height-64) {
            [chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height - chatTableView.frame.size.height) animated:animated];
        }
        
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
//原来拍照选择图片方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
////    [picker dismissViewControllerAnimated:YES completion:nil];
//    if (![info allKeys].count) {
//        return;
//    }
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    //    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
//    
//    //裁剪调整相机图片
//    NSString *msgid = [XNUtilityHelper getNowTimeInterval];
//    UIImage *fixImage = [self fixOrientationWithImage:image];
//    NSString *imagePath=[self fileOfPressedImage:fixImage withName:msgid];
//    
//    
//    XNImageMessage *imageMessage = [[XNImageMessage alloc] init];
//    imageMessage.pictureLocal = imagePath;
//    imageMessage.msgid = msgid;
//    
//    [self sendMessage:imageMessage resend:NO];
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];

//    [chatTableView reloadData];
    
//    [self scrollToTableViewBottom:YES];
//}

//重写拍照选择图片方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *url = info[UIImagePickerControllerReferenceURL];
    if (url == nil) {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [self uploadImage:orgImage];
    }else{
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset *asset , NSUInteger idx, BOOL *stop){
                if (asset) {
                    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *data, NSString *uti, UIImageOrientation orientation, NSDictionary *dic){
                        if (data.length > 10 * 1000 * 1000) {
                            
                            [self showToastViewWithContent:NSLocalizedStringFromTable(@"imageTooLargeTip", @"XNLocalizable", nil)
                                                   andRect:CGRectMake((kFWFullScreenWidth - 150)/2, (kFWFullScreenHeight - 50)/2, 150, 30)
                                                   andTime:1.0
                                                 andObject:self];
                            
                            
                            
                            return;
                        }
                        if (data != nil) {
                            UIImage *image = [UIImage imageWithData:data];
                            [self uploadImage:image];
                        } else {
                            [self showToastViewWithContent:NSLocalizedStringFromTable(@"imageTooLargeTip", @"XNLocalizable", nil)
                                                   andRect:CGRectMake((kFWFullScreenWidth - 150)/2, (kFWFullScreenHeight - 50)/2, 150, 30)
                                                   andTime:1.0
                                                 andObject:self];
                        }
                    }];
                }
            }];
        }else {
            ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
            [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
                if (asset) {
                    ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                    Byte* buffer = (Byte*)malloc((size_t)[assetRepresentation size]);
                    NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:(NSUInteger)[assetRepresentation size] error:nil];
                    NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                    if (fileData.length > 10 * 1000 * 1000) {
                        [self showToastViewWithContent:NSLocalizedStringFromTable(@"imageTooLargeTip", @"XNLocalizable", nil)
                                               andRect:CGRectMake((kFWFullScreenWidth - 150)/2, (kFWFullScreenHeight - 50)/2, 150, 30)
                                               andTime:1.0
                                             andObject:self];
                        return;
                    }
                    UIImage *fileImage = [UIImage imageWithData:fileData];
                    [self uploadImage:fileImage];
                }
            } failureBlock:NULL];
        }
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//上传图片数据
-(void)uploadImage:(UIImage *)image{
    //压缩一下
    NSData *imageData = [self compressImage:image];
    UIImage *newImage = [UIImage imageWithData:imageData];
    NSString *msgid = [XNUtilityHelper getNowTimeInterval];
    NSString *imagePath=[self fileOfPressedImage:newImage withName:msgid];
    
    XNImageMessage *imageMessage = [[XNImageMessage alloc] init];
    imageMessage.pictureLocal = imagePath;
    imageMessage.msgid = msgid;
    [self sendMessage:imageMessage resend:NO];
}
//压缩处理图片
-(NSData *)compressImage:(UIImage *)image{
    
    //实现等比例缩放
    CGFloat hfactor = image.size.width / kFWFullScreenWidth;
    CGFloat vfactor = image.size.height / kFWFullScreenHeight;
    CGFloat factor = fmax(hfactor, vfactor);
    //画布大小
    CGFloat newWith = image.size.width / factor;
    CGFloat newHeigth = image.size.height / factor;
    CGSize newSize = CGSizeMake(newWith, newHeigth);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newWith, newHeigth)];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //图像压缩
    NSData * newImageData = UIImageJPEGRepresentation(newImage, 0.5);
    return newImageData;
}


#pragma mark - Tool Function
-(UIImage *) fixOrientationWithImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (NSString *)fileOfPressedImage:(UIImage *)image withName:(NSString *)fileName{
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@.jpg", fileName];
    NSString *_image_Path=[self getConfigFile:imagelocalName_s];
    
    NSData *pressSizeData=UIImageJPEGRepresentation(image, 1);
//    if (pressSizeData.length>100*1024){
//        pressSizeData = UIImageJPEGRepresentation(image, 0.3);
//    }
//    
//    if (pressSizeData.length>100*1024) {
//        UIImage *bigImage = [UIImage imageWithData:pressSizeData];
//        CGFloat maxSize = 100 * 1024;
//        UIImage *pressImage = [self makeThumbnailFromImage:bigImage scale:maxSize/pressSizeData.length];
//        pressSizeData = UIImageJPEGRepresentation(pressImage, 1.0);
//    }
    
    BOOL writeSuccess = [pressSizeData writeToFile:_image_Path atomically:YES];
    if (writeSuccess) {
        return _image_Path;
    }else{
        return nil;
    }
}

- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {
    UIImage *thumbnail = nil;
    //double oriScale = srcImage.size.width / srcImage.size.height;
    double thumbnailWidth = srcImage.size.width * imageScale;
    double thumbnailHeight = srcImage.size.height * imageScale;
    CGSize imageSize = CGSizeMake(thumbnailWidth, thumbnailHeight);
    if (srcImage.size.width != imageSize.width || srcImage.size.height != imageSize.height)
    {
        CGSize itemSize = CGSizeMake(imageSize.width, imageSize.height);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [srcImage drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = srcImage;
    }
    return thumbnail;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, newRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}
- (NSString *)getConfigFile:(NSString *)fileName
{
    //读取documents路径:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//得到documents的路径，为当前应用程序独享
    NSString *documentD = [paths objectAtIndex:0];
    NSString *configFile = [documentD stringByAppendingPathComponent:fileName]; //得到documents目录下fileName文件的路径
    return configFile;
}
- (NSString *) getNowTimeWithLongType{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
}
/*!
 @brief 停止播放语音
 */
- (void)stop
{
    self.audioPlayer.currentTime = 0;  //当前播放时间设置为0
    [audioPlayer stop];
    self.audioPlayer=nil;
}
/*!
 @brief 返回上一层界面
 */
-(void)backFoward{
    //（如果正在播放）停止播放语音
    [self stop];
    [self tapGestureFunction:nil];
    if (self.pushOrPresent) {
        int count=(int)self.navigationController.viewControllers.count;
        int stack=count-1;
        for (int i=count-1; i>=0; i--) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:i];
            if ([viewController isKindOfClass:[NTalkerChatViewController class]]) {
                stack=i;
                break;
            }
        }
        if (stack>0) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:stack-1];
            [self.navigationController popToViewController:viewController animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
/*!
 @brief 返回上一层界面，并关闭本次会话
 */
-(void)endChat{
    //（如果正在播放）停止播放语音
    [[XNSDKCore sharedInstance] closeChatViewSettingid:_settingid];
    [self stop];
    [self tapGestureFunction:nil];
    if (self.pushOrPresent) {
        int count=(int)self.navigationController.viewControllers.count;
        int stack=count-1;
        for (int i=count-1; i>=0; i--) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:i];
            if ([viewController isKindOfClass:[NTalkerChatViewController class]]) {
                stack=i;
                break;
            }
        }
        if (stack>0) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:stack-1];
            [self.navigationController popToViewController:viewController animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 19090: {
            switch (buttonIndex) {
                case 0:{
                    break;
                }
                case 1:{
                    [self performSelector:@selector(endChat) withObject:nil afterDelay:0.3];
                    break;
                }
                default:{
                    
                    break;
                }
                    break;
            }
        }
        default:{
            
            break;
        }
    }
}

- (void)logoutLeaveMsgViewController {
    [self endChat];
}

-(void)predictChat{
    
}
- (void)remarkChat{
    
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self tapGestureFunction:nil];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentSize.height<scrollView.contentOffset.y+scrollView.frame.size.height+60) {
        scrollToBottom=YES;
    } else {
        scrollToBottom=NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == -64) {
        [self refresh];
    }
    if (scrollView.contentSize.height<scrollView.contentOffset.y+scrollView.frame.size.height+60) {
        scrollToBottom=YES;
    } else {
        scrollToBottom=NO;
    }
}

- (void)dealloc{
   
    [self.indicatorView removeFromSuperview];
    [self.titleLabel removeObserver:self forKeyPath:@"frame"];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
}
/*!
 @brief 初始化获取数据库消息数据
 */
- (void)initUIWithFMDB
{
    //
    CGFloat contentOffset = chatTableView.contentSize.height?:chatTableView.frame.size.height;
    dispatch_queue_t dbQueue = dispatch_queue_create("dbQueue", 0);
    dispatch_async(dbQueue, ^{
        // woo
        dbArray = [[XNSDKCore sharedInstance] messageFromDBByNum:20 andOffset:_messageArray.count];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (dbArray.count) {
                
                [self.messageArray insertObjects:dbArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dbArray.count)]];
                
                //历史提示
                for (int i = 0; i < dbArray.count; i++) {
                    XNBaseMessage *everyMessage = (XNBaseMessage *)dbArray[i];
                    [self checkHistoryTipInsertIndex:everyMessage andArray:dbArray];
                }
                [chatArray insertObjects:dbArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dbArray.count)]];
                [chatTableView reloadData];
                UIView *view = [self.view viewWithTag:9090];
                if (chatTableView.contentSize.height >= chatTableView.frame.size.height) {
                    [chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height - contentOffset + view.frame.size.height) animated:NO];
                }
            }
            [self stopRefresh];
        });
    });
}
- (void)setTipIndex:(NSUInteger)TipIndex {
    _TipIndex = TipIndex;
    if ([self.isShowHistoryTip isEqualToString:@"1"] && (TipIndex >= 1)) {
        XNBaseMessage *lastMessage = (XNBaseMessage *)dbArray.lastObject;
        if (lastMessage.msgType == MSG_TYPE_SYSTEM_HISTORYTip) {
            return;
        }
        //重新存储各标志
        NSString *uid = [XNUserBasicInfo sharedInfo].uid;
        NSString *lastBaseMsgIdName = [NSString stringWithFormat:@"XN_%@_LastBaseMessageID_%@",self.settingid,uid];
        NSString *needRefreshlastBaseMsgIdName = [NSString stringWithFormat:@"XN_%@_needRefreshLastBaseMessageID_%@",self.settingid,uid];
        [[NSUserDefaults standardUserDefaults]setObject:((XNBaseMessage *)[dbArray objectAtIndex:TipIndex - 1]).msgid forKey:lastBaseMsgIdName];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:needRefreshlastBaseMsgIdName];
        XNBaseMessage *tipMessage = [[XNBaseMessage alloc]init];
        tipMessage.msgType = MSG_TYPE_SYSTEM_HISTORYTip;
        [dbArray insertObject:tipMessage atIndex:TipIndex];
        _borderNumber = TipIndex; //
    }
}

/*!
 @brief 数据库取数据的时候必要时候插入“ 以上为历史消息”提示
 @param  message 待插入的消息。
 @param  array  接收待插入消息的消息数组
 */
-(void)checkHistoryTipInsertIndex:(XNBaseMessage *)message andArray:(NSMutableArray *)array{
    
    [self addHistoryTip];
    if ([self.isShowHistoryTip isEqualToString:@"1"]) {
        //刷新
        if ([self.needReflashLastBaseMessageID isEqualToString:@"1"]) {
            self.TipIndex = array.count;
            
        }else{
            //保持原样
            if ([self.lastBaseMessageID isEqualToString:message.msgid]) {
                
                self.TipIndex = [array indexOfObject:message]+1;
            }
        }
    }
}
/*!
 @brief 停止旋转加载效果
 */
- (void)stopRefresh
{
    UIView *goodsView =[self.view viewWithTag:9090];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, CGRectGetHeight(goodsView.frame))];
    view.backgroundColor = [UIColor clearColor];
    chatTableView.tableHeaderView = view;
}
/*!
 @brief 刷新界面效果
 */
- (void)refresh
{
    UIView *goodsView =[self.view viewWithTag:9090];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFWFullScreenWidth, CGRectGetHeight(goodsView.frame)+23)];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake((CGRectGetWidth(chatTableView.frame) - 25)/2, goodsView.frame.size.height + 5, 25, 25);
    [activityView startAnimating];
    [view addSubview:activityView];
    [chatTableView setTableHeaderView:view];
    
    [self initUIWithFMDB];
}

#pragma mark =====================SDKCORE=======================
/*!
 @brief 初始化商品、咨询发起页等参数
 */
- (void)initBasicInfo
{
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    self.userId = basicInfo.uid;
    
    if ([_productInfo.clientGoods_type isEqualToString:@"0"]) {
        
    } else if ([_productInfo.clientGoods_type isEqualToString:@"1"]) {
        self.productMessage = [[XNProductionMessage alloc] init];
        self.productMessage.goodsId = _productInfo.goods_id;
        self.productMessage.itemParam = _productInfo.itemparam;
    } else if ([_productInfo.clientGoods_type isEqualToString:@"2"]) {
        self.productMessage = [[XNProductionMessage alloc] init];
        self.productMessage.productInfoURL = _productInfo.goods_showURL;
    }
    
    if (_pageTitle.length || _pageURLString.length) {
        self.launchPageMessage = [[XNChatLaunchPageMessage alloc] init];
        self.launchPageMessage.pageURLString = _pageURLString;
        self.launchPageMessage.pageTitle = _pageTitle;
    }
}
/*!
 @brief 发送基本类消息（会话相关消息，如文本、语音、图片等消息）
 @param message 待发送消息
 @param resend 是否重发
 */
- (void)sendMessage:(XNBaseMessage *)message resend:(BOOL)resend
{
    [[XNSDKCore sharedInstance] sendMessage:message resend:resend];
}
/*!
 @brief 发送ERP类消息
 @param erpParam ERP类参数
 */
- (void)sendErpMessage:(NSString *)erpParam
{
    XNErpMessage *erpMessage = [[XNErpMessage alloc] init];
    erpMessage.erpParam = _erpParams;
    [self sendMessage:erpMessage resend:NO];
}

/*!
 @brief 转人工按钮点击事件方法（发送转人工消息）
 @param sender 转人工按钮
 */
-(void)robotChangeToManulServer:(UIButton *)sender{
    //设置按钮不可点击（防止频繁点击）
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    XNTextMessage *textMessage = [[XNTextMessage alloc] init];
    textMessage.textMsg = NSLocalizedStringFromTable(@"TurnManual", @"XNLocalizable", nil);//
//    textMessage.isClickRobot = YES;//0425
    [self sendMessage:(XNBaseMessage*)textMessage resend:NO];
    //延时3秒恢复按钮可点击
//    [self performSelector:@selector(canSelect) withObject:nil afterDelay:3.0];
}
//转人工按钮可点击
//-(void)canSelect{
//    if (robotChangeBtn) {
//         robotChangeBtn.selected = NO;
//    }
//}
/**
 恢复转人工按钮可点击状态（防止频繁点击）
 
 @param isCanClick 是否可点击
 */
-(void)robotChangeManualCanClicked:(BOOL)isCanClick{
    if (robotChangeBtn) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (isCanClick==YES) {
                robotChangeBtn.selected = NO;
            }
            
        });
    }
}

#pragma mark =================初始化变量====================

- (void)initData
{
    self.judgeDupDict = [[NSMutableDictionary alloc] init];
}
/*!
 @brief 判断消息是否重复
 @param message 待去重的消息
 @return 是否消息重复
 */
- (BOOL)duplicateMessage:(XNBaseMessage *)message
{
    BOOL duplicate = NO;
    for (XNBaseMessage *chatMessage in chatArray) {
        if ([chatMessage.msgid isEqualToString:message.msgid]) {
            [chatArray replaceObjectAtIndex:[chatArray indexOfObject:chatMessage] withObject:message];
            duplicate = YES;
            [chatTableView reloadData];
            break;
        }
    }
    return duplicate;
}
/*!
 @brief 将新消息添加到发送数组，并刷新界面
 @param message 待刷新显示的消息
 @param changeTitle 是否需要更新title上的客服名称
 @discusstion XNNotifyInterfaceDelegate 代理方法之一
 */
- (void)message:(XNBaseMessage *)message changeTitle:(BOOL)changeTitle
{
    //两层去重
    if ([chatArray containsObject:message]) {
        [chatTableView reloadData];
    } else if (![self duplicateMessage:message]) {
        if (message.msgType != MSG_TYPE_PICTURE &&
            message.msgType != MSG_TYPE_TEXT &&
            message.msgType != MSG_TYPE_VOICE &&
            message.msgType != MSG_TYPE_SYSTEM_EVALUATE &&
            message.msgType != MSG_TYPE_SYSTEM_HISTORYTip &&
            message.msgType != MSG_TYPE_FULLMEDIA &&
            message.msgType != MSG_TYPE_VIDEO) {
            return;//加 历史提示
        } else if ([message isKindOfClass:[XNEvaluateMessage class]]) {
            if (![chatArray containsObject:message]) {
                [chatArray addObject:message];
                [chatTableView reloadData];
                [self scrollToTableViewBottom:YES];
            }
            return;
        }
        
        if ([XNUtilityHelper isKefuUserid:message.userid] && changeTitle == YES) {
            NSString *str = message.externalname.length?message.externalname:(NSLocalizedStringFromTable(@"chatTitle", @"XNLocalizable", nil));
            //            if (str.length > 7) {
            //                str = [NSString stringWithFormat:@"%@...",[str substringToIndex:7]];
            //            }
            self.titleLabel.text = str;
            [self.titleLabel sizeToFit];
            self.currentKufuId = message.userid;
        }
        [self.messageArray addObject:message];
        [chatArray addObject:message];
        [chatTableView reloadData];
        [self scrollToTableViewBottom:YES];
    }
}
/*!
 @brief 点击链接文字事件方法（进留言）
 @discusstion 此处是机器人返回消息中含有进留言字段，点击会打开留言界面
 */
- (void)clickBlueText{
     [self gotoLeaveMsgCtrl:nil];
}

/*!
 @brief 点击链接文字事件方法（转人工）
 @discusstion 此处是机器人返回消息中含有转人工字段，点击会自动发送转人工的消息
 */
-(void)clickBlueTextToChangeManual{
    [self robotChangeToManulServer:nil];
}
/*!
 @brief 点击链接文字事件方法（进留言）
 @discusstion 此处是提示语中含有进留言字段，点击会打开留言界面
 */
- (void)blueTextClicked
{
    [self gotoLeaveMsgCtrl:nil];
}
/*!
 @brief 进留言的事件方法
 @param sender 手势
 @discusstion 打开留言界面
 */
- (void)gotoLeaveMsgCtrl:(UITapGestureRecognizer *)sender
{
    NTalkerLeaveMsgViewController *ctrl = [[NTalkerLeaveMsgViewController alloc] init];
    ctrl.siteId = [XNUtilityHelper siteidfromSettingid:_settingid];
    ctrl.settingId = _settingid;
    ctrl.responseKefu = _currentKufuId;
    ctrl.pageTitle = _pageTitle;
    ctrl.pageURLString = _pageURLString;
    //移除键盘
    [inputTextView resignFirstResponder];
    //移除键盘通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //跳转留言
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //重新添加键盘监听，否则无法输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppearance:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (!self.navigationController.navigationBar.translucent) {
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

/*!
 @brief 当前会话所处的连接状态
 @param status -1==失败；2 ==建立连接成功；4 ==请求客服成功；9 ==建立会话成功
 @param isError 连接是否出错
 @discusstion XNNotifyInterfaceDelegate代理方法之一
 */
- (void)connectStatus:(NSInteger)status isError:(BOOL)isError
{
    switch (status) {
        case -1:{
            
            _connectError = isError;
            
            _isInQueue = NO;
            [self.indicatorView stopAnimating];
            
            if ([chatArray containsObject:_utilMessage]) {
                [chatArray removeObject:_utilMessage];
            }
            
            XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
            XNLeaveMsgConfigureModel *model = basicInfo.leaveMsgConfigureModel;
            
            if (_currentStatus != 9 && basicInfo.netType.length) {
                if (isError) {
                    self.utilMessage.text = NSLocalizedStringFromTable(@"lostNetTip", @"XNLocalizable", nil);
                }else {
                    //配置可留言
                    if ([model.isopen isEqualToString:@"0"] || !model) {
                        self.utilMessage.text = NSLocalizedStringFromTable(@"customerServiceLeaved", @"XNLocalizable", nil);
                        //未设留言
                    }else{
                        self.utilMessage.text = NSLocalizedStringFromTable(@"KFLeavedNoLeaveMessage", @"XNLocalizable", nil);
                        //开启留言公告
                        if ([model.isannounce isEqualToString:@"0"]) {
                            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil)
                                                                                message:model.leavewords
                                                                               delegate:nil
                                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)
                                                                      otherButtonTitles:nil, nil];
                            [alertview show];
                            }
                    }
                }
                [chatArray addObject:_utilMessage];
                [chatTableView reloadData];
                [self scrollToTableViewBottom:YES];
            }
            break;
        }
        case 1:{
            if (!self.indicatorView.isAnimating) {
                [self.indicatorView startAnimating];
            }
            break;
        }
        case 2:{
            if (!self.indicatorView.isAnimating) {
                [self.indicatorView startAnimating];
            }
            break;
        }
        case 4:{
            break;
        }
        case 9:{
            [self.indicatorView stopAnimating];
            if ([chatArray containsObject:_utilMessage]) {
                [chatArray removeObject:_utilMessage];
                [chatTableView reloadData];
            }
            
            _successConnected = YES;
            _isInQueue = NO;
            [self sendMessage:_productMessage resend:NO];
            [self sendMessage:_launchPageMessage resend:NO];
            if (_erpParams.length) {
                [self sendErpMessage:_erpParams];
            }
            //机器人 刷新输入框
            [self refreshInputBarWhenRobot:self.KefuUserType];
            
            break;
        }
    }
    
    _currentStatus = status;
}
/*!
 @brief 当前排队情况
 @param num 排在第几位
 @discusstion 客服忙碌或刚上线时，用户咨询客服会先进入排队状态。
 */
- (void)currentWaitingNum:(NSInteger)num
{
    [self.indicatorView stopAnimating];
    
    _isInQueue = YES;
    
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    XNLeaveMsgConfigureModel *model = basicInfo.leaveMsgConfigureModel;
    //配置可留言
    if ([model.isopen isEqualToString:@"0"] || !model) {
        NSString *text1 = NSLocalizedStringFromTable(@"onlineUpFront", @"XNLocalizable", nil);
        NSString *text2 = NSLocalizedStringFromTable(@"onlineUpBehind", @"XNLocalizable", nil);
        self.utilMessage.text = [NSString stringWithFormat:@"%@%ld%@",text1,(long)(num + 1),text2];
    //未设留言
    }else{
        NSString *text1 = NSLocalizedStringFromTable(@"KFBusyNoLeaveMsgFront", @"XNLocalizable", nil);
        NSString *text2 = NSLocalizedStringFromTable(@"KFBusyNoLeaveMsgBehind", @"XNLocalizable", nil);
        self.utilMessage.text = [NSString stringWithFormat:@"%@%ld%@",text1,(long)(num + 1),text2];
        //开启留言公告
        if ([model.isannounce isEqualToString:@"0"]) {
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"tipTitle", @"XNLocalizable", nil)
                                                                        message:model.leavewords
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedStringFromTable(@"sure", @"XNLocalizable", nil)
                                                              otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    
    if ([chatArray containsObject:_utilMessage]) {
        [chatArray removeObject:_utilMessage];
        [chatArray addObject:_utilMessage];
        [chatTableView reloadData];
    } else {
        [chatArray addObject:_utilMessage];
        [chatTableView reloadData];
        [self scrollToTableViewBottom:YES];
    }
}
/*!
 @brief 刷新客服输入状态（消息预知）
 */
-(void)freshKefuInputing{
    if ([self.titleLabel.text isEqualToString:NSLocalizedStringFromTable(@"inputingTitle", @"XNLocalizable", nil)]) {
        return;
        
    }else {
        self.oldTitle = self.titleLabel.text;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.text = NSLocalizedStringFromTable(@"inputingTitle", @"XNLocalizable", nil);
            [self.titleLabel sizeToFit];
            
        });
    }
}
/*!
 @brief 隐藏客服输入状态（消息预知）
*/
-(void)hideKefuInputing{
    
    if ([self.titleLabel.text isEqualToString:NSLocalizedStringFromTable(@"inputingTitle", @"XNLocalizable", nil)]&&![self.oldTitle isEqualToString:NSLocalizedStringFromTable(@"inputingTitle", @"XNLocalizable", nil)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *olstring = self.oldTitle;
            self.titleLabel.text = olstring;
            [self.titleLabel sizeToFit];
        });
    }
}
/*!
 @brief 客服发来邀请评价后刷新客服名称
 @param userName 发来邀请评价的客服名称
 */
- (void)requestEvaluate:(NSString *)userName
{
    _alreadyShowEvaTag = NO;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in [keyWindow subviews]) {
        //评价崩溃bug 加保护
        if ([view subviews].count>0) {
            if ([[view subviews][0] isKindOfClass:[XNEvaluateView class]]) {
                return;
            }
        }
        
    }
    
    //    UIButton *button = [self.navigationItem.titleView subviews][0];
    //    [button setTitle:userName forState:UIControlStateNormal];
//    NSString *str = userName.length?userName:(NSLocalizedStringFromTable(@"chatTitle", @"XNLocalizable", nil));
    //    if (str.length > 7) {
    //        str = [NSString stringWithFormat:@"%@...",[userName substringToIndex:7]];
    //    }
//    self.titleLabel.text = str;
//    [self.titleLabel sizeToFit];
    if ([inputTextView isFirstResponder]) {
        [inputTextView resignFirstResponder];
    }
    [XNEvaluateView addEvaluateViewWithFrame:CGRectMake(10, 75, kFWFullScreenWidth - 20, kFWFullScreenHeight - 130) delegate:self];
}
/*!
 @brief 提交评价
 @param dict 评价内容
 @param evaluateView 评价界面
 */
- (void)submitMessage:(NSDictionary *)dict evaluateView:(XNEvaluateView *)evaluateView
{
    XNEvaluateMessage *message = [[XNEvaluateMessage alloc] init];
    message.score = [dict[EVALUATEVALUE] unsignedIntegerValue];
    message.evaluateContent = dict[EVALUATECONTENT];
    message.proposal = dict[EVALUATESUGGEST];
    message.solveStatus = dict[EVALUATESTATUS];
    message.solveStatusValue = [dict[EVALUATESTATUSVALUE] unsignedIntegerValue];
    [self sendMessage:message resend:NO];
    [evaluateView removeFromSuperview];
    //防止频繁点击评价按钮
    dispatch_async(dispatch_get_main_queue(), ^{
        if (functionView) {
            UIButton *evalueButton = (UIButton *)[functionView viewWithTag:1090];
            evalueButton.enabled = NO;
        }
    });
    
    if (_needPop) {
        [self performSelector:@selector(endChat) withObject:nil afterDelay:1.0];
    }
}
/*!
 @brief 取消评价
 @param evaluateView 评价界面
 */
- (void)cancel:(XNEvaluateView *)evaluateView
{
    _needPop = NO;
    //评价取消崩溃0513
    if (evaluateView) {
        [evaluateView removeFromSuperview];
    }
    
}

/*!
 @brief 获取评级配置信息
 @param couldEvaluate 是否可以评价
 @param enableevaluation 是否强制评价
 @param evaluated 是否评价过
 */
- (void)sceneChanged:(BOOL)couldEvaluate couldForceEvalue:(BOOL)enableevaluation andEvaluted:(BOOL)evaluated
{
    _couldEvaluted = couldEvaluate;
    _evaluated = evaluated;
    _enableevaluation = enableevaluation;
    
    UIButton *button = (UIButton *)[functionView viewWithTag:1090];
    UILabel *label = (UILabel *)[functionView viewWithTag:1091];
    
    if (!button) return;
    
    // woo222
//    if (couldEvaluate) {
//        button.enabled = YES;
//    } else {
//        button.enabled = NO;
//    }
    
    if (evaluated) {
        label.text = NSLocalizedStringFromTable(@"haveEvaluedLabel", @"XNLocalizable", nil);
        // woo222
        button.enabled = NO;
    }else {
        label.text = NSLocalizedStringFromTable(@"evalueLabel", @"XNLocalizable", nil);//评价 刷回 bug
    }
}
/*!
 @brief 刷新客服显示信息
 @param user 客服信息模型
*/
- (void)userList:(XNChatBasicUserModel *)user
{
    if ([user isKindOfClass:[XNChatKefuUserModel class]]) {
        XNChatKefuUserModel *kefu = (XNChatKefuUserModel *)user;
        NSString *str = kefu.externalname.length?kefu.externalname:(NSLocalizedStringFromTable(@"chatTitle", @"XNLocalizable", nil));
        //        if (str.length > 7) {
        //            str = [NSString stringWithFormat:@"%@...",[str substringToIndex:7]];
        //        }
        self.titleLabel.text = str;
        [self.titleLabel sizeToFit];
        self.currentKufuId = user.userid;
        //机器人
        self.KefuUserType = kefu.usertype;
        }
}
/*!
 @brief 机器人转人工后刷新inputView的UI
 @param scenemode 区分机器人和人工 1：机器人  0：人工  nil:没有机器人
 @discusstion XNNotifyInterfaceDelegate的代理方法之一
 */
-(void)reSetInputBarWithRobot:(NSInteger)scenemode{
    
    [self refreshInputBarWhenRobot:scenemode];
}

#pragma mark ===================resend=====================

- (void)videoWillPlay:(XNVideoMessage *)videoMessage
{
    XNVideoPlayerController *ctrl = [[XNVideoPlayerController alloc] init];
    ctrl.videoMessage = videoMessage;
    [self presentViewController:ctrl animated:YES completion:nil];
}
- (void)resendTextMsg:(XNTextMessage *)textMessage
{
    [self resendMessage:textMessage];
}

- (void)resendVoiceMsg:(XNVoiceMessage *)voiceMessage
{
    [self resendMessage:voiceMessage];
}

- (void)resendImageMsg:(XNImageMessage *)imageMessage
{
    [self resendMessage:imageMessage];
}
//小视频
- (void)resendVideoMsg:(XNVideoMessage *)videoMessage
{
    [self resendMessage:videoMessage];
}

- (void)reloadTableView
{
    [chatTableView reloadData];
}

- (void)resendMessage:(XNBaseMessage *)message
{
    if (![chatArray containsObject:message]) {
        return;
    }
    
    [chatArray removeObject:message];
    [chatArray addObject:message];
    [self.messageArray removeObject:message];//?
    [self.messageArray addObject:message];//?
    [self sendMessage:message resend:YES];
    [chatTableView reloadData];
    [self scrollToTableViewBottom:YES];
}

- (void)toWebViewBySuperLink:(NSString *)link
{
    //SF
    if (link.length) {
        
        
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        jump.type = 0;
        jump.url = link;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        [FWO2OJump didSelect:jump];
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
//            SFSafariViewController *webView = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:link]];
//            [self.navigationController pushViewController:webView animated:YES];
//        }else{
//            XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
//            ctrl.productURL = link;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
    }
}
/**
 @brief 点击链接名片cell跳转网页
 @param linkString  跳转的URL
 @discusstion XNTapSuperLinkDeleate的代理方法之一
 */
- (void)jumpToWebViewByLink:(NSString *)linkString
{
    
    //SF
    if (linkString.length) {
        
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        jump.type = 0;
        jump.url = linkString;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        [FWO2OJump didSelect:jump];
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
//            SFSafariViewController *webView = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:linkString]];
//            [self.navigationController pushViewController:webView animated:YES];
//        }else{
//            XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
//            ctrl.productURL = linkString;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
    }
    
    

}

/**
 @brief 点击富媒体cell跳转网页
 @param fullMediaString  跳转的URL
 @discusstion XNTapSuperFullMediaDeleate代理方法之一
 */
- (void)jumpToWebViewByFullMediaString:(NSString *)fullMediaString
{
    //SF
    if (fullMediaString.length) {
        
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        jump.type = 0;
        jump.url = fullMediaString;
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        [FWO2OJump didSelect:jump];
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
//            SFSafariViewController *webView = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:fullMediaString]];
//            [self.navigationController pushViewController:webView animated:YES];
//        }else{
//            XNShowProductWebController *ctrl = [[XNShowProductWebController alloc] init];
//            ctrl.productURL = fullMediaString;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
    }
}

/**
 @brief 点击发送反问引导代理方法。
 @param textMessage   需要添加到消息队列中的消息
 */
- (void)didSelectedToSendMsg:(XNTextMessage *)textMessage {
    
    [self.messageArray addObject:textMessage];
    [self sendMessage:textMessage resend:NO];
    [chatTableView reloadData];
    [self scrollToTableViewBottom:YES];
}
/**
 @brief 将自定义文本类消息（比如订单信息）加入发送队列。
 @param extendString   待发送文本类消息 
 */
+(void)sendExtendTextMessage:(NSString*)extendString{
    
    XNTextMessage *textMessage = [[XNTextMessage alloc] init];
    textMessage.textMsg = extendString;
    [[XNSDKCore sharedInstance] sendMessage:(XNBaseMessage*)textMessage resend:NO];
}

#pragma mark ====================other=====================

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
/**
 @brief 弹出提示语
 */
- (void)showPromptView
{
    NSString *str = nil;
    //优先判断网络状态
    XNUserBasicInfo *basicInfo = [XNUserBasicInfo sharedInfo];
    XNLeaveMsgConfigureModel *model = basicInfo.leaveMsgConfigureModel;
    //网络出错
    if (!basicInfo.netType.length) {
        str = NSLocalizedStringFromTable(@"netWorkStatusTip", @"XNLocalizable", nil);
    }else {
        if (_currentStatus == -1) {
            //连接出错
            if (_connectError) {
                str = NSLocalizedStringFromTable(@"lostNetTip", @"XNLocalizable", nil);
            }else{
                //配置可留言
                if ([model.isopen isEqualToString:@"0"]|| !model) {
                    str = NSLocalizedStringFromTable(@"customerServiceLeavedTip", @"XNLocalizable", nil);
                    }
                //未设留言
                else{
                    str = NSLocalizedStringFromTable(@"KFLeavedNoLeaveMessage", @"XNLocalizable", nil);
                }
            }
        } else {
            if (_isInQueue) {
              str = NSLocalizedStringFromTable(@"customerServiceBusyTip", @"XNLocalizable", nil);
            } else {
                str = NSLocalizedStringFromTable(@"requestingTip", @"XNLocalizable", nil);
            }
        }
    
    
    }
    [self showToastViewWithContent:str andRect:CGRectMake((kFWFullScreenWidth - 150)/2, (kFWFullScreenHeight - 50)/2, 150, 30) andTime:2.0 andObject:self];//0513
}
- (void)showToastViewWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController
{
    if ([selfController.view viewWithTag:1234554321]) {
        UIView * tView = [selfController.view viewWithTag:1234554321];
        [tView removeFromSuperview];
    }
    
    UIImageView * toastView = [[UIImageView alloc] initWithFrame:rect];
    
    [toastView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    
    [toastView.layer setCornerRadius:5.0f];
    [toastView.layer setMasksToBounds:YES];
    [toastView setAlpha:1.0f];
    [toastView setTag:1234554321];
    [selfController.view addSubview:toastView];
    
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:17.0f]
                           constrainedToSize: CGSizeMake(rect.size.width ,MAXFLOAT)
                               lineBreakMode: NSLineBreakByWordWrapping];
    if (labelSize.height > rect.size.height) {
        [toastView setFrame:CGRectMake(toastView.frame.origin.x, (kFWFullScreenHeight - 44 * 2- labelSize.height)/2, toastView.frame.size.width, labelSize.height)];
    }
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toastView.frame.size.width - 20, toastView.frame.size.height)];
    [contentLabel setText:content];
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [toastView addSubview:contentLabel];
    
    if (time>0.01) {
        [self performSelector:@selector(removeToastView:) withObject:selfController afterDelay:time];
    }
    
}

- (void)removeToastView:(id)sender
{
    UIViewController * selfController = (UIViewController *)sender;
    UIView * toastView = [selfController.view viewWithTag:1234554321];
    [toastView removeFromSuperview];
    toastView = nil;
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
/**
 @brief 连接tchat会话。
 @discusstion   tchat成功连接表示会话建立成功
 */
- (void)connectToChat
{
    [[XNSDKCore sharedInstance] startChatWithSettingid:_settingid
                                                kefuId:_kefuId
                                              isSingle:_isSingle];
}
//图片上加文字
-(void)setTipLabelToSuperView:(UIImageView*)superImageView withFrame:(CGRect)labelFrme Text:(NSString*)text textColor:(UIColor *)textColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment backGroundColor:(UIColor *)backcolor NumOflines:(NSInteger)numLine  labelTag:(NSInteger)tag andSelfLabel:(UILabel **)selfLabel
{
    UILabel *tipLabel = nil;
    
    if ((UILabel *)[superImageView viewWithTag:tag]) {
        tipLabel = (UILabel *)[superImageView viewWithTag:tag];
        
    }else {
       tipLabel = [[UILabel alloc]init];
    }
    [tipLabel setFrame:labelFrme];
    tipLabel.text = text?:@"";
    tipLabel.tag = tag;
    tipLabel.textColor = textColor;
    tipLabel.font = textFont;
    tipLabel.numberOfLines = numLine;
    tipLabel.textAlignment = textAlignment;
    tipLabel.backgroundColor = backcolor;
    [superImageView addSubview:tipLabel];
    if (selfLabel) {
        *selfLabel = tipLabel;
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
    CGSize  actualsize =[textString boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:textDic context:nil].size;
    
    promptLabel.numberOfLines = 0;
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    promptLabel.frame = CGRectMake(promptLabel.frame.origin.x,promptLabel.frame.origin.y, promptLabel.frame.size.width,actualsize.height);
    
}
/**
 获取相机是否可用权限
 */
- (void)obtainAuthorization
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (granted) {
                                             
                                             XNRecordViewController *ctrl = [[XNRecordViewController alloc] init];
                                             ctrl.delegate = self;
                                             [self presentViewController:ctrl animated:YES completion:nil];
                                         } else {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"noPermissions", @"XNLocalizable", nil) message:NSLocalizedStringFromTable(@"openPermissions", @"XNLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"XNLocalizable", nil) otherButtonTitles:nil, nil];
                                             [alertView show];
                                         }
                                     }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            
            XNRecordViewController *ctrl = [[XNRecordViewController alloc] init];
            ctrl.delegate = self;
            [self presentViewController:ctrl animated:YES completion:nil];
            
            break;
        }
        default:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"noPermissions", @"XNLocalizable", nil) message:NSLocalizedStringFromTable(@"openPermissions", @"XNLocalizable", nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"XNLocalizable", nil) otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
    }
}

//语音听筒与扬声器切换模式
- (void)proximitySensorChanged:(BOOL)isNearToUser
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isNearToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (![self.audioPlayer isPlaying]) {
            [[XNDeviceManager sharedInstance] cancelProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}


@end

