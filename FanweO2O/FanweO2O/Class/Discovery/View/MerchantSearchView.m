//
//  MerchantSearchView.m
//  TXSLiCai
//
//  Created by Owen on 16/8/3.
//  Copyright © 2016年 Arvin. All rights reserved.
//

#import "MerchantSearchView.h"
#import "MerchantSearchCollCell.h"
#import "MerchantSearchCollectionReusableView.h"
#import "MerchantSearchCollLayout.h"
#import "MerchantSearchTextFieldView.h"
#import "UIScrollView+UITouchEvent.h"
#import "NetHttpsManager.h"
#import "FanweMessage.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
static NSString *const collectionViewCell = @"cell";
static NSString *const headerViewInden = @"headView";
#define MerchantSearch @"MerchantSearch"
@interface MerchantSearchView()<UICollectionViewDelegate,UICollectionViewDataSource,MerchantSearchCollCellDelegate,MerchantSearchCollectionReusableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegateFlowLayout,MerchantSearchTextFieldViewDelegate>
{
    NSArray *array;
    NetHttpsManager *_httpManager;
    NSString        *_middleBtnStr;
    NSString        *_textFieldStr;
}
@property (nonatomic, strong)NSMutableArray *modelArray;//存储数组
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *searchArray;//搜索历史
@property (nonatomic, strong) UICollectionView *MyCollectionVeiw;
@property (nonatomic, strong) MerchantSearchTextFieldView *searchTextFieldView;
@property (nonatomic, strong)UIView *hiddenBlackView;
@property (nonatomic, copy) Search search;
@property (nonatomic,strong)UIImageView *triangleImageView;
@end
@implementation MerchantSearchView
#pragma mark - life cycle


- (instancetype)initSearchViewWithFrame:(CGRect)frame Parament:(id)parament search:(Search)search {
    if (self = [super initWithFrame:frame]) {
      
        self.search = search;
        [self addSubview:self.MyCollectionVeiw];
        [self addSubview:self.searchTextFieldView];
        [self addSubview:self.hiddenBlackView];
        _httpManager =[NetHttpsManager manager];
        [self updataNewData];
    }
    return self;
}
- (void)setIsReload:(BOOL)isReload
{
    if (isReload) {
        [self updataNewData];
    }
}
- (void)setIsNil:(BOOL)isNil
{
    if (isNil ==YES) {
        self.searchTextFieldView.searchTextField.text =nil;
    }
}
- (void)upDateInternet:(NSString *)str
{
    if (kOlderVersion ==1) {
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        if (_middleBtnStr ==nil ||[_middleBtnStr isEqualToString:@"团购"]) {
            [parameters setValue:@"tuan" forKey:@"ctl"];
        }else if([_middleBtnStr isEqualToString:@"商品"]){
            [parameters setValue:@"goods" forKey:@"ctl"];
        }else if([_middleBtnStr isEqualToString:@"活动"]){
            [parameters setValue:@"events" forKey:@"ctl"];
        }else
        {
            [parameters setValue:@"stores" forKey:@"ctl"];
        }
        if (str) {
            [parameters setValue:str forKey:@"keyword"];
        }else{
            [parameters setValue:_textFieldStr forKey:@"keyword"];
        }
        NSLog(@"%@",parameters);
        
        FWO2OJumpModel *model =[FWO2OJumpModel new];
        
        NSString *urlString =[NSString stringWithFormat:@"%@?ctl=%@&keyword=%@",
                              API_LOTTERYOUT_URL,parameters[@"ctl"],parameters[@"keyword"]];
        model.url =urlString;
        
        model.type = 0;
        model.isHideNavBar = YES;
        model.isHideTabBar = YES;
        [FWO2OJump didSelect:model];

    }else if(kOlderVersion >1){
        if (_middleBtnStr ==nil ||[_middleBtnStr isEqualToString:@"团购"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(navToViewController:andContent:)]) {
                [_delegate navToViewController:1 andContent:str];
            }
        }else if([_middleBtnStr isEqualToString:@"商城"]){
            if (_delegate && [_delegate respondsToSelector:@selector(navToViewController:andContent:)]) {
                [_delegate navToViewController:2 andContent:str];
            }
        }else if([_middleBtnStr isEqualToString:@"活动"]){
            if (_delegate && [_delegate respondsToSelector:@selector(navToViewController:andContent:)]) {
                [_delegate navToViewController:3 andContent:str];
            }
        }else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(navToViewController:andContent:)]) {
                [_delegate navToViewController:4  andContent:str];
            }
         
        }
    }

}
#pragma mark - 布局

#pragma mark - 赋值页面

#pragma mark --点击空白回收键盘--

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponderView:self];
    _hiddenBlackView.hidden =YES;
    _triangleImageView.hidden =YES;
}
- (void)resignFirstResponderView:(UIView *)view {
    NSArray *tempArray = view.subviews;
    if (tempArray.count <1) {
        return;
    } else {
        for (UIView *aView in tempArray) {
            if ([aView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField*)aView;
                
                [textField resignFirstResponder];
            } else if([aView isKindOfClass:[UITextView class]]) {
                UITextView *textView = (UITextView *)aView;
                
                [textView resignFirstResponder];
            } else {
                [self resignFirstResponderView:aView];
                
            }
        }
    }
}
- (void)updataNewData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"search" forKey:@"ctl"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"%@",responseJson[@"hot_kw"]);
        [self.modelArray removeAllObjects];
        [self.searchArray removeAllObjects];
