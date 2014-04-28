//
//  SVProgressHUDViewController.h
//  SVProgressHUD
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController : BaseViewController

- (IBAction)show;
- (IBAction)showWithStatus;
- (IBAction)dismissSuccess;
- (IBAction)dismissError;

@end

