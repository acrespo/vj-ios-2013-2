//
//  Phone.h
//  Contacts
//
//  Created by AdminMacLC01 on 8/22/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Phone : NSObject

@property (nonatomic, strong) NSNumber* phoneId;
@property (nonatomic, strong) NSString* phoneNumber;

- (NSDictionary*) json;

+ (Phone*) phoneFromJson:(NSDictionary*)json;


@end
