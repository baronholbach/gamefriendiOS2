//
//  GamerTokens.m
//  GamerFinder app.
//
//  Created by Tracy Liu on 1/5/14.
//  Copyright (c) 2014 Tracy Liu. All rights reserved.
//

#import "GamerTokens.h"
#import "GamerToken.h"

@implementation GamerTokens

@synthesize tokens, parentParserDelegate;

-(id) init
{
    self = [super init];
    if( self)
    {
        //initialize gamer token array
        tokens = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//////////////////////////////////////////
// NSXMLParserDelegate method overrides
//////////////////////////////////////////
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"gamertoken"])
    {
        GamerToken *token = [[GamerToken alloc] init];
        
        [token setParentParserDelegate:self];
        
        [parser setDelegate:token];
        
        [tokens addObject:token];
    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if([elementName isEqual:@"gamertokens"])
        [parser setDelegate:parentParserDelegate];
}
@end
