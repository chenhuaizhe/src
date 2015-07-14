//
//  ViewController2.m
//  CoreImage_1
//
//  Created by ccyy on 15/7/14.
//  Copyright (c) 2015年 111. All rights reserved.
//

#import "ViewController2.h"
#import <GLKit/GLKit.h>//导入头文件

@interface ViewController2 ()
@property (nonatomic,strong) GLKView *glkView;//渲染用的buffer缓冲视图
@property (nonatomic,strong) CIContext *ciContext;
@property (nonatomic,strong) CIImage *ciImage;
@property (nonatomic,strong)CIFilter *filter;

@end

@implementation ViewController2
#pragma 利用OpenGLES渲染

-(void)beginAction:(UISlider *)slider{
    [_filter setValue:_ciImage forKey:kCIInputImageKey];
    [_filter setValue:@(slider.value) forKey:kCIInputIntensityKey];
    //开始渲染
    [_ciContext drawImage:_filter.outputImage inRect:CGRectMake(0, 0, _glkView.drawableWidth, _glkView.drawableHeight) fromRect:_ciImage.extent];
    [_glkView display];
}







- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *showImage = [UIImage imageNamed:@"1"];
    CGRect rect  = CGRectMake(20, 50, showImage.size.width, showImage.size.height);
    
    //获取OpenGLES渲染的context
    EAGLContext *eaglContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //创建出渲染的buffer
    _glkView = [[GLKView alloc]initWithFrame:rect context:eaglContext];
    [_glkView bindDrawable];
    [self.view addSubview:_glkView];
    
    //创建出CIImage用的上下文
    _ciContext = [CIContext contextWithEAGLContext:eaglContext options:@{kCIContextWorkingColorSpace:[NSNull null]}];
    //CoreImage相关的设置
    _ciImage = [[CIImage alloc]initWithImage:showImage];
    _filter = [CIFilter filterWithName:@"CISepiaTone"];
    [_filter setValue:_ciImage forKey:kCIInputImageKey];
    [_filter setValue:@(0) forKey:kCIInputIntensityKey];//强度
    
    //开始渲染
    [_ciContext drawImage:_filter.outputImage inRect:CGRectMake(0, 0, _glkView.drawableWidth, _glkView.drawableHeight) fromRect:_ciImage.extent];
    [_glkView display];
    
    
    //加上一个UISlider，来实现连环渲染
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(30, 350, 320, 30)];
    slider.minimumValue = 0.f;
    slider.maximumValue = 1.f;
    [slider addTarget:self action:@selector(beginAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
}


@end
