//
//  MallListClassSectionView.m
//  FanweO2O
//
//  Created by hym on 2017/2/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MallListClassSectionView.h"
#import "ClassSectionView.h"
@interface MallListClassSectionView ()

@property (nonatomic, strong) ClassSectionView *section;
@property (nonatomic, strong) UIButton *btnClass;
@property (nonatomic, strong) NSArray *array;


@end

@implementation MallListClassSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    
    return self;
}

- (void)doInit {
    ClassSectionView *section = [[ClassSectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    //section.backgroundColor = [UIColor redColor];
    [self addSubview:section];
    
    [section mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-41);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    UIView *line = [UIView new];
    
    line.backgroundColor = kLineColor;
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(section.mas_right).with.offset(0);
        make.width.mas_offset(0.5);
    }];
    
    UIView *line1 = [UIView new];
    
    line1.backgroundColor = kLineColor;
    [self addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(section.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_offset(0.5);
    }];
    
    UIButton *btn = [UIButton new];
    
    [btn setImage:[UIImage imageNamed:@"o2o_list_icon"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"o2o_class_icon"] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(onClickClass:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(line.mas_top).with.offset(0);
        make.bottom.equalTo(line1.mas_top).with.offset(0);
    }];
    
    self.btnClass = btn;
    
    self.section = section;
    
    __weak MallListClassSectionView *weakSelf = self;
    
    self.section.block = ^(ClassSectionModel *select) {
        if ([weakSelf.delegate respondsToSelector:@selector(MallListClassSectionSelect:)]) {
            [weakSelf.delegate MallListClassSectionSelect:select];
        }
    };

}

- (void)upDataWith:(NSArray *)array hsClass:(BOOL)hsClass {
    _array = array;
    
    self.section.array = array;
    
    self.btnClass.selected = hsClass;
}

- (void)onClickClass:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(MallListClassSection:)]) {
        sender.selected = !sender.selected;
        [self.delegate MallListClassSection:sender.selected];
    }
    
    
    
}

@end
