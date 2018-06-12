//
//  NTalkerRobotChooseChatController.m
//  NTalkerUIKitSDK
//
//  Created by wu xiang on 16/4/14.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNRobotChooseViewModel.h"
#import "XNToolsHelper.h"

@interface XNLineView : UIView

@end

@implementation XNLineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGFloat lengths[] = {3, 3};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextSetStrokeColorWithColor(context, [XNToolsHelper colorWithHexString:@"cdd2de"].CGColor);
    CGContextMoveToPoint(context, 1.0, 0.0);
    CGContextAddLineToPoint(context, rect.size.width, 0.0);
    CGContextStrokePath(context);
}

@end

@interface XNRobotChooseViewModel ()<UITableViewDelegate, UITableViewDataSource, NTalkerMLEmojiLabelDelegate>

@property (nonatomic, strong) NSArray *textMsgArray;

@property (nonatomic, strong) NSMutableArray *cellSizeArray;

@property (nonatomic, strong) NTalkerMLEmojiLabel *tempLabel;

@end

@implementation XNRobotChooseViewModel

#define NTalkerRobotChooseChatDefaultHeight 100
#define NTalkerRobotChooseChatLabelTag 12580
#define NTalkerRobotChooseChatLineViewTag 10086

#define NTalkerRobotChooseChatLabelMargin 8

- (instancetype)init {
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, NTalkerRobotChooseChatDefaultHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.fontSize = 14;
        self.fontColor = [UIColor blueColor];
    }
    return self;
}

- (void)setTableViewWidth:(CGFloat)tableViewWidth {
    _tableViewWidth = tableViewWidth;
    
    self.tableView.frame = CGRectMake(10, 0, _tableViewWidth, NTalkerRobotChooseChatDefaultHeight);
}


- (void)setTextMsg:(NSString *)textMsg {
    _textMsg = textMsg;
    
    _textMsg = [_textMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray *arr = [[_textMsg componentsSeparatedByString:@"\n"] mutableCopy];
    self.textMsgArray = arr;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textMsgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellReuseIdentifier = @"NTalkerRobotChooseChatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellReuseIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 文本框
        NTalkerMLEmojiLabel *label = [[NTalkerMLEmojiLabel alloc] initWithFrame:CGRectMake(0, NTalkerRobotChooseChatLabelMargin, _tableViewWidth, 20)];
        label.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        label.customEmojiPlistName = @"expressionImage_custom";
        label.font = [UIFont systemFontOfSize:self.fontSize];
        label.numberOfLines = 0;
        label.tag = NTalkerRobotChooseChatLabelTag;
        label.backgroundColor = [UIColor clearColor];
        [cell addSubview:label];
        // 分割线
        XNLineView *lineView = [[XNLineView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
        lineView.tag = NTalkerRobotChooseChatLineViewTag;
        lineView.backgroundColor = [UIColor clearColor];
        [cell addSubview:lineView];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    NTalkerMLEmojiLabel *label = [cell viewWithTag:NTalkerRobotChooseChatLabelTag];
    label.text = self.textMsgArray[indexPath.row];
    if (indexPath.row == 0) {
        label.delegate = self;
        label.userInteractionEnabled = YES;
        cell.userInteractionEnabled = YES;
    } else {
        label.delegate = nil;
        label.userInteractionEnabled = NO;
        cell.userInteractionEnabled = self.canSelected;
    }
    NSString *richText = @"";
    NSRange clickFromRange = [label.text rangeOfString:@"["];
    NSRange clickToRange = [label.text rangeOfString:@"\n"];
    NSRange clickRange = NSMakeRange(0, 0);
    //    需要截取
    if (clickFromRange.location!= NSNotFound) {
        clickRange.location = clickFromRange.location;
        //截取部分
        if (clickToRange.location!=NSNotFound&&(clickToRange.location>clickFromRange.location)) {
            clickRange.length = clickToRange.location - clickFromRange.location;
            //截到最后
        }else{
            clickRange.length = [(NSString *)label.text length] - clickFromRange.location;
        }
        richText = [label.text substringWithRange:clickRange];
        //渲染
        [self RichTextLabel:label FontNumber:[UIFont systemFontOfSize:self.fontSize] AndRange:clickRange AndColor:self.fontColor];
        //不需要截取
    }else{
        label.textColor = [UIColor blackColor];
    }
    XNLineView *lineView = [cell viewWithTag:NTalkerRobotChooseChatLineViewTag];
    if (indexPath.row == 0 || indexPath.row == (self.textMsgArray.count - 1)) {
        lineView.hidden = YES;
    } else {
        lineView.hidden = NO;
    }
    CGSize size = [label preferredSizeWithMaxWidth:_tableViewWidth];
    label.frame = CGRectMake(0, NTalkerRobotChooseChatLabelMargin, size.width, size.height);
    lineView.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + NTalkerRobotChooseChatLabelMargin - 1, lineView.frame.size.width, lineView.frame.size.height);
}

// cell的高度计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = self.textMsgArray[indexPath.row];
    CGSize size = [self sizeForLabelContent:content];
    // 這裏返回需要的高度
    return size.height + 2 * NTalkerRobotChooseChatLabelMargin ;
}

// 根据文本内容返回emojiLabel的size
- (CGSize)sizeForLabelContent:(NSString *)content {
    self.tempLabel.text = content;
    CGSize size = [self.tempLabel preferredSizeWithMaxWidth:_tableViewWidth];
    return size;
}
// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 0) {
        
    } else if (self.didSelectCellBlock && self.canSelected) {
        UILabel *label = [cell viewWithTag:NTalkerRobotChooseChatLabelTag];
        self.didSelectCellBlock(label.text);
    }
}

#pragma mark -- 懒加载
- (NSArray *)textMsgArray {
    if (!_textMsgArray) {
        _textMsgArray = [NSArray array];
    }
    return _textMsgArray;
}

- (NTalkerMLEmojiLabel *)tempLabel {
    if (!_tempLabel) {
        NTalkerMLEmojiLabel *label = [[NTalkerMLEmojiLabel alloc] initWithFrame:CGRectMake(0, NTalkerRobotChooseChatLabelMargin, _tableViewWidth, 20)];
        label.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        label.customEmojiPlistName = @"expressionImage_custom";
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:self.fontSize];
        _tempLabel = label;
    }
    return _tempLabel;
}
//设置不同字体颜色
-(void)RichTextLabel:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)TextColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:TextColor range:range];
    label.attributedText = str;
}

// woo
- (void)mlEmojiLabel:(NTalkerMLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(NTalkerMLEmojiLabelLinkType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedEmojiLabelLink:withType:)]) {
        [self.delegate didSelectedEmojiLabelLink:link withType:type];
    }
}



@end
