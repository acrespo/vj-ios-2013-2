//
//  AddContactViewController.h
//  Contacts
//
//  Created by AdminMacLC01 on 8/22/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

FOUNDATION_EXPORT NSString* kContactAdded;
FOUNDATION_EXPORT NSString* kContactEdited;

@interface AddContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *phonesTableView;
@property (strong, nonatomic) NSMutableArray* phones;
@property (strong, nonatomic) Phone* tempPhone;

- (void) phoneDidEdit:(Phone*)edited;
- (void) finishedEditingPhone;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
@end
