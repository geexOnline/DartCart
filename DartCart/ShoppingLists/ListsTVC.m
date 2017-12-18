//
//  ListsTVC.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "ListsTVC.h"
#import "maestro.h"
#import "EditViewController.h"
#import "ShoppingListTVC.h"
#import "MasterListTVC.h"
#import "ShoppingListsNames+CoreDataClass.h"
#import "ListsTVCCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ListsTVC ()
@property (strong) NSMutableArray *lists;


@end

@implementation ListsTVC
@synthesize frc = _frc;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [maestro testie];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:116 green:205 blue:203 alpha:1]];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleDoubleLine];
    //[self.tableView setSeparatorStyle: UITableViewCellSeparatorStyle.SingleLine;
}

-(void)viewDidAppear:(BOOL)animated
{
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ShoppingListsNames"];
    self.lists = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    [self.tableView reloadData];
    NSLog(@"viewDidAppear Done: Here's the list: %@",self.lists);
     */
    NSError *error = nil;
    if (![[self frc] performFetch:&error])
    {
        NSLog(@"Error! %@",error);
        abort();
    }

    if([self.frc.fetchedObjects count] <1 ){
    self.title = @"Start by Adding a List";
    }
    else
    {
    self.title = @"DartCart!";
    }
    [self.tableView reloadData];
     
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.frc sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"listsCell";
    ListsTVCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    /*NSManagedObjectModel *aList = [self.lists objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[aList valueForKey:@"listName"]]];
    NSString *rawDate = [aList valueForKey:@"date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    //[dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    //NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    //[dateFormat setTimeZone:zone];
    //NSDate *recordDate = [dateFormat dateFromString:rawDate];
     */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EE LLL d, yyyy - h:mma"];
    ShoppingListsNames *list = [self.frc objectAtIndexPath:indexPath];
    NSManagedObjectContext *moc = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShoppingLists" inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listName == %@ AND crossed == 0",list.listName];
    [fetch setEntity:entity];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSUInteger results = [moc countForFetchRequest:fetch error:&error];
    NSLog(@"Per Store Results: %lu",(unsigned long)results);

    cell.lblListName.text = list.listName;
    cell.lblListDate.text = [dateFormat stringFromDate:list.date];
    if (results > 0)
    {
        cell.lblCount.hidden = NO;
        cell.lblCount.text = [NSString stringWithFormat:@"%lu",results];
        
    }
    else
    {
        cell.lblCount.hidden = YES;
    }
    //[cell.textLabel setText:list.listName];
    //[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",list.date]];
    //[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",rawDate]];
    cell.lblListName.font = [UIFont fontWithName:@"Thonburi" size: 20];
    cell.lblListDate.font = [UIFont fontWithName:@"Avenir Next Condensed" size: 12];
    [cell.lblListDate setTextColor:[UIColor grayColor]];
    cell.lblCount.layer.masksToBounds = YES;
    cell.lblCount.layer.cornerRadius = 10;
    cell.accessoryType = UITableViewCellStyleValue1;

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *deletedList = [[NSString alloc]init];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        ShoppingListsNames *listToDelete = [self.frc objectAtIndexPath:indexPath];
        deletedList = listToDelete.listName;
        [context deleteObject:listToDelete];
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }
    
        if (![[self frc] performFetch:&error])
        {
            NSLog(@"Error! %@",error);
            abort();
        }
        [self.tableView reloadData];
        
    }

//    +(void) cleanUpLists:(NSString *)ListName
        [maestro cleanUpLists:deletedList];
        [self.tableView reloadData];
 
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        self.title = @"Lists";
    if([[segue identifier] isEqualToString:@"addShoppingList"])
    {
        //NSManagedObjectModel *selectedList = [self.lists objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        EditViewController *evc = segue.destinationViewController;
        //evc.package = selectedList;
        evc.packageType = @"List";
        
    }
    if([[segue identifier] isEqualToString:@"useShoppingList"])
    {
        ShoppingListsNames *selectedList = [self.frc objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSLog(@"SelectedList = %@\n\n%@",selectedList,selectedList.listName);
        ShoppingListTVC *slTVC = segue.destinationViewController;
        slTVC.relatedList = selectedList.listName;
        //evc.packageType = @"List";
    }
}

#pragma mark -
#pragma mark Fetched Results Controller

-(NSFetchedResultsController*)frc
{
    if(_frc !=nil) {return _frc;}
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShoppingListsNames" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *sort1Key = @"date";
    NSString *sort2Key = @"listName";
    NSSortDescriptor *sort1 =
    [[NSSortDescriptor alloc] initWithKey:sort1Key ascending:NO];
    NSSortDescriptor *sort2 =
    [[NSSortDescriptor alloc] initWithKey:sort2Key ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1,sort2, nil]];
    _frc = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return _frc;
}

@end
