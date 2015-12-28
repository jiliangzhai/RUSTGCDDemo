//
//  ViewController3.m
//  GCDDemo
//
//  Created by rust_33 on 15/12/5.
//  Copyright (c) 2015年 rust_33. All rights reserved.
//

#import "ViewController3.h"
#define space 10
#define topSpace 60
#define column 3
#define row 3

@interface ViewController3 (){
    NSMutableArray *imageURL;
    NSMutableArray *imageViews;
    UIScrollView *scrollView;
    NSCondition *condition;
    NSInteger count;
}

@end

@implementation ViewController3

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
    count = -1;
    imageViews = [NSMutableArray array];
    imageURL = [NSMutableArray array];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.scrollEnabled = YES;
    condition = [[NSCondition alloc] init];
    
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
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(frame.size.width/2-80, 10, 60, 30);
    [button1 setTitle:@"加载图片" forState:UIControlStateNormal];
    [scrollView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 addTarget:self action:@selector(creatImage) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(frame.size.width/2+20, 10, 60, 30);
    [button2 setTitle:@"创建图片" forState:UIControlStateNormal];
    [scrollView addSubview:button2];
    
    scrollView.contentSize = CGSizeMake(frame.size.width,topSpace+row*(space+imageHeight)+imageHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}

- (void)loadImage
{
    
    for (int i=0; i<row*column; i++) {
        
        NSString *urlStr = [NSString stringWithFormat:@"http://7xpi4l.com1.z0.glb.clouddn.com/menghuan%i.jpg",i+1];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [imageURL addObject:urlStr];
    }
    
    for (int i=0; i<15; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self getData];
            
        });
        
    }
    
}

- (void)getData
{
    [condition lock];
    
    [condition wait];
    count++;
    [condition unlock];
    
    if (imageURL.count>0) {
        [self loadImageAtIndex:count];
    }
    
}

- (void)loadImageAtIndex:(NSInteger)index
{
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageURL lastObject]]]];
    UIImageView *imageView = [imageViews objectAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
            
            imageView.image = image;
            
    });
    [imageURL removeLastObject];
   
}

- (void)creatImage
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [condition signal];
    });
}
@end

/*NSCondition不仅包含了NSLock的功能还可以进行流程的控制
 另外GCD还提供了一种dispatch_semaphore类型，这是一种信号量机制，信号量初始值是1，每当发送一个信号通知则信号量＋1，每当发送一个等待信号时信号量－1.当信号量
 为0时信号就处于等待状态，直到信号量大于0.
 其中涉及的方法
 dispatch_semaphore_t
 dispatch_semaphore_creat(1)
 diapatch_semaphore_wait()
 dispath_semaphore_signal()
 */





