#import <Cephei/HBPreferences.h>
#import <Foundation/Foundation.h>

// Advanced GPS Spoofing with per-app configuration
%hook CLLocationManager

- (void)startUpdatingLocation {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    
    if (!enabled) {
        %orig;
        return;
    }
    
    BOOL gpsEnabled = [prefs boolForKey:@"GPSEnabled"];
    if (!gpsEnabled) {
        %orig;
        return;
    }
    
    // Start location updates with spoofed data
    %orig;
}

- (CLLocation *)location {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL gpsEnabled = [prefs boolForKey:@"GPSEnabled"];
    
    CLLocation *original = %orig;
    
    if (!enabled || !gpsEnabled) {
        return original;
    }
    
    // Get spoofed coordinates
    NSString *latStr = [prefs objectForKey:@"GPSLatitude"];
    NSString *lonStr = [prefs objectForKey:@"GPSLongitude"];
    
    double latitude = latStr ? [latStr doubleValue] : 24.7136;
    double longitude = lonStr ? [lonStr doubleValue] : 46.6753;
    
    CLLocationCoordinate2D spoofedCoord = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation *spoofedLocation = [[CLLocation alloc] 
        initWithCoordinate:spoofedCoord
        altitude:original.altitude
        horizontalAccuracy:5.0
        verticalAccuracy:5.0
        course:0
        speed:0
        timestamp:[NSDate date]];
    
    return spoofedLocation;
}

- (CLLocationCoordinate2D)coordinate {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL gpsEnabled = [prefs boolForKey:@"GPSEnabled"];
    
    if (!enabled || !gpsEnabled) {
        return %orig;
    }
    
    NSString *latStr = [prefs objectForKey:@"GPSLatitude"];
    NSString *lonStr = [prefs objectForKey:@"GPSLongitude"];
    
    double latitude = latStr ? [latStr doubleValue] : 24.7136;
    double longitude = lonStr ? [lonStr doubleValue] : 46.6753;
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

%end

// Enhanced Device ID Spoofing
%hook UIDevice

- (NSString *)uniqueIdentifier {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL deviceIDEnabled = [prefs boolForKey:@"DeviceIDEnabled"];
    
    if (!enabled || !deviceIDEnabled) {
        return %orig;
    }
    
    NSString *spoofedUDID = [prefs objectForKey:@"SpoofedUDID"];
    if (spoofedUDID && spoofedUDID.length > 0) {
        return spoofedUDID;
    }
    
    return %orig;
}

- (NSString *)model {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL deviceIDEnabled = [prefs boolForKey:@"DeviceIDEnabled"];
    
    if (!enabled || !deviceIDEnabled) {
        return %orig;
    }
    
    NSString *spoofedModel = [prefs objectForKey:@"SpoofedDeviceModel"];
    if (spoofedModel && spoofedModel.length > 0) {
        return spoofedModel;
    }
    
    return %orig;
}

- (NSString *)systemVersion {
    return %orig;
}

- (NSString *)systemName {
    return %orig;
}

%end

// IDFA/IDFV Spoofing
%hook ASIdentifierManager

- (NSUUID *)advertisingIdentifier {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL deviceIDEnabled = [prefs boolForKey:@"DeviceIDEnabled"];
    
    if (!enabled || !deviceIDEnabled) {
        return %orig;
    }
    
    NSString *spoofedIDFA = [prefs objectForKey:@"SpoofedIDFA"];
    if (spoofedIDFA && spoofedIDFA.length > 0) {
        return [[NSUUID alloc] initWithUUIDString:spoofedIDFA];
    }
    
    return %orig;
}

%end

// Biometric Bypass
%hook LAContext

- (void)evaluatePolicy:(LAPolicy)policy 
    localizedReason:(NSString *)localizedReason 
    reply:(void(^)(BOOL success, NSError *error))reply {
    
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL biometricBypass = [prefs boolForKey:@"BiometricBypassEnabled"];
    
    if (enabled && biometricBypass) {
        reply(YES, nil);
        return;
    }
    
    %orig;
}

- (void)evaluatePolicyWithDeviceOwnerAuthentication:(LAPolicy)policy 
    localizedReason:(NSString *)localizedReason 
    reply:(void(^)(BOOL success, NSError *error))reply {
    
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    BOOL enabled = [prefs boolForKey:@"GlobalEnabled"];
    BOOL biometricBypass = [prefs boolForKey:@"BiometricBypassEnabled"];
    
    if (enabled && biometricBypass) {
        reply(YES, nil);
        return;
    }
    
    %orig;
}

%end

// Jailbreak Detection Bypass
%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString *)path {
    // Common jailbreak detection paths
    NSArray *jailbreakPaths = @[
        @"/Applications/Cydia.app",
        @"/Applications/blackra1n.app",
        @"/Applications/FakeCarrier.app",
        @"/Applications/Winterboard.app",
        @"/Applications/SBSettings.app",
        @"/Library/MobileSubstrate/DynamicLibraries",
        @"/usr/sbin/sshd",
        @"/usr/bin/sshd",
        @"/usr/libexec/ssh-keysign",
        @"/usr/bin/ssh",
        @"/etc/ssh/sshd_config",
        @"/var/run/sshd.pid",
        @"/var/cache/apt",
        @"/etc/apt",
        @"/bin/bash",
        @"/usr/bin/env",
        @"/usr/bin/perl"
    ];
    
    for (NSString *jbPath in jailbreakPaths) {
        if ([path isEqualToString:jbPath]) {
            return NO;
        }
    }
    
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory {
    NSArray *jailbreakPaths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate",
        @"/usr/sbin/sshd",
        @"/etc/apt"
    ];
    
    for (NSString *jbPath in jailbreakPaths) {
        if ([path isEqualToString:jbPath]) {
            return NO;
        }
    }
    
    return %orig;
}

%end

// Process Detection Bypass
%hook NSTask

+ (NSTask *)launchedTaskWithLaunchPath:(NSString *)path arguments:(NSArray *)arguments {
    NSArray *blockedProcesses = @[@"dpkg", @"apt-get", @"apt", @"cydia"];
    
    for (NSString *process in blockedProcesses) {
        if ([path containsString:process]) {
            return nil;
        }
    }
    
    return %orig;
}

%end

// Constructor
%ctor {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.gps.spoof.prefs"];
    
    [prefs registerPreferenceChangeBlock:^{
        // Preferences changed - hooks will auto-update on next call
    }];
}
