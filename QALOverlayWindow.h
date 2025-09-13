#import <UIKit/UIKit.h>

@interface QALOverlayWindow : UIWindow
+ (instancetype)sharedWindow;
- (void)setQuickApps:(NSArray *)apps;
@end