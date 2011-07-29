//
//  GoogleTranslateAPI.h
//  TweetMe
//
//  Created by Tim Desir on 9/8/10.
//  Copyright 2010 Timstarockz LLC. All rights reserved.
//
//	DON'T STEAL FROM ME
//
//  This work is licensed under the Creative Commons GNU General Public License License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/GPL/2.0/
//  or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif
#import <Foundation/Foundation.h>

@interface GNSURLRequest : NSURLRequest //GoogleNSURLRequest
{
@private
	NSUInteger _tag;
}
@property(nonatomic) NSUInteger tag; // @synthesize tag;
@end

@protocol GoogleTranslateDelegate;

@interface GoogleTranslateAPI : NSObject
{
@private
	NSString *_originalString;
	NSString *_translatedString;
	
	GNSURLRequest *_request;
	NSURLConnection *_connection;
	
	NSUInteger _tag;
	
	id <GoogleTranslateDelegate> _delegate;
}
NSString *CurrentLanguageCode();
+ (NSArray *)systemLanguages;

- (void)translate:(NSString *)text;
- (void)translate:(NSString *)text to:(NSString *)language; //en, ja, zh-CN, ect...

@property(nonatomic) NSUInteger tag; // @synthesize tag = _tag;
@property (nonatomic, assign) id <GoogleTranslateDelegate> delegate;
@end

@protocol GoogleTranslateDelegate <NSObject>
@optional

- (void)google:(GoogleTranslateAPI *)google didTranslate:(NSString *)translatedText;
- (void)googleDidFail:(GoogleTranslateAPI *)fail;

@end

