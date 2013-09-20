//
//  MainMenuViewController.m
//  multipong
//
//  Created by Jorge Lorenzon on 12/4/12.
//
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "CCBReader.h"
#import "cocos2d.h"
#import "InGameLayer.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize newGameButton =_newGameButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.newGameButton.enabled = NO;
    
    // Do any additional setup after loading the view from its nib.
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
        self.newGameButton.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender {
    
    GKMatchRequest* matchRequest = [[[GKMatchRequest alloc] init] autorelease];
    matchRequest.maxPlayers = 2;
    matchRequest.minPlayers = 2;
    
    GKMatchmakerViewController* gkmvc =[[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
    gkmvc.matchmakerDelegate = self;
    
    [self presentModalViewController:gkmvc animated:YES];
    
//    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:matchRequest withCompletionHandler:^(GKMatch *match, NSError *error) {
//        NSLog(@"found match");
//        
//        CCDirector* director = [(AppController*)[UIApplication sharedApplication].delegate director];
//        
//        [self.navigationController pushViewController:director animated:YES];
//        
//        CCScene* scene = [CCScene node];
//        CCNode* ingameLayer = [CCBReader nodeGraphFromFile:@"ingame.ccbi"];
//        match.delegate = (InGameLayer*)ingameLayer;
//        [scene addChild:ingameLayer];
//        
//        [director pushScene: scene];
//    }];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    NSLog(@"found match");

    CCDirector* director = [(AppController*)[UIApplication sharedApplication].delegate director];

    [self.navigationController pushViewController:director animated:YES];

    CCScene* scene = [CCScene node];
    CCNode* ingameLayer = [CCBReader nodeGraphFromFile:@"ingame.ccbi"];
    [scene addChild:ingameLayer];

    [director pushScene: scene];
    
    match.delegate = (InGameLayer*)ingameLayer;
    
    if (match.expectedPlayerCount == 0)
        [(InGameLayer*)ingameLayer start:match];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
    [_newGameButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNewGameButton:nil];
    [super viewDidUnload];
}
@end
