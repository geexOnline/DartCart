//
//  CategoriesTVC.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "CategoriesTVC.h"
#import "maestro.h"
#import "EditViewController.h"
#import "Categories+CoreDataClass.h"

@interface CategoriesTVC ()
@property (strong) NSMutableArray *categories;

@end

@implementation CategoriesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"Category List";
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Categories"];
    NSMutableArray *categoryList = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSLog(@"Categories Fetched: %@",categoryList);
    Categories *cats = [[Categories alloc]initWithContext:context];
    if(categoryList.count > 0)
    {
        NSLog(@"We got cats! :%lu",categoryList.count);
    }
    else
    {
        NSLog(@"No Cats - Need to add default");
        [cats setValue:@"Uncategorized" forKey:@"category"];
        NSError *error = nil;
        if(![context save:&error])
            {NSLog(@"\n****Error: \n****%@ \n****%@",error,[error localizedDescription]);}
                   
    }
    [maestro cleanUp];

    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Categories"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    self.categories = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    [self.tableView reloadData];
    NSLog(@"viewDidAppear Done: Here's the list: %@",self.categories);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return self.categories.count;}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSManagedObjectModel *aCat = [self.categories objectAtIndex:indexPath.row];
    NSString *aCatName = [aCat valueForKey:@"category"];
    if (!aCatName) aCatName = @"Uncategorized";
    [cell.textLabel setText:aCatName];
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
        [context deleteObject:[self.categories objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if(![context save:&error])
        {
            NSLog(@"%@ %@",error, [error localizedDescription]);
            
        }
        [self.categories removeObjectAtIndex:indexPath.row];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
 if([[segue identifier] isEqualToString:@"addCategory"])
 {
 //NSManagedObjectModel *selectedList = [self.lists objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
 EditViewController *evc = segue.destinationViewController;
 //evc.package = selectedList;
 evc.packageType = @"Category";
 }
 
}


@end
