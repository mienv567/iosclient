//
//  MyOrderDetailsVC.m
//  FanweO2O
//  订单详情
//  Created by hym on 2017/3/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyOrderDetailsVC.h"
#import "NSDictionary+Property.h"
#import "MyOrderDetailsModel.h"
#import "MyOrderDetailsSection1TBCell.h"
#import "MyOrderDetailsSection2TBCell.h"
#import "MyOrderDetailsSection3TBCell.h"
#import "MyOrderDetailsSection4TBCell.h"
#import "MyOrderDetailsSection5TBCell.h"
#import "UIView+BlocksKit.h"
#import "FWO2OJump.h"
#import "SecondaryNavigationBarView.h"
#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "MyCenterViewController.h"
#import "MyOrderListVC.h"
#import "MyOrderDetailsSection22TBCell.h"
@interface MyOrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource,SecondaryNavigationBarViewDelegate,PopViewDelegate>
{
    SecondaryNavigationBarView *nav;
    PopView *pop;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NetHttpsManager *httpManager;

@property (nonatomic, strong) GlobalVariables *fanweApp;

@property (nonatomic, strong) MyOrderDetailsModel *myOrderModel;

@property (nonatomic, assign) NSInteger storeInfoSection;         //商家个数

@end

@implementation MyOrderDetailsVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =YES;
    [self updateNewData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    HideIndicatorInView(self.view);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    _httpManager = [NetHttpsManager manager];
    _fanweApp = [GlobalVariables sharedInstance];
    [self doInit];
    [self bulidNav];
    //[self updateNewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:FW_O2O_REFRESH_ORDER object:nil];
}

- (void)refresh:(NSNotification *)notification {
    NSString *object = notification.object;
    //[self updateNewData];
    
    if ([object isEqualToString:@"删除订单"]) {
        [[HUDHelper sharedInstance] tipMessage:@"删除成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else {
        [self updateNewData];
    }
    
}

- (void)bulidNav
{
    nav = [SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"订单详情";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha =0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
}

- (void)doInit {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.top.equalTo(self.view.mas_top).with.offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(64);
//    }];
    
    
}

#pragma mark 网络请求

- (void)updateNewData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"uc_order" forKey:@"ctl"];
    [parameters setValue:@"wap_view" forKey:@"act"];
    [parameters setValue:self.data_id forKey:@"data_id"];
    
    __weak MyOrderDetailsVC *weekSelf = self;
    ShowIndicatorTextInView(self.view,@"");
    [self.httpManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {
        
        NSLog(@"%@",responseJson);
        HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] == 1) {
            weekSelf.myOrderModel = [MyOrderDetailsModel mj_objectWithKeyValues:responseJson[@"item"]];
            weekSelf.storeInfoSection = weekSelf.myOrderModel.deal_order_item.count;
            
            [weekSelf createButtonView];
            [weekSelf.tableView reloadData];
        }else {
            
            [[HUDHelper sharedInstance] tipMessage:responseJson[@"info"]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                for (UIViewController *vc in weekSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MyOrderListVC class] ]) {
                        [weekSelf.navigationController popToViewController:vc animated:YES];
                        return ;
                    }
                }
               
                
                
