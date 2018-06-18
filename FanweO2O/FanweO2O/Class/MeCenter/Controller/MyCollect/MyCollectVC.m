//
//  MyCollectVC.m
//  FanweO2O
//
//  Created by zzl on 2017/3/10.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "MyCollectVC.h"
#import "ZWTopFilterView.h"
#import "collectCell.h"
#import "dataModel.h"
#import "UITableView+CNHEmptyDataSet.h"
#import "FWO2OJump.h"
#import "FWO2OJumpModel.h"
@interface MyCollectVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation MyCollectVC
{
    ZWTopFilterView*    _topfilter;
    
    NSMutableArray*     _alldata;
    
    BOOL                _editing;
    BOOL                _allchecked;
    int _pages[3];
    
    int     _nowpage;
    
    int    _bbbb;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _allchecked = NO;
    _editing = NO;
    
    _pages[0] =1;
    _pages[1] =1;
    _pages[2] =1;
    
    self.mcancle.layer.cornerRadius = 3;
    self.mcancle.layer.borderWidth = 1.0f;
    self.mcancle.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    //添加顶部的4个过滤View
    _topfilter = [ZWTopFilterView makeTopFilterView:@[@"商品&团购",@"优惠券",@"活动"] MainCorol:[UIColor blackColor] rect:CGRectMake(0,0,kScreenW,45)];
    _topfilter.backgroundColor = [UIColor whiteColor];
    
    __weak MyCollectVC* selfcv = self;
    _topfilter.mitblock = ^(int from ,int to){
        [selfcv topchanged:from to:to];
    };
    
    [self.mtopwaper addSubview:_topfilter];
    
    _alldata = NSMutableArray.new;
    
    [_alldata addObject: NSMutableArray.new];
    [_alldata addObject: NSMutableArray.new];
    [_alldata addObject: NSMutableArray.new];
    
    _nowpage = 0;
    self.mscrollwaper.delegate = self;
    
    self.mittaba.delegate = self.mittabb.delegate = self.mittabc.delegate  = self;
    self.mittaba.dataSource =  self.mittabb.dataSource  = self.mittabc.dataSource  = self;
    
    UINib*  cell = [UINib nibWithNibName:@"collectCell" bundle:nil];
    [self.mittaba registerNib:cell forCellReuseIdentifier:@"cell"];
    [self.mittabb registerNib:cell forCellReuseIdentifier:@"cell"];
    [self.mittabc registerNib:cell forCellReuseIdentifier:@"cell"];
    
