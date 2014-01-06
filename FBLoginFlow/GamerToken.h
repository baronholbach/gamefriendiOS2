//
//  GamerToken.h
//  GamerFinder app
//
//  Each gamer token represents one gamer with his/her FacebookID, XBoxID and PlayStationID.
//
//  Created by Tracy Liu on 1/5/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamerToken : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentString;
}
@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSString *FaceBookID;
@property (nonatomic, strong) NSString *XBoxID;
@property (nonatomic, strong) NSString *PlayStationID;

@end