                MyOrderListVC *vc = [MyOrderListVC new];
                vc.isComingOrderDetails =YES;
                [weekSelf.navigationController pushViewController:vc animated:YES];
                
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weekSelf.navigationController popViewControllerAnimated:NO];
//                });
                
            });
            
        }
        
        
        
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [self.tableView.mj_header endRefreshing];
    }];
    
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section >= 3 &&section < 3 + self.storeInfoSection) {
        return 44.0f;
    }
    
    return 0.0001f ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        if (self.myOrderModel.existence_expire_refund == 1) {
            return 10.0f;
        }
        
        return 0.00001f;
    }
    
    if (section == 2) {
        
        if ([self hsDeliveryAddress]) {
            return 10.0f;
        }
        
        return 0.00001f;
    }

    if ((section >= 3 &&section < 3 + self.storeInfoSection) ||(section - (3 + self.storeInfoSection) == 1)||(section - (3 + self.storeInfoSection) == 2)) {
        return 0.001f;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    
    if (section >= 3 &&section < 3 + self.storeInfoSection) {
        DealOrderDetailsItem *item = self.myOrderModel.deal_order_item[section - 3];
        
        [view setBackgroundColor:[UIColor whiteColor]];
        UIImageView *image = [UIImageView new];
        [image setImage:[UIImage imageNamed:@"o2o_store_icon"]];
        
        [view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(view.mas_left).with.offset(10);
            make.centerY.equalTo(view).with.offset(0);
        }];
        
        UILabel *lbName = [UILabel new];
        
        [lbName setTextColor:kAppFontColorComblack];
        [lbName setFont:[UIFont systemFontOfSize:13]];
        lbName.text = item.supplier_name;
        [view addSubview: lbName];

        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view).with.offset(0);
            make.left.equalTo(image.mas_right).with.offset(2);
        }];
        
        
        
        UIImageView *image1 = [UIImageView new];
        [image1 setImage:[UIImage imageNamed:@"o2o_left_arrows"]];
        
        [view addSubview:image1];
        [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.left.equalTo(lbName.mas_right).with.offset(0);
            make.centerY.equalTo(view).with.offset(0);
        }];
        
        UIView *line = [UIView new];
        
        [line setBackgroundColor:kLineColor];
        [view addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view.mas_left).with.offset(0);
            make.right.equalTo(view.mas_right).with.offset(0);
            make.bottom.equalTo(view.mas_bottom).with.offset(0);
            make.height.mas_offset(0.5);
            
        }];
        
    }
    
    return view;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
    [view setBackgroundColor:kBackGroundColor];
    return view;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.myOrderModel) {
        
        if (section == 0) {
            
            return 1;
            
        }else if (section == 1) {
            
            if (self.myOrderModel.existence_expire_refund == 1) {
                return 1;
            }
            
            return 0;
            
        }else if (section == 2) {
            
            if ([self hsDeliveryAddress]) {
                return 1;
            }
            
            return 0;
            
        }else if (section < 3 + self.storeInfoSection) {
            
            DealOrderDetailsItem *item = self.myOrderModel.deal_order_item[section - 3];
            return item.list.count;
            
        }else {
            
            if (section - (3 + self.storeInfoSection) == 0) {
                //下单时间、配送方式
                
                return 1;
                
            }else if (section - (3 + self.storeInfoSection) == 1){
                
                return self.myOrderModel.feeinfo.count;
                
            }else if (section - (3 + self.storeInfoSection) == 2){
                
                return self.myOrderModel.paid.count;
                
            }else if (section - (3 + self.storeInfoSection) == 3){
                
                return 1;
                
            }
        }
        
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //订单编号 + //收货地址 + //商品信息 + //下单时间、配送方式  + //商品金额 + //优惠 + //总价
    
    return 7 + self.storeInfoSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        MyOrderDetailsSection1TBCell *cell = [MyOrderDetailsSection1TBCell cellWithTbaleview:tableView];
        cell.orderModel = self.myOrderModel;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderDetailsSection11TBCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderDetailsSection11TBCell"];
            UILabel *lb = [[UILabel alloc] init];
            [lb setFont:[UIFont systemFontOfSize:13]];
            [lb setTextColor:kAppFontColorComblack];
            [lb setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).with.offset(0);
                make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(0);
                make.centerX.equalTo(cell.contentView).with.offset(0);
                make.height.mas_offset(42);
            }];
            
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString
                                                        : @"支持过期退款，立即退款"];

            
            NSRange range = [@"支持过期退款，立即退款"
                           rangeOfString:@"立即退款"];
            
            if (range.location != NSNotFound) {
                
                [attributedStr
                 addAttribute: NSUnderlineStyleAttributeName
                
                 value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                 
                 range: range];
                
                UIButton *btn = [UIButton new];
                [btn addTarget:self action:@selector(onClickRefund) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lb.mas_right).with.offset(0);
                    make.top.equalTo(cell.contentView.mas_top).with.offset(0);
                    make.width.mas_offset(range.length * 13);
                    make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(0);
                }];
                
                
     
            }
            lb.attributedText = attributedStr;
            

            [cell.contentView setBackgroundColor:[MyTool colorWithHexString:@"#ffff00"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
        
    }else if (indexPath.section == 2) {
        
        if ([self.myOrderModel.location_id intValue]  > 0) {
            MyOrderDetailsSection22TBCell *cell = [MyOrderDetailsSection22TBCell cellWithTbaleview:tableView];
            cell.orderModel = self.myOrderModel;
            
            return cell;
        }else {
            MyOrderDetailsSection2TBCell *cell = [MyOrderDetailsSection2TBCell cellWithTbaleview:tableView];
            cell.orderModel = self.myOrderModel;
            
            return cell;
        }
        
        
        
        
    }else if(indexPath.section < 3 + self.storeInfoSection){
        
        MyOrderDetailsSection3TBCell *cell = [MyOrderDetailsSection3TBCell cellWithTbaleview:tableView];
        DealOrderDetailsItem *item = self.myOrderModel.deal_order_item[indexPath.section - 3];
        MyOrderDetailsStoreItem *model = item.list[indexPath.row];
        cell.model = model;
        
        if (indexPath.row == item.list.count - 1) {
            cell.layoutHeight.constant = 0;
        }else {
            cell.layoutHeight.constant = 1.5;
        }
        
        return cell;
    }else {
        
        if (indexPath.section - (3 + self.storeInfoSection) == 0) {
            //下单时间、配送方式
            MyOrderDetailsSection4TBCell *cell = [MyOrderDetailsSection4TBCell cellWithTbaleview:tableView];
            
            cell.orderModel = self.myOrderModel;
            return cell;
            
        }else if (indexPath.section - (3 + self.storeInfoSection) == 1) {
            MyOrderDetailsSection5TBCell *cell = [MyOrderDetailsSection5TBCell cellWithTbaleview:tableView];
            MyOrderDetailsFeeinfo *model = self.myOrderModel.feeinfo[indexPath.row];
            cell.orderModel = model;
            
            if (indexPath.row == self.myOrderModel.feeinfo.count - 1) {
                cell.line.hidden = NO;
            }else {
                cell.line.hidden = YES;
            }
            
            return cell;
        }else if (indexPath.section - (3 + self.storeInfoSection) == 2) {
            MyOrderDetailsSection5TBCell *cell = [MyOrderDetailsSection5TBCell cellWithTbaleview:tableView];
            MyOrderDetailsFeeinfo *model = self.myOrderModel.paid[indexPath.row];
            cell.orderModel = model;
            
            if (indexPath.row == self.myOrderModel.paid.count - 1) {
                cell.line.hidden = NO;
            }else {
                cell.line.hidden = YES;
            }
            
            return cell;

        }else if (indexPath.section - (3 + self.storeInfoSection) == 3) {
            
            
            MyOrderDetailsSection5TBCell *cell = [MyOrderDetailsSection5TBCell cellWithTbaleview:tableView];
            cell.line.hidden = YES;
            
            if ([self.myOrderModel.app_format_youhui_price floatValue] == 0) {
                cell.lbName.text = [NSString stringWithFormat:@"原价 ￥%@",self.myOrderModel.app_format_order_total_price];
            }else {
               cell.lbName.text = [NSString stringWithFormat:@"原价 ￥%@ 共优惠 ￥%@",self.myOrderModel.app_format_order_total_price,self.myOrderModel.app_format_youhui_price];
            }
            
            
            
            NSString *current_price = [NSString stringWithFormat:@"合计：￥%@",self.myOrderModel.app_format_order_pay_price];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:current_price];
            NSRange range = [current_price rangeOfString:@"合计："];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:RGB(255, 34, 68)
             
                                  range:NSMakeRange(range.length, current_price.length - range.length)];
            
            cell.lbValue.attributedText = AttributedStr;
            
            //cell.lbValue.text = [NSString stringWithFormat:@"合计：￥%@",self.myOrderModel.app_format_order_pay_price];
            
            return cell;
            
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.backgroundColor = kBackGroundColor;
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >= 3 &&indexPath.section < 3 + self.storeInfoSection) {
        DealOrderDetailsItem *item = self.myOrderModel.deal_order_item[indexPath.section - 3];
        MyOrderDetailsStoreItem *model = item.list[indexPath.row];
    
        FWO2OJumpModel *jump = [FWO2OJumpModel new];
        jump.isHideTabBar = YES;
        jump.isHideNavBar = YES;
        jump.url = [NSString stringWithFormat:@"%@?ctl=deal&data_id=%@",API_LOTTERYOUT_URL,model.deal_id];
        
        [FWO2OJump didSelect:jump];
        
    }
    
    
    
}

