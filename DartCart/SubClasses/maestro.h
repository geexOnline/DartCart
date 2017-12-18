//
//  maestro.h
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface maestro : NSObject
//@property (strong, nonatomic) AppDelegate *appDelegate;
//@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, atomic) NSString *EntityShoppingListNames;
@property (strong, atomic) NSString *EntityCategories;
@property (strong, atomic) NSString *EntityShoppingList;
@property (strong, atomic) NSString *EntityProducts;



+(void) testie;
+(void) writeOut:(NSString *)entity index:(NSString *)index value:(NSString *)value;
+(NSDate *)getLocalDateTime;
+(NSMutableArray *)getCategories;
+(void) defaultCategoryCheck;
+(void) cleanUp;
+(void) cleanUpLists:(NSString *)ListName;
+(void) cleanUpMasterLists:(NSString *)itemName;
@end
