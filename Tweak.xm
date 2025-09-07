#import <UIKit/UIKit.h>
#import "QALOverlayWindow.h"

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    UIWindow *keyWindow = nil;

    // ? iOS 13+ (Scene-based)
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
    } else {
        // ? Fallback for < iOS 13
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        keyWindow = [UIApplication sharedApplication].keyWindow;
        #pragma clang diagnostic pop
    }

    if (keyWindow) {
        QALOverlayWindow *overlay = [[QALOverlayWindow alloc] initWithFrame:keyWindow.bounds];
        overlay.windowLevel = UIWindowLevelAlert + 1; // keep above normal windows
        overlay.hidden = NO;
        [keyWindow addSubview:overlay];
    }
}

%end