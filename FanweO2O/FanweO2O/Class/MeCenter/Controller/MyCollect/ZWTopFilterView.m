//
//  ZWTopFilterView.m
//  MeiRongSeller
//
//  Created by zzl on 15/12/17.
//  Copyright © 2015年 zongyoutec.com. All rights reserved.
//

#import "ZWTopFilterView.h"

#define M_LINECO [UIColor colorWithRed:242/255.0f green:245/255.0f blue:244/255.0f alpha:1]
@implementation ZWTopFilterView
{
    NSArray *   _alltitles;
    UIColor*    _maincorol;
    NSMutableArray* _allbts;
    
    int     _nowselected;
    int     _lastselected;
    
    UIView*  _lineview;
    UIScrollView* _scrollview;
    BOOL    _isscroll;
    
    
    BOOL        _isdoing;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(ZWTopFilterView*)makeTopFilterView:(NSArray*)allTitles MainCorol:(UIColor*)MainCorol rect:(CGRect)rect
{
    
    ZWTopFilterView * retobj = [[ZWTopFilterView alloc] initWithFrame:rect];
    [retobj initWithAllTitles:allTitles MainCorol:MainCorol Width:0 IsBorder:0 scroll:NO];
    return retobj;
}

//创建一个顶部可滚动的过滤View
+(ZWTopFilterView*)makeScrollTopFilterView:(NSArray*)allTitles MainCorol:(UIColor*)MainCorol  rect:(CGRect)rect Width:(float)width IsBorder:(BOOL)border{
    
    ZWTopFilterView * retobj = [[ZWTopFilterView alloc] initWithFrame:rect];
    [retobj initWithAllTitles:allTitles MainCorol:MainCorol Width:width IsBorder:border scroll:YES];
    return retobj;
}


-(void)initWithAllTitles:(NSArray*)allTitles MainCorol:(UIColor*)MainCorol Width:(float)width IsBorder:(BOOL)border scroll:(BOOL)scroll
{
    if( allTitles.count == 0 || MainCorol == nil ) return;
    _nowselected = 0;
    _lastselected = 0;
    _alltitles = allTitles;
    _maincorol = MainCorol;
    _allbts = NSMutableArray.new;
    
    CGFloat onesizex = self.bounds.size.width / allTitles.count;
    
    if (scroll) {
        
        _isscroll = YES;
        onesizex = width;
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollview.backgroundColor = [UIColor whiteColor];
        [self addSubview:_scrollview];
        
        _scrollview.contentSize = CGSizeMake(onesizex* _alltitles.count, self.bounds.size.height);
        _scrollview.showsHorizontalScrollIndicator = NO;
       
    }
    
    
    
    for (int j = 0 ; j < _alltitles.count; j++ )
    {
        NSString* one  = _alltitles[j];
        UIButton* onebt = [[UIButton alloc]initWithFrame:CGRectMake( onesizex * j, 0, onesizex, self.bounds.size.height )];
        onebt.titleLabel.font = [UIFont systemFontOfSize:14];
        onebt.titleLabel.numberOfLines = 0;
        onebt.titleLabel.textAlignment = NSTextAlignmentCenter;
        onebt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [onebt setTitle:one forState:UIControlStateNormal];
        [onebt setTitleColor:[UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1] forState:UIControlStateNormal];
        onebt.tag = j;
        
        if (scroll) {
            [_scrollview addSubview:onebt];
            
            if (border) {
                UIView *b = [[UIView alloc] initWithFrame:CGRectMake(onesizex-1, 0, 1, self.bounds.size.height)];
                b.backgroundColor = M_LINECO;
                [onebt addSubview:b];
            }
            
        }else{
            [self addSubview:onebt];
        }
        
        
        [_allbts addObject:onebt];
        [onebt addTarget:self action:@selector(btclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _nowselected = 0;
    _lastselected = 0;
    NSLog(@"====%.2f", self.bounds.size.height);
    
    _lineview = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-2,onesizex, 2)];
    
     NSLog(@"====%.2f", self.bounds.size.height);
    _lineview.backgroundColor = [UIColor redColor];
   
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1,onesizex* _alltitles.count, 1)];
    line.backgroundColor = M_LINECO;
    
    if (scroll) {
        [_scrollview addSubview:line];
        [_scrollview addSubview:_lineview];
    }else{
        [self addSubview:line];
        [self addSubview:_lineview];
    }
    
    
    
    [self changeToIndex:_lastselected doblock:YES];//默认选中第一个
}


//更换所有的title
-(void)changeAllTitles:(NSArray*)all
{
    if( all.count != _alltitles.count )
    {
        NSLog(@"change error count confid");
        return;
    }
    _alltitles = all;
    for ( NSString* one in _alltitles ) {
        UIButton* onebt  = _allbts[[_alltitles indexOfObject:one]];
        [onebt setTitle:one forState:UIControlStateNormal];
    }
  
}
-(void)enableAllBt:(BOOL)enable
{
    for( UIButton* bt in _allbts  )
    {
        bt.enabled = enable;
    }
}

//返回当前选中
-(int)getNowIndex
{
    return _nowselected;
}

-(void)btclicked:(UIButton*)sender
{
    [self changeToIndex:(int)sender.tag doblock:YES];
}
//设置到某个一个
-(void)changeToIndex:(int)index doblock:(BOOL)doblock
{
    if( _isdoing ) return;
    _isdoing = YES;
    
    if( _nowselected == index && index != 0 )
    {
        if( _mitblock && doblock )
            _mitblock(_nowselected,_nowselected);
        _isdoing = NO;
        return;
    }
    if( index >= _alltitles.count || index < 0)
    {
        NSLog(@"zwtopfilter err: you index:%d",index);
        _isdoing = NO;
        return;
    }
    
    [UIView animateWithDuration:0.15f animations:^{
 
        UIButton* bt = _allbts[index];
        CGRect f = _lineview.frame;
        if( bt.titleLabel.frame.size.width )
        {
            if (!_isscroll) {
                f.size.width = bt.titleLabel.frame.size.width;
            }
            _lineview.frame = f;
        }
        
        _lineview.center = CGPointMake(bt.center.x , _lineview.center.y);
        [bt setTitleColor:_maincorol forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
        _lastselected   = _nowselected;
        _nowselected    = index;
        if( _mitblock && doblock )
            _mitblock(_lastselected,_nowselected);
        _isdoing = NO;
        
        if( _nowselected != -1 )
        {
            for( int j = 0 ; j < _allbts.count;j++ )
            {
                UIButton* onebt = _allbts[j];
                if( j == _nowselected )
                    [onebt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                else
                    [onebt setTitleColor:[UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1] forState:UIControlStateNormal];
            }
        }
        
    }];
    return;
}






@end
