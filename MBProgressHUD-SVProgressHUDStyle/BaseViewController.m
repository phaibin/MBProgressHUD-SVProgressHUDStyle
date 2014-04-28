

#import "BaseViewController.h"
#import "MBProgressHUD.h"

#define LOADING_STYLE 1 // 0:white, 1:black

@implementation BaseViewController

- (void)showLoading
{
    [self showLoadingWithStatus:nil];
}

- (void)showLoadingWithStatus:(NSString *)status
{
    CGFloat hudViewY = 100;
    CGFloat animatedLayerY = 21;
    if (status && status.length > 0) {
        hudViewY = 70;
        animatedLayerY = 0;
    }
    
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, hudViewY)];
    hudView.backgroundColor = [UIColor clearColor];
    CAShapeLayer *animatedLayer = [[self class] sharedAnimatedLayer];
    animatedLayer.frame = CGRectMake(21, animatedLayerY, animatedLayer.frame.size.width, animatedLayer.frame.size.height);
    [hudView.layer addSublayer:animatedLayer];
    
    [self showLoadingWithStatus:status customView:hudView];
}

- (void)showLoadingWithStatus:(NSString *)status customView:(UIView *)customView
{
    [self dismissLoadingAnimated:NO];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
#if LOADING_STYLE == 0
    HUD.dimBackground = YES;
    HUD.color = [UIColor whiteColor];
    HUD.labelColor = [UIColor blackColor];
#else
    HUD.dimBackground = NO;
    HUD.color = [UIColor colorWithWhite:0 alpha:0.6];
    HUD.labelColor = [UIColor whiteColor];
#endif
        
	[self.view addSubview:HUD];
	
    if (status && status.length > 0) {
        HUD.labelText = status;
    }
    
    HUD.customView = customView;
	HUD.mode = MBProgressHUDModeCustomView;
	
	[HUD show:YES];
}

- (void)showSuccessWithStatus:(NSString *)status
{
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    hudView.backgroundColor = [UIColor clearColor];
#if LOADING_STYLE == 0
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_success_black.png"]];
#else
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_success_white.png"]];
#endif
    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.origin.x = (100-imageViewFrame.size.width) / 2;
    imageViewFrame.origin.y = (100-imageViewFrame.size.height) / 2 - 10;
    imageView.frame = imageViewFrame;
    [hudView addSubview:imageView];
    
    [self showLoadingWithStatus:status customView:hudView];
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:1];
}

- (void)showErrorWithStatus:(NSString *)status
{
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    hudView.backgroundColor = [UIColor clearColor];
#if LOADING_STYLE == 0
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_error_black.png"]];
#else
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_error_white.png"]];
#endif
    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.origin.x = (100-imageViewFrame.size.width) / 2;
    imageViewFrame.origin.y = (100-imageViewFrame.size.height) / 2 - 10;
    imageView.frame = imageViewFrame;
    [hudView addSubview:imageView];
    
    [self showLoadingWithStatus:status customView:hudView];
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:1];
}

- (void)dismissLoading
{
    [self dismissLoadingAnimated:YES];
}

- (void)dismissLoadingAnimated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}

+ (CAShapeLayer*)sharedAnimatedLayer {
    static dispatch_once_t once;
    static CAShapeLayer *sharedLayer;
    dispatch_once(&once, ^ { sharedLayer = [[self class] indefiniteAnimatedLayer]; });
    return sharedLayer;
}

+ (CAShapeLayer*)indefiniteAnimatedLayer
{
    CGPoint center = CGPointMake(45, 45);
    CGFloat radius = 24;
    CGPoint arcCenter = CGPointMake(radius+4/2+5, radius+4/2+5);
    CGRect rect = CGRectMake(center.x-radius, center.y-radius, arcCenter.x*2, arcCenter.y*2);
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                radius:radius
                                                            startAngle:M_PI*3/2
                                                              endAngle:M_PI/2+M_PI*5
                                                             clockwise:YES];
    
    CAShapeLayer *_indefiniteAnimatedLayer = [CAShapeLayer layer];
    _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
    _indefiniteAnimatedLayer.frame = rect;
    _indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
#if LOADING_STYLE == 0
    _indefiniteAnimatedLayer.strokeColor = [UIColor blackColor].CGColor;
#else
    _indefiniteAnimatedLayer.strokeColor = [UIColor whiteColor].CGColor;
#endif
    _indefiniteAnimatedLayer.lineWidth = 4;
    _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
    _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
    _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[[UIImage imageNamed:@"loading_angle-mask@2x.png"] CGImage];
    maskLayer.frame = _indefiniteAnimatedLayer.bounds;
    _indefiniteAnimatedLayer.mask = maskLayer;
    
    NSTimeInterval animationDuration = 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = linearCurve;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0.015;
    strokeStartAnimation.toValue = @0.515;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0.485;
    strokeEndAnimation.toValue = @0.985;
    
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
    
    return _indefiniteAnimatedLayer;
}

@end