    self.mittaba.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mittabb.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mittabc.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mittaba.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{ [self startRefreshHeader:0]; }];
    self.mittaba.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{ [self startRefreshFooter:0]; }];
    
    self.mittabb.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{ [self startRefreshHeader:1]; }];
    self.mittabb.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{ [self startRefreshFooter:1]; }];
    
    self.mittabc.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{ [self startRefreshHeader:2]; }];
    self.mittabc.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{ [self startRefreshFooter:2]; }];
    
    [self.mittaba.mj_header beginRefreshing];
    self.fd_interactivePopDisabled = YES;

    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(realScrollDo:) withObject:@(_bbbb) afterDelay:0.05f];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if( _editing ) return;
    _bbbb++;
    
}
//这个方法的发起一定是 手动拖动了 手指放开了才会开始,
-(void)realScrollDo:(id)iii
{
    int vv = [iii intValue];
    if( _bbbb != vv )//如果还在变化,说明还在滚动..那就等会
        [self performSelector:@selector(realScrollDo:) withObject:@(_bbbb) afterDelay:0.05f];
    else
    {
        _bbbb = 0;
        
        CGFloat pageWidth = self.mscrollwaper.frame.size.width;
        
        int currentPage = floor((self.mscrollwaper.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if( _nowpage != currentPage )
        {
            _nowpage = currentPage;
            [_topfilter changeToIndex:_nowpage doblock:YES];
        }
        
    }
}

-(UITableView*)nowtableview
{
    UITableView*nowtableview = self.mittaba;
    if( self.i == 0 ) nowtableview       =   self.mittaba;
    else if( self.i == 1 ) nowtableview  =   self.mittabb;
    else if( self.i == 2 ) nowtableview  =   self.mittabc;
    return nowtableview;
}
-(void)handleSwipeToRight:(UISwipeGestureRecognizer*)gest
{
    if( _editing ) return;
    if( self.i == 0 ) return;
    //[_topfilter changeToIndex:self.i-1];
}

-(void)handleSwipeToLeft:(UISwipeGestureRecognizer*)gest
{
    if( _editing ) return;
    if( self.i == 2 ) return;
    //[_topfilter changeToIndex:self.i+1];
}

-(void)topchanged:(int)from to:(int)to
{
    if( _editing )
    {
        [self rightClicked];
        return;
    }
    
    NSArray* t = _alldata[ self.i ];
    if( t.count == 0 )
    {
        [self.nowtableview.mj_header beginRefreshing];
    }
    else
    {
        [self.nowtableview reloadData];
    }
    
    if( self.i != _nowpage )
    {
        _nowpage = to;
        [self.mscrollwaper setContentOffset:CGPointMake(_nowpage*kScreenW, 0) animated:YES];
    }
}



-(int)i
{
    return [_topfilter getNowIndex];
}
-(void)startRefreshHeader:(int)index
{
    UITableView*nowtableview = nil;
    if( index == 0 ) nowtableview       =   self.mittaba;
    else if( index == 1 ) nowtableview  =   self.mittabb;
    else if( index == 2 ) nowtableview  =   self.mittabc;
    
    if( _editing )
    {
        [nowtableview.mj_header endRefreshing];
        return;
    }
    
    _pages[ self.i ] = 1;
    ShowIndicatorText(@"加载中...");
    [OTOCollect getCollectList:self.i page:0 block:^(NSArray *all, SResBase *resb) {
        
        [nowtableview.mj_header endRefreshing];
        HideIndicator();

        if( resb.msuccess )
        {
            
            [_alldata[self.i] removeAllObjects];
            [_alldata[self.i] addObjectsFromArray:all];
            [nowtableview reloadData];
        }
        else
        {
            [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
        }
        
    }];
}
-(void)startRefreshFooter:(int)index
{
    UITableView*nowtableview = nil;
    if( index == 0 ) nowtableview       =   self.mittaba;
    else if( index == 1 ) nowtableview  =   self.mittabb;
    else if( index == 2 ) nowtableview  =   self.mittabc;
    
    if( _editing )
    {
        [nowtableview.mj_footer endRefreshing];
        return;
    }
    
    
    _pages[ self.i ] += 1;
    ShowIndicatorText(@"加载中...");
    [OTOCollect getCollectList:self.i page:_pages[ self.i ] block:^(NSArray *all, SResBase *resb) {
        
        [nowtableview.mj_footer endRefreshing];
        HideIndicator();

        if( resb.msuccess )
        {
            [_alldata[self.i] addObjectsFromArray:all];
            [nowtableview reloadData];
        }
        else
        {
        
            [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"我的收藏";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:121/255.0f green:123/255.0f blue:135/255.0f alpha:1];
    
}
-(void)rightClicked
{
    if( self.nowtableview.mj_header.isRefreshing ||
       self.nowtableview.mj_footer.isRefreshing )
        return;
    
    if( !_editing )
    {//如果不是编辑状态,马上就是要编辑了,
        NSArray* t = _alldata[ self.i ];
        if( t.count == 0 )
        {
            [[HUDHelper sharedInstance] tipMessage:@"当前没有收藏"];
            return;
        }
    }
    
    _editing = !_editing;
    
    [_topfilter enableAllBt:!_editing];
    
    if( _editing )
    {
        
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [UIView animateWithDuration:0.3f animations:^{
            self.mbottomconst.constant = -45;
            [self.view layoutIfNeeded];
        }];
        NSArray* t = _alldata[ self.i ];
        for( OTOCollect* oneobj in t )
        {
            oneobj.mSelectStated = 2;
        }
        [self.nowtableview reloadData];
        
    }
    else
    {
        //如果不是编辑状态了,把全选也都设置了
        _allchecked = NO;
        [self.mallsel setImage:[UIImage imageNamed:_allchecked ?  @"ic_addr_gou":@"ic_addr_nogou"]  forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        [UIView animateWithDuration:0.3f animations:^{
            self.mbottomconst.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
        NSArray* t = _alldata[ self.i ];
        for( OTOCollect* oneobj in t )
        {
            oneobj.mSelectStated = 0;
        }
        [self.nowtableview reloadData];
    }
    
    self.mscrollwaper.scrollEnabled = !_editing;

}

-(void)leftClicked
{
    if( _editing )  return;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)allclicked:(id)sender {
    
    if( !_editing )  return;
    
    _allchecked = !_allchecked;
    
    NSArray* t = _alldata[ self.i ];
    for( OTOCollect* one in t )
    {
        one.mSelectStated = _allchecked ? 1:2;
    }
    
    [self.mallsel setImage:[UIImage imageNamed:_allchecked ?  @"ic_addr_gou":@"ic_addr_nogou"]  forState:UIControlStateNormal];
    
    [self.nowtableview reloadData];
    
}
-(void)updateAllCheckBt
{
    if( !_editing )  return;

    NSArray* t = _alldata[ self.i ];
    int  ballhaveselectd = 0;
    for( OTOCollect* one in t )
    {
        if( one.mSelectStated != 1 )
        {
            ballhaveselectd = 1;
            break;
        }
        else
            ballhaveselectd = 2;
    }
    if( ballhaveselectd == 2 )
    {
        _allchecked = YES;
        [self.mallsel setImage:[UIImage imageNamed:_allchecked ?  @"ic_addr_gou":@"ic_addr_nogou"]  forState:UIControlStateNormal];
    }
    else
    {
        _allchecked = NO;
        [self.mallsel setImage:[UIImage imageNamed:_allchecked ?  @"ic_addr_gou":@"ic_addr_nogou"]  forState:UIControlStateNormal];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* t = _alldata[ self.i ];
    [tableView tableViewDisplayWitMsg:@"暂无收藏" ifNecessaryForRowCount:t.count];
    return t.count;
    
    //return t.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    collectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray* t = _alldata[ self.i ];
    if( indexPath.row >= t.count ) return cell;
    
    OTOCollect* oneobj = t[ indexPath.row ];
    
    cell.mtitle.text = oneobj.mTitle;
    
    if( oneobj.mSubTitle )
    {
        cell.mprcie.text = oneobj.mSubTitle;
        cell.mprcie.hidden = NO;
    }
    else
        cell.mprcie.hidden = YES;
    
    [cell.mlogo sd_setImageWithURL:[NSURL URLWithString:oneobj.mLogo] placeholderImage:nil];
    cell.moutvailed.hidden = !oneobj.mIsInVaild;
    if( !cell.moutvailed.hidden )
    {
        if( oneobj.mType == 0 )
            cell.moutvailed.image = [UIImage imageNamed:@"ic_outsp"];
        else
            cell.moutvailed.image = [UIImage imageNamed:@"ic_outyhj"];
        
        cell.mtitle.textColor = [UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1];
        cell.mprcie.textColor = [UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1];
    }
    else
    {
        cell.mtitle.textColor = [UIColor blackColor];
        cell.mprcie.textColor = [UIColor redColor];
    }
    
    
    cell.mgouconst.constant = oneobj.mSelectStated == 0 ? -25:8;
    cell.mgou.image = oneobj.mSelectStated == 1 ? [UIImage imageNamed:@"ic_addr_gou"] : [UIImage imageNamed:@"ic_addr_nogou"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* t = _alldata[ self.i ];

    if( indexPath.row >= t.count ) return;
    OTOCollect* oneobj = t[ indexPath.row ];

    if( _editing )
    {
        oneobj.mSelectStated = oneobj.mSelectStated == 1 ? 2 :1;
        [self updateAllCheckBt];
        [self.nowtableview reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        
        if( oneobj.mType == 0 )
        {//点击了某个商品
        
            

            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=deal&data_id=%d",
                                  API_LOTTERYOUT_URL,oneobj.mId];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
            
            //oneobj.mId 商品ID
            
        }
        else if( oneobj.mType == 1 )
        {//点击了某个优惠券
            

            
            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=youhui&data_id=%d",
                                  API_LOTTERYOUT_URL,oneobj.mId];
            jumpModel.url =urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
            //oneobj.mId 优惠券 ID
            
        }
        else if( oneobj.mType == 2 )
        {//点击了某个活动
            

            
            FWO2OJumpModel *jumpModel =[FWO2OJumpModel new];
            NSString *urlString =[NSString stringWithFormat:@"%@?ctl=event&data_id=%d",
                                  API_LOTTERYOUT_URL,oneobj.mId];
            jumpModel.url = urlString;
            jumpModel.type = 0;
            jumpModel.isHideNavBar = YES;
            jumpModel.isHideTabBar = YES;
            [FWO2OJump didSelect:jumpModel];
            //oneobj.mId 活动ID
            
        }
    
    }
}

- (IBAction)canclcledi:(id)sender {
    
    [self realCancle];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) return;
    [self realCancle];
}
-(void)realCancle
{
    NSMutableArray * ttt = NSMutableArray.new;
    NSMutableArray * tt = NSMutableArray.new;
    NSArray* t = _alldata[ self.i ];
    
    for( OTOCollect* oneobj in t )
    {
        if( oneobj.mSelectStated == 1 )
        {
            [tt addObject:oneobj];
            [ttt addObject:@(oneobj.mId)];
        }
    }
    if( tt.count == 0 )
    {
        [[HUDHelper sharedInstance] tipMessage:@"请先选择要取消的项目"];
        return;
    }
    
    ShowIndicatorText(@"操作中...");
    [OTOCollect cancleCollect:ttt type:self.i block:^(SResBase *resb) {
        HideIndicator();

        
        if( resb.msuccess )
        {
            [[HUDHelper sharedInstance] tipMessage:@"取消成功"];
            NSMutableArray* ta = _alldata[ self.i ];
            [ta removeObjectsInArray:tt];
            [self rightClicked];
        }
        else
        {
            [[HUDHelper sharedInstance] tipMessage:resb.mmsg];
        }
        
    }];
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
