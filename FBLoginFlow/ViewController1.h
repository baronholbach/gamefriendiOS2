//
//  ViewController.h
//  FBLoginFlow
//
//  Created by Tracy Liu on 10/20/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//


#import "FriendProtocols.h"
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class GamerTokens;
@class XBViewController1;
@class PSViewController;
@class settingsViewController;


@interface ViewController1 : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, NSXMLParserDelegate,FBLoginViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    // web service related objects
    NSURLConnection *connection;
    NSMutableData *xmlData;
    GamerTokens *tokenData;
    
    // view controllers
    XBViewController1 *xvc;
    PSViewController *pvc;
    settingsViewController *svc;

    NSMutableArray *searchArray;
    int cachedUser;
    
    NSMutableString *searchIDs;
}

@property (weak, nonatomic) IBOutlet UILabel *uiLabel;

@property (weak, nonatomic) IBOutlet UITextView *uiTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *networkPicker;
@property (weak, nonatomic) IBOutlet UITextField *xbEntry;
@property (weak, nonatomic) IBOutlet UITextField *psEntry;
@property (weak, nonatomic) IBOutlet UILabel *xbLabel;
@property (weak, nonatomic) IBOutlet UILabel *psLabel;
@property UINavigationBar *navBar;
@property UINavigationItem *navItem;
@property XBViewController1 *xvc;
@property FBLoginView *loginView;
@property UIBarButtonItem *nextButton;
@property UIBarButtonItem *backButton;
@property NSString *fullname;


@property (strong, nonatomic) NSArray *networkOptions;
@property NSString *myFBID;


- (IBAction)clickBasicShare:(id)sender;
- (IBAction)clickFriends:(id)sender;
- (IBAction)confirmPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;
- (void)xboxPicked;
-(void)psPicked;
- (void)fetchGamerTokens;
- (void)xboxBack;
- (void)psBack;
- (void)psNext;
- (void)psAndXboxBack;
- (BOOL)connectedToInternet;
- (void)commitToken:(NSString *)token;



@end
