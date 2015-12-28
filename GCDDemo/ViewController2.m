//
//  ViewController2.m
//  GCDDemo
//
//  Created by rust_33 on 15/12/5.
//  Copyright (c) 2015年 rust_33. All rights reserved.
//

#import "ViewController2.h"
#define space 10
#define topSpace 60
#define column 3
#define row 3

@interface ViewController2 (){
    
    NSMutableArray *imageURL;
    NSMutableArray *imageViews;
    UIScrollView *scrollView;
    NSLock *lock;
    NSInteger count;
}

@end

@implementation ViewController2

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)layoutUI
{
    imageViews = [NSMutableArray array];
    imageURL = [NSMutableArray array];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.scrollEnabled = YES;
    lock = [[NSLock alloc] init];
    
    CGRect frame = self.view.frame;
    NSInteger width = frame.size.width;
    NSInteger imageWidth = (width-4*space)/3;
    NSInteger imageHeight = imageWidth;
    
    for (int i=0; i<row; i++) {
        for (int j=0; j<column; j++) {
            
            CGRect imageFrame = CGRectMake(space+j*(space+imageWidth),topSpace+i*(space+imageHeight), imageWidth, imageHeight);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.layer.borderColor = [UIColor redColor].CGColor;
            imageView.layer.borderWidth = 2.0;
            [scrollView addSubview:imageView];
            [imageViews addObject:imageView];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(frame.size.width/2-30, 10, 60, 30);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [scrollView addSubview:button];
    
    scrollView.contentSize = CGSizeMake(frame.size.width,topSpace+row*(space+imageHeight)+imageHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}

- (void)loadImage
{
    count = -1;
    
    for (int i=0; i<row*column; i++) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [imageURL addObject:urlStr];
    }
    //创建15个线程争夺9张图片的加载
    for (int i=0; i<15; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self getTheData];
            
        });
        
    }
    
}

- (void)getTheData
{
    [lock lock];
    
        count++;
    
    [lock unlock];
    
    //前9个线程会进行加载任务
    if (count<9) {
         [self updateTheImageViewAtIndex:count];
    }
}

- (void)updateTheImageViewAtIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL[index]]]];
    UIImageView *imageView = [imageViews objectAtIndex:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        imageView.image = image;
        
    });
    
}

/*@synchronize代码块和NSLock的用法类似需要改动的部分如下：

NSString *string;
@synchronize(self){
if (imageURL.count>0) {
    string = [imageURL lastObject];
    [imageURL removeLastObject];
    count++;
}else
return;
 }
*/
@end




















