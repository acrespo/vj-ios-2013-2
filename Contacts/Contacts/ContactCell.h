//
//  ContactCell.h
//  Contacts
//
//  Created by AdminMacLC03 on 8/15/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UILabel *NameLabel;

    - (void) setLabel:(NSString*)labelName;

@end
