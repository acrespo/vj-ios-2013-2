//
//  Phone.m
//  Contacts
//
//  Created by AdminMacLC01 on 8/22/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import "Phone.h"

@implementation Phone


- (Phone*) initPhoneWithNumber:(NSString*) number {
    self = [super init];
    if(self){
        _phoneNumber = number;
    }
    return self;
}


+ (Phone*) phoneFromJson:(NSDictionary*)json
{
    Phone* phone = [[Phone alloc] init];
    phone.phoneNumber = [json objectForKey:@"phone"];
    phone.phoneId = [json objectForKey:@"id"];
    return phone;
}

- (NSDictionary*)json
{
    return @{@"phone": _phoneNumber};
}
@end
