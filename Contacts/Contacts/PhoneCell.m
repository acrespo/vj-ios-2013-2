//
//  PhoneCell.m
//  Contacts
//
//  Created by AdminMacLC01 on 8/22/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import "PhoneCell.h"

@implementation PhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPhone:(Phone*)phone {
    _phone = phone;
    _phoneTextField.text = phone.phoneNumber;
}


- (void)awakeFromNib {

}

- (void) textFieldDidChange:(UITextField*)textField {
    
    _phone.phoneNumber = textField.text;
//    [_acvc phoneDidEdit:_phone]
}


@end
