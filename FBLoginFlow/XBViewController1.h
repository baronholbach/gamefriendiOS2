//
//  XBViewController.h
//  FBLoginFlow
//
//  Created by Tompkins, Nathan on 12/22/13.
//  Copyright (c) 2013 Tracy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class GamerTokens;

@interface XBViewController1 : FBFriendPickerViewController <FBFriendPickerDelegate>

@property NSMutableArray *curFriendInfo;
@property NSMutableArray *sortedFriendInfo;
@property NSArray *finalSortedFriendInfo;
@property NSArray *sortedArray;
@property GamerTokens *tokenData;


//- (NSArray *) alphaSort:(NSArray *)array;
- (NSString *) nameSwap:(NSString *)array;

@end
