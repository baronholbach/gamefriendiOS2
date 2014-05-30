//
//  settingsViewController.m
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/15/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "settingsViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "PSViewController.h"
#import "XBViewController1.h"
#import "ViewController1.h"
#import "GamerToken.h"
#import "GamerTokens.h"


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
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getReadyToUpdate)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refresh)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];

        NSURL *url2 = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/getURL.php"];
        
        //Put the URL into an USURLRequest
        NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
        
        [req2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req2 setHTTPMethod:@"GET"];
        
        [req2 setHTTPBody:[NSData dataWithBytes:@"" length:0]];
        
        _urlRec = [[ShareURLReceiver alloc] init];
        connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:_urlRec startImmediately:YES];

        
        
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
    
    CALayer *btnLayer = [_fbShare layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:4.0f];
    
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
    
    if ([textField.text isEqualToString:@""]) {  // if you press enter when the field is blank
    
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
    
    else {     // if textfield is not currently blank
        
        if (textField == _psEntry) {
            
            
            if ([textField.text isEqualToString:[settings stringForKey:@"psEntry"]]) {
                        _nextPSEntry = textField.text;
            }
            else {
                
                _nextPSEntry = textField.text;
                
                _psAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to update PSN Online ID?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                [_psAlert show];
                
                
            }

            
        }
        
        
        else if (textField == _xbEntry) {
            
            
            if ([textField.text isEqualToString:[settings stringForKey:@"xbEntry"]]) {
                _nextXBEntry = textField.text;
                
            }
          else {

               _nextXBEntry = textField.text;
               
               
               _xbAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to update Gamertag?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
               [_xbAlert show];
            
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
            
            [req2 setHTTPBody:[NSData dataWithBytes:[[NSString stringWithFormat:@"xbid=%@&fbid=%@", [settings objectForKey:@"xbEntry"], fbid] UTF8String] length:strlen([[NSString stringWithFormat:@"xbid=%@&fbid=%@", [settings objectForKey:@"xbEntry"], fbid] UTF8String])]];
            connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:self startImmediately:YES];
            _xbEntry.clearsOnBeginEditing = NO;
            
                if ([settings integerForKey:@"networks"] == 1)  // if there is not yet an xbox gamertag registered
                {
                    [settings setInteger:3 forKey:@"networks"];
                    
                    XBViewController1 *xvc = [[XBViewController1 alloc] init];
                    NSArray *xbtabArray = [[self tabBarController] viewControllers];
                    NSArray *xbaddView = [NSArray arrayWithObjects:xvc, xbtabArray[0], xbtabArray[1], nil];
                    [[self tabBarController] setViewControllers:xbaddView animated:NO];
                    [self setUpSearchIDs];
                     platformUpdate = 1;
                }
            }
        
            else if (buttonIndex == 0) {
                _xbEntry.text = [settings objectForKey:@"xbEntry"];
            }
    }
    
    
        else {  // if you updated the PSN ID box
            
            if (buttonIndex == 1) {
            
            [settings setObject:_nextPSEntry forKey:@"psEntry"];
                [settings synchronize];

            NSURL *url2 = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/submitUserDetails.php"];
            
            
            //Put the URL into an USURLRequest
            NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
            
            [req2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            [req2 setHTTPMethod:@"POST"];
            
            
            [req2 setHTTPBody:[NSData dataWithBytes:[[NSString stringWithFormat:@"psid=%@&fbid=%@", [settings objectForKey:@"psEntry"], fbid] UTF8String] length:strlen([[NSString stringWithFormat:@"psid=%@&fbid=%@", [settings objectForKey:@"psEntry"], fbid] UTF8String])]];
            
                connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:self startImmediately:YES];
            _psEntry.clearsOnBeginEditing = NO;
                
                if ([settings integerForKey:@"networks"] == 0)
                    {
                        [settings setInteger:3 forKey:@"networks"];
                        PSViewController *pvc = [[PSViewController alloc] init];
                        NSArray *tabArray = [[self tabBarController] viewControllers];
                        NSArray *addView = [NSArray arrayWithObjects:tabArray[0], pvc, tabArray[1], nil];
                        [[self tabBarController] setViewControllers:addView animated:NO];
                        [self setUpSearchIDs];
                        platformUpdate = 0;
                    }
            }
            
            else if (buttonIndex == 0) {
                _psEntry.text = [settings objectForKey:@"psEntry"];
            }
            
            
    }
    
}


