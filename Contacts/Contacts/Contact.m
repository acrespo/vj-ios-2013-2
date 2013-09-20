//
//  Contact.m
//  Contacts
//
//  Created by AdminMacLC03 on 8/15/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import "Contact.h"
#import "Phone.h"

@implementation Contact

- (Contact*) initContactWithName:(NSString*) nombre andPhone:(NSArray*) phonesL{
    self = [super init];
    if(self){
        _name = nombre;
        _phones = phonesL;
    }
    return self;
}


+ (NSArray*) contactsFromJson:(NSArray*)json
{
    NSMutableArray* contacts = [[NSMutableArray alloc] init];
    
    for (NSDictionary* contactDict in json) {
        [contacts addObject:[Contact contactFromJson:contactDict]];
    }
    
    return contacts;
}

+ (Contact*) contactFromJson:(NSDictionary*)json
{
    Contact* contact = [[Contact alloc] init];
    contact.name = [json objectForKey:@"name"];
    NSMutableArray* phones = [NSMutableArray array];
    
    for (NSDictionary* phoneDict in [json objectForKey:@"phones"]) {
        [Phone phoneFromJson:phoneDict];
    }
    
    contact.phones = phones;
    
    return contact;
}

@end
