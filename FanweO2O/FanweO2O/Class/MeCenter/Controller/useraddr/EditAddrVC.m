//
//  EditAddrVC.m
//  FanweO2O
//
//  Created by zzl on 2017/3/1.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "EditAddrVC.h"
#import "searchMapVC.h"
#import "IQKeyboardManager.h"
#import "IQTextView.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface EditAddrVC ()<UIPickerViewDelegate,UIPickerViewDataSource,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@end

@implementation EditAddrVC
{
    NSMutableArray*         _allregions;
    
    BOOL                    _bandoing;
    
    NSInteger               _asel;
    NSInteger               _bsel;
    NSInteger               _csel;
    
    NSString*               _selectmap;
    NSString*               _selectdetail;
    
    CLLocationCoordinate2D  _ll;
    
    BOOL                    _bselectedreg;//是否有设置过 区域,如果是点击过设置的确定或者是 本来就有
}
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self.mcitybt setTitleColor:[UIColor colorWithRed:0.863 green:0.859 blue:0.871 alpha:1.00] forState:UIControlStateNormal];
//    [self.maddrbt setTitleColor:[UIColor colorWithRed:0.863 green:0.859 blue:0.871 alpha:1.00] forState:UIControlStateNormal];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addrregion" ofType:@"plist"];
    NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray* allprovs = [[[dic objectForKey:@"r1"] objectForKey:@"c"] allValues];
    
    _allregions = NSMutableArray.new;
    for( NSDictionary* one in  allprovs )
    {
        NSString* provnmae = [one objectForKey:@"n"];
        if( ![provnmae isKindOfClass:[NSString class]] ) continue;
        NSDictionary* at = [one objectForKey:@"c"];
        if( ![at isKindOfClass:[NSDictionary class]] ) continue;
        
        int provid = [[one objectForKey:@"i"] intValue];
        
        NSArray* citys = [at allValues];
        NSMutableArray* allciyts = NSMutableArray.new;

        for( NSDictionary* onec in citys )
        {
            NSString* cityname = [onec objectForKey:@"n"];
            if( ![cityname isKindOfClass:[NSString class]] ) continue;
            NSDictionary* bt = [onec objectForKey:@"c"];
            if( ![bt isKindOfClass:[NSDictionary class]] ) continue;
            
            int ciytid = [[onec objectForKey:@"i"] intValue];
            
            NSArray* dist = [bt allValues];
            NSMutableArray* alldist = NSMutableArray.new;
            for( NSDictionary* onedist in dist )
            {
                NSString* distname = [onedist objectForKey:@"n"];
                if( ![distname isKindOfClass:[NSString class]] ) continue;
                int distid = [[onedist objectForKey:@"i"] intValue];
                [alldist addObject: @[ distname,@(distid) ] ];
            }
            [alldist addObject:@(ciytid)];
            NSMutableDictionary* oneciytmap = NSMutableDictionary.new;
            [oneciytmap setObject:alldist forKey:cityname];
            [allciyts addObject:oneciytmap];
        }
        [allciyts addObject:@(provid)];
        NSMutableDictionary* oneprovmap = NSMutableDictionary.new;
        [oneprovmap setObject:allciyts forKey:provnmae];
        [_allregions addObject:oneprovmap];
    }
    
    self.minputdetailaddr_t.placeholder = @"详细地址";
    [self.minputdetailaddr_t setHolderToTop];
    
    self.mokbt.layer.cornerRadius = 3;
    self.mokbt.layer.borderWidth = 1.0f;
    self.mokbt.layer.borderColor = [UIColor clearColor].CGColor;
    self.mokbt.enabled =YES;
    
    self.mpicka.delegate = self;
    self.mpicka.dataSource = self;
    
    self.mpickb.delegate = self;
    self.mpickb.dataSource = self;
    
    self.mpickc.delegate = self;
    self.mpickc.dataSource = self;
    
    
    if( self.mEditTag )
    {
        _bselectedreg  = YES;
        
        _ll.latitude = self.mEditTag.mYpoint;
        _ll.longitude = self.mEditTag.mXpoint;
        _selectmap = self.mEditTag.mStreet;
        _selectdetail = self.mEditTag.mAddress;
        [self updatePage:self.mEditTag];
        [self reGetPickIndex:self.mEditTag];
    }
    else
    {
        _asel = 0;
        _bsel = 0;
        _csel = 0;
    }
    

}

