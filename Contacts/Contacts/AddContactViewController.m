//
//  AddContactViewController.m
//  Contacts
//
//  Created by AdminMacLC01 on 8/22/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import "AddContactViewController.h"
#import "CTCAppDelegate.h"
#import "Phone.h"
#import "PhoneCell.h"

NSString* kContactAdded = @"kContactAdded";
NSString* kContactEdited = @"kContactEdited";

@interface AddContactViewController ()

@end

@implementation AddContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.phones count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhoneCell";
    PhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if ([self.phones count]) {
        [cell setPhone: self.phones[indexPath.row]];
    } else {
    }
    return cell;
}

- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
   	 
    NSMutableDictionary* contactDict = [NSMutableDictionary dictionary];
    [contactDict setObject:_nameTextField.text forKey:@"name"];
    
    
    
    NSMutableArray* phonesArray = [NSMutableArray arrayWithCapacity:[_phones count]];
    for (Phone* phone in _phones) {
        [phonesArray addObject:[phone json]];
    }
    [contactDict setObject:phonesArray forKey:@"phones"];
    
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:contactDict options:0 error:&error];
    NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [[CTCAppDelegate sharedClient] postPath:@"/contact/" parameters:@{@"contact": json} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kContactAdded object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed");
    }];
    
    
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


        
- (void) finishedEditingPhone {
    if (_tempPhone.phoneNumber != nil && [_tempPhone.phoneNumber length] > 0 ) {
        [_phones addObject:_tempPhone];
        _tempPhone = [[Phone alloc] init];
    }
    
    NSMutableArray* deletedPhones = [NSMutableArray array];
    
    for (Phone* phone in _phones) {
        if (phone.phoneNumber == nil || [phone.phoneNumber length] == 0) {
            [deletedPhones addObject:phone];
        }
    }
    
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (Phone* phone in deletedPhones) {
        int idx = [_phones indexOfObject:phone];
    
    }
}

- (void) phoneDidEdit:(Phone*)edited {
    
}


- (void) textFieldDidEndEditing: (UITextField*) textField  {
        
}

@end
