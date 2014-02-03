//
//  ShareURLReceiver.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 2/1/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareURLReceiver : NSObject <NSURLConnectionDelegate>

@property NSString *myURL;

-(NSString *) returnURL;

@end
