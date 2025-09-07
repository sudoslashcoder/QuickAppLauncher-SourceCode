#import <Preferences/PSListController.h>
#import <spawn.h>

@interface QALRootListController : PSListController
@end

@implementation QALRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)respringDevice {
    pid_t pid;
    const char *argv[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)argv, NULL);
}

@end