-(void)reGetPickIndex:(OTOAddr*)tagobj
{
    NSArray* arr = @[ self.mpicka,self.mpickb,self.mpickc ];
    
    _asel = 0;
    _bsel = 0;
    _csel = 0;
    
    BOOL bfinda = NO;
    BOOL bfindb = NO;
    for( int k = 0 ; k < 3; k++ )
    {
        if( k == 1 && !bfinda ) break;
        if( k == 2 && !bfindb ) break;
        
        UIPickerView* one = arr[k];
        NSInteger acount = [self pickerView:one numberOfRowsInComponent:0];
        for( NSInteger j = 0; j < acount; j++ )
        {
            NSString* titlle = [self pickerView:one titleForRow:j forComponent:0];
            if( k == 0 )
            {
                if( [titlle isEqualToString:tagobj.mRegion_lv2_name] )
                {
                    _asel = j;
                    bfinda = YES;
                    break;
                }
            }
            else if( k == 1 )
            {
                if( [titlle isEqualToString:tagobj.mRegion_lv3_name] )
                {
                    _bsel = j;
                    bfindb = YES;
                    break;
                }
            }
            else if( k == 2 )
            {
                if( [titlle isEqualToString:tagobj.mRegion_lv4_name] )
                {
                    _csel = j;
                    break;
                }
            }
            
        }
    }
    
    [self.mpicka selectRow:_asel inComponent:0 animated:YES];
    [self.mpickb selectRow:_bsel inComponent:0 animated:YES];
    [self.mpickc selectRow:_csel inComponent:0 animated:YES];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (pickerView.tag) {
        case 0:
            result = _allregions.count;
            break;
        case 1:
        {
            NSDictionary* t = _allregions[ _asel ];
            NSArray* ta = t.allValues[0];
            result = ta.count-1;
            break;
        }
        case 2:
        {
            NSDictionary* t = _allregions[ _asel ];
            NSArray* ta = t.allValues[0];
            t = ta[ _bsel ];
            ta = t.allValues[0];
            result = ta.count-1;
        }
            break;
        default:
            break;
    }
    
    return result;
}
-(int)pickerView:(UIPickerView *)pickerView titleIdForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int  titleid = 0;
    switch ( pickerView.tag ) {
        case 0:
        {
            NSDictionary* t = _allregions[ row ];
            titleid = [[t.allValues[0] lastObject] intValue];
        }
            break;
        case 1:
        {
            NSDictionary* t = _allregions[  _asel ];
            NSArray* tb = t.allValues[ 0 ];
            NSDictionary* tcc = tb[row];
            titleid = [[tcc.allValues[0] lastObject] intValue];
        }
            break;
        case 2:
        {
            NSDictionary* t = _allregions[  _asel ];
            NSArray* tb = t.allValues[ 0 ];
            NSDictionary* tcc = tb[ _bsel ];
            titleid = [tcc.allValues[ 0 ][ row][1] intValue];
            break;
        }
        default:
            break;
    }
    
    return titleid;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = @"";
    switch ( pickerView.tag ) {
        case 0:
        {
            NSDictionary* t = _allregions[ row ];
            title = t.allKeys[0];
        }
            break;
        case 1:
        {
            NSDictionary* t = _allregions[  _asel ];
            NSArray* tb = t.allValues[ 0 ];
            NSDictionary* tcc = tb[row];
            title = tcc.allKeys[0];
        }
            break;
        case 2:
        {
            NSDictionary* t = _allregions[  _asel ];
            NSArray* tb = t.allValues[ 0 ];
            NSDictionary* tcc = tb[ _bsel ];
            title = tcc.allValues[ 0 ][ row][0];
            break;
        }
        default:
            break;
    }
    
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch ( pickerView.tag) {
        case 0:
        {
            _asel = row;
            _bsel = 0;
            _csel = 0;
            [self.mpickb reloadComponent:0];
            [self.mpickc reloadComponent:0];
        }
            break;
        case 1:
        {
            _bsel = row;
            _csel = 0;
            [self.mpickc reloadComponent:0];
        }
            break;
        case 2:
        {
            _csel = row;
        }
            break;
        default:
            break;
    }
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 0.2;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = self.mEditTag == nil ? @"新增地址" :@"修改地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:121/255.0f green:123/255.0f blue:135/255.0f alpha:1];

    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)leftClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)swclicked:(id)sender {
    
    if( self.mEditTag.mIs_default == 1 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"无法取消默认"];
        [self.msw setOn:YES];
    }
    
}

