#import <Preferences/PSListController.h>

@interface GPSSpoofPrefsListController : PSListController
@end

@implementation GPSSpoofPrefsListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

@end
