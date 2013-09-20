//
//  PhoneCell.h
//  AgendaiOS
//
//  Created by Jorge Lorenzon on 8/19/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

@class AddContactViewController;

@interface AddPhoneCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) Phone* phone;

@property (weak, nonatomic) AddContactViewController* acvc;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
