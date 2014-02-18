//
//  PSViewController.m
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/22/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "PSViewController.h"
#import "FriendProtocols.h"
#import "PSSelectedRow.h"
#import "GamerToken.h"
#import "GamerTokens.h"

@interface PSViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation PSViewController

@synthesize tokenData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setImage:[UIImage imageNamed:@"tab_psn.png"]];
        [tbi setTitle:@"PSN"];
        _curFriendInfo = [[NSMutableArray alloc] init];
        _sortedFriendInfo = [[NSMutableArray alloc] init];
        _finalSortedFriendInfo = [[NSArray alloc] init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    FBRequest* request = [FBRequest requestForMyFriends];
    
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        
        /*for(id<FBGraphUser> user in result[@"data"])
         {
         if ([user.last_name characterAtIndex:0] >= (int)'M') {
         
         NSString *curName = [[NSString alloc] initWithFormat:@"%@, %@, %@", user.last_name, user.name, user.id];
         
         
         [_sortedFriendInfo addObject:curName]; }
         
         
         
         
         }*/
        
        //_sortedFriendInfo  = [self alphaSort:_curFriendInfo];
        
        
        //NSLog(@"%@", _sortedArray);
        // _finalSortedFriendInfo = [self nameSwap:_sortedArray];
        
        
        
        
        
        
        for(id username in _sortedFriendInfo) {
            
        }
    }];

    // request.parameters[@"fields"] =
    // [NSString stringWithFormat:@"%@, installed",request.parameters[@"fields"]];
    
    
    
   // [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        
        
        //_sortedFriendInfo  = [self alphaSort:_curFriendInfo];
        
        
        //NSLog(@"%@", _sortedArray);
         //_finalSortedFriendInfo = [self nameSwap:_sortedArray];
        
        
        
        
        
        
        //for(id username in _sortedFriendInfo) {
            
      //  }
    //}];
    
    
    
    [self setSortOrdering:FBFriendSortByLastName];
    
    self.cancelButton  = nil;
    self.doneButton  = nil;
    self.delegate = self;
    self.tableView.delegate = self;

    
    //[self loadData];
    
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlayStation_Network_2013.png"]];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"psn_bg2.png"]];
    [titleView setFrame:CGRectMake(92, 8, 140, 36)];
    [bgView setFrame:CGRectMake(0, 0, 320, 50)];
    
    [self.view addSubview:bgView];
    [self.view addSubview:titleView];
    
    
    
    [self.tableView setFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-100)];
    [self.tableView setSectionHeaderHeight:0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUserExtraFields>)user
{
    //NSLog(@"%@", _tokenData.tokens[0]);
    
    // Loop through list of devices for the friend
    // if ( [user.id])
    
    
    
    for (GamerToken *token in [self tokenData].tokens) {
        if ([user.id isEqualToString:token.FaceBookID]) {

            if (![token.PlayStationID isEqualToString:@""]){

                
                NSString *curName = [[NSString alloc] initWithFormat:@"%@, %@, %@, %@", user.last_name, user.name, user.id, token.PlayStationID];
                
                
                if(![_sortedFriendInfo containsObject:curName]) {
                [_sortedFriendInfo addObject:curName];
                }
                
                
                return YES;
            }
            
        }
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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    _sortedArray = [[NSArray alloc] initWithArray:[_sortedFriendInfo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    PSSelectedRow *psr = [[PSSelectedRow alloc] init];
        psr.prevCell = cell;
    [[self navigationController] pushViewController:psr animated:YES];
    self.navigationController.navigationBar.hidden = 0;
    int rowTotal = 0;
    for (int i=0; i < indexPath.section; i++) {
        rowTotal += [tableView numberOfRowsInSection:i];
    }
    
    NSString *selectedName = [[NSString alloc] initWithString:_sortedArray[indexPath.row+rowTotal]];
    [psr setMyName:[self nameSwap:selectedName]];
    
    NSArray *splitName = [selectedName componentsSeparatedByString:@","];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100", [splitName[2] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    NSLog(@"%@", splitName[2]);
    [psr setMyProfileImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
    [psr setMyID:splitName[3]];
}

/*
 
 - (NSArray *)alphaSort:(NSArray *)array {
 
 __block NSString *lastWord = nil;
 __block NSString *firstWord = nil;
 __block NSString *reverseName = nil;
 NSMutableArray *reverseArray = [[NSMutableArray alloc] init];
 
 for (int i = 0; i < [array count]; i++) {
 [array[i] enumerateSubstringsInRange:NSMakeRange(0, [array[i] length]) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
 lastWord = substring;
 
 firstWord = [array[i] stringByReplacingOccurrencesOfString:lastWord withString:@""];
 reverseName = [NSString stringWithFormat:@"%@ %@", lastWord, firstWord];
 
 *stop = YES;
 [reverseArray addObject:reverseName];
 
 }];
 
 }
 
 return reverseArray;
 }*/

- (NSString *)nameSwap:(NSString *)array {
    NSArray *lastWord = nil;
    //__block NSString *firstWord = nil;
    // NSMutableArray *reverseArray = [[NSMutableArray alloc] init];
    
    //for (int i = 0; i < [array count]; i++) {
    lastWord = [array componentsSeparatedByString:@","];
    
    NSString *reverseName  = [[NSString alloc] initWithFormat:@"%@", lastWord[1]];
    
    
    
    
    
    /*[array[i] enumerateSubstringsInRange:NSMakeRange(0, [array[i] length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
     firstWord = substring;
     
     lastWord = [array[i] stringByReplacingOccurrencesOfString:firstWord withString:@""];
     reverseName = [NSString stringWithFormat:@"%@%@", lastWord, firstWord];
     
     *stop = YES;
     [reverseArray addObject:reverseName];
     
     }];*/
    
    // }
    
    return reverseName;
    
    
}


@end
