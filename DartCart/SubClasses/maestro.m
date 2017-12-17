//
//  maestro.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "maestro.h"
#import "Categories+CoreDataClass.h"


@implementation maestro

NSString *EntityShoppingListNames = @"ShoppingListNames";
NSString *EntityCategories = @"Categories";
NSString *EntityShoppingList = @"ShoppingList";
NSString *EntityProducts = @"Products";

+(void)testie
{
    NSLog(@"Your Testie is working!");
    
}

+(void) writeOut:(NSString *)entity index:(NSString *)index value:(NSString *)value
{
    
    
    
}

+(NSDate *)getLocalDateTime
{
    NSDate* appleDumbDate = [NSDate date];
    NSLog(@"appleDumbDate = %@",appleDumbDate);
    NSString *dateString = [NSString stringWithFormat:@"%@",appleDumbDate];
    NSLog(@"dateString = %@",dateString);
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *returnDate = [dateFormatter dateFromString:dateString];
    NSLog(@"ReturnDate = %@",returnDate);
    NSLog(@"TimeZones = %@",[NSTimeZone knownTimeZoneNames]);
    return returnDate;
    
}

/*
 +(NSMutableArray *)getCategories
{
     //AppDelegate *categoriesAppDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //NSManagedObjectContext *categoriesContext = categoriesAppDelegate.persistentContainer.viewContext;
    NSFetchRequest *categoryFetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Categories"];
    NSMutableArray *categoryList = [[categoriesContext executeFetchRequest:categoryFetchRequest error:nil]mutableCopy];
    NSLog(@"getCategories Done: Here's the list: %@",categoryList);
    Categories *cats = [[Categories alloc]initWithContext:categoriesContext];
    if ([categoryList count] > 0)
    {
        NSLog(@"We got cats! :%lu",(unsigned long)[categoryList count]);
        
    }
    else
    {
        NSLog(@"No Cats... Need to add default: Uncategorized");
        [cats setValue:@"Uncategorized" forKey:@"category"];
        
        NSLog(@"Infor added to addtoEntity: %@, context: %@",cats,categoriesContext);
        
        
        NSError *error = nil;
        //[context save:&error];
        if (![categoriesContext save:&error])
        {
            NSLog(@"There was an error: %@ %@", error, [error localizedDescription]);
            
        }
        
    }
    
    return categoryList;
 
    
}
 */

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

@end
