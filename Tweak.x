#import <UIKit/UIKit.h>

@interface QuickAppLauncherView : UIView
@end

@implementation QuickAppLauncherView {
    UIButton *launcherButton;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 100, 60, 60)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        launcherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        launcherButton.frame = self.bounds;
        launcherButton.layer.cornerRadius = 30;
        launcherButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [launcherButton setTitle:@"⚡" forState:UIControlStateNormal];
        launcherButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [launcherButton addTarget:self action:@selector(showAppList) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:launcherButton];
    }
    return self;
}

- (void)showAppList {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quick Apps"
                                                                   message:@"Select an app"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    NSArray *apps = @[@"Safari", @"Mail", @"Settings"];
    for (NSString *appName in apps) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:appName
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Launching %@", appName);
        }];
        [alert addAction:action];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    UIViewController *rootVC = [self topViewController];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

- (UIViewController *)topViewController {
    UIWindow *mainWindow = [self mainAppWindow];
    return mainWindow.rootViewController;
}

- (UIWindow *)mainAppWindow {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
        }
    }
    return nil;
}

@end


%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QuickAppLauncherView *launcher = [[QuickAppLauncherView alloc] init];

        UIWindow *mainWindow = [launcher mainAppWindow];
        if (mainWindow) {
            [mainWindow addSubview:launcher];
        }
    });
}

%end

