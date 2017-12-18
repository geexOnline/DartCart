//
//  Categories+CoreDataProperties.m
//  
//
//  Created by PAUL CHRISTIAN on 12/18/17.
//
//  This file was automatically generated and should not be edited.
//

#import "Categories+CoreDataProperties.h"

@implementation Categories (CoreDataProperties)

+ (NSFetchRequest<Categories *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Categories"];
}

@dynamic category;

@end
