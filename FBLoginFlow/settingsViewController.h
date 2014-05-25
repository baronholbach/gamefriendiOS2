//
//  settingsViewController.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/15/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController1.h"
#import "ShareURLReceiver.h"

@interface settingsViewController : UIViewController  <UITextFieldDelegate>

{
    NSURLConnection *connection;
    NSUserDefaults *settings;
    
    
    NSMutableData *xmlData;
    //GamerTokens *tokenData;
    NSMutableString *searchIDs;
    NSMutableArray *searchArray;
    
    int platformUpdate;
}

@property (weak, nonatomic) IBOutlet UITextField *xbEntry;
@property (weak, nonatomic) IBOutlet UITextField *psEntry;

@property (weak, nonatomic) IBOutlet UIButton *fbShare;
@property NSString *nextXBEntry;
@property NSString *nextPSEntry;
@property NSString *fbid;
@property UIAlertView *xbAlert;
@property UIAlertView *psAlert;
@property NSString *fbURL;
@property ShareURLReceiver *urlRec;
@property GamerTokens *tokenData;

- (IBAction)shareLinkWithShareDialog:(id)sender;
- (NSDictionary*)parseURLParams:(NSString *)query;
- (void)setUpSearchIDs;
- (void)fetchGamerTokens;
- (void)refresh;
- (void)getReadyToUpdate;
//- (BOOL) connectedToInternet;

@end
