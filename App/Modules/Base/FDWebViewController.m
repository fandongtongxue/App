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

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    DDLogDebug(@"%s",__func__);
}

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    DDLogDebug(@"%s",__func__);
}

- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL{
    DDLogDebug(@"%s",__func__);
}

@end