- (IBAction)shareLinkWithShareDialog:(id)sender
{
    
    
    
    // Check if the Facebook app is installed and we can present the share dialog
 /*   FBShareDialogParams *params = [[FBShareDialogParams alloc] init];

    NSString *myURL = [_urlRec returnURL];
    params.link = [NSURL URLWithString:myURL];
    params.name = @"Game Friend Finder";
    params.caption = @"For PSN and Xbox Live.";
    params.picture = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/gff_icon_256_rounded14.png"];
    params.description = @"Check out this app that lets you find all your friends on Xbox Live and PSN instantly!";
    
    
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
    } else {*/
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        

        
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Game Friend Finder", @"name",
                                       @"For PSN and Xbox Live", @"caption",
                                       @"Check out this app that helps you find all your Facebook friends on Xbox Live and PSN!", @"description",
                                       [_urlRec returnURL], @"link",
                                       @"http://www.apsgames.com/gamefinder/gff_icon_256_rounded14.png", @"picture",
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
   // }
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 16) ? NO : YES;
}

/////////////////////////////////////
// Web service methods
////////////////////////////////////

// function to get gamer tokens from web service
- (void)fetchGamerTokens
{
    
    // initialize holder for data coming back from server
    xmlData = [[NSMutableData alloc] init];
    
    
    //construct an URL
    NSURL *url = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/getUserList.php"];
    
    //Put the URL into an USURLRequest
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[NSData dataWithBytes:[searchIDs UTF8String] length:strlen([searchIDs UTF8String])]];
    
    //Create a connection
    
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}


-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    
    [xmlData appendData:data];
    //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

