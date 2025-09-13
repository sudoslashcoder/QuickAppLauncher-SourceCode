#import "QALOverlayWindow.h"
#import "QALPreferences.h"

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *apps = [[QALPreferences sharedInstance] quickApps];
        [[QALOverlayWindow sharedWindow] setQuickApps:apps];
        [[QALOverlayWindow sharedWindow] setHidden:NO];
    });
}

%end