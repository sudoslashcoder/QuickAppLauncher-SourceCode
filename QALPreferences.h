#import <Foundation/Foundation.h>

@interface QALPreferences : NSObject
+ (instancetype)sharedInstance;

- (NSArray *)quickApps;
- (BOOL)snapToEdgeEnabled;
@end