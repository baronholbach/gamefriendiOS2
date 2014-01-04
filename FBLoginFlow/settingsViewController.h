//
//  settingsViewController.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/15/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsViewController : UIViewController  <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *xbEntry;
@property (weak, nonatomic) IBOutlet UITextField *psEntry;

@end
