//
//  Contact.h
//  Contacts
//
//  Created by AdminMacLC03 on 8/15/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSArray* phones;

- (Contact*) initContactWithName:(NSString*) nombre andPhone:(NSArray*) phonesL;

+ (NSArray*) contactsFromJson:(NSArray*)json;
@end
