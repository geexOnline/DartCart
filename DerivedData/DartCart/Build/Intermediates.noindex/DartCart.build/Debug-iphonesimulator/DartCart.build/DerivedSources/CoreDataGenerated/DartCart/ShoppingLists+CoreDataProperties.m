//
//  ShoppingLists+CoreDataProperties.m
//  
//
//  Created by PAUL CHRISTIAN on 12/17/17.
//
//  This file was automatically generated and should not be edited.
//

#import "ShoppingLists+CoreDataProperties.h"

@implementation ShoppingLists (CoreDataProperties)

+ (NSFetchRequest<ShoppingLists *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ShoppingLists"];
}

@dynamic category;
@dynamic crossed;
@dynamic itemName;
@dynamic listName;

@end
