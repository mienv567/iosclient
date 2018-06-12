//
//  ClassSectionView.m
//  FanweO2O
//
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassSectionView.h"
#import "ClassSectionModel.h"
#import "ClassSectionButton.h"
@interface ClassSectionView()
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ClassSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        //
        [self doInit];
    }
    
    return self;
}

- (void)doInit {
    
    UIView *line = [UIView new];
    [line setBackgroundColor:kLineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_offset(0.5);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    self.scrollView = [UIScrollView new];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(line.mas_top).with.offset(0);
    }];
    
    self.iCount = 4;
}

- (void)setArray:(NSArray *)array {
    _array = array;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat width = CGRectGetWidth(self.frame) / self.iCount;
    
    for (int i = 0;i < array.count; i++) {
        
        ClassSectionModel *model = array[i];
        model.tag = i;
        ClassSectionButton *btn = [ClassSectionButton new];
        [btn setTitleColor:kAppFontColorRed forState:UIControlStateSelected];
        [btn setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        btn.tag = i;
        
        [btn setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:model.imageSelect] forState:UIControlStateSelected];
        
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitle:model.name forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(onClickSelct:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = model.hsSelect;
        
        [self.scrollView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(i * width);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.width.mas_offset(width);
        }];
        
        
        
    }
    
    [self.scrollView setContentSize:CGSizeMake(width*array.count, CGRectGetHeight(self.frame))];
}

- (void)onClickSelct:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    
    ClassSectionModel *model = _array[tag];
    
    sender.selected = YES;

    if (model.hsChange) {
        
        if (model.hsSelect) {
            
            return;
        }
        
        for (int i = 0; i < _array.count; i++) {
            ClassSectionModel *model = _array[i];
            if (i == tag) {
                
                model.hsSelect = YES;
                
            }else {
                
                model.hsSelect = NO;
            }
        }
        
    }else {
        
        for (int i = 0; i < _array.count; i++) {
            ClassSectionModel *model = _array[i];
            if (!model.hsChange) {
                if (model.tag != tag) {
                    model.hsSelect = NO;
                }
            }
        }
        
        model.hsSelect = !model.hsSelect;
        
    }
    
    if (self.block) {
        self.block(model);
    }
    
}

@end
