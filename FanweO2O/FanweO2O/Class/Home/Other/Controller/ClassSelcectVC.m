//
//  ClassSelcectVC.m
//  FanweO2O
//
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "ClassSelcectVC.h"
#import "ClassSectionDataModel.h"
#import "UIView+BlocksKit.h"
#define LB_TITLES_TAG   1001

#define LB_NUMBER_TAG   2001

@interface ClassSelcectVC ()<UITableViewDelegate,UITableViewDataSource,ClassSelcectVCDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewSection;

@property (weak, nonatomic) IBOutlet UITableView *tableViewRow;

@property (nonatomic, strong) UIButton *btnSelect;

@property (nonatomic, strong) ClassBcate_list *selectCommon;

@property (nonatomic, strong) ClassQuan_list *selectArea;


@property (nonatomic, assign) ClassSelectType type;

@end

@implementation ClassSelcectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewRow.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)classSelectCommonInitWith:(ClassBcate_list *)selectCommon
                         delegate:(id <ClassSelcectVCDelegate>)delegate
                       selectType:(ClassSelectType)selectType {
    
    self.selectCommon = selectCommon;
    self.delegate = delegate;
    self.type = selectType;
}

- (void)classSelectAreaInitWith:(ClassQuan_list *)selectArea
                       delegate:(id <ClassSelcectVCDelegate>)delegate
                     selectType:(ClassSelectType)selectType{
    self.selectArea = selectArea;
    self.delegate = delegate;
    self.type = selectType;
}

