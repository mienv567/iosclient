//
//  AccountManagementViewController.m
//  FanweO2O
//
//  Created by ycp on 17/1/11.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "AccountManagementViewController.h"
#import "NetHttpsManager.h"
#import "AccountManagerTableViewCell.h"
#import "AccountManagerModel.h"
#import "AccountTPTableViewCell.h"
#import "AccountXPTableViewCell.h"
#import "BindingPhoneViewController.h"
#import "O2ORetrievePasswordViewController.h"
#import "ChangeNameViewController.h"

#import "PopView.h"
#import "MessageCenterViewController.h"
#import "ShoppingViewController.h"
#import "DiscoveryViewController.h"
#import "O2OAccountLoginVC.h"
#import "SecondaryNavigationBarView.h"
#define CAMERA 0
#define ALBUM 1
@interface AccountManagementViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,PopViewDelegate,SecondaryNavigationBarViewDelegate>
{
    UITableView *_myTableView;
     NetHttpsManager *_httpManager;
    AccountManagerModel *_model;
    NSMutableArray      *_textArray;
    NSMutableArray      *_detailArray;
    NSMutableArray      *_imageArray;
    NSMutableString *xx;
    
    SecondaryNavigationBarView *nav;
    PopView *pop;
}
@end

@implementation AccountManagementViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden =YES;
    [self updateNetWork];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title =@"";
    self.navigationController.navigationBar.hidden =NO;
    HideIndicatorInView(self.view);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bulidNav];
    self.view.backgroundColor =[UIColor whiteColor];
    _httpManager =[NetHttpsManager manager];
    _textArray =[NSMutableArray arrayWithCapacity:0];
    _detailArray =[NSMutableArray arrayWithCapacity:0];
    _imageArray =[NSMutableArray arrayWithCapacity:0];
    [self buildTableView];
    [self updateNetWork];
    [_myTableView registerNib:[UINib nibWithNibName:@"AccountManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"AccountTPTableViewCell" bundle:nil] forCellReuseIdentifier:@"tCell"];
    [_myTableView registerNib:[UINib nibWithNibName:@"AccountXPTableViewCell" bundle:nil] forCellReuseIdentifier:@"xpCell"];
}
- (void)buildTableView
{
    _myTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _myTableView.backgroundColor =[UIColor colorWithRed:0.918 green:0.929 blue:0.925 alpha:1.00];
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    _myTableView.estimatedRowHeight = 50;
    
    [self.view addSubview:_myTableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_myTableView setTableFooterView:v];
    
    pop =[[PopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    pop.alpha=0.0;
    pop.delegate =self;
    [self.view bringSubviewToFront:pop];
    [self.view addSubview:pop];
   
}
- (void)bulidNav
{
    nav =[SecondaryNavigationBarView EditNibFromXib];
    nav.frame =CGRectMake(0, 20, kScreenW, 44);
    nav.delegate =self;
    nav.searchText =@"账户管理";
    nav.isTitleOrSearch =YES;
    [self.view addSubview:nav];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else if (section ==1)
    {
        return 1;
    }else if (section ==2){
        if (_textArray.count !=0) {
            return _textArray.count;
        }else{
            return 0;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return UITableViewAutomaticDimension;
    }else
    {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        AccountManagerTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell =[[AccountManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (_model) {
            cell.model =_model;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else  if(indexPath.section ==1)
    {
       
        AccountTPTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"tCell"];
        if (!cell) {
            cell =[[AccountTPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tCell"];
        }
        if (_imageArray.count !=0) {
            cell.leftLabel.text =@"头像";
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray firstObject]]];
        }else
        {
            cell.leftLabel.text =@"头像";
            cell.headerImageView.image =[UIImage imageNamed:@"my_noLoginImage"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        AccountXPTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"xpCell"];
        if (!cell) {
            cell =[[AccountXPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xpCell"];
        }
        if (_textArray.count !=0) {
            cell.leftLab.text =_textArray[indexPath.row];
            if (indexPath.row ==0 ) {
                if ([_model.user_info.is_tmp isEqualToString:@"1"]) {
                    
                }else
                {
                    cell.arrowImage.image =[UIImage imageNamed:@""];
                }
                
            }
            if (![_model.user_info.email isEqualToString:@""] &&_model.user_info.email !=nil) {
                if (indexPath.row ==1) {
                    cell.arrowImage.image =[UIImage imageNamed:@""];
                }
            }
        }
        if (_detailArray.count !=0) {
            if ([_detailArray[indexPath.row] isEqualToString:@"******"]) {
                cell.rightLab.textColor =[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:1.00];
                cell.rightLab.text =_detailArray[indexPath.row];
            }else
            {
                 cell.rightLab.text =_detailArray[indexPath.row];
            }
           
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
  
}
- (void)updateNetWork
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_account" forKey:@"ctl"];
    [dic setObject:@"wap_index" forKey:@"act"];
    ShowIndicatorTextInView(self.view,@"");
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        HideIndicatorInView(self.view);
        if ([responseJson toInt:@"status"] ==1) {
//            NSLog(@"------->%@",responseJson);
            [_imageArray removeAllObjects];
            [_detailArray removeAllObjects];
            [_textArray removeAllObjects];
            _model =[AccountManagerModel mj_objectWithKeyValues:responseJson];
            if (![_model.user_info.user_avatar isEqualToString:@""]) {
                [_imageArray addObject:_model.user_info.user_avatar];
            }
            if (![_model.user_info.user_name isEqualToString:@""]) {
                [_textArray addObject:@"会员名"];
                [_detailArray addObject:_model.user_info.user_name];
            }
            if (![_model.user_info.email isEqualToString:@""] &&_model.user_info.email !=nil) {
                [_textArray addObject:@"邮箱"];
                [_detailArray addObject:_model.user_info.email];
            }
            if (![_model.user_info.mobile isEqualToString:@""] &&_model.user_info.mobile !=nil) {
                [_textArray addObject:@"绑定手机"];
                xx =[[NSMutableString alloc] initWithString:_model.user_info.mobile];
                 [xx replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                [_detailArray addObject:xx];
            }else
            {
                [_textArray addObject:@"绑定手机"];
                [_detailArray addObject:@"未绑定"];
            }
            if (![_model.user_info.user_pwd isEqualToString:@""]) {
                [_textArray addObject:@"修改密码"];
                [_detailArray addObject:@"******"];
            }
            
            [_myTableView reloadData];
        }
    } FailureBlock:^(NSError *error) {
        HideIndicatorInView(self.view);
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==1) {
        
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
        
        [sheet showInView:self.view];
    }
    if (indexPath.section ==2) {
        NSString *str =_textArray[indexPath.row];
        if ([str isEqualToString:@"修改密码"]) {
            if (![_model.user_info.mobile isEqualToString:@""] &&_model.user_info.mobile !=nil) {
                O2ORetrievePasswordViewController *vc =[O2ORetrievePasswordViewController new];
                if (_model.user_info.mobile !=nil) {
                    vc.phoneStr =xx;
                    vc.phoneAllNumber =_model.user_info.mobile;
                }
                vc.type =@"修改密码";
                [self.navigationController pushViewController:vc animated:YES];
               
            }else
            {
                BindingPhoneViewController *vc =[BindingPhoneViewController new];
                vc.step =@"2";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if ([str isEqualToString:@"绑定手机"]) {
            if (![_model.user_info.mobile isEqualToString:@""] &&_model.user_info.mobile !=nil) {
                BindingPhoneViewController *vc =[BindingPhoneViewController new];
                vc.step =@"1";
                vc.telString =_model.user_info.mobile;
                vc.telEncryptionString =xx;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                BindingPhoneViewController *vc =[BindingPhoneViewController new];
                vc.step =@"2";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if ([str isEqualToString:@"会员名"]) {
            if ([_model.user_info.is_tmp isEqualToString:@"1"]) {
                ChangeNameViewController *vc =[ChangeNameViewController new];
                vc.name =_model.user_info.user_name;
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                return;
            }
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image){
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
     NSData * headImgData = UIImageJPEGRepresentation(image,0.00001);
      [self performSelector:@selector(uploadAvatar:) withObject:headImgData ];
}

- (void)uploadAvatar:(NSData*)data{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"uc_account" forKey:@"ctl"];
    [parmDict setObject:@"upload_avatar" forKey:@"act"];
    
    [_httpManager imageResponse:parmDict imageData:data SuccessBlock:^(NSDictionary *responseJson) {
        [self updateNetWork];
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];//退出
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==CAMERA) {
        [self openCamera];
    }else if(buttonIndex==ALBUM){
        [self openAlbum];
    }
}
#pragma mark 调用相机
-(void)openCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return;
    
    UIImagePickerController * ImagePicker=[[UIImagePickerController alloc]init];
    ImagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    ImagePicker.delegate=self;
    
    [self presentViewController:ImagePicker animated:YES completion:nil];
}

#pragma mark 打开图片
-(void)openAlbum{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;
    
    UIImagePickerController * ImagePicker=[[UIImagePickerController alloc]init];
    ImagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ImagePicker.delegate=self;
    [self presentViewController:ImagePicker animated:YES completion:nil];
}

- (void)popNewView
{
    [self noReadMessage];
    [UIView animateWithDuration:0.1 animations:^{
        pop.alpha =1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:0.1f options:UIViewAnimationOptionLayoutSubviews animations:^{
                pop.closeButton .frame =CGRectMake((kScreenW-40)/2, kScreenH-4*40-180, 40, 40);
            } completion:nil];
        });
    }];
    
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)noReadMessage
{
    NSMutableDictionary *dic =[NSMutableDictionary new];
    [dic setObject:@"uc_msg" forKey:@"ctl"];
    [dic setObject:@"countNotRead" forKey:@"act"];
    [_httpManager POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] ==1) {
            pop.no_msg =[responseJson[@"count"] integerValue];
        }
    } FailureBlock:^(NSError *error) {
        [[HUDHelper sharedInstance] tipMessage:kNetErrorMsg];
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
    [self updateNetWork];
    
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
             self.tabBarController.selectedIndex =0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
           
            
            break;
        case 1:
            [self.navigationController pushViewController:[DiscoveryViewController new] animated:YES];
            break;
        case 2:
        {
          
            [self.navigationController pushViewController:[MessageCenterViewController new]animated:YES];
            
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }
    
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
