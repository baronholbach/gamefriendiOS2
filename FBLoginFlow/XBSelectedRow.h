//
//  XBSelectedRow.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 1/2/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBSelectedRow : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak) IBOutlet UIImageView *profileImage;
@property NSString *myName;
@property NSString *myID;
@property UIImage *myProfileImage;

@end
