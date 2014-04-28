
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showLoading;
- (void)showLoadingWithStatus:(NSString *)status;
- (void)showSuccessWithStatus:(NSString *)status;
- (void)showErrorWithStatus:(NSString *)status;
- (void)dismissLoading;

@end