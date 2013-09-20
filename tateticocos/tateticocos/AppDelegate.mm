//
//  AppDelegate.m
//  tateticocos
//
//  Created by Jorge Lorenzon on 10/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"

@implementation AppController
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
}

@end

