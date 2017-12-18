//
//  ShoppingLists+CoreDataProperties.h
//  
//
//  Created by PAUL CHRISTIAN on 12/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "ShoppingLists+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShoppingLists (CoreDataProperties)

+ (NSFetchRequest<ShoppingLists *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *category;
@property (nonatomic) BOOL crossed;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nullable, nonatomic, copy) NSString *listName;

@end

NS_ASSUME_NONNULL_END
