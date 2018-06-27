//
//  MoneyViewController.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/23.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "MoneyViewController.h"
#import "MoneyViewCell.h"
#import "headMonerView.h"

@interface MoneyViewController (){
    NetHttpsManager *_httpManager;
    GlobalVariables *_FanweApp;
}
@property (nonatomic,strong) UIView  *headView;

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"headMonerView" bundle:nil] forCellReuseIdentifier:@"headMonerView"];
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"headMonerView" owner:self options:nil].lastObject;
    self.tableView.tableHeaderView = view;
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyViewCell"];
    [self loadDate];
    _httpManager = [NetHttpsManager manager];

}

- (void)loadDate {

    ShowIndicatorTextInView(self.view,@"");
    
    NSMutableDictionary *parmDict = [NSMutableDictionary new];
    [parmDict setObject:@"uc_money" forKey:@"ctl"];
    [parmDict setObject:@"money_log" forKey:@"act"];
    [parmDict setObject:_FanweApp.session_id forKey:@"sess_id"];
    [_httpManager POSTWithParameters:parmDict
                        SuccessBlock:^(NSDictionary *responseJson) {
                            HideIndicatorInView(self.view);
                
                            
                        } FailureBlock:^(NSError *error) {
                            HideIndicatorInView(self.view);
                            [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
                        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyViewCell" forIndexPath:indexPath];
    
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}


@end
