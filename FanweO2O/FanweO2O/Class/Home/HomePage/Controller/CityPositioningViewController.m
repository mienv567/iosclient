//
//  CityPositioningViewController.m
//  FanweO2O
//
//  Created by ycp on 16/11/29.
//  Copyright © 2016年 fanwe. All rights reserved.
//

#import "CityPositioningViewController.h"
#import "GlobalVariables.h"
#import "MBProgressHUD.h"
#import "ExtendNSDictionary.h"
#import "FanweMessage.h"
#import "NetHttpsManager.h"
#import "CityPositioningSectionView.h"
#import "CityModelFirst.h"
#import "CityModelSecond.h"
#import "CityPositioningTBCell.h"
#import "LeftTextFieldView.h"
#define SectionCount  3
#define kDefaultH 44
#define kW 15
#define kBtnH 30 //按钮高度
#define kBtnW 80 //按钮宽度
#define RandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1] //随机颜色
@interface CityPositioningViewController ()<MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,CityPositioningTBCellDelegate>

{
    GlobalVariables         *_fanweApp;
    NetHttpsManager         *_httpsManager;
    MBProgressHUD           *_HUD;
    int                     *_cityID;           //城市id
    UISearchBar             *_searchBar;        //搜索框
    BOOL                    _isSearch;          //是否是search状态
    UITableView             *_myTableView;
    NSMutableArray          *_cityArray;        //存放城市
    NSMutableArray          *_hotCityArray;     //存放热门城市信息
    NSMutableArray          *_tempArray;        //数据模型数组
    NSMutableArray          *_lettersArray;     //存放开头字母
    NSMutableArray          *_cityOrderArray;   //存放排序后的城市信息
    UITableViewCell         *_hotCityCell;
    UITableViewCell         *_allCityCell;
    NSArray                 *_newArray;         //存放排序后的字母
    CGFloat                 _hotCityH;
    CGFloat                 _allCityH;
    NSString                *_currentCity;
    UIView                  *_searchView;
    LeftTextFieldView       *_searchTextField;
    UIButton                *_hiddenButton;
    UITableView             *_searchTableView;  //搜索的表
    NSString                *cityStr;
    UILabel                 *cityLabel;
    NSMutableArray          *_arrayModel;
    NSMutableDictionary     *_dictionary;
}

@end

@implementation CityPositioningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self NavigationViewAndInitMyView];
    [self loadingHttpsData];
    _fanweApp = [GlobalVariables sharedInstance];
    _dictionary =[NSMutableDictionary new];
    _arrayModel =[NSMutableArray new];
    _myTableView.estimatedRowHeight = 44.0f;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    self.modalPresentationStyle =3;
//    self.modalTransitionStyle =3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtableView) name:FW_O2O_MYWEBVIEW_CHANGE_CITY object:nil];
    
}
- (void)refreshtableView
{
   
    [self loadingHttpsData];
     [_myTableView reloadData];
}
- (void)NavigationViewAndInitMyView

