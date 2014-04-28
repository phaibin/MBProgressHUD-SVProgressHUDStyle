//
//  SVProgressHUDViewController.m
//  SVProgressHUD
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)show {
	[self showLoading];
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:5];
}

- (void)showWithStatus {
    [self showLoadingWithStatus:@"Doing Stuff"];
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:5];
}

- (void)dismissSuccess {
    [self showSuccessWithStatus:@"Great Success!"];
}

- (void)dismissError {
    [self showErrorWithStatus:@"Failed with Error"];
}

@end
