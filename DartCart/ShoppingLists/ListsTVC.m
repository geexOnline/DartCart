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

@interface ListsTVC ()
@property (strong) NSMutableArray *lists;

@end

@implementation ListsTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [maestro testie];
    //[maestro defaultCategoryCheck];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ShoppingListsNames"];
    self.lists = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    [self.tableView reloadData];
    NSLog(@"viewDidAppear Done: Here's the list: %@",self.lists);
    if(_lists.count <1 ){
    self.title = @"Start by Adding a List";
    }
    else
    {
    self.title = @"DartCart!";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return [self.lists count];}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"listsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSManagedObjectModel *aList = [self.lists objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[aList valueForKey:@"listName"]]];
    NSString *rawDate = [aList valueForKey:@"date"];
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    //[dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
    //NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    //[dateFormat setTimeZone:zone];
    //NSDate *recordDate = [dateFormat dateFromString:rawDate];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",rawDate]];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size: 8];

    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [context deleteObject:[self.lists objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }
        [self.lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
        NSManagedObjectModel *selectedList = [self.lists objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        EditViewController *evc = segue.destinationViewController;
        evc.package = selectedList;
        //evc.packageType = @"List";
    }
}

@end
