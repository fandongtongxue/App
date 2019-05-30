//
//  HomeViewController.m
//  App
//
//  Created by 范东 on 2019/5/1.
//  Copyright © 2019 范东. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"

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

- (void)searchItemAction:(UIBarButtonItem *)item{
    [[FDPayManager defaultManager] pay:FDPayTypeAli];
    return;
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
