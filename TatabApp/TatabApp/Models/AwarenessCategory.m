//
//  AwarenessCategory.m
//  TatabApp
//
//  Created by Shagun Verma on 02/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "AwarenessCategory.h"

@implementation AwarenessCategory
static AwarenessCategory* _sharedInstance = nil;

+(AwarenessCategory*) sharedInstance
{
    @synchronized([AwarenessCategory class])
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
