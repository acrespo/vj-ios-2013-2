//
//  CTCAppDelegate.h
//  Contacts
//
//  Created by AdminMacLC03 on 8/15/13.
//  Copyright (c) 2013 federico. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface CTCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) AFHTTPClient* client;

+ (AFHTTPClient*) sharedClient;

@end
