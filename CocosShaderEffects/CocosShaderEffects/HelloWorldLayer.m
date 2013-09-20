//
//  HelloWorldLayer.m
//  CocosShaderEffects
//
//  Created by Ray Wenderlich on 3/20/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CSEColorRamp.h"
#import "CSEEmboss.h"
#import "CSEGrass.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	if( (self=[super init])) {
		// 1 - create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		// 2 - ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		// 3 - position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		// 4 - add the label as a child to this Layer
		[self addChild: label];
		// 5 - Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		// 6 - color ramp Menu Item using blocks
		CCMenuItem *itemColorRamp = [CCMenuItemFont itemWithString:@"Color Ramp" block:^(id sender) {
			CCScene *scene = [CCScene node];
			[scene addChild: [CSEColorRamp node]];
			[[CCDirector sharedDirector] pushScene:scene];
		}];
		// 7 - Emboss menu item
		CCMenuItem *emboss = [CCMenuItemFont itemWithString:@"Emboss" block:^(id sender) {
			CCScene *scene = [CCScene node];
			[scene addChild: [CSEEmboss node]];
			[[CCDirector sharedDirector] pushScene:scene];
		}];
		// 7.1 - Grass menu item
		CCMenuItem *grass = [CCMenuItemFont itemWithString:@"Grass" block:^(id sender) {
			CCScene *scene = [CCScene node];
			[scene addChild: [CSEGrass node]];
			[[CCDirector sharedDirector] pushScene:scene];
		}];
		// 7.2 - Create menu
		CCMenu *menu = [CCMenu menuWithItems:itemColorRamp, emboss, grass, nil];
		// 8 - Configure menu
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		// 9 - Add the menu to the layer
		[self addChild:menu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
