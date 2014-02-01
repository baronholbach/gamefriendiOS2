//
//  ViewController.m
//  FBLoginFlow
//
//  Created by Tracy Liu on 10/20/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "ViewController1.h"


#import "XBViewController1.h"
#import "PSViewController.h"
#import "settingsViewController.h"
#import "GamerTokens.h"
#import "GamerToken.h"

@interface ViewController1 () 
@end

@implementation ViewController1


int i = 0;
int currentSeq = 0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cachedUser = FALSE;
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            [self.view addSubview:_navBar];
    _navBar.hidden = 1;
    _navItem = [[UINavigationItem alloc] initWithTitle:@""];
    [_navBar pushNavigationItem:_navItem animated:YES];
    [_navBar setBackgroundColor:[UIColor orangeColor]];

    
	// Do any additional setup after loading the view, typically from a nib.
    
    FBLoginView* loginView = [[FBLoginView alloc]init];
    loginView.readPermissions = @[@"basic_info"];
    loginView.delegate = self;
    loginView.center = CGPointMake(160,330);
 
    self.networkOptions  = [[NSArray alloc] initWithObjects:@"Xbox Live",@"PlayStation Network",@"Both", nil];
    
    // initialize view controllers
    xvc =[[XBViewController1 alloc] init];
    pvc = [[PSViewController alloc]  init];
    svc =[[settingsViewController alloc] init];
    
}


-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    }


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self.view addSubview:loginView];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    if (cachedUser == FALSE) {
        cachedUser = TRUE;
       self.myFBID = [NSString stringWithFormat:@"%@", [user id]];
    [svc setFbid:[user id]];
    NSLog(@"user info fetched!");
    
    
    self.networkPicker.hidden = 0;
    
    loginView.center = CGPointMake(150,450);
    
    FBRequest* request = [FBRequest requestForMyFriends];
    searchIDs =  [[NSMutableString alloc] init];
    NSUserDefaults *setting = [[NSUserDefaults alloc] init];
    
    // Set up string of friends to send to search against database
    
    [searchIDs appendString:@"name="];
    searchArray = [[NSMutableArray alloc] init];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        for(id<FBGraphUser> user in result[@"data"])
        {
            
            [searchArray addObject:user.id];
            [searchIDs appendFormat:@"\"%@\"", user.id];
            [searchIDs appendString:@","];
            
        }
        
        if ([searchIDs length] > 0) {
            
            [searchIDs deleteCharactersInRange:NSMakeRange([searchIDs length] - 1, 1)];
        }
        
        // Send request to database
        
        if (self) {
            [self fetchGamerTokens];
        }
        
    }
     
     ];
    
    // Only check database for my current info if I am on a fresh install.  Otherwise this info is stored in NSUser defaults
    
   if ( ![setting objectForKey:@"intro"]) {
        
        NSURL *url2 = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/getUserDetails.php"];
        
        NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
        NSURLResponse *response = nil;
        NSError *error = nil;
        [req2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [req2 setHTTPMethod:@"POST"];
        
        [req2 setHTTPBody:[NSData dataWithBytes:[[NSString stringWithFormat:@"name=%@", _myFBID] UTF8String] length:strlen([[NSString stringWithFormat:@"name=%@", _myFBID] UTF8String])]];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:req2 returningResponse:&response error:&error];
        NSString *curString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        
        if ( [curString length] > 2 ) {
            
            //construct a URL
            
            NSArray *curArray = [curString componentsSeparatedByString:@","];
            
            NSString *curPSID = [curArray[1] substringFromIndex:16];
            NSString *curXBID =  [curArray[0] substringFromIndex:16];
            
            
            [setting setObject:@"1" forKey:@"intro"];
            [setting synchronize];
            
            
            if (![curXBID isEqualToString:@""]) {
                [setting setObject:curXBID forKey:@"xbEntry"];
                if (![curPSID isEqualToString:@""]) {
                    [setting setObject:curPSID forKey:@"psEntry"];
                    [setting setInteger:3 forKey:@"networks"];
                    
                }
                
                else {
                    [setting setInteger:0 forKey:@"networks"];
                    
                }
            }
            
            else {
                [setting setObject:curPSID forKey:@"psEntry"];
                [setting setInteger:1 forKey:@"networks"];
                
                
            }
            
            
        }
        
   
        
        
}
        
        if (! [setting objectForKey:@"intro"]) {   //Before you have gone through intro, show intro flow, starting with friend picker
            loginView.hidden = 1;
            _uiLabel.hidden = 0;
        }
        
        
        // Use the setting for "networks" to determine which views to load in the tab bar controller.
        
        else {
            
            NSLog(@"%d", [setting integerForKey:@"networks"]);
            
            UITabBarController *tbc = [[UITabBarController alloc] init];
            
            
            switch ([setting integerForKey:@"networks"]) {
                    
                case 0:  //Xbox ONLY
                {
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
                    nav.navigationBar.hidden = YES;
                    NSArray *viewControllers = [[NSArray alloc] initWithObjects:xvc, svc, nil];
                    [tbc setViewControllers:viewControllers animated:NO];
                    [self presentViewController:nav animated:NO completion:NULL];
                    
                }
                    break;
                    
                case 1:  //PS ONLY
                {
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
                    nav.navigationBar.hidden = YES;
                    NSArray *viewControllers = [[NSArray alloc] initWithObjects:pvc, svc, nil];
                    [tbc setViewControllers:viewControllers animated:NO];
                    [self presentViewController:nav animated:NO completion:NULL];
                    
                    
                }
                    break;
                    
                case 3:  //BOTH Networks
                {
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
                    nav.navigationBar.hidden = YES;
                    NSArray *viewControllers = [[NSArray alloc] initWithObjects:xvc, pvc, svc, nil];
                    [tbc setViewControllers:viewControllers animated:NO];
                    [self presentViewController:nav animated:NO completion:NULL];
                    
                    break;
                }
            }
        }

   
   }
    
    
    
}


- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    FBFriendPickerViewController *fpc = (FBFriendPickerViewController *)sender;
    
    for(id<FBGraphUser> user in fpc.selection)
    {
        NSLog(@"Friend selected: %@", user.name);
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBasicShare:(id)sender {
    
    [FBNativeDialogs presentShareDialogModallyFrom:self initialText:@"FB Log Flow" image:nil url:nil handler:^(FBNativeDialogResult result, NSError *error) {
        if (error)
            NSLog(@"Error!");
            }];
}

- (IBAction)clickFriends:(id)sender {
    
    FBFriendPickerViewController* vc = [[FBFriendPickerViewController alloc]init];
    
    vc.title = @"Your facebook friends";
    
    vc.delegate = self;
    
    vc.fieldsForRequest = [NSSet setWithObjects:@"devices", nil];
    
    [vc loadData];
    [vc presentModallyFromViewController:self animated:YES handler:^(FBViewController *sender, BOOL donePressed) {
        if(donePressed)
        {
            NSLog(@"Success!");
        }
    }];
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.networkOptions objectAtIndex:row];
}
    
    
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {  //User selecting their game networks during intro
    
    
    switch (row) {
        case 0:
        {
            [self xboxPicked];
            currentSeq = 0;
        }
        break;
    
    
        case 1:
        {
            
            [self psPicked];
            currentSeq = 1;
    }
    
            break;
        
        case 2:
            
        [self xboxPicked];
        currentSeq = 2;
        
            
            break;
        
        
    
    }
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (currentSeq == 2)
        _nextButton.hidden = NO;
    
    
    else {
    
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(confirmPressed:)];
    [_navItem setRightBarButtonItem:doneButton];
    }
    
    if (currentSeq == 1 || currentSeq  == 3) {
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setObject:_psEntry.text forKey:@"psEntry"];
        
    }
    
    else {
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setObject:_xbEntry.text forKey:@"xbEntry"];
        
        
    }
    [textField resignFirstResponder];


        return YES;
}


-(IBAction)confirmPressed:(id)sender  {  //Entered your game network username, intro sequence
    NSUserDefaults *setting = [[NSUserDefaults alloc] init];
    
    //////COMMENTED OUT FOR DEV PURPOSES.
    [setting setObject:@"1" forKey:@"intro"];

    
    
    //construct a URL
    NSURL *url2 = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/submitUserDetails.php"];
    
    //Put the URL into an USURLRequest
    NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
    
    [req2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [req2 setHTTPMethod:@"POST"];

    
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    //settingsViewController *svc =[[settingsViewController alloc] init];
    
    [req2 setHTTPBody:[NSData dataWithBytes:[[NSString stringWithFormat:@"xbid=%@&psid=%@&fbid=%@", [setting objectForKey:@"xbEntry"],[setting objectForKey:@"psEntry"], _myFBID] UTF8String] length:strlen([[NSString stringWithFormat:@"xbid=%@&psid=%@&fbid=%@", [setting objectForKey:@"xbEntry"], [setting objectForKey:@"psEntry"], _myFBID] UTF8String])]];
    
    
    //Create a connection
    connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:self startImmediately:YES];

    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    if (currentSeq == 3) {
        
        //TODO: set user defaults and send usernames to database
        
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setInteger:3 forKey:@"networks"];
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:xvc, pvc, svc, nil];
        [tbc setViewControllers:viewControllers animated:NO];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:NULL];
       
    }
    
    else if (currentSeq == 1)
    {
        
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setInteger:1 forKey:@"networks"];
        _xbEntry.text = @"";
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:pvc, svc, nil];
        [tbc setViewControllers:viewControllers animated:NO];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
        nav.navigationBar.hidden = YES;
        [self presentViewController:nav animated:YES completion:NULL];

        
        
    }
    
    else    //Xbox only
    {
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setInteger:0 forKey:@"networks"];
        _psEntry.text = @"";
        
        
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:xvc, svc, nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbc];
        nav.navigationBar.hidden = YES;
        [tbc setViewControllers:viewControllers animated:NO];
        
         [self presentViewController:nav animated:NO completion:NULL];

    
    }
    

    
}

