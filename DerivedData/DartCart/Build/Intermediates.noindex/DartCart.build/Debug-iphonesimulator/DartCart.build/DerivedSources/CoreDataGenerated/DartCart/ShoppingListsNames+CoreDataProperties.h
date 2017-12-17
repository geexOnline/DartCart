//
//  ShoppingListsNames+CoreDataProperties.h
//  
//
//  Created by PAUL CHRISTIAN on 12/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "ShoppingListsNames+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShoppingListsNames (CoreDataProperties)

+ (NSFetchRequest<ShoppingListsNames *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *listName;

@end

NS_ASSUME_NONNULL_END
