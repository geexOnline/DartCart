//
//  Products+CoreDataProperties.h
//  
//
//  Created by PAUL CHRISTIAN on 12/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Products+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Products (CoreDataProperties)

+ (NSFetchRequest<Products *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *itemName;

@end

NS_ASSUME_NONNULL_END
