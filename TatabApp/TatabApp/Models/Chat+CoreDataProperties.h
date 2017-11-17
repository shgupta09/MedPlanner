//
//  Chat+CoreDataProperties.h
//  
//
//  Created by NetprophetsMAC on 11/17/17.
//
//

#import "Chat+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Chat (CoreDataProperties)

+ (NSFetchRequest<Chat *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *isReceive;
@property (nullable, nonatomic, copy) NSString *senderId;

@end

NS_ASSUME_NONNULL_END
