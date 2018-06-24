//
//  MoneyViewController.m
//  ZhoubaitongO2O
//
//  Created by Harlan on 2018/6/23.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "MoneyViewController.h"
#import "MoneyViewCell.h"
@interface MoneyViewController ()

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = nil;
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyViewCell"];
    
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
