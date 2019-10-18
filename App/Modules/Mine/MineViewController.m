//
//  MineViewController.m
//  App
//
//  Created by 范东 on 2019/5/2.
//  Copyright © 2019 范东. All rights reserved.
//

#import "MineViewController.h"
#import "PlayViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = Localized(@"Mine.Title");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    PlayViewController *playVC = [[PlayViewController alloc]init];
    playVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playVC animated:YES];
}

@end
