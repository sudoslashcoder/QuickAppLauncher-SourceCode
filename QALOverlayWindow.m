#import "QALOverlayWindow.h"
#import "PrivateHeaders/LSApplicationWorkspace.h"

@interface QALOverlayWindow ()
@property (nonatomic, strong) NSArray *quickApps;
@end

@implementation QALOverlayWindow

- (void)setQuickApps:(NSArray *)apps {
    _quickApps = apps;
}

- (NSArray *)installedApps {
    LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
    if (workspace && [workspace respondsToSelector:@selector(allApplications)]) {
        return [workspace allApplications];
    }
    // Fail safe: return empty list on Dopamine / iOS 15+
    return @[];
}

- (void)launchAppWithBundleID:(NSString *)bundleID {
    LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
    if (workspace && [workspace respondsToSelector:@selector(openApplicationWithBundleID:)]) {
        BOOL success = [workspace openApplicationWithBundleID:bundleID];
        if (!success) {
            NSLog(@"[QAL] Failed to open app: %@", bundleID);
        }
    } else {
        NSLog(@"[QAL] openApplicationWithBundleID not available on this iOS");
    }
}

@end
