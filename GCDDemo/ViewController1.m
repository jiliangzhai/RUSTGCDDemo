//
//  ViewController1.m
//  GCDDemo
//
//  Created by rust_33 on 15/12/4.
//  Copyright (c) 2015年 rust_33. All rights reserved.
//

#import "ViewController1.h"
#define space 10
#define topSpace 60
#define column 3
#define row 4

@interface ViewController1 ()
{
    NSMutableArray *imageURL;
    NSMutableArray *imageViews;
    UIScrollView *scrollView;
}
- (void)loadImage;

@end

@implementation ViewController1

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
    
    CGRect frame = self.view.frame;
    NSInteger width = frame.size.width;
    NSInteger imageWidth = (width-4*space)/3;
    NSInteger imageHeight = imageWidth;
    
    for (int i=0; i<row; i++) {
        for (int j=0; j<column; j++) {
            
            CGRect imageFrame = CGRectMake(space+j*(space+imageWidth),topSpace+i*(space+imageHeight), imageWidth, imageHeight);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
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

- (void)loadImage {
    
    for (int i=0; i<row*column; i++) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [imageURL addObject:urlStr];
    }
    
    dispatch_queue_t globalQueue = dispatch_queue_create("rustblogs", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(globalQueue, ^{
        
        [self loadImageAtIndex:11];
    });
    
    for (int i=0;i<row*column-1;i++) {
        
        dispatch_async(globalQueue, ^{
               
            [self loadImageAtIndex:i];
               
        });
    }
    
}

- (void)loadImageAtIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageURL objectAtIndex:index]]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImageView *imageView = [imageViews objectAtIndex:index];
        imageView.image = image;
        
    });
}
@end

/*另外的方法包括
 diapatch_group_t + diapatch_group() + diapatch_group_notify()
用以实现任务分组，以及分组任务完成后得到通知再执行其他任务的方法。
 
 dispatch_time_t + dispatch_time() + dispatch_after()
 用以实现任务的延时执行
 
*/












