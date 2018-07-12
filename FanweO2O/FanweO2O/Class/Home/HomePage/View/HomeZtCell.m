//
//  HomeZtCell.m
//  O2O
//
//  Created by mac on 15/3/17.
//  Copyright (c) 2015年 fanwe. All rights reserved.
//

#import "HomeZtCell.h"
#import "LogInViewController.h"
//static NSString *cellIndent =  @"HomeZtCell";
@interface HomeZtCell()
{
    UIWebView *_myWebView;
    float _myHeight;
    BOOL _isWebViewDidFinishLoad;
    UIView *_bottomView;
    NSInteger _section;
}
@end

@implementation HomeZtCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
    }
    return self;
}

+ (HomeZtCell *)cellWithTableView:(UITableView *)tableView cellIndent:(NSString *)cellIndent {
    HomeZtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[HomeZtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.contentView setBackgroundColor:kBackGroundColor];
    }
    return cell;
}

-(void)setCellContent:(NSString *) contentStr isWebViewDidFinishLoad:(BOOL)isWebViewDidFinishLoad{
    
    if(contentStr.length == 0){
        CGRect newFrame = self.frame;
        newFrame.size.height = 0;
        _myHeight = 0;
        self.frame = newFrame;
    } else {
        _isWebViewDidFinishLoad = isWebViewDidFinishLoad;
        self.backgroundColor = [UIColor clearColor];
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        //底部图层
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bottomView];
        
        _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
     
        _myWebView.backgroundColor = [UIColor whiteColor];
        _myWebView.opaque = NO;
        _myWebView.delegate = self;
        _myWebView.scrollView.scrollEnabled = NO; //不滚动
        [self.contentView addSubview:_myWebView];
        [_myWebView loadHTMLString:contentStr baseURL:nil];
    }
    
}
//获得单元格式高度
- (CGFloat)getCellHeight:(float)myHeight{
    _myHeight = myHeight;
    return _myHeight;
}

- (void)setTableViewTag:(NSInteger)Tag {
    _section = Tag;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    
    newFrame = _bottomView.frame;
    newFrame.size.height = webViewHeight;
    _bottomView.frame = newFrame;
    
    newFrame = _myWebView.frame;
    newFrame.size.height = webViewHeight;
    _myWebView.frame = newFrame;
    newFrame = self.frame;
    newFrame.size.height = webViewHeight;
    
    self.frame = newFrame;
    _myHeight = webViewHeight;
    
    if (!_isWebViewDidFinishLoad) {
            if (_delegate &&[_delegate respondsToSelector:@selector(refreshTableView: withTag:)]) {
//                [_delegate performSelector:@selector(refreshTableView: withTag:) withObject:[NSString stringWithFormat:@"%f",_myHeight]];
                [_delegate refreshTableView:[NSString stringWithFormat:@"%f",_myHeight] withTag:_section];
            }
//            if ([_delegate respondsToSelector:@selector(refreshTableView:tagStr:)]) {
//                [_delegate refreshTableView:_myHeight tagStr:_tagStr];
//            }
        
    }
    
    //加载js文件
    NSString *path=[[NSBundle mainBundle] pathForResource:@"funs.js" ofType:nil];
    NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js文件到页面
    [_myWebView stringByEvaluatingJavaScriptFromString:jsStr];
    
}

#pragma mark - WebView 代理方法
#pragma mark 页面加载前(此方法返回false则页面不再请求)
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@".."];
    NSString *fils = (NSString *)[components objectAtIndex:0];
    NSString *sssf = [fils substringWithRange:NSMakeRange(fils.length-14, 14)];
    if ([components count] > 1 && [sssf  isEqualToString:@"App.app_detail"]) {
        
        NSString *tmpStr = [components objectAtIndex:1];
        NSArray *myKeyArray = [tmpStr componentsSeparatedByString:@"&&"];
        NSString *myDetailType = [myKeyArray objectAtIndex:0];
        NSString *myDetailId = [myKeyArray objectAtIndex:1];
        
        [self goMyDetail:myDetailType detailMyId:myDetailId];
        
        return NO;
    }else if([requestString hasPrefix:@"http"]){
        [self goMyWebView:requestString];
        
        return NO;
    }
    return true;
}

- (void)goMyDetail:(NSString *)detailType detailMyId:(NSString *)detailId{
    
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(goDetail:detailId:)]) {
            [_delegate performSelector:@selector(goDetail:detailId:) withObject:detailType withObject:detailId];
        }
    }
    
}

- (void)goMyWebView:(NSString *)url{
    if (_delegate != nil) {
        if ([_delegate respondsToSelector:@selector(goWebView:)]) {
            [_delegate performSelector:@selector(goWebView:) withObject:url];
        }
    }
}

@end
