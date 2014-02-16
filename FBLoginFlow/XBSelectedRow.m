//
//  XBSelectedRow.m
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 1/2/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import "XBSelectedRow.h"


@interface XBSelectedRow ()

@end

@implementation XBSelectedRow
@synthesize myID;
@synthesize myName;
@synthesize myProfileImage;
@synthesize prevCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated  {
    self.nameLabel.text =  myName;
    self.idLabel.text = myID;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.profileImage.image = myProfileImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    self.prevCell.backgroundColor = [UIColor clearColor];
}
@end
