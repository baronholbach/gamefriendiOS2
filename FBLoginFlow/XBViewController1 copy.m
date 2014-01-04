//
//  XBViewController.m
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/22/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "XBViewController1.h"
#import "FriendProtocols.h"
#import "XBSelectedRow.h"

@interface XBViewController1 () <UITableViewDelegate>

@end

@implementation XBViewController1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

            // Custom initialization
            UITabBarItem *tbi = [self tabBarItem];
            [tbi setImage:[UIImage imageNamed:@"tab_xbox.png"]];
            [tbi setTitle:@"Xbox Live"];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    FBLoginView* loginView = [[FBLoginView alloc]init];
   // loginView.readPermissions = @[@"basic_info"];
    //loginView.delegate = self;
    //loginView.center = CGPointMake(160,330);
    //[self.view addSubview:loginView];
    
    
    
    FBRequest* request = [FBRequest requestForMyFriends];
    
    request.parameters[@"fields"] =
    [NSString stringWithFormat:@"%@, installed",request.parameters[@"fields"]];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSMutableString* string = [[NSMutableString alloc] init];
        
        for(id<FBGraphUser> user in result[@"data"])
        {
            [string appendFormat:@"%@ installed the app? %@\n", [user first_name], user[@"installed"]?@"Yes":@"No"];

        }
        
    }];
    
    self.cancelButton  = nil;
    self.doneButton  = nil;
    self.tableView.delegate = self;

    
    //self.fieldsForRequest = [NSSet setWithObjects:@"devices", nil];
    [self setSortOrdering:FBFriendSortByLastName];
    [self loadData];

    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XboxLIVE_RGBvectorKO_horizontal_2013.png"]];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xbox_bg.png"]];
    [titleView setFrame:CGRectMake(64, -12, 192, 72)];
    [bgView setFrame:CGRectMake(0, 0, 320, 50)];
    
    [self.view addSubview:bgView];
    [self.view addSubview:titleView];
 
    
    [self.tableView setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50)];
    
        [self setSortOrdering:FBFriendSortByLastName];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUserExtraFields>)user
{

    // Loop through list of devices for the friend
        // Check if there is a device match
        if ([user.last_name characterAtIndex:0] >= (int)'M') {
                     // Friend is an iOS user, include them in the display

            return YES;
        }
    
    // Friend is not an iOS user, do not include them
    return NO;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XBSelectedRow *xbr = [[XBSelectedRow alloc] init];
    [[self navigationController] pushViewController:xbr animated:YES];
    self.navigationController.navigationBar.hidden = 0;
}
@end
