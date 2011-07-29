//
//  Google_Translate_APIAppDelegate.h
//  Google Translate API
//
//  Created by Tim Desir on 9/9/10.
//  Copyright 2010 Timstarockz LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleTranslateAPI.h"

@interface Google_Translate_APIAppDelegate : NSObject <UIApplicationDelegate, GoogleTranslateDelegate> {
	UIWindow *window;
	
	GoogleTranslateAPI *api;
	
	IBOutlet UITextView *textView;
}
- (IBAction)translateText;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

