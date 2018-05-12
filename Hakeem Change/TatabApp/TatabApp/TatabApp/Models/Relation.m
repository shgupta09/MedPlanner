//
//  Relation.m
//  TatabApp
//
//  Created by shubham gupta on 1/27/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "Relation.h"

@implementation Relation
static Relation* _sharedInstance = nil;

+(Relation*) sharedInstance
{
    @synchronized([Relation class])
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
