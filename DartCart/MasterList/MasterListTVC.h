//
//  MasterListTVC.h
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MasterListTVC : UITableViewController
{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}
@property(nonatomic, strong) NSFetchedResultsController *frc;

@end
