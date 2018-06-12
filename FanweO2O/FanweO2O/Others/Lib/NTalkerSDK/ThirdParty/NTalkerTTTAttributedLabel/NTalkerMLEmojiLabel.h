//
//  MLEmojiLabel.h
//  MLEmojiLabel
//
//  Created by molon on 5/19/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "NTalkerTTTAttributedLabel.h"
#pragma mark ********* 自定义*********
typedef void(^clickedBlueTextBlock)(NSString *clickedBlueTextBlock);

typedef NS_OPTIONS(NSUInteger, NTalkerMLEmojiLabelLinkType) {
    NTalkerMLEmojiLabelLinkTypeURL = 0,
    NTalkerMLEmojiLabelLinkTypeEmail,
    NTalkerMLEmojiLabelLinkTypePhoneNumber,
    NTalkerMLEmojiLabelLinkTypeAt,
    NTalkerMLEmojiLabelLinkTypePoundSign,
};


@class NTalkerMLEmojiLabel;
@protocol NTalkerMLEmojiLabelDelegate <NTalkerTTTAttributedLabelDelegate>

@optional
- (void)mlEmojiLabel:(NTalkerMLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(NTalkerMLEmojiLabelLinkType)type;


@end

@interface NTalkerMLEmojiLabel : NTalkerTTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者
@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要
@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, weak) id<NTalkerMLEmojiLabelDelegate> delegate; //点击连接的代理方法
#pragma clang diagnostic pop

@property (nonatomic, copy, readonly) id emojiText; //外部能获取text的原始副本

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;

#pragma mark******** 自定义修改的方法*******
@property (nonatomic,copy)clickedBlueTextBlock clickedBlueTextBlock;
@property(nonatomic) NSRange highlightedRange;
@property (nonatomic,strong)NSMutableArray *clickTextArray;
//确定段落范围
-(id)configureWithText:(NSString *)text andClickText:(NSMutableArray *)clickStringArray;
//点击蓝色文字
-(void)setBlock:(clickedBlueTextBlock)block;


@end
