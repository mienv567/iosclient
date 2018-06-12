//
//  cutPictureView.m
//  test
//
//  Created by GuoMs on 16/1/28.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "cutPictureView.h"
#import "ANScrollView.h"
#import "ANLayer.h"
#import "ANImageView.h"
#import "UIView+CutLayer.h"
#define CAMERA 0
#define ALBUM 1

@interface cutPictureView ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *BG;
@property (weak, nonatomic) IBOutlet ANScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewBG;
@property (assign, nonatomic) CGRect rect;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation cutPictureView


+(instancetype)cutPicture{
    
    cutPictureView *cutView=[[NSBundle mainBundle] loadNibNamed:@"cutPictureView" owner:self options:nil].firstObject;
    cutView.frame=[UIScreen mainScreen].bounds;
    
    return cutView;
}


-(void)awakeFromNib{
    self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5];
    //  self.alpha=0.5;
    self.BG.alpha=1;
    self.BG.layer.cornerRadius=5;
    self.BG.clipsToBounds=YES;
    self.BG.layer.borderWidth=1;
    self.BG.layer.borderColor=[UIColor grayColor].CGColor;
    //self.scrollView.image=_image;
    self.switchButton.layer.cornerRadius=3;
    self.switchButton.clipsToBounds=YES;
    self.dismissButton.layer.cornerRadius=3;
    self.dismissButton.clipsToBounds=YES;
    self.sureButton.layer.cornerRadius=3;
    self.sureButton.clipsToBounds=YES;
//    ANLayer *layer=[ANLayer layer];
//    layer.frame=_scrollViewBG.bounds;
//    layer.size=_size;
//    [layer setNeedsDisplay];
//    [_scrollViewBG.layer addSublayer:layer];
//    _rect=layer.rect;
   // UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.buttonView.frame.size.width, 1)];
    line1.backgroundColor=[UIColor grayColor];
    [self.buttonView addSubview:line1];
    
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(self.buttonView.frame.size.width/3, 0, 1, self.buttonView.frame.size.height)];
    line2.backgroundColor=[UIColor grayColor];
    [self.buttonView addSubview:line2];
    
    UIImageView *line3=[[UIImageView alloc]initWithFrame:CGRectMake(self.buttonView.frame.size.width/3*2, 0, 1, self.buttonView.frame.size.height)];
    line3.backgroundColor=[UIColor grayColor];
    [self.buttonView addSubview:line3];
    
   // [sheet showInView:self];
}

-(void)setImage:(UIImage *)image{
    
    _image=image;
    self.scrollView.image=image;
}

-(void)setSize:(CGSize)size{
    _size=size;
    ANLayer *layer=[ANLayer layer];
    layer.frame=_scrollViewBG.bounds;
    layer.size=_size;
    [layer setNeedsDisplay];
    [_scrollViewBG.layer addSublayer:layer];
    _rect=layer.rect;
}

- (IBAction)showActionSheet:(UIButton *)sender {
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    
    [sheet showInView:self];
}

- (IBAction)cutImage:(UIButton *)sender {
    
    
    
    UIImage *image=[self.scrollViewBG CutLayerWithFrame:_rect];
    
//    self.scrollView.hidden=YES;
//    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
//    imageView.backgroundColor=[UIColor redColor];
//    [self.scrollViewBG addSubview:imageView];
    if ([self.delegate respondsToSelector:@selector(imageDidCut:)]) {
        [self.delegate imageDidCut:image];
    }
    [self removeFromSuperview];
    
    
}
- (IBAction)dismiss:(UIButton *)sender {
    
    [self removeFromSuperview];
}





-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==CAMERA) {
        [self openCamera];
    }else if(buttonIndex==ALBUM){
        [self openAlbum];
    }
}



-(void)openCamera{

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return;
  
    UIImagePickerController * ImagePicker=[[UIImagePickerController alloc]init];
    ImagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    ImagePicker.delegate=self;

    
    [self.control presentViewController:ImagePicker animated:YES completion:nil];
    
    
}



-(void)openAlbum{
 
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        return;

    UIImagePickerController * ImagePicker=[[UIImagePickerController alloc]init];
    ImagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ImagePicker.delegate=self;
    [self.control presentViewController:ImagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //通过UIImagePickerControllerOriginalImage获取图片
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    self.scrollView.image=image;
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"取消选择");
}


@end
