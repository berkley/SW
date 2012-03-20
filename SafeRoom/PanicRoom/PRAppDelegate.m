//
//  PRAppDelegate.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

/***********************************************************************
 
1.0
 - UI Changes
   - Better activation method/graphics
   - New logo/startup screen/color scheme
   - Move "add a service" to its own cell
   - add facebook/twitter icons
 - Add Twitter service, count characters
 - Add character counting for SMS
 - Use geoloqi for mapping link instead of static google map
 
 1.1
 - Add walkie-talkie feature

************************************************************************/

#import "PRAppDelegate.h"
#import "PRViewController.h"

@implementation PRAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        self.viewController = [[PRViewController alloc] initWithNibName:@"PRViewController_iPhone" bundle:nil];
    } 
    else 
    {
        self.viewController = [[PRViewController alloc] initWithNibName:@"PRViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(authorizeFacebook:) 
                                                 name:NOTIFICATION_AUTHORIZE_FACEBOOK 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(logoutOfFacebook) 
                                                 name:NOTIFICATION_FACEBOOK_LOGOUT 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(postToFacebook:) 
                                                 name:NOTIFICATION_POST_TO_FACEBOOK 
                                               object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [facebook extendAccessTokenIfNeeded];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    NSLog(@"returned facebook url: %@", url);
    return [facebook handleOpenURL:url]; 
}

#pragma mark - notification selectors

- (void)authorizeFacebook:(NSNotification*)notification
{
    if (![facebook isSessionValid]) 
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"offline_access", 
                                @"publish_stream",
                                nil];
        [facebook authorize:permissions];
    }
}

- (void)logoutOfFacebook
{
    [facebook logout];
}

- (void)postToFacebook:(NSNotification*)notification
{
    NSString *msg = [notification.userInfo objectForKey:@"message"];
    NSString *accessToken = [notification.userInfo objectForKey:@"accessToken"];
    NSDate *expirationDate = [notification.userInfo objectForKey:@"expirationDate"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   msg ,@"message", nil];
    
    self.facebook.expirationDate = expirationDate;
    self.facebook.accessToken = accessToken;
    
    [self.facebook requestWithGraphPath:@"me/feed"
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
}

#pragma mark - facebook delegate

- (void)fbDidLogin 
{
    PRFacebookService *fbservice = [[PRFacebookService alloc] init];
    fbservice.accessToken = [facebook accessToken];
    fbservice.expirationDate = [facebook expirationDate];
    fbservice.name = @"Facebook";
    [[PRSession instance] addService:fbservice];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_SERVICE_LIST object:nil];
    NSLog(@"facebook login success");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Facebook Login Successful", @"text", nil]];
}

- (void)fbSessionInvalidated;
{
    //try to auth again
    NSLog(@"facebook session invalidated");
    for(PRService *service in [PRSession instance].services)
    {
        if([service isKindOfClass:[PRFacebookService class]])
        {
            [[PRSession instance] removeService:service];
        }
    }
}

- (void)fbDidLogout
{
    NSLog(@"facebook logout");
    PRService *fbservice = [[PRSession instance] serviceWithName:@"Facebook"];
    [[PRSession instance] removeService:fbservice];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"User Logged Out of Facebook", @"text", nil]];

}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    PRFacebookService *service = (PRFacebookService*)[[PRSession instance] serviceWithName:@"Facebook"];
    service.accessToken = accessToken;
    service.expirationDate = expiresAt;
    [[PRSession instance] removeService:service];
    [[PRSession instance] addService:service];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Facebook Token Extended", @"text", nil]];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    //do not add the fb service
    NSLog(@"facebook login failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_STATUS_TEXT 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Facebook Login Failed", @"text", nil]];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Facebook error: %@", error);
}

@end
