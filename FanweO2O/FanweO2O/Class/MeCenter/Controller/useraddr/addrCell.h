//
//  addrCell.h
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

extern UIColor* g_defcolor;

@protocol addrCellProtocol<NSObject>

//clicked 表明那个被点击了,这个地址界面是 1:默认 2:编辑 3:删除
-(void)addrCellClicked:(NSObject*)dataref clicked:(int)clicked;

@end

@interface addrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mname;
@property (weak, nonatomic) IBOutlet UILabel *mtel;
@property (weak, nonatomic) IBOutlet UILabel *maddrdesc;
@property (weak, nonatomic) IBOutlet UIButton *mdefaultbt;
@property (weak, nonatomic) IBOutlet UIButton *meditbt;
@property (weak, nonatomic) IBOutlet UIButton *mdelbt;

@property (nonatomic,weak)  NSObject*   mDataRef;
@property (nonatomic,weak) id<addrCellProtocol> mCellDelegate;

@end