#pragma mark 判断配送地址

- (BOOL)hsDeliveryAddress {
    
    if (self.myOrderModel) {
        if ([self.myOrderModel.delivery_status integerValue] != 6 && self.myOrderModel.consignee.length > 0) {
            
            return YES;
            
        }
        if ([self.myOrderModel.location_id intValue] > 0 ) {
            
            return YES;
        }
    }
    
    
    return NO;
}

#pragma mark 按钮界面生成

- (void)createButtonView {
    
    
   
    
    if (self.myOrderModel.operation.count > 0) {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.top.equalTo(self.view.mas_top).with.offset(44);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        }];
        
        UIView *viewButtonContainer = [UIView new];
        [viewButtonContainer setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:viewButtonContainer];
        
        [viewButtonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.top.equalTo(self.tableView.mas_bottom).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        }];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        [line setBackgroundColor:kLineColor];
        [viewButtonContainer addSubview:line];
        
        MyOrderOperation *operation = [self.myOrderModel.operation firstObject];
        
        if ([operation.type isEqualToString:@"center-none"]) {
            //暂无操作
            UILabel *lbTitles = [UILabel new];
            [lbTitles setFont:[UIFont systemFontOfSize:13]];
            [lbTitles setTextColor:RGB(153, 153, 153)];
            [lbTitles setText:operation.name];
            [viewButtonContainer addSubview:lbTitles];
            
            [lbTitles mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(viewButtonContainer).with.offset(0);
                make.centerY.equalTo(viewButtonContainer).with.offset(0);
            }];
            
            return;
        }
        
        
        CGFloat right = 10;
        for (MyOrderOperation *operation in self.myOrderModel.operation) {
            
            CGSize size = [self boundingSizeWithString:operation.name font:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 100)];
            
            UIButton *btn = [UIButton new];
            
            btn.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setTitle:operation.name forState:UIControlStateNormal];
            if (![operation.type isEqualToString:@"j-payment"]) {
                [btn setTitleColor:kAppFontColorComblack forState:UIControlStateNormal];
                btn.layer.borderColor = RGB(231, 231, 231).CGColor;//设置边框颜色
                btn.layer.borderWidth = 0.5f;//设置边框颜色
            }else {
                [btn setBackgroundColor:RGB(255, 34, 68)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            [viewButtonContainer addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(viewButtonContainer);
                make.right.equalTo(viewButtonContainer.mas_right).with.offset(-right);
                make.size.mas_equalTo(CGSizeMake(size.width + 30, 28));
            }];
            
            right = right + 10 + size.width + 30;
            
            __block MyOrderDetailsVC *weakSelf = self;
            [btn bk_whenTouches:1 tapped:1 handler:^{
                
                //[weakSelf onClick:btn];
                if (operation.param) {
                    [FWO2OJump myOrderHandler:operation.type orderId:weakSelf.myOrderModel.id couponType:operation.param.coupon_status];
                }else {
                    [FWO2OJump myOrderHandler:operation.type orderId:weakSelf.myOrderModel.id couponType:0];
                }
                
            }];
        }

        
    }
}

