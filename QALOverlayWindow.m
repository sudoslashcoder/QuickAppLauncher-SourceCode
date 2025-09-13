#import "QALOverlayWindow.h"
#import <objc/runtime.h>

@interface QALOverlayWindow ()
@property (nonatomic, strong) NSArray *apps;
@end

@implementation QALOverlayWindow

+ (instancetype)sharedWindow {
    static QALOverlayWindow *win = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        win = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        win.windowLevel = UIWindowLevelAlert + 1;
        win.backgroundColor = [UIColor clearColor];
        win.hidden = YES;
    });
    return win;
}

- (void)setQuickApps:(NSArray *)apps {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.apps = apps ?: @[];
        // remove previous buttons
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        // Create simple buttons along the left side
        CGFloat startY = 80.0;
        CGFloat x = 8.0;
        CGFloat w = 160.0;
        CGFloat h = 36.0;
        NSInteger idx = 0;
        for (id item in self.apps) {
            NSString *title = nil;
            if ([item isKindOfClass:[NSString class]]) {
                title = item;
            } else if ([item respondsToSelector:@selector(stringValue)]) {
                title = [item stringValue];
            } else {
                title = [NSString stringWithFormat:@"app-%ld", (long)idx];
            }
            UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
            b.frame = CGRectMake(x, startY + idx * (h + 8), w, h);
            [b setTitle:title forState:UIControlStateNormal];
            b.tag = idx;
            b.layer.cornerRadius = 8;
            b.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
            idx++;
        }
        // show window
        self.hidden = NO;
    });
}

- (void)buttonTapped:(UIButton *)sender {
    NSInteger idx = sender.tag;
    if (idx < 0 || idx >= self.apps.count) return;
    id app = self.apps[idx];
    NSString *bundleID = nil;
    if ([app isKindOfClass:[NSString class]]) bundleID = app;
    else if ([app respondsToSelector:@selector(stringValue)]) bundleID = [app stringValue];
    if (!bundleID) return;

    // Use LSApplicationWorkspace to open app (dynamic)
    Class LSAppWorkspace = objc_getClass("LSApplicationWorkspace");
    if (LSAppWorkspace) {
        id workspace = [LSAppWorkspace performSelector:@selector(defaultWorkspace)];
        if (workspace && [workspace respondsToSelector:@selector(openApplicationWithBundleID:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleID];
#pragma clang diagnostic pop
            return;
        }
    }

    // Fallback: try UIApplication openURL with bundle's URL scheme (best-effort)
    // No universal fallback available for all apps, so just return.
}

@end