//          [self prepareDataWithParament];
        NSArray *dic = responseJson[@"hot_kw"];
        if (dic.count !=0) {
//            for (NSString *key in [dic allKeys]) {
//                [self.dataArray addObject:dic];
//            }
            
            //_dataArray = [dic allValues];
            NSLog(@"%@",_dataArray);
            //         _dataArray=  [MerchantSearchModel mj_objectArrayWithKeyValuesArray:responseJson[@"hot_kw"]];
            
            
            //        NSDictionary *testDict1 = @{@"section_id":@"1",@"section_title":@"热门搜索",@"section_content":@[@"化妆化妆棉哈萨克发货的说法",@"面膜",@"口红红红红红红红红红红红红红红红红",@"眼霜",@"洗面奶",@"防晒霜",@"补水",@"香水",@"眉笔"]};
            NSMutableDictionary *testDict =[NSMutableDictionary dictionary];
            [testDict setObject:@"1" forKey:@"section_id"];
            [testDict setObject:@"热门搜索" forKey:@"section_title"];
            [testDict setObject:dic forKey:@"section_content"];
            [self.modelArray addObject:testDict];
            
        }
        NSMutableDictionary *historyDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1",@"section_id",@"历史搜索",@"section_title", nil];
        NSArray *historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:MerchantSearch];
        [self.searchArray addObjectsFromArray:historyArray];
        [historyDic setObject:self.searchArray forKey:@"section_content"];
        [self.modelArray addObject:historyDic];
        
        [_MyCollectionVeiw reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark - UICollectionViewdelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_modelArray.count !=0)
    {
//        if (self.dataArray.count !=0) {
            NSArray *tempArray = [self.modelArray[section] objectForKey:@"section_content"];
            return tempArray.count;
//        }
//        else
//        {
//            return 1;
//        }
    }
    else
    {
        return 0;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MerchantSearchCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCell forIndexPath:indexPath];
    NSDictionary *modelDic = self.modelArray[indexPath.section];
    NSArray *contenArray = modelDic[@"section_content"];
    [cell.contentButton setTitle:contenArray[indexPath.row] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_modelArray.count !=0)
    {
        if (self.searchArray.count == 0) {
            return 1;
        }
        return self.modelArray.count;
    }
    else
    {
        return 0;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MerchantSearchCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewInden forIndexPath:indexPath ];
        view.delectDelegate = self;
        NSDictionary *contenDic = self.modelArray[indexPath.section];
        [view setText:contenDic[@"section_title"]];
        if (indexPath.section == 0) {
            [view setImage:@""];
            view.delectButton.hidden = YES;
        }else {
            [view setImage:@""];
            view.delectButton.hidden = NO;
        }
//        view.delectButton.hidden = NO;
        reusableView = view;
    }
    else {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath ];
        reusableView = view;
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *contenDic = self.modelArray[indexPath.section];
    NSArray *contenArray = contenDic[@"section_content"];
    if (contenArray.count > 0) {
        return [MerchantSearchCollCell getSizeWithText:contenArray[indexPath.row]];
    }
    return CGSizeMake(80, 24);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - celldelegate
- (void)selectButtonClick:(MerchantSearchCollCell *)cell {
    NSIndexPath *indexPath = [self.MyCollectionVeiw indexPathForCell:cell];
    NSDictionary *contenDic = self.modelArray[indexPath.section];
    NSArray *contenArray = contenDic[@"section_content"];
     self.searchTextFieldView.searchTextField.text =contenArray[indexPath.row];
    if (self.search) {
        self.search(@"123");
    }
#pragma mark -添加点击跳转
     [self upDateInternet:contenArray[indexPath.row]];
    self.searchTextFieldView.searchTextField.text =nil;
    
}
#pragma mark - headViewdelegate
- (void)delectData:(MerchantSearchCollectionReusableView *)view {
    if(self.searchArray.count>0) {
        [self.searchArray removeAllObjects];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"MerchantSearch"];
        [self.MyCollectionVeiw reloadData];
    }
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextFieldView.searchTextField resignFirstResponder];
    
}
#pragma mark - texteFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [FanweMessage alert:@"请输入搜索内容"];
       
        return NO;
    }
    if ([self.searchArray containsObject:textField.text]) {
        [self upDateInternet:textField.text];
        self.searchTextFieldView.searchTextField.text =nil;
        return YES;
    }
    [self.searchArray addObject:textField.text];
    [self.MyCollectionVeiw reloadData];
    [[NSUserDefaults standardUserDefaults]setObject:self.searchArray forKey:@"MerchantSearch"];
#pragma mark - 添加搜索跳转
    [self upDateInternet:textField.text];
    self.searchTextFieldView.searchTextField.text =nil;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {//如果没有文字处理
        
    }
    return YES;
}
#pragma mark - 数据请求

