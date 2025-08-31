#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <SpringBoard/SpringBoard.h>

// =============================
// QuickAppLauncherView
// =============================
@interface QuickAppLauncherView : UIView
@end

@implementation QuickAppLauncherView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(100, 200, 60, 60)];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.layer.cornerRadius = 30;
        self.userInteractionEnabled = YES;

        // Load preferences
        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:
            @"/var/mobile/Library/Preferences/com.yourname.quickapplauncher.plist"];

        // Apply scale
        CGFloat buttonScale = [[prefs objectForKey:@"QALButtonScale"] floatValue];
        if (buttonScale <= 0) buttonScale = 1.0;
        self.transform = CGAffineTransformMakeScale(buttonScale, buttonScale);

        // Add tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchApp)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)launchApp {
    // Load prefs again in case user changed them
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:
        @"/var/mobile/Library/Preferences/com.yourname.quickapplauncher.plist"];

    NSString *bundleID = [prefs objectForKey:@"QALBundleID"];
    if (!bundleID || [bundleID length] == 0) {
        bundleID = @"com.apple.Preferences"; // Default to Settings
    }

    SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:bundleID];
    if (app) {
        [[%c(SBUIController) sharedInstance] activateApplication:app];
    }
}

@end

// =============================
// UIWindow helper
// =============================
@interface QuickAppLauncherView (WindowHelper)
- (UIWindow *)mainAppWindow;
@end

@implementation QuickAppLauncherView (WindowHelper)
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

// =============================
// Hook SpringBoard
// =============================
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

