//
//  AppDelegate.m
//  FBLoginFlow
//
//  Created by Tracy Liu on 10/20/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController1.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    
    [FBLoginView class];
    NSSet* set = [NSSet setWithObjects:FBLoggingBehaviorFBRequests, nil];
    [FBSettings setLoggingBehavior:set];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSLog(@"In failback handler");
    }];
    
    // add app-specific handling code here
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        UIStoryboard *ms = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
       _vc = [ms instantiateViewControllerWithIdentifier:@"ViewController1"];
        
        
        self.window.rootViewController = _vc;


    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
  
    if (![self connectedToInternet]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Friend Finder" message:@"Could not find server. Please make sure you are connected to the Internet and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL) connectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.apsgames.com"] encoding:NSUTF8StringEncoding error:nil];
    return ( URLString != NULL ) ? YES : NO;
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
if (buttonIndex == 0) {
    UIApplication *app = [UIApplication sharedApplication];
    [self applicationDidBecomeActive:app];
}
    
            
    
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSUserDefaults *setting = [[NSUserDefaults alloc] init];
    NSMutableString *tokenString = [NSMutableString stringWithCapacity:[deviceToken length]];
    [tokenString appendString:deviceToken.description];

    [tokenString replaceOccurrencesOfString:@" " withString:@"" options:nil range:NSMakeRange(0, [tokenString length])];
    [tokenString replaceOccurrencesOfString:@"<" withString:@"" options:nil range:NSMakeRange(0, [tokenString length])];
        [tokenString replaceOccurrencesOfString:@">" withString:@"" options:nil range:NSMakeRange(0, [tokenString length])];
    //NSLog(@"%@", tokenString);
    [setting setObject:tokenString forKey:@"deviceToken"];
    
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@", error);
}


@end
