//
//  settingsViewController.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/15/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsViewController : UIViewController  <UITextFieldDelegate>

{
    NSURLConnection *connection;
}

@property (weak, nonatomic) IBOutlet UITextField *xbEntry;
@property (weak, nonatomic) IBOutlet UITextField *psEntry;

@property (weak, nonatomic) IBOutlet UIButton *fbShare;
@property NSString *nextXBEntry;
@property NSString *nextPSEntry;
@property NSString *fbid;
@property UIAlertView *xbAlert;
@property UIAlertView *psAlert;



@end