{

    UIView *topView =[[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
    topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topView];

    cityLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, (44-25)/2, kScreenW, 25)];
    cityLabel.textAlignment =NSTextAlignmentCenter;
    cityLabel.font =kAppTextFont16;
    cityLabel.textColor =KAppMainTextBackColor;
    [topView addSubview:cityLabel];
    UIButton *topBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame =CGRectMake(10, (44-24)/2, 24, 24);
    [topBtn setImage:[UIImage imageNamed:@"o2o_dismiss_icon"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topBtn];
   
    _searchView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    _searchTextField =[[LeftTextFieldView alloc] initWithFrame:CGRectMake(10, (44-28)/2, kScreenW-20, 28)];
    _searchTextField.clearButtonMode =UITextFieldViewModeAlways;
    _searchTextField.placeholder =@"城市/行政区/拼音";
    _searchTextField.backgroundColor =kGaryGroundColor;
    _searchTextField.font =kAppTextFont14;
//    _searchTextField.clearButtonMode =UITextFieldViewModeAlways;
    _searchTextField.layer.cornerRadius = 3;
    _searchTextField.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_searchTextField];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(-20, 0, 18, 18)];
    imageView.image =[UIImage imageNamed:@"search"];
    _searchTextField.leftView =imageView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.delegate =self;
    [_searchView addSubview:_searchTextField];
    
    _hiddenButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _hiddenButton.frame =CGRectMake(CGRectGetMaxX(_searchTextField.frame)+20, (44-28)/2, 50, 28);
    _hiddenButton.titleLabel.font =kAppTextFont14;
    [_hiddenButton setTitle:@"搜索" forState:UIControlStateNormal];
    [_hiddenButton setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
    [_hiddenButton addTarget:self action:@selector(hiddenClickButton) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:_hiddenButton];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.backgroundColor =[UIColor whiteColor];
    _myTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    _cityArray = [NSMutableArray new];
    _hotCityArray = [[NSMutableArray alloc]init];
    _tempArray = [[NSMutableArray alloc]init];
    _lettersArray = [[NSMutableArray alloc]init];
    _cityOrderArray = [[NSMutableArray alloc]init];
    _httpsManager =[NetHttpsManager manager];
 
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_searchView.frame)+64,kScreenW-20,30) style:UITableViewStylePlain];
    _searchTableView.dataSource = self;
    _searchTableView.delegate = self;
    _searchTableView.hidden =YES;
    _searchTableView.layer.borderWidth=1;
    _searchTableView.layer.borderColor=kGaryGroundColor.CGColor;
    _searchTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _searchTableView.showsVerticalScrollIndicator =NO;
 
    [self.view addSubview:_searchTableView];
    
   
}
- (void)loadingHttpsData
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@"city" forKey:@"ctl"];
    
    [_httpsManager POSTWithParameters:parameters SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] ==1) {
            [_tempArray removeAllObjects];
            [_hotCityArray removeAllObjects];
            [_lettersArray removeAllObjects];
            _fanweApp.city_name =responseJson[@"city_name"];
            cityStr =[NSString stringWithFormat:@"当前城市-%@",_fanweApp.city_name];
            cityLabel.text =cityStr;
           _hotCityArray = [CityModelSecond mj_objectArrayWithKeyValuesArray:responseJson[@"hot_city"]];
            
            NSDictionary *dic =responseJson[@"city_list"];
            
            for (NSString *key in dic) {
                CityValueModel *xx = [CityValueModel new];
                xx.key = key;
                [_lettersArray addObject:key];
                xx.coent = [CityBaseModel mj_objectArrayWithKeyValuesArray:dic[key]];
                [_tempArray addObject:xx];
            }
            _newArray = [_lettersArray sortedArrayUsingSelector:@selector(compare:)];
           
            [_myTableView reloadData];

        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_myTableView]) {
        return  SectionCount;

    }else if ([tableView isEqual:_searchTableView]){
        return 1;
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_myTableView]) {
        if (section ==0) {
            
            return nil;
        }else if(section ==1)
        {
            CityPositioningSectionView *view =[[CityPositioningSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30) sectionName:@"热门城市"];
            view.backgroundColor =[UIColor whiteColor];
            return view;
            
        }else if (section ==2){
            CityPositioningSectionView *view =[[CityPositioningSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30) sectionName:@"全部城市"];
            view.backgroundColor =[UIColor whiteColor];
            return view;
        }
 
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_myTableView]) {
       if (section ==0) {
            return 0.01;
        }else{
            return 30;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_myTableView]) {
        NSUInteger section =[indexPath section];
        if (section ==1) {
            return _hotCityH;

        }else if (section == 2){
            NSString *key = _newArray[indexPath.row];
            CityValueModel *cityModela;
            for (CityValueModel *cityModel in _tempArray) {
            
                if ([key isEqualToString:cityModel.key]) {
                    cityModela = cityModel;
                    break;
                }
            }
            return cityModela.hight;
        }
        return 44;
    }else if([tableView isEqual:_searchTableView]){
        return 30;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_myTableView]) {
        if (section ==0) {
            return 1;
        }else if (section ==1){
            if ([_hotCityArray count]) {
                return 1;
            }else
            {
                return 0;
            }
        }else{
            return _newArray.count;
        }
    }else if([tableView isEqual:_searchTableView]){
        if (_cityArray.count !=0) {
           return  _cityArray.count;
        }else{
            return 1;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_myTableView]) {
        NSUInteger section = [indexPath section];
        static NSString *CellIdentifier0 = @"CellIdentifier0";
        static NSString *CellIdentifier2 = @"CellIdentifier2";

    
        if (section ==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:_searchView];
            }
            cell.backgroundColor =[UIColor whiteColor];
            return cell;
        }else if(section == 1){
            _hotCityCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (!_hotCityCell) {
                _hotCityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
                _hotCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (_hotCityArray.count !=0) {
                [self createBtn:_hotCityArray btn_x:10 btn_y:5];
            }
            return _hotCityCell;
        }else{

            CityPositioningTBCell *cell = [CityPositioningTBCell cellWithTableView:tableView];
            cell.delegate = self;
            NSString *key = _newArray[indexPath.row];
            CityValueModel *cityModela;
            for (CityValueModel *cityModel in _tempArray) {
            
                if ([key isEqualToString:cityModel.key]) {
                    cityModela = cityModel;
                    break;
                }
            }
       
            if (cityModela) {
                cell.cityModel = cityModela;
            }

            return cell;

        }
    }
    else if([tableView isEqual:_searchTableView]){
        static NSString *searchCell =@"searchCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:searchCell];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCell];
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
            label.tag =9999;
            label.textColor =KAppMainTextBackColor;
            label.font=KAppTextFont13;
            [cell.contentView addSubview:label];
        }
        UILabel *label =(UILabel *)[cell viewWithTag:9999];
        if (_cityArray.count ==0) {
            label.text =@"暂无数据";
        }else{
        
            CityBaseModel *model = _cityArray[indexPath.row];
            label.text = model.name;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchTableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_searchTableView]) {
        if (_cityArray.count !=0) {
             CityBaseModel *model = _cityArray[indexPath.row];
            _fanweApp.city_name =model.name;
            _fanweApp.city_id =model.id;
            _fanweApp.is_refresh_tableview =YES;
            _searchTextField.text =_fanweApp.city_name;
            _searchTextField.text =nil;
            [_cityArray removeAllObjects];
            [_searchTableView reloadData];
            if (_delegate && [_delegate respondsToSelector:@selector(closeBtn)]) {
                cityStr =[NSString stringWithFormat:@"当前城市-%@",_fanweApp.city_name];
                cityLabel.text =cityStr;
                [_searchTextField resignFirstResponder];
                [_delegate closeBtn];
            }
        }
        
    }
}
#pragma -mark 热门城市
-(void)createBtn:(NSMutableArray *)arrayList btn_x:(CGFloat)btn_x btn_y:(CGFloat)btn_y{
    
    CGFloat btn_x_2 = btn_x;
    CGFloat btn_y_2 = btn_y;
    CGFloat btn_spage = 10;
    
    for (UIView *view in _hotCityCell.subviews) {
        [view removeFromSuperview];
    }
   
      for(int i=0; i < [arrayList count]; i ++){
        UIButton *btnCate = [[UIButton alloc]initWithFrame:CGRectMake(btn_x_2, btn_y_2, kBtnW , kBtnH)];
        [btnCate setTitleColor:KAppMainTextBackColor forState:UIControlStateNormal];
        btnCate.titleLabel.font = KAppTextFont13;
        btnCate.layer.borderColor = [UIColor colorWithRed:0.890 green:0.898 blue:0.914 alpha:1.00].CGColor;
        btnCate.layer.borderWidth = myLineHight1;
        btnCate.layer.cornerRadius = 3;
        btnCate.backgroundColor = [UIColor whiteColor];
        
        btnCate.tag = i+300;
    
        CityModelSecond *city = [arrayList objectAtIndex:i];
    
        [btnCate setTitle:city.name forState:UIControlStateNormal];
        [btnCate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_hotCityCell addSubview:btnCate];
        
        [btnCate addTarget:self action:@selector(onActionClick:) forControlEvents:UIControlEventTouchUpInside];
    
        //计算下一个按钮的位置
        if (i < [arrayList count]-1){ //判断是否有下一个按钮
            //列
            if (btnCate.frame.origin.x + btnCate.frame.size.width + btn_spage + kBtnW > kScreenW){
                //换行
                btn_x_2 = btn_x;
                btn_y_2 = btnCate.frame.origin.y + btnCate.frame.size.height + 10;
            }else{
                btn_x_2 = btnCate.frame.origin.x + btnCate.frame.size.width + btn_spage;
            }
        }
    }
    _hotCityH = btn_y_2 + kBtnH + 5;
}

