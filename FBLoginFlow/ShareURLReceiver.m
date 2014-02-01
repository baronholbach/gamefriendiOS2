//
//  ShareURLReceiver.m
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 2/1/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import "ShareURLReceiver.h"

@implementation ShareURLReceiver


-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    
    NSString *url = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    _myURL = url;
    
}

@end
