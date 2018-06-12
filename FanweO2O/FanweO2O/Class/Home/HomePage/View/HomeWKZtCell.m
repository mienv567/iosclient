//
//  HomeWKZtCell.m
//  FanweO2O
//
//  Created by hym on 2016/12/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "HomeWKZtCell.h"
#import <WebKit/WebKit.h>

static NSString *cellIndent =  @"HomeWKZtCell";

@interface HomeWKZtCell()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,HomeWKZtCellDelegate> {
    BOOL _isWebViewDidFinishLoad;
}

@property (nonatomic, strong) WKWebView         *webView;               //wkwebview

@end

@implementation HomeWKZtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

+ (HomeWKZtCell *)cellWithTableView:(UITableView *)tableView {
    HomeWKZtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndent];
    
    if (!cell) {
        cell = [[HomeWKZtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.contentView setBackgroundColor:kBackGroundColor];
        [cell doInit];
    }
    
    return cell;
    
}

- (void)doInit {
    WKWebView *webView = [WKWebView new];
    
    [self.contentView addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    self.webView = webView;
    self.webView.navigationDelegate=self;
    [self.webView.scrollView setScrollEnabled:NO];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setCellContent:(NSString *) contentStr isWebViewDidFinishLoad:(BOOL)isWebViewDidFinishLoad{
    if (!isWebViewDidFinishLoad) {
        [self.webView loadHTMLString:contentStr baseURL:nil];
    }
    
}

#pragma mark js请求oc
- (void)evaluateMyJavaScript:(WKWebView *)webView{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"fun.js" ofType:nil];
    NSString *jsStr=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView evaluateJavaScript:jsStr completionHandler:nil];
}


#pragma mark 加载完毕
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%lf",[result doubleValue]);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.webView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.
        
        UIScrollView *scrollView = self.webView.scrollView;
        NSLog(@"New contentSize: %f x %f", scrollView.contentSize.width, scrollView.contentSize.height);
        
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.height.mas_offset(scrollView.contentSize.height);
        }];
        
        if (_delegate != nil) {
            if ([_delegate respondsToSelector:@selector(beginRefreshTableView:isWebViewDidFinishLoad:)]) {
              
                [_delegate beginRefreshTableView:scrollView.contentSize.height isWebViewDidFinishLoad:YES];
            }

        }

        
        
        //self.frame = CGRectMake(0, 0, SCREEN_WIDTH, scrollView.contentSize.height);
    }
}

@end
