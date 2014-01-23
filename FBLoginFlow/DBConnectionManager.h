//
//  DBConnectionManager.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 1/4/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBConnectionManager : NSObject

@property NSString *curUserId;

- (void)sendData:(id)data toField:(id)field;
- (id) pullDataFromField:(id)field;

@end
