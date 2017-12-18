//
//  MasterListTVC.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "MasterListTVC.h"
#import "maestro.h"
#import "EditViewController.h"
#import "Products+CoreDataClass.h"
#import "ShoppingLists+CoreDataClass.h"


@interface MasterListTVC ()
@property (strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *categoryList;

@end

@implementation MasterListTVC
@synthesize frc = _frc;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Item Master List";
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    NSLog(@"Incoming List: %@",_relatedList);


    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    //Re-Fetch Context
    NSError *error = nil;
    if (![[self frc] performFetch:&error])
    {
        NSLog(@"Error! %@",error);
        abort();
    }
    /*NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Products"];
    self.items = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSSet *catSet = [_items valueForKey:@"category"];
    self.categoryList = [NSMutableArray arrayWithArray:[catSet allObjects]];

    */
    //NSLog(@"viewDidAppear Done in MasterListTVC: Here's the list: \nCategories:%@\nItems:%@",self.categoryList,self.items);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//warning Incomplete implementation, return the number of sections
    //NSMutableArray *categories = [maestro getCategories];
    //return [categories count]
//    NSLog(@"Category List Count: %lu",[_categoryList count]);
 //   return [_categoryList count];
    NSLog(@"Category List Count: %lu",[[self.frc sections]count]);
    return [[self.frc sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    /*
    NSString *sectionTitle = [_categoryList objectAtIndex:section];
    NSCountedSet *counted = [[NSCountedSet alloc]initWithArray:_items];
    long i = [counted countForObject:sectionTitle];
    NSLog(@"number of Rows in Section: \nSection Title: %@\nCounted: %@\ni=%lu",sectionTitle,counted,i);
    return i;
    */
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
    NSString *string2 =[_items objectAtIndex:section];
    // Section header is in 0th index... 
    [label setText:string];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"itemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    /*
    NSManagedObjectModel *anItem = [self.items objectAtIndex:indexPath.row];
    NSLog(@"Item = %@",anItem);
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[anItem valueForKey:@"itemName"]]];
    */
    Products *product = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = product.itemName;
    
    return cell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[[self.frc sections]objectAtIndex:section]name];
//}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.items objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }
        [self.items removeObjectAtIndex:indexPath.row];
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

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     //Prepare for Seque
     if([[segue identifier] isEqualToString:@"addItem"])
        {
                EditViewController *evc = segue.destinationViewController;
                evc.packageType = @"Product";
        }
 }

#pragma mark -
#pragma mark Fetched Results Controller

-(NSFetchedResultsController*)frc
{
    if(_frc !=nil) {return _frc;}
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Products" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortOnCategory =
        [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
    NSSortDescriptor *sortOnItem =
        [[NSSortDescriptor alloc] initWithKey:@"itemName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortOnCategory,sortOnItem, nil]];
    _frc = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"category" cacheName:nil];
    return _frc;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_relatedList)
    {
        NSLog(@"No Related List");
        
    }
    else
    {
        NSLog(@"Related List = %@",_relatedList);
        Products *itemToAdd = [self.frc objectAtIndexPath:indexPath];
        NSString *addCategory = itemToAdd.category;
        NSString *addItemName = itemToAdd.itemName;
        NSString *listName = _relatedList;
        BOOL *crossed = 0;
        NSLog(@"ItemtoAdd: %@\n",itemToAdd);
        //appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        //NSManagedObjectContext *newContext = appDelegate.persistentContainer.viewContext;
        ShoppingLists *addListItem = [[ShoppingLists alloc]initWithContext:context];
        
        //NSLog(@"Added Item Build: %@\n",addListItem);
        addListItem.crossed = NO;
        //NSLog(@"Added Item Build: %@\n",addListItem);
        addListItem.itemName = addItemName;
        //NSLog(@"Added Item Build: %@\n",addListItem);
        addListItem.category = addCategory;
        //NSLog(@"Added Item Build: %@\n",addListItem);
        addListItem.listName = listName;
        //NSLog(@"Added Item Build: %@\n",addListItem);
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }

    }
    
}

@end
