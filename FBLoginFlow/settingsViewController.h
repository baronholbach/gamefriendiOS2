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
    GamerTokens *tokenData;
    NSMutableString *searchIDs;
    NSMutableArray *searchArray;
    ShareURLReceiver *urlRec;
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

- (IBAction)shareLinkWithShareDialog:(id)sender;
- (NSDictionary*)parseURLParams:(NSString *)query;
- (void)setUpSearchIDs;
- (void)fetchGamerTokens;

@end
