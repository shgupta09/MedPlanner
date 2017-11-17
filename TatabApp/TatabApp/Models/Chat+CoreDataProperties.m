//
//  Chat+CoreDataProperties.m
//  
//
//  Created by NetprophetsMAC on 11/17/17.
//
//

#import "Chat+CoreDataProperties.h"

@implementation Chat (CoreDataProperties)

+ (NSFetchRequest<Chat *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
}

@dynamic message;
@dynamic isReceive;
@dynamic senderId;

@end