// function called when finishing receiving data from web service
-(void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // For testing only: log xml data received from web service
    // NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    // NSLog(@"xmlCheck = %@", xmlCheck);
    
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];
    
    [parser parse];
    
    xmlData = nil;
    
    connection = nil;
    
    
    // set token data on view controller
    // TO DO: Need to do similar work for playstation view controller
    
    if (platformUpdate == 1) {
    [[[self tabBarController] viewControllers][0] setTokenData:tokenData];
        [[[self tabBarController] viewControllers][0] loadData];}
    /*
    
    else if (platformUpdate == 0) {
    [[[self tabBarController] viewControllers][1] setTokenData:tokenData];
        [[[self tabBarController] viewControllers][1] loadData]; }*/
    
    else if (platformUpdate == 2) {
        [[[self tabBarController] viewControllers][0] setTokenData:tokenData];
        [[[self tabBarController] viewControllers][0] loadData];
        [[[self tabBarController] viewControllers][1] setTokenData:tokenData];
        [[[self tabBarController] viewControllers][1] loadData];
        

        CGRect screen = [[UIScreen mainScreen] bounds];
        
        NSMutableArray *PSIDs = [[NSMutableArray alloc] init];
        NSMutableArray *XBIDs = [[NSMutableArray alloc] init];
        for (GamerToken *token in tokenData.tokens) {
            
            if (![token.PlayStationID isEqualToString:@""]) {
                [PSIDs addObject:token.PlayStationID];
            }
            
            if (![token.XBoxID isEqualToString:@""]) {
                [XBIDs addObject:token.XBoxID];
            }
        }

        
        if ([settings integerForKey:@"networks"] == 0) {
            XBViewController1 *xvc = [[self tabBarController] viewControllers][0];
            
            if ( [XBIDs count] == 0) {

            [xvc.tableView removeFromSuperview];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screen.size.width, 100)];
            label.text = @"None of your Facebook friends were found in Xbox Live database. Share on Facebook and invite them!";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:@"Futura" size:14];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.bounds = CGRectInset(label.frame, 15.0f, 0);
            
            UIButton *fbShare = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width/2-63, screen.size.height/2+10, 125, 83)];
            
            fbShare.backgroundColor = [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1];
            
            [fbShare setTitle:@"Share on Facebook" forState:UIControlStateNormal];
            fbShare.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            fbShare.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [fbShare setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 35)];
            fbShare.titleLabel.shadowOffset = CGSizeMake(2, 2);
            fbShare.titleLabel.shadowColor = [UIColor darkGrayColor];
            [fbShare setEnabled:YES];
            [fbShare setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [fbShare setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [fbShare setAdjustsImageWhenDisabled:YES];
            [fbShare setAdjustsImageWhenHighlighted:YES];
            [fbShare addTarget:self action:@selector(shareLinkWithShareDialog:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *fbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FB-f-Logo__white_100.png"]];
            [fbIcon setFrame:CGRectMake(5, 5, 30, 30)];
            
            [fbShare addSubview:fbIcon];
            
            
            CALayer *btnLayer = [fbShare layer];
            [btnLayer setMasksToBounds:YES];
            [btnLayer setCornerRadius:4.0f];
            
            [xvc.view addSubview:fbShare];
            [xvc.view addSubview:label];
            }
            
            else {
                [xvc.view addSubview:xvc.tableView];
                
            }
            
        }
        
        else if ([settings integerForKey:@"networks"] == 1) {
            PSViewController *pvc = [[self tabBarController] viewControllers][0];
            
            if ([PSIDs count] == 0) {
                
                [pvc.tableView removeFromSuperview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screen.size.width, 100)];
                label.text = @"None of your Facebook friends were found in PSN database. Share on Facebook and invite them!";
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont fontWithName:@"Futura" size:14];
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.numberOfLines = 0;
                label.bounds = CGRectInset(label.frame, 15.0f, 0);
                
                UIButton *fbShare = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width/2-63, screen.size.height/2+10, 125, 83)];
                
                fbShare.backgroundColor = [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1];
                
                [fbShare setTitle:@"Share on Facebook" forState:UIControlStateNormal];
                fbShare.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                fbShare.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [fbShare setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 35)];
                fbShare.titleLabel.shadowOffset = CGSizeMake(2, 2);
                fbShare.titleLabel.shadowColor = [UIColor darkGrayColor];
                [fbShare setEnabled:YES];
                [fbShare setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [fbShare setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [fbShare setAdjustsImageWhenDisabled:YES];
                [fbShare setAdjustsImageWhenHighlighted:YES];
                [fbShare addTarget:self action:@selector(shareLinkWithShareDialog:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *fbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FB-f-Logo__white_100.png"]];
                [fbIcon setFrame:CGRectMake(5, 5, 30, 30)];
                
                [fbShare addSubview:fbIcon];
                
                
                CALayer *btnLayer = [fbShare layer];
                [btnLayer setMasksToBounds:YES];
                [btnLayer setCornerRadius:4.0f];
                
                
                
                [pvc.view addSubview:fbShare];
                [pvc.view addSubview:label];
                
            }
        
            else {
                [pvc.view addSubview:pvc.tableView];
            }
            
            
        
        }
        
        else if ([settings integerForKey:@"networks"] == 3) {
            XBViewController1 *xvc = [[self tabBarController] viewControllers][0];
            PSViewController *pvc = [[self tabBarController] viewControllers][1];
            
            
            if ( [XBIDs count] == 0) {
                
                [xvc.tableView removeFromSuperview];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screen.size.width, 100)];
                label.text = @"None of your Facebook friends were found in Xbox Live database. Share on Facebook and invite them!";
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont fontWithName:@"Futura" size:14];
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.numberOfLines = 0;
                label.bounds = CGRectInset(label.frame, 15.0f, 0);
                
                UIButton *fbShare = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width/2-63, screen.size.height/2+10, 125, 83)];
                
                fbShare.backgroundColor = [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1];
                
                [fbShare setTitle:@"Share on Facebook" forState:UIControlStateNormal];
                fbShare.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                fbShare.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [fbShare setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 35)];
                fbShare.titleLabel.shadowOffset = CGSizeMake(2, 2);
                fbShare.titleLabel.shadowColor = [UIColor darkGrayColor];
                [fbShare setEnabled:YES];
                [fbShare setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [fbShare setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [fbShare setAdjustsImageWhenDisabled:YES];
                [fbShare setAdjustsImageWhenHighlighted:YES];
                [fbShare addTarget:self action:@selector(shareLinkWithShareDialog:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *fbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FB-f-Logo__white_100.png"]];
                [fbIcon setFrame:CGRectMake(5, 5, 30, 30)];
                
                [fbShare addSubview:fbIcon];
                
                
                CALayer *btnLayer = [fbShare layer];
                [btnLayer setMasksToBounds:YES];
                [btnLayer setCornerRadius:4.0f];
                
                
                
                [xvc.view addSubview:fbShare];
                [xvc.view addSubview:label];
                
            }
            else {
                [xvc.view addSubview:xvc.tableView];
                
            }
            
            
            
            if ([PSIDs count] == 0) {
                
                [pvc.tableView removeFromSuperview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screen.size.width, 100)];
                label.text = @"None of your Facebook friends were found in PSN database. Share on Facebook and invite them!";
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont fontWithName:@"Futura" size:14];
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.numberOfLines = 0;
                label.bounds = CGRectInset(label.frame, 15.0f, 0);
                
                UIButton *fbShare = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width/2-63, screen.size.height/2+10, 125, 83)];
                
                fbShare.backgroundColor = [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1];
                
                [fbShare setTitle:@"Share on Facebook" forState:UIControlStateNormal];
                fbShare.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                fbShare.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [fbShare setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 35)];
                fbShare.titleLabel.shadowOffset = CGSizeMake(2, 2);
                fbShare.titleLabel.shadowColor = [UIColor darkGrayColor];
                [fbShare setEnabled:YES];
                [fbShare setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [fbShare setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [fbShare setAdjustsImageWhenDisabled:YES];
                [fbShare setAdjustsImageWhenHighlighted:YES];
                [fbShare addTarget:self action:@selector(shareLinkWithShareDialog:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *fbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FB-f-Logo__white_100.png"]];
                [fbIcon setFrame:CGRectMake(5, 5, 30, 30)];
                
                [fbShare addSubview:fbIcon];
                
                
                CALayer *btnLayer = [fbShare layer];
                [btnLayer setMasksToBounds:YES];
                [btnLayer setCornerRadius:4.0f];
                
                
                
                [pvc.view addSubview:fbShare];
                [pvc.view addSubview:label];
                
                
                
            }
            else {
                [pvc.view addSubview:pvc.tableView];
            }
            
            
            
        }

    }
}

