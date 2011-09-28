//
//  Google_Translate_APIAppDelegate.m
//  Google Translate API
//
//  Created by Tim Desir on 9/9/10.
//  Copyright 2010 Timstarockz LLC. All rights reserved.
//

#import "Google_Translate_APIAppDelegate.h"

@implementation Google_Translate_APIAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[textView becomeFirstResponder];
	
	api = [[GoogleTranslateAPI alloc] init];
	api.delegate = self;
    
	[window makeKeyAndVisible];
    
	return YES;
}

- (IBAction)translateText;
{
	[api translate:textView.text];
}

#pragma mark -
#pragma mark GoogleTranslateAPI
- (void)google:(GoogleTranslateAPI *)google didTranslate:(NSString *)translatedText;
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Translation" 
						  message:translatedText 
						  delegate:self cancelButtonTitle:@"Close" 
						  otherButtonTitles:@"Use",nil];
	alert.tag = 9000;
	[alert show];
	[alert release];
}

- (void)googleDidFail:(GoogleTranslateAPI *)fail;
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Error" 
						  message:@"lawl fail" 
						  delegate:nil cancelButtonTitle:@"Awww" 
						  otherButtonTitles:@"kay :(",nil];
	[alert show];
	[alert release];
}
#pragma mark -

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex; 
{
	if (alertView.tag == 9000) {
		if (buttonIndex == 1) {
			[textView setText:alertView.message];
		}
	}
}
#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
