//
//  Chat+CoreDataProperties.m
//  
//
//  Created by shubham gupta on 11/18/17.
//
//

#import "Chat+CoreDataProperties.h"

@implementation Chat (CoreDataProperties)

+ (NSFetchRequest<Chat *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
}

@dynamic message;
@dynamic senderId;
@dynamic isReceive;
@dynamic date;

@end
