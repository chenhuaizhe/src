//
//  ViewController1.m
//  CoreImage_1
//
//  Created by ccyy on 15/7/14.
//  Copyright (c) 2015年 111. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1
#pragma 多种滤镜的组合使用
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建CIImage图片
    CIImage *ciImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"1"]];
    //2.创建和设置滤镜
    CIFilter *filterOne = [CIFilter filterWithName:@"CIPixellate"];
    [filterOne setValue:ciImage forKey:kCIInputImageKey];
    [filterOne setDefaults];
    
    CIImage *outputImage = [filterOne valueForKey:kCIOutputImageKey];
    //将第一个滤镜的输出图片作为第二个滤镜的输入图片
    CIFilter *filterTwo = [CIFilter filterWithName:@"CIHueAdjust"];
    [filterTwo setValue:outputImage forKey:kCIInputImageKey];
    [filterTwo setDefaults];
    //给滤镜设置参数
    [filterTwo setValue:@(1.5) forKey:kCIInputAngleKey];
    CIImage *finalImage = [filterTwo valueForKey:kCIOutputImageKey];
    
    //渲染出来称为CGImageRef类型的
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:finalImage fromRect:finalImage.extent];
    
    //从CGImage类型的转换成UIImage类型并拿出来使用
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:showImage];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    

    
}


































@end
