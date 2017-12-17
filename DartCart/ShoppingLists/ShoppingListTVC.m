//
//  ShoppingListTVC.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "ShoppingListTVC.h"
#import "EditViewController.h"
#import "maestro.h"
#import "ShoppingLists+CoreDataClass.h"

@interface ShoppingListTVC ()
@property (strong) NSMutableArray *list;
@property (strong) NSMutableSet *categories;
@property (strong) NSString *listTitle;

@end

@implementation ShoppingListTVC



- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"incoming package: %@",_package);
    NSLog(@"List Name: %@",[_package valueForKey:@"listName"]);
    _listTitle = [_package valueForKey:@"listName"];
    self.title = _listTitle;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ShoppingLists"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"listName == %@",_listTitle]];
    self.list = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    self.categories = [self.list valueForKey:@"category"];
    [self.tableView reloadData];
    NSLog(@"viewDidAppear Done: Here's the list: %@",self.list);
    NSLog(@"viewDidAppear Done: Here's the categories: %@",self.categories);

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return [self.categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 10;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"shoppingListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSManagedObjectModel *anItem = [self.list objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[anItem valueForKey:@"itemName"]]];
    if (![anItem valueForKey:@"crossed"])
    {
        NSLog(@"Crossed is Nil for this item: %@",anItem);
    }
    
    else if ([anItem valueForKey:@"crossed"]==0)
    {
        [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:16.5]];
        [[cell textLabel] setTextColor:[UIColor grayColor]];
    }
    else
    {
        [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.5]];
        [[cell textLabel] setTextColor:[UIColor blueColor]];
    }
    
    return cell;
}







// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [context deleteObject:[self.list objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }
        [self.list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"addItem"])
    {
     //NSManagedObjectModel *selectedList = [self.lists objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        EditViewController *evc = segue.destinationViewController;
        //evc.package = selectedList;
        evc.packageType = @"ShoppingLists";
        evc.relatedList = self.listTitle;
    }
}
@end
