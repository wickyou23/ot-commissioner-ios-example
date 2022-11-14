//
//  LoadingView.m
//  TPOpenthreadCommissionerExample
//
//  Created by Thang Phung on 07/11/2022.
//

#import "LoadingView.h"

@implementation LoadingView {
    UIWindow* loadingWindow;
}

static LoadingView* _loadingView;

- (instancetype)init {
    if (self = [super init]) {
        UIScene *scene = [UIApplication sharedApplication].connectedScenes.anyObject;
        loadingWindow = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
        loadingWindow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        loadingWindow.windowLevel = 1991;
        loadingWindow.backgroundColor = [UIColor clearColor];
        loadingWindow.userActivity = FALSE;
    }
    
    return self;
}

- (void)handleShowLoading {
    UIViewController* rootViewController = [[UIViewController alloc] init];
    rootViewController.view.backgroundColor = [UIColor clearColor];
    
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    [indicatorView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    indicatorView.tintColor = [UIColor darkGrayColor];
    
    [rootViewController.view addSubview:indicatorView];
    [indicatorView.centerYAnchor constraintEqualToAnchor:rootViewController.view.centerYAnchor constant:0].active = TRUE;
    [indicatorView.centerXAnchor constraintEqualToAnchor:rootViewController.view.centerXAnchor constant:0].active = TRUE;
    [indicatorView startAnimating];
    
    loadingWindow.rootViewController = rootViewController;
    [loadingWindow makeKeyAndVisible];
}

- (void)handleHideLoading {
    [loadingWindow setHidden:TRUE];
    loadingWindow = NULL;
}

+ (void)show {
    if (_loadingView != NULL) {
        return;
    }
    
    _loadingView = [[LoadingView alloc] init];
    [_loadingView handleShowLoading];
}

+ (void)hide {
    if (_loadingView == NULL) {
        return;
    }
    
    [_loadingView handleHideLoading];
    _loadingView = NULL;
}

@end
