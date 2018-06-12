//
//  ClassSelcectVC.h
//  FanweO2O
//
//  Created by hym on 2017/1/5.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSectionDataModel.h"

typedef NS_ENUM(NSInteger, ClassSelectType) {
    
    ClassSelectCommon = 100,          //普通类型
    ClassSelectArea = 101,            //地区类型
    
};

@protocol  ClassSelcectVCDelegate <NSObject>

@optional

- (void)ClassSelectModel:(id)model classSelectType:(ClassSelectType)classSelectType;

@end

@interface ClassSelcectVC : UIViewController

@property (weak,nonatomic) id <ClassSelcectVCDelegate>delegate;

@property (nonatomic, strong) NSArray *dataArray;

- (void)classSelectCommonInitWith:(ClassBcate_list *)selectCommon
                         delegate:(id <ClassSelcectVCDelegate>)delegate
                       selectType:(ClassSelectType)selectType;

- (void)classSelectAreaInitWith:(ClassQuan_list *)selectArea
                         delegate:(id <ClassSelcectVCDelegate>)delegate
                       selectType:(ClassSelectType)selectType;

@end
