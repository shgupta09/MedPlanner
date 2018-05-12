//
//  Chat+CoreDataProperties.h
//  
//
//  Created by shubham gupta on 11/18/17.
//
//

#import "Chat+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Chat (CoreDataProperties)

+ (NSFetchRequest<Chat *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *senderId;
@property (nullable, nonatomic, copy) NSString *isReceive;
@property (nullable, nonatomic, copy) NSString *delivered;
@property (nullable, nonatomic, copy) NSString *recieverId;
@property (nullable, nonatomic, copy) NSDate *date;
@end

NS_ASSUME_NONNULL_END
