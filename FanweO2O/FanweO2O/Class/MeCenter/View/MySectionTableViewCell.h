//
//  MySectionTableViewCell.h
//  FanweO2O
//
//  Created by ycp on 17/1/6.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonCustom.h"
#import "MyCenterModel.h"

@protocol MySectionTableViewCellDelegate <NSObject>

- (void)nextToLogin;

@end

@interface MySectionTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *labelName;
@property (nonatomic,strong)UIButton *allOrderButton;
@property (nonatomic,strong)MyCenterModel *model;
@property (nonatomic,strong) NSArray *numberArray;
@property (nonatomic,assign)id<MySectionTableViewCellDelegate>delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
@end
