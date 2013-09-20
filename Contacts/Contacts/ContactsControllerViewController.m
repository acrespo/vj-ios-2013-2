//
//  ContactsControllerViewController.m
//  Contacts
//
//  Created by AdminMacLC03 on 8/15/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import "ContactsControllerViewController.h"
#import "Contact.h"
#import "AddContactViewController.h"
#import "CTCAppDelegate.h"
#import "ContactCell.h"

@interface ContactsControllerViewController ()

    @property (nonatomic,strong) NSArray* contacts;

@end

@implementation ContactsControllerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
  
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    _contacts = @[[[Contact alloc]initContactWithName:@"Jorge"andPhone:@[@"4754-4587",@"4754-4587"]],
//                  [[Contact alloc] initContactWithName:@"Roberto"andPhone:@[@"11-4754-4587",@"5654-4587"]],
//                  [[Contact alloc] initContactWithName:@"Carlos"andPhone:@[@"11-4754-4587",@"5654-4587",@"4754-4587",@"4754-4587"]]];
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshTableView:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:kContactAdded object:nil];
}

- (void) refreshTableView:(NSNotification*)notif
{
    [[CTCAppDelegate sharedClient] getPath:@"/contact/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error = nil;
        if (error == nil)
            self.contacts = [Contact contactsFromJson:[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error]];
        
        NSLog(@"%@", _contacts);
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setLabel: [_contacts[indexPath.row] name]];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
