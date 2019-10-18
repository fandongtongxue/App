//
//  RootWebViewController.m
//  UniversalApp
//
//  Created by bogokj on 2019/9/17.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "FDWebViewController.h"

@interface FDWebViewController ()<SFSafariViewControllerDelegate>

@end

@implementation FDWebViewController

- (instancetype)initWithURL:(NSURL *)URL{
    if (self = [super initWithURL:URL]) {
        self.delegate = self;
    }
    return self;
}

@end