- (IBAction)cityclicked:(id)sender {
    
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    [self showPickView:YES];
    
}

- (IBAction)okclicked:(id)sender {
    
    if( !_bselectedreg )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先设置所在城市"];
        return;
    }
    
    OTOAddr* itsend = self.mEditTag == nil ? OTOAddr.new : self.mEditTag;
    
    itsend.mConsignee = self.minputname.text;
    itsend.mMobile = self.minputtel.text;
    itsend.mRegion_lv1_name = @"中国";
    itsend.mRegion_lv2_name = [self pickerView:self.mpicka titleForRow:_asel forComponent:0];
    itsend.mRegion_lv3_name = [self pickerView:self.mpickb titleForRow:_bsel forComponent:0];
    itsend.mRegion_lv4_name = [self pickerView:self.mpickc titleForRow:_csel forComponent:0];
    
    itsend.mRegion_lv1 = 1;
    itsend.mRegion_lv2 = [self pickerView:self.mpicka titleIdForRow:_asel forComponent:0];
    itsend.mRegion_lv3 = [self pickerView:self.mpickb titleIdForRow:_bsel forComponent:0];
    itsend.mRegion_lv4 = [self pickerView:self.mpickc titleIdForRow:_csel forComponent:0];
    
    itsend.mAddress = _selectdetail;
    itsend.mStreet = _selectmap;
    itsend.mDoorplate = self.minputnub.text;
    itsend.mIs_default = self.msw.on?1:0;
    itsend.mXpoint = _ll.longitude;
    itsend.mYpoint = _ll.latitude;
    
    if( itsend.mConsignee.length == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先输入收货人名字"];
        return;
    }
    if( itsend.mMobile.length == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先输入收货人电话"];
        return;
    }
    if( itsend.mRegion_lv2 == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择省份"];
        return;
    }
    if( itsend.mRegion_lv3 == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择城市"];
        return;
    }
    if( itsend.mRegion_lv4 == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择区县"];
        return;
    }
    if( itsend.mAddress.length == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先输入详细地址"];
        return;
    }
    if( _selectmap.length == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择地址"];
        return;
    }
    if( itsend.mDoorplate.length == 0 )
    {
        itsend.mDoorplate = @"";
        //[[HUDHelper sharedInstance] tipMessage:@"请先输入门牌号"];
        //return;
    }
    if ( ![itsend.mMobile isTelephone] )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请输入正确的手机号码~"];
        return;
    }
    
    ShowIndicatorText(@"正在保存...");
    [itsend addEditAddr:^(SResBase *resb) {
    
        HideIndicator();
        if( resb.msuccess )
        {
            self.mokbt.enabled =NO;
            [self performSelector:@selector(opBack) withObject:nil afterDelay:0.8f];
        }
        else
        {
             self.mokbt.enabled =YES;
            [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
        }
        
    }];
}
-(void)opBack
{
    if( self.mItBlock )
    {
        self.mItBlock( self.mEditTag != nil ? 1 : 2 , self.mEditTag );
    }
    [self leftClicked];
}

