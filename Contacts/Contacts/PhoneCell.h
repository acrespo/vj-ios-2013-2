//
//  PhoneCell.h
//  Contacts
//
//  Created by AdminMacLC01 on 8/22/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phone.h"

@interface PhoneCell : UITableViewCell

    @property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
    @property (strong, nonatomic) Phone *phone;

    - (void) setPhone:(Phone*)phone;
@end
