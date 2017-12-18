//
//  ShoppingListsNames+CoreDataProperties.m
//  
//
//  Created by PAUL CHRISTIAN on 12/18/17.
//
//  This file was automatically generated and should not be edited.
//

#import "ShoppingListsNames+CoreDataProperties.h"

@implementation ShoppingListsNames (CoreDataProperties)

+ (NSFetchRequest<ShoppingListsNames *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ShoppingListsNames"];
}

@dynamic date;
@dynamic listName;

@end
