//
//  ViewController.m
//  App
//
//  Created by 范东 on 2019/4/21.
//  Copyright © 2019 范东. All rights reserved.
//

#import "ViewController.h"
#import "TestApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[[TestApi alloc]initWithPageNo:0 pageSize:20] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"");
    }];
}


@end
