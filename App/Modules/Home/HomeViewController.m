//
//  HomeViewController.m
//  App
//
//  Created by 范东 on 2019/5/1.
//  Copyright © 2019 范东. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Home.Title", @"首页");
}

- (void)setupNavigationItems{
    [super setupNavigationItems];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemAction:)];
    AddAccessibilityLabel(self.navigationItem.leftBarButtonItem, NSLocalizedString(@"Home.Title", @"首页"));
}

- (void)searchItemAction:(UIBarButtonItem *)item{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
