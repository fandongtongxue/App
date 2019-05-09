//
//  FDNavigationController.m
//  App
//
//  Created by 范东 on 2019/5/1.
//  Copyright © 2019 范东. All rights reserved.
//

#import "FDNavigationController.h"

@interface FDNavigationController ()

@end

@implementation FDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *titleAttrDict = [NSDictionary dictionaryWithObjectsAndKeys: Font(17), NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttrDict];
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
