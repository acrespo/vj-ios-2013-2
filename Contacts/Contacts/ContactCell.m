//
//  ContactCell.m
//  Contacts
//
//  Created by AdminMacLC03 on 8/15/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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

- (void) setLabel:(NSString*)labelName
{
    self.NameLabel.text = labelName;
}

@end
