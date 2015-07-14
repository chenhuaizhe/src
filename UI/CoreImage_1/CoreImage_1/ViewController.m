//
//  ViewController.m
//  CoreImage_1
//
//  Created by ccyy on 15/7/14.
//  Copyright (c) 2015年 111. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma CIImage滤镜处理照片的简单使用

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.导入ciimage图片
    CIImage *ciImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"1"]];
    
    //2.创建出Filter滤镜
    NSArray *array =   [CIFilter filterNamesInCategory:kCICategoryBuiltIn];//搜索属于 kCICategoryBuiltIn类别的所有滤镜名字，返回一个数组；
    NSLog(@"array = %@",array);
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
   // 调用[CIFilter attributes]会返回filter详细信息，
    NSLog(@"%@",filter.attributes);
    //将ciimage作为输入的照片
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //将输入滤镜设为默认值
    [filter setDefaults];
    //接收加了滤镜后导出的CIImage
    CIImage *outputImage = [filter valueForKey:kCIOutputImageKey];
    
    //3.用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    //渲染出来的图片是CGImageRef类型的
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    //4.将图片转换成UIImage类型
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    //虽然是arc模式，cgImage不会自己释放，这里要手动释放
    CGImageRelease(cgImage);
    //5.拿出UIImage使用
    UIImageView *imageVIew = [[UIImageView alloc]initWithImage:showImage];
    imageVIew.center = self.view.center;
    [self.view addSubview:imageVIew];
}


@end
