//
//  QueueDetails.m
//  TatabApp
//
//  Created by shubham gupta on 2/10/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "QueueDetails.h"

@implementation QueueDetails
static QueueDetails* _sharedInstance = nil;

+(QueueDetails*) sharedInstance
{
    @synchronized([QueueDetails class])
    {
        if (!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

-(NSMutableArray*) myDataArray
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    return theArray;
}
@end
