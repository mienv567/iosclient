//
//  CategoryViewController.m
//  ZhoubaitongO2O
//
//  Created by harlan on 2018/6/17.
//  Copyright © 2018年 xfg. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryCell.h"

static NSString *collectionID = @"collection";
@interface CategoryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) float CellWidth;
@end

@implementation CategoryViewController

- (float)CellWidth {
    if (!_CellWidth) {
        _CellWidth = (SCREEN_WIDTH - 60) / 2;
    }
    return _CellWidth;
}

-(NSMutableArray *)array {
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    [self creatCollectionView];
    [self.collectionV registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:collectionID];
    [self loadPlistData];
}

- (void)loadPlistData {
    // 从plist加载数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CategoryPlist" ofType:@"plist"];
//    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile: path];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
//    self.array = [dict objectForKey:@"Root"];
    self.array = [arr mutableCopy];
    [self.collectionV reloadData];
}

- (void)creatCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.collectionV = collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:self.array[indexPath.row][@"image"]];
    cell.titleLabel.text = self.array[indexPath.row][@"title"];
    if (indexPath.row == 1) {
        cell.frame = CGRectMake(20 + self.CellWidth, 0, self.CellWidth, 0.8 * self.CellWidth);
    } else if (indexPath.row == 3) {
        cell.frame = CGRectMake(20 + self.CellWidth, 20 + 0.8 * self.CellWidth, self.CellWidth, 0.8 * self.CellWidth);
    } else if (indexPath.row == 4) {
        cell.frame = CGRectMake(0, 2 * self.CellWidth + 40, self.CellWidth, 0.8 * self.CellWidth);
    } else if (indexPath.row == 5) {
        cell.frame = CGRectMake(20 + self.CellWidth, 40 + 2 * 0.8 * self.CellWidth, self.CellWidth, 1.2 * self.CellWidth);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (SCREEN_WIDTH - 60) / 2;
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(width,1.2 * width);
            break;
        case 1:
            return CGSizeMake(width,0.8 * width);
            break;
        case 2:
            return CGSizeMake(width,0.8 * width);
            break;
        case 3:
            return CGSizeMake(width,0.8 * width);
            break;
        case 4:
            return CGSizeMake(width,0.8 * width);
            break;
        case 5:
            return CGSizeMake(width,1.2 * width);
            break;
        default:
            return CGSizeZero;
            break;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 加气 加油 换轮胎 维修保养 保险 整车
    
}



@end