-(IBAction)nextPressed:(id)sender  {

    
    //self.uiLabel.hidden = 1;

    
        [self psPicked];
        _nextButton.hidden = YES;
    currentSeq = 3;
}



-(void)xboxPicked {
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
    _networkPicker.frame = CGRectOffset(_networkPicker.frame, -480, 0);
    _xbEntry.frame = CGRectOffset(_xbEntry.frame, -515, 0);
    _xbLabel.frame = CGRectOffset(_xbLabel.frame, -485, 0);
    _uiLabel.frame = CGRectOffset(_uiLabel.frame, -485, 0);
        
        

    }];
    

    self.navBar.hidden = 0;

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(xboxBack)];
    [_navItem setLeftBarButtonItem:backButton];
    
}


-(void)xboxBack{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _networkPicker.frame = CGRectOffset(_networkPicker.frame, 480, 0);
        _xbEntry.frame = CGRectOffset(_xbEntry.frame, 515, 0);
        _xbLabel.frame = CGRectOffset(_xbLabel.frame, 485, 0);
        _uiLabel.frame = CGRectOffset(_uiLabel.frame, 485, 0);
        
        
    }];

    [_xbEntry resignFirstResponder];
    self.navBar.hidden = 1;
    
}



-(void)psPicked {
    self.uiLabel.hidden = 1;
    
    if (currentSeq != 2) {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.networkPicker.frame = CGRectOffset(self.networkPicker.frame, -480, 0);
        _psEntry.frame = CGRectOffset(_psEntry.frame, -520, 0);
        _psLabel.frame = CGRectOffset(_psLabel.frame, -470, 0);
        
        self.navBar.hidden = 0;
        
    
    }];
        
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(psBack)];
    [_navItem setLeftBarButtonItem:backButton];
        
    }
    
    else {
        [UIView animateWithDuration:0.5 animations:^{
            _psEntry.frame = CGRectOffset(_psEntry.frame, -520, 0);
            _psLabel.frame = CGRectOffset(_psLabel.frame, -468, 0);
            _xbLabel.frame = CGRectOffset(_xbLabel.frame, -485, 0);
            _xbEntry.frame = CGRectOffset(_xbEntry.frame, -485, 0);
        }];
    }
}


- (void)psBack {
    [UIView animateWithDuration:0.5 animations:^{
        
        _networkPicker.frame = CGRectOffset(_networkPicker.frame, 480, 0);
        _psEntry.frame = CGRectOffset(_psEntry.frame, 515, 0);
        _psLabel.frame = CGRectOffset(_psLabel.frame, 485, 0);
        _uiLabel.frame = CGRectOffset(_uiLabel.frame, 485, 0);
        
        
    }];
    
    [_psEntry resignFirstResponder];
    self.navBar.hidden = 1;
    
}

/////////////////////////////////////
// Web service methods
////////////////////////////////////

// function to get gamer tokens from web service
- (void)fetchGamerTokens
{
    
    // initialize holder for data coming back from server
    xmlData = [[NSMutableData alloc] init];
    
    
    //construct an URL
    NSURL *url = [NSURL URLWithString:@"http://www.apsgames.com/gamefinder/getUserList.php"];
    
    //Put the URL into an USURLRequest
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[NSData dataWithBytes:[searchIDs UTF8String] length:strlen([searchIDs UTF8String])]];
    
    //Create a connection
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}


-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    
        [xmlData appendData:data];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

// function called when finishing receiving data from web service
-(void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // For testing only: log xml data received from web service
    // NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    // NSLog(@"xmlCheck = %@", xmlCheck);
    
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];

    [parser parse];
    
    xmlData = nil;
    
    connection = nil;
    
    
    // set token data on view controller
    // TO DO: Need to do similar work for playstation view controller
    [xvc setTokenData:tokenData];
    [pvc setTokenData:tokenData];

    [xvc loadData];
    [pvc loadData];
}

// function called when fail to web service
-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    connection = nil;
    xmlData = nil;
    
    // show alert view
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

/////////////////////////////////////////////////
// NSXMLParserDelegate method overrides
/////////////////////////////////////////////////
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"gamertokens"])
    {
        tokenData = [[GamerTokens alloc] init];
        
        [tokenData setParentParserDelegate:self];  // Give channel object a pointer back to ListViewController(self) for later
        
        [parser setDelegate:tokenData];
    }


}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 16) ? NO : YES;
}

@end
