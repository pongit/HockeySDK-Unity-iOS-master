#import "HockeyAppUnity.h"
#import "Utils.h"

@interface HockeyAppUnity()

@end

@implementation HockeyAppUnity

#pragma mark - Setup SDK

+ (void)startManagerWithIdentifier:(NSString *)appIdentifier
                         serverURL:(NSString *)serverURL
                          authType:(NSString *)authType
                            secret:(NSString *)secret
              updateManagerEnabled:(BOOL)updateManagerEnabled
                userMetricsEnabled:(BOOL)userMetricsEnabled
                   autoSendEnabled:(BOOL)autoSendEnabled {
  [self configHockeyManagerWithAppIdentifier:appIdentifier serverURL:serverURL];
  [self configAuthentificatorWithIdentificationType:authType secret:secret];
  [self configUpdateManagerWithUpdateManagerEnabled:updateManagerEnabled];
  [self configMetricsManagerWithUserMetricsEnabled:userMetricsEnabled];
  [self startManager];
}

+ (void)configHockeyManagerWithAppIdentifier:(NSString *)appIdentifier serverURL:(NSString *)serverURL{
  
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:appIdentifier];
  
  if(serverURL && serverURL.length > 0) {
    [[BITHockeyManager sharedHockeyManager] setServerURL:serverURL];
  }
}

+ (void)configCrashManagerWithAutoSendEnabled:(BOOL)autoSendEnabled{
  
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:[Utils statusForAutoSendEnabled:autoSendEnabled]];
}

+ (void)configMetricsManagerWithUserMetricsEnabled:(BOOL)userMetricsEnabled{
  
  [[BITHockeyManager sharedHockeyManager] setDisableMetricsManager:!userMetricsEnabled];
}

+ (void)configUpdateManagerWithUpdateManagerEnabled:(BOOL)updateManagerEnabled{
  
  [[BITHockeyManager sharedHockeyManager] setDisableUpdateManager:!updateManagerEnabled];
}

+ (void)configAuthentificatorWithIdentificationType:(NSString *)identificationType secret:(NSString *)secret{
  
  if(secret && secret.length > 0){
    [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:[Utils identificationTypeForString:identificationType]];
    [[BITHockeyManager sharedHockeyManager].authenticator setAuthenticationSecret:secret];
  }
}

+ (void)startManager{
  
  [[BITHockeyManager sharedHockeyManager] startManager];
  [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
}

+ (BOOL)handleOpenURL:(NSURL *) url sourceApplication:(NSString *) sourceApplication annotation:(id) annotation{
  
  if ([[BITHockeyManager sharedHockeyManager].authenticator handleOpenURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation]) {
    return YES;
  }
  return NO;
}

+ (void) sendViewLoadedMessageToUnity{
  
  NSString *gameObj = @"HockeyAppUnityIOS";
  NSString *msg = @"";
  NSString *method = @"GameViewLoaded";
  UnitySendMessage([gameObj UTF8String], [method UTF8String], [msg UTF8String]);
}

#pragma mark - Setup SDK

+ (void)showFeedbackListView{
  
  [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackListView];
}

+ (void)checkForUpdate {
  [[BITHockeyManager sharedHockeyManager].updateManager checkForUpdate];
}

+ (NSString *)versionCode{
  
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)versionName{
	
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleIdentifier;{
  
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)sdkVersion{
	
	return @"4.0.1";
}

+ (NSString *)sdkName{
	
	return @"HockeySDK";
}

@end
