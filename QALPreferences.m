#import "QALPreferences.h"

@implementation QALPreferences {
    NSDictionary *_prefs;
}

+ (instancetype)sharedInstance {
    static QALPreferences *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[self alloc] init];
    });
    return s;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self reload];
        // observe file changes to reload prefs when user edits (simple timer fallback)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    return self;
}

- (void)reload {
    NSString *path = @"/var/mobile/Library/Preferences/com.slash.quickapplauncher.plist";
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:path];
    if (d) _prefs = d;
    else _prefs = @{};
}

- (NSArray *)quickApps {
    id v = _prefs[@"quickApps"];
    if (!v) return @[];
    if ([v isKindOfClass:[NSArray class]]) return v;
    if ([v isKindOfClass:[NSString class]]) {
        NSString *s = (NSString*)v;
        NSMutableArray *out = [NSMutableArray new];
        for (NSString *part in [s componentsSeparatedByString:@","]) {
            NSString *trim = [part stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (trim.length) [out addObject:trim];
        }
        return out;
    }
    return @[];
}

- (BOOL)snapToEdgeEnabled {
    id v = _prefs[@"snapToEdgeEnabled"];
    if (!v) return YES;
    if ([v respondsToSelector:@selector(boolValue)]) return [v boolValue];
    return YES;
}

@end
