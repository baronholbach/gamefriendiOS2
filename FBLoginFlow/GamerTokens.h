//
//  GamerTokens.h
//  GamerFinder app.
//
//  GamerTokens store a mutable array of GamerToken.
//
//
//  Created by Tracy Liu on 1/5/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamerTokens : NSObject <NSXMLParserDelegate>

// property to track parser delegate
@property (nonatomic, weak) id parentParserDelegate;

// an array of gamer tokens
@property (nonatomic, readonly, strong) NSMutableArray *tokens;

@end