// function called when fail to web service
-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    connection = nil;
    xmlData = nil;
    
    // show alert view
 /*   NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];*/
}

/////////////////////////////////////////////////
// NSXMLParserDelegate method overrides
/////////////////////////////////////////////////
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"gamertokens"])
    {
        tokenData = [[GamerTokens alloc] init];
        
        [tokenData setParentParserDelegate:self];  // Give channel object a pointer back to ListViewController(self) for later
        
        [parser setDelegate:tokenData];
    }
    
    
}



-(void)setUpSearchIDs {
    
FBRequest* request = [FBRequest requestForMyFriends];
searchIDs =  [[NSMutableString alloc] init];
[searchIDs appendString:@"name="];
searchArray = [[NSMutableArray alloc] init];
[request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    for(id<FBGraphUser> user in result[@"data"])
    {
        
        [searchArray addObject:user.id];
        [searchIDs appendFormat:@"\"%@\"", user.id];
        [searchIDs appendString:@","];
        
    }
    
    if ([searchIDs length] > 0) {
        
        [searchIDs deleteCharactersInRange:NSMakeRange([searchIDs length] - 1, 1)];
    }
    
    // Send request to database
    
    if (self) {
        [self fetchGamerTokens];
    }

}];
}

- (void)refresh {
    
    if (platformUpdate == 2) {
       
        
        [self setUpSearchIDs];
        }

}


- (void)getReadyToUpdate {
    
    platformUpdate = 2;
    
}


@end
