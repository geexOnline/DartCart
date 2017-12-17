//
//  EditViewController.h
//  DartCart
//
//  Created by PAUL CHRISTIAN on 12/15/17.
//  Copyright © 2017 GroupZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

@property (strong) NSManagedObjectModel *package;
@property (strong, nonatomic) NSString *packageType;
@property (strong, nonatomic) NSString *relatedList;

- (void)setPageUp:(NSString *)pkgType list: (NSString *)list;

@end
