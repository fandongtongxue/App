//
//  TabBarController.m
//  App
//
//  Created by 范东 on 2019/5/1.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDTabBarController.h"
#import "FDNavigationController.h"
#import "LoginViewController.h"
#import "FDNavigationController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "ZFDouyinViewController.h"
#import "ConversationController.h"

@interface FDTabBarController ()<UITabBarControllerDelegate>

@end

@implementation FDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = Font(12);
    
    ZFDouYinViewController *douyinVC = [[ZFDouYinViewController alloc]init];
    douyinVC.hidesBottomBarWhenPushed = NO;
    FDNavigationController *homeNav = [[FDNavigationController alloc]initWithRootViewController:douyinVC];
    homeNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Home.Title") image:[UIImageMake(@"tab_home_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_home_selected") tag:0];
    [homeNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [homeNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(homeNav.tabBarItem, Localized(@"Home.Title"));
    
    ConversationController *conv = [[ConversationController alloc]init];
    conv.hidesBottomBarWhenPushed = NO;
    FDNavigationController *convNav = [[FDNavigationController alloc]initWithRootViewController:conv];
    convNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Message.Title") image:[UIImageMake(@"tab_chat_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_chat_selected") tag:1];
    [convNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [convNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(convNav.tabBarItem, Localized(@"Message.Title"));
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    mineVC.hidesBottomBarWhenPushed = NO;
    FDNavigationController *mineNav = [[FDNavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem = [QDUIHelper tabBarItemWithTitle:Localized(@"Mine.Title") image:[UIImageMake(@"tab_mine_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"tab_mine_selected") tag:2];
    [mineNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:attrDict forState:UIControlStateSelected];
    AddAccessibilityHint(mineNav.tabBarItem, Localized(@"Mine.Title"));
    
    self.viewControllers = @[homeNav,convNav,mineNav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index != 0) {
        if (!kisLogin) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            FDNavigationController *loginNav = [[FDNavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
            return NO;
        }
        return YES;
    }
    return YES;
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
