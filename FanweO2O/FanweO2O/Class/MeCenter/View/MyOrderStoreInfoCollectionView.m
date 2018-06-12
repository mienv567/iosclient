//
//  MyOrderStoreInfoCollectionView.m
//  FanweO2O
//
//  Created by hym on 2017/3/3.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderStoreInfoCollectionView.h"
#import "MyOrderModel.h"
#import "MyOrderImageView.h"
#import "MyOrderDetailsVC.h"

@interface MyOrderStoreInfoCollectionView()


@property (weak, nonatomic) IBOutlet UILabel *lbStoreName;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end

@implementation MyOrderStoreInfoCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viewContainer setBackgroundColor:RGB(247, 248, 248)];
    [self.scrollView setBackgroundColor:RGB(247, 248, 248)];
    [self.line setBackgroundColor:kLineColor];
    [self.lbStatus setFont:[UIFont systemFontOfSize:15]];
    [self.lbStatus setTextColor:RGB(255, 34, 68)];
}

+ (instancetype )appView {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"MyOrderView" owner:nil options:nil];
    
    return [objs lastObject];
}

- (void)setItem:(DealOrderItem *)item {
    _item = item;
    
    //MyOrderStoreItem *store = [item.list firstObject];
    self.lbStoreName.text = item.supplier_name;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat left = 10;
    UIView *bg = [UIView new];
    for (MyOrderStoreItem *store in item.list) {
        MyOrderImageView *image = [MyOrderImageView createView];
        
        [image.imageView sd_setImageWithURL:[NSURL URLWithString:store.deal_icon] placeholderImage:kDefaultCoverIcon];
        
        [bg addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(69, 69));
            make.centerY.equalTo(bg).with.offset(-1);
            make.left.equalTo(bg.mas_left).with.offset(left);
        }];
        
        UILabel *lbCount = [UILabel new];
        [lbCount setTextColor:[UIColor whiteColor]];
        [lbCount setBackgroundColor:RGB(255, 34, 68)];
        [lbCount setFont:[UIFont systemFontOfSize:10]];
        
        [bg addSubview:lbCount];
        
        NSString *number = store.number;
        
        //store.number = @"99";
        if ([store.number length] > 2) {
          number = @"99";
        }
        
        [lbCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14 , 14 ));
            make.bottom.equalTo(image.mas_bottom).with.offset(2);
            make.right.equalTo(image.mas_right).with.offset(7);
        }];
        lbCount.layer.masksToBounds = YES;
        lbCount.textAlignment = NSTextAlignmentCenter;
        lbCount.text = number;
        lbCount.layer.cornerRadius = 7 ;
        
        left = left + 69 + 10;
        
    }
    [self.scrollView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(left, CGRectGetHeight(self.scrollView.frame)));
        make.left.equalTo(self.scrollView.mas_left).with.offset(0);
        make.top.equalTo(self.scrollView.mas_top).with.offset(0);
    }];
    [self.scrollView setContentSize:CGSizeMake(left, CGRectGetHeight(self.scrollView.frame))];
    
    UIButton *button = [UIButton new];
    
    [bg addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bg.mas_left).with.offset(0);
        make.right.equalTo(bg.mas_right).with.offset(0);
        make.top.equalTo(bg.mas_top).with.offset(0);
        make.bottom.equalTo(bg.mas_bottom).with.offset(0);
        //make.centerY.equalTo(bg).with.offset(0);
        //make.size.mas_equalTo(CGSizeMake(left, 90));
    }];
    
    [button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) onClick {
    if (self.block) {
        self.block(nil);
    }
}

@end