#pragma mark 计算文字宽度

- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // below ios7
        textSize = [string sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        //iOS 7
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)popNewView
{
    [self.view bringSubviewToFront:pop];
    [self noReadMessage];
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:0.1f options:UIViewAnimationOptionLayoutSubviews animations:^{
                pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180, 40, 40);
            } completion:nil];
        });
    }];
}

- (void)noReadMessage

{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"countNotRead" forKey:@"act"];
    [self.httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            pop.no_msg =[responseJson[@"count"] integerValue];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma make PopViewDelegate
-(void)back
{
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =0.0;
        pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180-80, 40, 40);
    }];
}
- (void)toRefresh
{
    
    [self back];
    [self updateNewData];
    //    [self.tableView.mj_header beginRefreshing];
}

- (void)onClickRefund {
    for (MyOrderOperation *operation in self.myOrderModel.operation) {
        
        if ([operation.type isEqualToString:@"j-refund"]) {
            if (operation.param) {
                [FWO2OJump myOrderHandler:operation.type orderId:self.myOrderModel.id couponType:operation.param.coupon_status];
            }else {
                [FWO2OJump myOrderHandler:operation.type orderId:self.myOrderModel.id couponType:0];
            }
        }
        
    }
}

- (void)selectButton:(NSInteger)count
{
    NSNumber *number = [NSNumber numberWithInteger:count];
    [self back];
    [self performSelector:@selector(performButtonClick:) withObject:number afterDelay:0.5];
}

- (void)performButtonClick:(NSNumber *)number
{
    NSInteger count =[number integerValue];
    switch (count) {
        case 0:
        {
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            
            break;
        case 1:
            [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
            break;
        case 2:
        {
            
            [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
            
        }
            break;
        case 3:
        {
            ShoppingViewController *shop = [ShoppingViewController webControlerWithUrlString:nil andNavTitle:nil isShowIndicator:NO isHideNavBar:YES isHideTabBar:NO];
            [self.navigationController pushViewController:shop animated:YES];
        }
            break;
        case 4:
        {
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
