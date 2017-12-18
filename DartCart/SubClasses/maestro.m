//
//  maestro.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "maestro.h"
#import "Categories+CoreDataClass.h"
#import "ShoppingLists+CoreDataClass.h"


@implementation maestro

NSString *EntityShoppingListNames = @"ShoppingListNames";
NSString *EntityCategories = @"Categories";
NSString *EntityShoppingList = @"ShoppingList";
NSString *EntityProducts = @"Products";

+(void)testie
{
    NSLog(@"Your Testie is working!");
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

+(void) writeOut:(NSString *)entity index:(NSString *)index value:(NSString *)value
{
    
    
    
}

+(void) cleanUp
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Categories"];
    NSPredicate *p =[NSPredicate predicateWithFormat:@"category == nil"];
    [fetchRequest setPredicate:p];
    Categories *categoryList = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSLog(@"Categories Fetched: %@",categoryList);
    int i=0;
    for (NSManagedObject *nullCats in categoryList)
    {
        [context deleteObject:nullCats];
        i++;
        NSLog(@"%i NullCat Deleted!",i);
        
    }
    
}
+(void) cleanUpLists:(NSString *)ListName
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ShoppingLists"];
    NSPredicate *p =[NSPredicate predicateWithFormat:@"listName == %@",ListName];
    [fetchRequest setPredicate:p];
    ShoppingLists *list = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSLog(@"List Fetched: %@ for ListName: %@",list,ListName);
    int i=0;
    for (NSManagedObject *deletedList in list)
    {
        [context deleteObject:deletedList];
        i++;
        NSLog(@"%i Items Deleted!",i);
        
    }
    
}
+(void) cleanUpMasterLists:(NSString *)itemName
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ShoppingLists"];
    NSPredicate *p =[NSPredicate predicateWithFormat:@"itemName == %@",itemName];
    [fetchRequest setPredicate:p];
    ShoppingLists *list = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSLog(@"List Fetched: %@ for ListName: %@",list,itemName);
    int i=0;
    for (NSManagedObject *deletedList in list)
    {
        [context deleteObject:deletedList];
        i++;
        NSLog(@"%i Items Deleted!",i);
        
    }
    
}
@end