#pragma mark 热门城市点击事件
-(void)onActionClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    CityModelSecond *city = [_hotCityArray objectAtIndex:button.tag - 300];
    if (_fanweApp.city_id == city.id) {
        
       
    }else {
        _fanweApp.city_id = city.id;
        _fanweApp.city_name = city.name;
        _fanweApp.is_refresh_tableview = YES;
        cityStr =[NSString stringWithFormat:@"当前城市-%@",_fanweApp.city_name];
        cityLabel.text =cityStr;
       
    }
    if (_delegate && [_delegate respondsToSelector:@selector(closeBtn)]) {
        [_delegate closeBtn];
    }
     [self dismissViewControllerAnimated:YES completion:nil];

    
    
}

#pragma mark 选择城市 
- (void)selectCity:(CityBaseModel *)model {
    if (_fanweApp.city_id == model.id ) {
        
        
    }else {
        _fanweApp.city_id = model.id;
        _fanweApp.city_name = model.name;
        _fanweApp.is_refresh_tableview = YES;

    }
   
    if (_delegate && [_delegate respondsToSelector:@selector(closeBtn)]) {
         cityStr =[NSString stringWithFormat:@"当前城市-%@",_fanweApp.city_name];
        cityLabel.text =cityStr;
        [_delegate closeBtn];
    }
     [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)leftButtonClick
{

    if (_delegate && [_delegate respondsToSelector:@selector(closeBtn)]) {
        [_delegate closeBtn];
    }
    _searchTextField.text =nil;
    [_searchTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    _HUD = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _searchTableView.hidden =NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _searchTextField.frame=CGRectMake(10, (44-28)/2, kScreenW-20-60, 28);
        _hiddenButton.frame =CGRectMake(CGRectGetMaxX(_searchTextField.frame)+10, (44-28)/2, 50, 28);
    } completion:nil];
   
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _searchTableView.hidden =YES;
    [UIView animateWithDuration:0.5 animations:^{
        _searchTextField.frame=CGRectMake(10, (44-28)/2, kScreenW-20, 28);
        _hiddenButton.frame =CGRectMake(CGRectGetMaxX(_searchTextField.frame)+10, (44-28)/2, 50, 28);
    } completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchTextField resignFirstResponder];
}
- (void)textFieldChanged:(UITextField *)textField
{
    if (_cityArray !=nil) {
        [_cityArray removeAllObjects];
    }
    if ([_searchTextField.text isEqualToString:@""]) {
        _searchTableView.height =30;
    }else
    {
        
        for (CityValueModel *city in _tempArray) {
            for (CityBaseModel *model in city.coent) {
                if ([model.name rangeOfString:_searchTextField.text].location != NSNotFound) {
                    [_cityArray addObject:model];
                    _searchTableView.height =_cityArray.count*30;
                }
            }
        }
        
    }
    [_searchTableView reloadData];
  
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _searchTableView.hidden =YES;
    [_searchTextField resignFirstResponder];
}
- (void)hiddenClickButton
{
    
    BOOL hsFind = NO;
    CityBaseModel *model1;
    for (CityValueModel *city in _tempArray) {
       
        for (CityBaseModel *model in city.coent) {
          
            if ([model.name isEqualToString:_searchTextField.text]) {
                hsFind = YES;
                model1 = model;
            }
        }
    }

    if (hsFind) {
        _fanweApp.city_name =model1.name;
        _fanweApp.city_id =model1.id;
        _fanweApp.is_refresh_tableview =YES;
        _searchTextField.text =_fanweApp.city_name;
        _searchTextField.text =nil;
        [_cityArray removeAllObjects];
        [_searchTableView reloadData];
        if (_delegate && [_delegate respondsToSelector:@selector(closeBtn)]) {
            cityStr =[NSString stringWithFormat:@"当前城市-%@",_fanweApp.city_name];
            cityLabel.text =cityStr;
            [_searchTextField resignFirstResponder];
            [_delegate closeBtn];

        }

    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:@"没有该城市"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
