//
//  GamerToken.m
//  GamerFinder app
//
//  Created by Tracy Liu on 1/5/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import "GamerToken.h"

@implementation GamerToken
@synthesize FaceBookID, XBoxID, PlayStationID, FavGame, parentParserDelegate;

//////////////////////////////////////////
// NSXMLParserDelegate method overrides
//////////////////////////////////////////
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"FBID"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setFaceBookID:currentString];
    }
    else if ([elementName isEqual:@"XBID"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setXBoxID:currentString];
        NSLog(@"%@", self.XBoxID);
        
        

    }
    else if ([elementName isEqual:@"PSID"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setPlayStationID:currentString];
        NSLog(@"%@", self.PlayStationID);
    }
    
    else if ([elementName isEqual:@"FAVGAME"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setFavGame:currentString];
    }

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [currentString appendString:str];

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    currentString = nil;
    
    if ([elementName isEqual:@"gamertoken"])
        [parser setDelegate:parentParserDelegate];
}
@end

