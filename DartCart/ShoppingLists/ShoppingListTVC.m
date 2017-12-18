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
#import "MasterListTVC.h"

@interface ShoppingListTVC ()
@property (strong) NSMutableArray *list;
@property (strong) NSMutableSet *categories;
@property (strong) NSString *listTitle;

@end

@implementation ShoppingListTVC
@synthesize frc = _frc;



- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    self.title = _relatedList;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSError *error = nil;
    if (![[self frc] performFetch:&error])
    {
        NSLog(@"Error! %@",error);
        abort();
    }
    [self.tableView reloadData];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
        NSLog(@"Category List Count: %lu",[[self.frc sections]count]);
    return [[self.frc sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    id <NSFetchedResultsSectionInfo> secInfo = [[self.frc sections] objectAtIndex:section];
    NSLog(@"Number of Objects %lu",[secInfo numberOfObjects]);
    return [secInfo numberOfObjects];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    // Create custom view to display section header...
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string = [[[self.frc sections]objectAtIndex:section]name];
    if ([string isEqualToString:@""])
    {
        string = @"<No Category>";
        [label setFont:[UIFont boldSystemFontOfSize:10]];
        
    }
    //NSString *string2 =[_items objectAtIndex:section];
    // Section header is in 0th index...
    [label setText:string];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"shoppingListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    ShoppingLists *listItem = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"");
        //NSManagedObjectModel *anItem = [self.list objectAtIndex:indexPath.row];
    cell.textLabel.text = listItem.itemName;
    if (listItem.crossed)
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
    
    if([[segue identifier] isEqualToString:@"addItems"])
    {
     //NSManagedObjectModel *selectedList = [self.lists objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        MasterListTVC *mlTVC = segue.destinationViewController;
        //evc.package = selectedList;
        //mlTVC.packageType = @"ShoppingLists";
        mlTVC.relatedList = _relatedList;
        NSLog(@"From %@ --> %@",_relatedList,mlTVC.relatedList);
    }
}
#pragma mark -
#pragma mark Fetched Results Controller

-(NSFetchedResultsController*)frc
{
    if(_frc !=nil) {return _frc;}
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShoppingLists" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listName == %@", _relatedList];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort1 =
    [[NSSortDescriptor alloc] initWithKey:@"crossed" ascending:YES];
    NSSortDescriptor *sort2 =
    [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
    NSSortDescriptor *sort3 =
    [[NSSortDescriptor alloc] initWithKey:@"itemName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1,sort2,sort3, nil]];
    _frc = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"category" cacheName:nil];
    return _frc;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShoppingLists *listitem = [self.frc objectAtIndexPath:indexPath];
        listitem.crossed = !listitem.crossed;
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }
[self.tableView reloadData];
        
    
    
}

@end