#pragma mark - 数据解析

- (void)prepareDataWithParament:(id)parament {
    
}

#pragma mark - set get
- (NSMutableArray *)modelArray {
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
        
    }
    return _modelArray;
}

- (NSMutableArray *)searchArray {
    if (_searchArray == nil) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)MyCollectionVeiw {
    if (_MyCollectionVeiw == nil) {
        _MyCollectionVeiw = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) collectionViewLayout:[MerchantSearchCollLayout new]];
        [_MyCollectionVeiw registerClass:[MerchantSearchCollCell class] forCellWithReuseIdentifier:collectionViewCell];
        [_MyCollectionVeiw registerClass:[MerchantSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewInden];
        [_MyCollectionVeiw registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
        _MyCollectionVeiw.delegate = self;
        _MyCollectionVeiw.dataSource = self;
        _MyCollectionVeiw.backgroundColor =[UIColor whiteColor] ;
        _MyCollectionVeiw.alwaysBounceVertical = YES;
    }
    return _MyCollectionVeiw;
}

- (MerchantSearchTextFieldView *)searchTextFieldView {
    if (_searchTextFieldView == nil) {
        _searchTextFieldView = [[MerchantSearchTextFieldView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
        _searchTextFieldView.delegate=self;
        _searchTextFieldView.searchTextField.delegate =self;
//        [_searchTextFieldView.cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchTextFieldView;
}
- (void)setIsHidden:(BOOL)isHidden
{
    _searchTextFieldView.isGoBackHidden =isHidden;
    if (isHidden ==YES) {
       _hiddenBlackView.frame =CGRectMake(12, CGRectGetMaxY(_searchTextFieldView.frame), 80, 120);
       _triangleImageView.frame =CGRectMake(22, CGRectGetMaxY(_searchTextFieldView.frame)-15, 25, 28);
        
    }else
    {
        _hiddenBlackView.frame= CGRectMake(42, CGRectGetMaxY(_searchTextFieldView.frame), 80, 120);
        _triangleImageView.frame = CGRectMake(52, CGRectGetMaxY(_searchTextFieldView.frame)-15, 25, 28);
    }
}
- (UIView *)hiddenBlackView
{
    array =@[@"团购",@"商城",@"活动",@"店铺"];
    if (_hiddenBlackView ==nil) {
        _hiddenBlackView =[[UIView alloc] init];
        _hiddenBlackView.backgroundColor =[UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:0.9];
        _hiddenBlackView.hidden =YES;
        _triangleImageView =[[UIImageView alloc] init];
        _triangleImageView.hidden=YES;
        _triangleImageView.image =[UIImage imageNamed:@"triangle"];
        [self addSubview:_triangleImageView];
        for (int i =0; i<4; i++) {
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame =CGRectMake(0, 30*i, 80, 29.5);
            [btn setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
            btn.tag =i+10086;
            btn.titleLabel.font =[UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(themeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_hiddenBlackView addSubview:btn];
            if (i+1<4) {
                UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 29.5*(i+1), 80, 0.5)];
                line.backgroundColor =[UIColor whiteColor];
                [_hiddenBlackView addSubview:line];
            }
        }
    }
    return _hiddenBlackView;
}
- (void)themeButtonClick:(UIButton *)btn
{
    [_searchTextFieldView.middleBtn setTitle:array[btn.tag-10086] forState:UIControlStateNormal];
    _searchTextFieldView.searchTextField.placeholder =[NSString stringWithFormat:@"搜索%@",array[btn.tag-10086]];
    _middleBtnStr =array[btn.tag-10086];
    _triangleImageView.hidden =YES;
    _hiddenBlackView.hidden =YES;

}
#pragma mark -----MerchantSearchTextFieldViewDelegate
- (void)goToBack
{
    if (_delegate && [_delegate respondsToSelector:@selector(leftButtonClick)]) {
        [_delegate leftButtonClick];
    }
}
- (void)searchClickButton
{
    NSLog(@"%@",_searchTextFieldView.searchTextField.text);
    if ([[_searchTextFieldView.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] ) {
        [FanweMessage alert:@"请输入搜索内容"];
    }else
    {
        if ([self.searchArray containsObject:_searchTextFieldView.searchTextField.text]) {
            [self endEditing:YES];
            [self upDateInternet:_searchTextFieldView.searchTextField.text];
             self.searchTextFieldView.searchTextField.text =nil;
            return ;
        }
        [self endEditing:YES];
        [self.searchArray addObject:_searchTextFieldView.searchTextField.text];
        _textFieldStr =_searchTextFieldView.searchTextField.text;
        [self.MyCollectionVeiw reloadData];
        [[NSUserDefaults standardUserDefaults]setObject:self.searchArray forKey:@"MerchantSearch"];
        [self upDateInternet:_searchTextFieldView.searchTextField.text];
        self.searchTextFieldView.searchTextField.text =nil;

    }
   
}
- (void)middleClickBtnToView
{
    NSLog(@"点击到了");
    _triangleImageView.hidden =NO;
    _hiddenBlackView.hidden =NO;
}

@end
