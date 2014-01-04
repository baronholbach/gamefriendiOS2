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

@interface settingsViewController () <FBLoginViewDelegate>

@end

@implementation settingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBarItem initWithTitle:@"Settings" image:[UIImage imageNamed:@"tab_settings.png"] tag:2];
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
    
    NSUserDefaults *settings = [[NSUserDefaults alloc] init];
    _psEntry.text =[settings stringForKey:@"psEntry"];
    
    _xbEntry.text = [settings stringForKey:@"xbEntry"];
    
    
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
    


@end
