//
//  settingsViewController.m
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/15/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "settingsViewController.h"
#import "ViewController1.h"
#import <FacebookSDK/FacebookSDK.h>

@interface settingsViewController () <FBLoginViewDelegate, UIAlertViewDelegate>
@end

static NSUserDefaults *settings;


@implementation settingsViewController

@synthesize fbid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBarItem initWithTitle:@"Settings" image:[UIImage imageNamed:@"tab_settings.png"] tag:2];
        settings = [[NSUserDefaults alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FBLoginView* loginView = [[FBLoginView alloc]init];
    loginView.readPermissions = @[@"basic_info"];
    loginView.delegate = self;
    loginView.center = CGPointMake(160,400);
    [self.view addSubview:loginView];
    

    
    if ([settings valueForKey:@"psEntry"]) {
        _psEntry.text =[settings stringForKey:@"psEntry"];
        _psEntry.backgroundColor = [UIColor whiteColor];
        _psEntry.font = [UIFont boldSystemFontOfSize:20];
        _psEntry.textAlignment = NSTextAlignmentCenter;
        _psEntry.clearsOnBeginEditing = NO;
    }
    else {

    }
    
    if ([settings valueForKey:@"xbEntry"]) {
        _xbEntry.text = [settings stringForKey:@"xbEntry"];
       _xbEntry.backgroundColor = [UIColor whiteColor];
        _xbEntry.font = [UIFont boldSystemFontOfSize:20];
       _xbEntry.textAlignment = NSTextAlignmentCenter;
        _xbEntry.clearsOnBeginEditing = NO;
    }
    else {

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    [FBLoginView class];
    NSSet* set = [NSSet setWithObjects:FBLoggingBehaviorFBRequests, nil];
    [FBSettings setLoggingBehavior:set];

    
    
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ViewController1 *v1 = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    [self presentViewController:v1 animated:NO completion:nil];
}
    


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@""]) {
    
        if (textField == _psEntry) {
        
            if ([settings stringForKey:@"psEntry"] == NULL) {
                
                textField.backgroundColor = [UIColor grayColor];
                textField.font = [UIFont italicSystemFontOfSize:14];
                textField.textAlignment = NSTextAlignmentLeft;
                textField.text = @"Add PSN Online ID";
            }
            
            else {
  
                textField.text = [settings objectForKey:@"psEntry"];
            }
        
    }
    
        if (textField == _xbEntry) {
            
            if ([settings stringForKey:@"xbEntry"] == NULL) {
                
                textField.backgroundColor = [UIColor grayColor];
                textField.font = [UIFont italicSystemFontOfSize:14];
                textField.textAlignment = NSTextAlignmentLeft;
                textField.text = @"Add Xbox Live Gamertag";


            }
            
            else {

                textField.text = [settings objectForKey:@"xbEntry"];
            }
        }
        
    
    }
    
    else {
        
        if (textField == _psEntry) {
            
            
            if ([settings stringForKey:@"psEntry" ] != NULL) {
                
                if (![textField.text isEqualToString:[settings stringForKey:@"psEntry"]]) {
                    _nextPSEntry = textField.text;
                
                _psAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to update Online ID?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                [_psAlert show];
                    
                }
                
            }
            
            

            
        }
        
        
        else if (textField == _xbEntry) {
            
            
          if (![textField.text isEqualToString:[settings stringForKey:@"xbEntry"]]) {

           if ([settings stringForKey:@"xbEntry" ] != NULL) {
               _nextXBEntry = textField.text;
               
               
               _xbAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to update Gamertag?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
               [_xbAlert show];
            
           }
          }
            
            

        }
    }
    

    
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont boldSystemFontOfSize:20];
    textField.textAlignment = NSTextAlignmentCenter;
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    

    if ([alertView isEqual:_xbAlert]) {
            if (buttonIndex == 1) {
            
            [settings setObject:_nextXBEntry forKey:@"xbEntry"];
                              [settings synchronize];
            
            NSURL *url2 = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/submitUserDetails.php"];
            
            
            //Put the URL into an USURLRequest
            NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
            
            [req2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [req2 setHTTPMethod:@"POST"];
            
            [req2 setHTTPBody:[NSData dataWithBytes:[[NSString stringWithFormat:@"xbid=%@&fbid=%@", [settings objectForKey:@"xbEntry"], fbid] UTF8String] length:strlen([[NSString stringWithFormat:@"xbid=%@&fbid=%@", [settings objectForKey:@"xbEntry"], fbid]UTF8String])]];
            
            connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:self startImmediately:YES];
            }
        
        
            else if (buttonIndex == 0) {
                _xbEntry.text = [settings objectForKey:@"xbEntry"];
            }
        }
        
        else {
            
            if (buttonIndex == 1) {
            
            [settings setObject:_nextPSEntry forKey:@"psEntry"];
                [settings synchronize];
            
            NSURL *url2 = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/submitUserDetails.php"];
            
            
            //Put the URL into an USURLRequest
            NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
            
            [req2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [req2 setHTTPMethod:@"POST"];
            
            
            [req2 setHTTPBody:[NSData dataWithBytes:[[NSString stringWithFormat:@"psid=%@&fbid=%@", [settings objectForKey:@"psEntry"], fbid] UTF8String] length:strlen([[NSString stringWithFormat:@"psid=%@&fbid=%@", [settings objectForKey:@"psEntry"], fbid]UTF8String])]];
            
            connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:self startImmediately:YES];
            }
            
            else if (buttonIndex == 0) {
                _psEntry.text = [settings objectForKey:@"psEntry"];
            }
            
            
    }
    
}


- (IBAction)shareLinkWithShareDialog:(id)sender
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"Sharing Tutorial";
    params.caption = @"Build great social apps and get more installs.";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.description = @"Allow your users to share stories on Facebook from your app using the iOS SDK.";
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Game Friend Finder", @"name",
                                       @"For PSN and Xbox Live", @"caption",
                                       @"Check out this app that lets you find all your friends on Xbox Live and PSN instantly!", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       [UIImage imageNamed:@"400_F_32161739_cLQcViNu7WgHC3yjBDP5sanGGBRRkmtC.jpg"], @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}



@end
