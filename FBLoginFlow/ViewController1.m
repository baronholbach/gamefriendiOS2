//
//  ViewController.m
//  FBLoginFlow
//
//  Created by Tracy Liu on 10/20/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import "ViewController1.h"
#import "FriendProtocols.h"
#import <FacebookSDK/FacebookSDK.h>
#import "XBViewController1.h"
#import "PSViewController.h"
#import "settingsViewController.h"
#import "GamerTokens.h"

@interface ViewController1 () <FBLoginViewDelegate, UITextFieldDelegate>
@end

@implementation ViewController1


int i = 0;
int currentSeq = 0;


- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    //fetch gamer tokens from web service
    if (self) {
            [self fetchGamerTokens];
    }
    
    
    NSUserDefaults *setting = [[NSUserDefaults alloc] init];
    
    
    if (![setting objectForKey:@"intro"]) {   //Before you have gone through intro
    loginView.hidden = 1;
    _uiLabel.hidden = 0;
    }
    
    else {
        
        
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        int network = [setting integerForKey:@"networks"];

        NSLog(@"%d", network);
        
        
        
        
        UITabBarController *tbc = [[UITabBarController alloc] init];
        
        
        switch (network) {
            
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
                NSArray *viewControllers = [[NSArray alloc] initWithObjects:pvc, svc, nil];
                [tbc setViewControllers:viewControllers animated:NO];
                [self presentViewController:tbc animated:NO completion:NULL];


            }
            break;
                
            case 3:  //BOTH Networks
            {
                NSArray *viewControllers = [[NSArray alloc] initWithObjects:xvc, pvc, svc, nil];
                [tbc setViewControllers:viewControllers animated:NO];
                [self presentViewController:tbc animated:NO completion:NULL];

                break;
            }
            
            
        }
                 
        
        
    }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self.view addSubview:loginView];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    
   // self.uiLabel.text = [NSString stringWithFormat:@"Hi, %@", [user first_name]];
    
    //NSString *greetingText = @"Greetings";
    //self.uiLabel.text = [NSString stringWithFormat:@"Hi, %@ %@ ", greetingText, [user first_name]];
   
    
    
    self.networkPicker.hidden = 0;
    
    loginView.center = CGPointMake(150,450);
    
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
            [self xboxPicked];
            currentSeq = 0;
            
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
    else
        _confirmButton.hidden = NO;
    
    
    if (currentSeq == 1 || currentSeq  == 3) {
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setObject:_psEntry.text forKey:@"psEntry"];
        
    }
    
    else {
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setObject:_xbEntry.text forKey:@"xbEntry"];
        
        
    }
    _networkPicker.hidden = YES;
    [textField resignFirstResponder];


        return YES;
}


-(IBAction)confirmPressed:(id)sender  {  //Entered your game network username, intro sequence
    NSUserDefaults *setting = [[NSUserDefaults alloc] init];
    [setting setObject:@"1" forKey:@"intro"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    XBViewController1 *xvc =[[XBViewController1 alloc] init];
    PSViewController *pvc = [[PSViewController alloc]  init];
    settingsViewController *svc =[[settingsViewController alloc] init];
    

    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    if (currentSeq == 3) {
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:xvc, pvc, svc, nil];
        [tbc setViewControllers:viewControllers animated:NO];
        [self presentViewController:tbc animated:YES completion:NULL];
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setInteger:3 forKey:@"networks"];
    }
    
    else if (currentSeq == 1)
    {
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:pvc, svc, nil];
        [tbc setViewControllers:viewControllers animated:NO];
        [self presentViewController:tbc animated:YES completion:NULL];
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setInteger:1 forKey:@"networks"];
    }
    
    else if (currentSeq == 0)
    {
        NSUserDefaults *setting = [[NSUserDefaults alloc] init];
        [setting setInteger:0 forKey:@"networks"];

        
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

    }];
    self.uiLabel.hidden = 1;

}

-(void)psPicked {
    self.uiLabel.hidden = 1;
    
    if (currentSeq != 2) {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.networkPicker.frame = CGRectOffset(self.networkPicker.frame, -480, 0);
        _psEntry.frame = CGRectOffset(_psEntry.frame, -520, 0);
        _psLabel.frame = CGRectOffset(_psLabel.frame, -468, 0);
    }];
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


/////////////////////////////////////
// Web service methods
////////////////////////////////////

// function to get gamer tokens from web service
- (void)fetchGamerTokens
{
    // initialize holder for data coming back from server
    xmlData = [[NSMutableData alloc] init];
    
    //construct an URL
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/GameFinder/getUserList.php"];
    
    //Put the URL into an USURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL: url];
    
    //Create a connection
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}


-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
    
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
    xvc.tokenData = tokenData;
    
    [xvc loadData];
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

@end
