//
//  Products+CoreDataProperties.m
//  
//
//  Created by PAUL CHRISTIAN on 12/18/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Products+CoreDataProperties.h"

@implementation Products (CoreDataProperties)

+ (NSFetchRequest<Products *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Products"];
}

@dynamic category;
@dynamic itemName;

@end