- (IBAction)citybgclicked:(id)sender {
    
    [self showPickView:NO];
}

- (IBAction)gotomap:(id)sender {
    
    [[IQKeyboardManager sharedManager]resignFirstResponder];

    searchMapVC* vc = [[searchMapVC alloc]initWithNibName:@"searchMapVC" bundle:nil];
    
    vc.mItBlock = ^(NSString* name,NSString*addr,CLLocationCoordinate2D ll)
    {
        _ll = ll;
        _selectmap = name;
        _selectdetail = addr;
        [self.maddrbt setTitle:name forState:UIControlStateNormal];
        [self.maddrbt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.minputdetailaddr_t.text = addr;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showPickView:(BOOL)bshow
{
    if( _bandoing ) return;
    _bandoing = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.mbottomconst.constant = bshow ? 0:SCREEN_HEIGHT;
        self.mbottomwaper.alpha = bshow ? 1:0;
        
    }completion:^(BOOL finished) {
        
        _bandoing = NO;
        
    }];
    
}


- (IBAction)pickokclicked:(id)sender {
    [self showPickView:NO];
    
    _bselectedreg = YES;
    
    NSString* xxa = [self pickerView:self.mpicka titleForRow:_asel forComponent:0];
    NSString* xxb = [self pickerView:self.mpickb titleForRow:_bsel forComponent:0];
    NSString* xxc = [self pickerView:self.mpickc titleForRow:_csel forComponent:0];
    NSString* str = [NSString stringWithFormat:@"%@  %@  %@",xxa,xxb,xxc];
    [self.mcitybt setTitle:str forState:UIControlStateNormal];
    [self.mcitybt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
}

- (IBAction)pickcancleclicked:(id)sender {
    [self showPickView:NO];
    
}

-(void)dealFuck10_1_1
{
    CNContactPickerViewController *pickerVC = [[CNContactPickerViewController alloc] init];
    
    pickerVC.delegate = self;

    [self presentViewController:pickerVC animated:YES completion:nil];
    
}
// 点击了联系人的确切属性的时候调用, 注意, 这两个方法只能实现一个
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    NSString*phoneNO = [contactProperty.value stringValue];
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    self.minputtel.text = phoneNO;
    
    
}



- (IBAction)clickedconact:(id)sender {
    
    if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f )
    {
        [self dealFuck10_1_1];
        return;
    }
    
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;
    if( ios8x )
    {
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

//选择了某个属性
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.minputtel.text = phoneNO;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
}
//选择了一个人
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    personViewController.allowsActions = NO;
    personViewController.allowsEditing = NO;
    [peoplePicker pushViewController:personViewController animated:YES];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}
-(void)updatePage:(OTOAddr*)tagObj
{
    self.minputname.text = tagObj.mConsignee;
    self.minputtel.text = tagObj.mMobile;
    
    if( tagObj.mStreet.length ){
        [self.maddrbt setTitle:tagObj.mStreet forState:UIControlStateNormal];
        
    }else{
        [self.maddrbt setTitle:@"选择小区/写字楼/学校" forState:UIControlStateNormal];
       
    }
    [self.msw setOn: tagObj.mIs_default == 1];
    
    NSString* str = [NSString stringWithFormat:@"%@  %@  %@",tagObj.mRegion_lv2_name,tagObj.mRegion_lv3_name,tagObj.mRegion_lv4_name];
    
    [self.mcitybt setTitle:str forState:UIControlStateNormal];
    self.minputdetailaddr_t.text = tagObj.mAddress;
    self.minputnub.text = tagObj.mDoorplate;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
