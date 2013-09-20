//
//  PhoneCell.m
//  AgendaiOS
//
//  Created by Jorge Lorenzon on 8/19/13.
//  Copyright (c) 2013 Jorge Lorenzon. All rights reserved.
//

#import "AddPhoneCell.h"
#import "AddContactViewController.h"

@implementation AddPhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField addTarget:self action:@selector(textFieldFinishedEditing:) forControlEvents:UIControlEventEditingDidEnd | UIControlEventEditingDidEndOnExit];
    
    _textField.delegate = self;
}

- (void) setPhone:(Phone *)phone
{
    _phone = phone;
    _textField.text = phone.phone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _acvc.activeTextField = textField;
    [_acvc updateTableInsets];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_textField resignFirstResponder];
    _acvc.activeTextField = nil;
}

- (void) textFieldDidChange:(UITextField*)textField
{
    _phone.phone = textField.text;
    [_acvc phoneDidEdit:_phone];
}

- (void) textFieldFinishedEditing:(UITextField*)textField
{
    [_textField resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_acvc finishedEditingPhone];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


@end
