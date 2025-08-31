#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <substrate.h>

#define SETTINGS_PATH @"/var/mobile/Library/Preferences/com.slash.quickapplauncher.plist"

@interface QuickAppLauncherButton : UIButton
@property NSString *bundleID;
@end

@implementation QuickAppLauncherButton
@end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_PATH];
    NSArray *apps = settings[@"quickApps"];
    if (!apps || apps.count == 0) return;

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    for (NSDictionary *appDict in apps) {
        QuickAppLauncherButton *button = [QuickAppLauncherButton buttonWithType:UIButtonTypeCustom];
        button.bundleID = appDict[@"bundleID"];
        button.frame = CGRectMake([appDict[@"x"] intValue], [appDict[@"y"] intValue], 60, 60);
        button.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.7];
        button.layer.cornerRadius = 10;

        // Launch app on tap
        [button addTarget:self action:@selector(launchApp:) forControlEvents:UIControlEventTouchUpInside];

        // Enable drag
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragButton:)];
        [button addGestureRecognizer:pan];

        [window addSubview:button];
    }
}

// Launch app
- (void)launchApp:(QuickAppLauncherButton *)sender {
    Class SBAppController = objc_getClass("SBApplicationController");
    id controller = [SBAppController sharedInstance];
    id app = [controller applicationWithBundleIdentifier:sender.bundleID];
    [app launch];

    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:1];
    [generator impactOccurred];
}

// Drag handler
- (void)dragButton:(UIPanGestureRecognizer *)gesture {
    UIView *button = gesture.view;
    CGPoint translation = [gesture translationInView:button.superview];
    button.center = CGPointMake(button.center.x + translation.x, button.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:button.superview];
}

%end