- (void)doInit {
    
    self.scrollViewSection.backgroundColor = [UIColor whiteColor];
    self.tableViewRow.backgroundColor = RGB(248,250,250);
    
    CGFloat allHight = 0;
    CGFloat btnHight = 40;
    UIView *view = [UIView new];
    [self.scrollViewSection addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewSection.mas_left).with.offset(0);
        make.top.equalTo(self.scrollViewSection.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(82, self.dataArray.count * btnHight));
    }];
    
    [self.scrollViewSection setContentSize:CGSizeMake(82, self.dataArray.count * btnHight)];
    
    for (UIView *views in view.subviews) {
        [views removeFromSuperview];
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIButton *btn = [UIButton new];
        btn.tag = i;
        if (self.type == ClassSelectCommon) {
            ClassBcate_list *list = self.dataArray[i];
            [btn setTitle:list.name forState:UIControlStateNormal];
            [btn setTitle:list.name forState:UIControlStateSelected];
            if ([self.selectCommon.name isEqualToString:list.name]) {
                
                self.btnSelect = btn;
                self.btnSelect.selected = YES;
            }
        }else if (self.type == ClassSelectArea) {
            ClassQuan_list *selectArea = self.dataArray[i];
            [btn setTitle:selectArea.name forState:UIControlStateNormal];
            [btn setTitle:selectArea.name forState:UIControlStateSelected];
            if ([self.selectArea.name isEqualToString:selectArea.name]) {
                
                self.btnSelect = btn;
                self.btnSelect.selected = YES;
            }
        }

        [btn setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
        [btn setTitleColor:kAppFontColorRed forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"o2o_class_button_icon"] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"o2o_class_button_h_icon"] forState:UIControlStateSelected];
        
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        

        
        __block ClassSelcectVC *weakSelf = self;
        [btn bk_whenTouches:1 tapped:1 handler:^{
            
            weakSelf.btnSelect.selected = NO;
            
            weakSelf.btnSelect = btn;
            
            weakSelf.btnSelect.selected = YES;
            
            [weakSelf.tableViewRow reloadData];
        }];
        

        
        

        
        [view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).with.offset(0);
            make.width.mas_offset(82);
            make.height.mas_offset(btnHight);
            make.top.equalTo(view.mas_top).with.offset(btnHight *i);
        }];
        allHight = allHight + btnHight;
    }
    

   
    
    self.tableViewRow.delegate = self;
    self.tableViewRow.dataSource = self;
   
    
    [self.tableViewRow reloadData];
    
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self doInit];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return 0;
    }
    
    if (self.btnSelect == nil) {
        
        if (self.type == ClassSelectCommon) {
            ClassBcate_list *bcateList = [self.dataArray firstObject];
            return bcateList.bcate_type.count;
        }else if (self.type == ClassSelectArea) {
            ClassQuan_list *quanList = [self.dataArray firstObject];
            
            return quanList.quan_sub.count;
        }
        
        return 0;
    }
    
    if (self.type == ClassSelectCommon) {
        
        ClassBcate_list *bcateList = self.dataArray[self.btnSelect.tag];
        return bcateList.bcate_type.count;
        
    }else if (self.type == ClassSelectArea) {
        
        ClassQuan_list *quanList = self.dataArray[self.btnSelect.tag];
        
        return quanList.quan_sub.count;
    }
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = RGB(248,250,250);
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"cells";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = RGB(248,250,250);
        
        UILabel *lbTitles = [UILabel new];
        [lbTitles setFont:[UIFont systemFontOfSize:14]];
        [lbTitles setTextColor:kAppFontColorComblack];
        lbTitles.tag = LB_TITLES_TAG;
        [cell.contentView addSubview:lbTitles];
        
        [lbTitles mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(20);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UILabel *lbnumber = [UILabel new];
        [lbnumber setFont:[UIFont systemFontOfSize:14]];
        [lbnumber setTextColor:kAppFontColorLightGray];
        lbnumber.tag = LB_NUMBER_TAG;
        [cell.contentView addSubview:lbnumber];
        
        [lbnumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).with.offset(-20);
            make.centerY.equalTo(cell.contentView);
        }];

    }
    
    if (self.type == ClassSelectCommon) {
        
        ClassBcate_list *bcateList = self.dataArray[self.btnSelect.tag];
        ClassBcate_type *bcate_type = bcateList.bcate_type[indexPath.row];
        
        UILabel *lbTitles = [cell.contentView viewWithTag:LB_TITLES_TAG];
        lbTitles.text = bcate_type.name;
        UILabel *lbnumber = [cell.contentView viewWithTag:LB_NUMBER_TAG];
        lbnumber.text = [NSString stringWithFormat:@"%ld",bcate_type.count];
        
        if ([bcateList.name isEqualToString:self.selectCommon.name]) {
            
            if ([bcateList.hsSelectModel.name isEqualToString:bcate_type.name]) {
                [lbnumber setTextColor:kAppFontColorRed];
                [lbTitles setTextColor:kAppFontColorRed];
            }else {
                [lbnumber setTextColor:kAppFontColorLightGray];
                [lbTitles setTextColor:kAppFontColorComblack];
                
            }
        }else {
            [lbnumber setTextColor:kAppFontColorLightGray];
            [lbTitles setTextColor:kAppFontColorComblack];
            
        }
        
        return cell;

    }else if (self.type == ClassSelectArea) {
        
        ClassQuan_list *quanList = self.dataArray[self.btnSelect.tag];
        ClassQuan_sub *quan_sub = quanList.quan_sub[indexPath.row];
        
        UILabel *lbTitles = [cell.contentView viewWithTag:LB_TITLES_TAG];
        lbTitles.text = quan_sub.name;
        UILabel *lbnumber = [cell.contentView viewWithTag:LB_NUMBER_TAG];
        lbnumber.hidden = YES;
        
        if ([quanList.name isEqualToString:self.selectArea.name]) {
            
            if ([quanList.hsSelectModel.name isEqualToString:quan_sub.name]) {
                [lbnumber setTextColor:kAppFontColorRed];
                [lbTitles setTextColor:kAppFontColorRed];
            }else {
                [lbnumber setTextColor:kAppFontColorLightGray];
                [lbTitles setTextColor:kAppFontColorComblack];
                
            }
        }else {
            [lbnumber setTextColor:kAppFontColorLightGray];
            [lbTitles setTextColor:kAppFontColorComblack];
            
        }
        
        return cell;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == ClassSelectCommon) {
        ClassBcate_list *bcateList = self.dataArray[self.btnSelect.tag];
        ClassBcate_type *bcate_type = bcateList.bcate_type[indexPath.row];
        bcate_type.cate_id = bcateList.id;
        bcateList.hsSelectModel = bcate_type;
        
        if ([self.delegate respondsToSelector:@selector(ClassSelectModel:classSelectType:)]) {
            
            [self.delegate ClassSelectModel:bcateList classSelectType:self.type];
        }
    }else if (self.type == ClassSelectArea) {
        
        ClassQuan_list *quanList = self.dataArray[self.btnSelect.tag];
        ClassQuan_sub *quan_sub = quanList.quan_sub[indexPath.row];
        
        quanList.hsSelectModel = quan_sub;
        
        if ([self.delegate respondsToSelector:@selector(ClassSelectModel:classSelectType:)]) {
            
            [self.delegate ClassSelectModel:quanList classSelectType:self.type];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    
}


@end
