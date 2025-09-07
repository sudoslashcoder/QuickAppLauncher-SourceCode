#import "QALPreferences.h"
#import <Cephei/HBPreferences.h>

@implementation QALPreferences {
    HBPreferences *_prefs;
}

+ (instancetype)sharedInstance {
    static QALPreferences *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _prefs = [[HBPreferences alloc] initWithIdentifier:@"com.yourname.quickapplauncher"];
    }
    return self;
}

- (NSArray *)quickApps {
    return [_prefs objectForKey:@"quickApps"] ?: @[];
}

- (BOOL)snapToEdgeEnabled {
    return [_prefs boolForKey:@"snapToEdgeEnabled" default:YES];
}

@end