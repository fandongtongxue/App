//
//  HomeViewController.m
//  App
//
//  Created by 范东 on 2019/5/1.
//  Copyright © 2019 范东. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "ZFDouYinViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = Localized(@"Home.Title");
}

- (void)setupNavigationItems{
    [super setupNavigationItems];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemAction:)];
    AddAccessibilityLabel(self.navigationItem.leftBarButtonItem, Localized(@"Search.Title"));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    ZFDouYinViewController *douyinVC = [[ZFDouYinViewController alloc]init];
    douyinVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:douyinVC animated:YES];
}

- (void)searchItemAction:(UIBarButtonItem *)item{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
