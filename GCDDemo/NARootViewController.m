//
//  NARootViewController.m
//  GCDDemo
//
//  Created by rust_33 on 15/12/4.
//  Copyright (c) 2015年 rust_33. All rights reserved.
//

#import "NARootViewController.h"
#import "ViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController5.h"

@interface NARootViewController ()

- (IBAction)loadImage:(id)sender;
- (IBAction)loadImageWithOrderControl:(id)sender;
- (IBAction)loadImageWithGroup:(id)sender;
- (IBAction)taskSynchronization1:(id)sender;
- (IBAction)taskSynchornization2:(id)sender;
- (IBAction)loadImageInSerialQueue:(id)sender;

@end

@implementation NARootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)loadImage:(id)sender {
    
    ViewController *viewController = [[ViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)loadImageWithOrderControl:(id)sender {
    
    ViewController1 *viewController1 = [[ViewController1 alloc] init];
    [self.navigationController pushViewController:viewController1 animated:YES];
}

- (IBAction)loadImageWithGroup:(id)sender {
    ViewController4 *viewController4 = [[ViewController4 alloc] init];
    [self.navigationController pushViewController:viewController4 animated:YES];
}

- (IBAction)taskSynchronization1:(id)sender {
    
    ViewController2 *viewController2 = [[ViewController2 alloc] init];
    [self.navigationController pushViewController:viewController2 animated:YES];
}

- (IBAction)taskSynchornization2:(id)sender {
    
    ViewController3 *viewController3 = [[ViewController3 alloc] init];
    [self.navigationController pushViewController:viewController3 animated:YES];
}

- (IBAction)loadImageInSerialQueue:(id)sender {
    
    ViewController5 *viewController5 = [[ViewController5 alloc] init];
    [self.navigationController pushViewController:viewController5 animated:YES];
}

@end







