//
//  MusicViewController.m
//  App
//
//  Created by bogokj on 2019/8/31.
//  Copyright © 2019 范东. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicCategoryApi.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[[MusicCategoryApi alloc] init] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        DDLogDebug(@"");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DDLogDebug(@"");
    }];
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
