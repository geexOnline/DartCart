//
//  EditViewController.m
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import "EditViewController.h"
#import "ShoppingListsNames+CoreDataClass.h"
#import "ShoppingLists+CoreDataClass.h"
#import "Categories+CoreDataClass.h"
#import "Products+CoreDataClass.h"
#import "maestro.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblPageTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblField1;
@property (weak, nonatomic) IBOutlet UILabel *lblField2;
@property (weak, nonatomic) IBOutlet UITextField *txtValue1;
@property (weak, nonatomic) IBOutlet UITextField *txtValue2;
@property (weak, nonatomic) IBOutlet UIPickerView *pkrField3;
@property (strong) NSMutableArray *categories;
@property (strong, nonatomic) NSArray *sortedCategories;

@end

@implementation EditViewController

static NSString *entity = nil;
static NSString *field1 = nil;
static NSString *field2 = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Categories"];
    self.categories = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    NSArray *c = [_categories valueForKeyPath:@"category"];
    self.sortedCategories = [c sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"Category Lists: \n\n\ncategories: %@\n\nc:%@\n\nsortedCategories:%@\n\n",_categories,c,_sortedCategories);
    //NSMutableArray *categories = [maestro getCategories];
    //[self.view addSubview:_pkrField3];
    //_pkrField3.dataSource = self;
    
    //self.pkrField3.delegate = self;
    [self setPageUp:self.packageType list:self.relatedList];
    NSLog(@"Package: %@\npackageType: %@\nrelatedList:%@",_package,_packageType,_relatedList);
    _pkrField3.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actSaveRecord:(UIButton *)sender {
    NSLog(@"Entity: %@",entity);
    if ([entity isEqualToString:@"ShoppingListsNames"])
    {
        NSLog(@"Preparing to Add Info");
        ShoppingListsNames *addtoEntity = [[ShoppingListsNames alloc]initWithContext:context];
        NSLog(@"addtoEntity: %@",addtoEntity);
        NSDate *now = [NSDate date];
        NSLog(@"Going to record date of: %@ and name of %@",now, self.txtValue1.text);
        [addtoEntity setValue:now forKey:@"date"];
        [addtoEntity setValue:self.txtValue1.text forKey:@"listName"];
        
        NSLog(@"Infor added to addtoEntity: %@, context: %@",addtoEntity,context);
        NSError *error = nil;
        //[context save:&error];
        if (![context save:&error])
        {
            NSLog(@"There was an error: %@ %@", error, [error localizedDescription]);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
        self.txtValue1.text = @"";
        self.txtValue2.text = @"";
    }
    else if ([entity isEqualToString:@"ShoppingLists"])
    {
        NSLog(@"Preparing to Add Info");
        ShoppingLists *addtoEntity = [[ShoppingLists alloc]initWithContext:context];
        NSLog(@"addtoEntity: %@",addtoEntity);
        NSLog(@"Adding %@:%@ %@:%@ to list %@",
              field1,_relatedList,field2,self.txtValue2.text,addtoEntity);
        [addtoEntity setValue:0 forKey:@"crossed"];
        [addtoEntity setValue:_relatedList forKey:@"listName"];
        [addtoEntity setValue:self.txtValue2.text forKey:@"itemName"];
        // Might need to add category here - Look it up maybe?
        //[addtoEntity setValue:self.txtValue1.text forKey:@"listName"];
        NSLog(@"Infor added to addtoEntity: %@, context: %@",addtoEntity,context);
        NSError *error = nil;
        //[context save:&error];
        if (![context save:&error])
        {
            NSLog(@"There was an error: %@ %@", error, [error localizedDescription]);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
        self.txtValue1.text = @"";
        self.txtValue2.text = @"";
    }
    else if ([entity isEqualToString:@"Categories"])
    {
        #define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
        NSLog(@"Preparing to Add Category to Categories");
        Categories *addtoEntity = [[Categories alloc]initWithContext:context];
        NSLog(@"\n\n ++AddtoEntity: %@",addtoEntity);
        [addtoEntity setValue:self.txtValue1.text forKey:@"category"];
        NSLog(@"\n\n ++Adding %@:%@ to entity: %@",
              field1,self.txtValue1.text,addtoEntity);
        
        NSError *error = nil;
        //[context save:&error];
        NSLog(@"Context:---------------\n%@\n========================",context);
        if (![context save:&error])
        {
            NSLog(@"\n\n\nThere was an error: %@ %@\n\n\n", error, [error localizedDescription]);
            
        }
        else
        {
            NSLog(@"\n\n ++Info added to addtoEntity: %@, context: %@",addtoEntity,context);
        }
        
        self.txtValue1.text = @"";
        self.txtValue2.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([entity isEqualToString:@"Products"])
    {
        #define NSLog(FORMAT, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
        NSLog(@"Preparing to Add Item to Products");
        Products *addtoEntity = [[Products alloc]initWithContext:context];
        
        [addtoEntity setValue:self.txtValue1.text forKey:@"itemName"];
        //NSArray *cat = [_sortedCategories valueForKey:@"category"];
        [addtoEntity setValue:_sortedCategories[[_pkrField3 selectedRowInComponent:0]] forKey:@"category"];
        NSLog(@"\n\n ++AddtoEntity: %@",addtoEntity);
        NSLog(@"\n\n ++Adding:\n%@:%@\n%@:%@\n to entity: %@\n",
              field1,self.txtValue1.text,field2,_sortedCategories[[_pkrField3 selectedRowInComponent:0]], addtoEntity);
        
        NSError *error = nil;
        //[context save:&error];
        NSLog(@"Context:---------------\n%@\n========================",context);
        if (![context save:&error])
        {
            NSLog(@"\n\n\nThere was an error: %@ %@\n\n\n", error, [error localizedDescription]);
            
        }
        else
        {
            NSLog(@"\n\n ++Info added to addtoEntity: %@, context: %@",addtoEntity,context);
        }
        
        self.txtValue1.text = @"";
        self.txtValue2.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)DismissKeyboard:(id)sender {
    
}

//-(void)setPageUp:(NSString *)pkgType
- (void)setPageUp:(NSString *)pkgType list: (NSString *)list;
{
    self.txtValue1.hidden = NO;
    self.txtValue2.hidden = NO;
    self.txtValue1.enabled = YES;
    self.txtValue2.enabled = YES;
    self.pkrField3.hidden = YES;
    if ([pkgType isEqual: @"List"])
    {
        self.lblPageTitle.text = @"Add a New Shopping List";
        self.lblField1.text = @"List Name";
        self.lblField2.text = @"Date";
        //NSLog(@"Local Date Time: %@",[maestro getLocalDateTime]);
        //NSDate *now = [maestro getLocalDateTime];
        NSDate *now = [NSDate date];
        self.txtValue2.text = [NSString stringWithFormat:@"%@",now];
        self.txtValue2.enabled = NO;
        
        entity = @"ShoppingListsNames";
        field1 = @"listName";
        field2 = @"date";
    }
    // Going to move this to a table view selector (if I ever figure it out)
/*    else if ([pkgType  isEqual: @"ShoppingLists"])
    {
        self.lblPageTitle.text = @"Add Item to Your List";
        self.lblField1.text = @"List";
        self.lblField2.text = @"Item";
        self.txtValue1.text = list;
        self.txtValue1.enabled = NO;
        
        entity = @"ShoppingLists";
        field1 = @"listName";
        field2 = @"itemName";
        
    }
 */
    else if ([_packageType  isEqual: @"Category"])
    {
        self.lblPageTitle.text = @"Add a Category";
        self.lblField1.text = @"Category:";
        self.lblField2.text = @"";
        self.txtValue2.hidden = YES;

        entity = @"Categories";
        field1 = @"category";
        field2 = nil;
    }
    else if ([_packageType  isEqual: @"Product"])
    {
        self.lblPageTitle.text = @"Add a New Product";
        self.lblField1.text = @"Item Name";
        self.lblField2.text = @"Category";
        self.pkrField3.hidden = NO;
        self.txtValue2.hidden = YES;
        entity = @"Products";
        field1 = @"itemName";
        field2 = @"category";
        
    }
    else
    {
        self.lblPageTitle.text = @"Something ain't right here";
    }
}
#pragma mark - Picker Data Source Methods

//Here's where you set the number of components (columns) in the picker wheel
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{return 1;}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"Cat Count for Picker View: %lu",_categories.count);
    return _categories.count;}

#pragma mark - Picker Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //NSArray *cat = [_sortedCategories valueForKey:@"category"];
    
    return _sortedCategories[row];
}
@end
