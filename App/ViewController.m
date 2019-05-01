//
//  ViewController.m
//  App
//
//  Created by 范东 on 2019/4/21.
//  Copyright © 2019 范东. All rights reserved.
//

#import "ViewController.h"
#import "TestApi.h"
#import "TestSocialViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(testLogin) withObject:nil afterDelay:3];
}

- (void)testLogin{
    TestSocialViewController *testVC = [[TestSocialViewController alloc]initWithNibName:NSStringFromClass([TestSocialViewController class]) bundle:[NSBundle mainBundle]];
    [self presentViewController:testVC animated:YES completion:nil];
}

@end
