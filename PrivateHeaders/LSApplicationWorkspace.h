#import <Foundation/Foundation.h>

@interface LSApplicationWorkspace : NSObject
+ (instancetype)defaultWorkspace;
- (NSArray *)allApplications;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleID;
@end

@interface LSApplicationProxy : NSObject
@property (nonatomic, readonly) NSString *applicationIdentifier;
@property (nonatomic, readonly) NSString *localizedName;
@end