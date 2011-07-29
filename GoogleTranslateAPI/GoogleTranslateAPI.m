//
//  GoogleTranslateAPI.m
//  TweetMe
//
//  Created by Tim Desir on 9/8/10.
//  Copyright 2010 Timstarockz LLC. All rights reserved.
//
//  This work is licensed under the Creative Commons GNU General Public License License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/GPL/2.0/
//  or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
//

#import "GoogleTranslateAPI.h"

@implementation GNSURLRequest
@synthesize tag = _tag;
@end

@implementation GoogleTranslateAPI

@synthesize tag = _tag;
@synthesize delegate = _delegate;

static NSString *_responseString;

NSString *CurrentLanguageCode()
{
	static NSString *currentLanguage = nil;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	currentLanguage = [[languages objectAtIndex:0] retain];
	
	return currentLanguage;
}

+ (NSArray *)systemLanguages;
{	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	
	return languages;
}

- (void)translate:(NSString *)text;
{
	static NSString *queryURL = @"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=%@&langpair=%@%@";
	
	NSString *escapedString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *copier = [escapedString copy];
	NSString *query = [NSString stringWithFormat:queryURL, copier, @"%7C", CurrentLanguageCode()];
		
	_request = [[GNSURLRequest alloc] initWithURL:[NSURL URLWithString:query]];
	_request.tag = 0;
	_connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
}

- (void)translate:(NSString *)text to:(NSString *)language;
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
	
	static NSString *queryURL = @"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=%@&langpair=%@%@";
	
	text = [text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString *escapedString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *query = [NSString stringWithFormat:queryURL, escapedString, @"%7C", language];
	//NSLog(@"uRL: %@",query);
	
	_request = [[GNSURLRequest alloc] initWithURL:[NSURL URLWithString:query]];
	_request.tag = 1;
	_connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	_responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//NSLog(@"LOL WUT?x2: %@",_responseString);
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSString *errorString = 
	[NSString stringWithFormat:@"\n reason: %@ domain: %@ code: %d user info: \n %@", 
	 [error localizedFailureReason],[error domain],[error code],[error userInfo]];
	NSLog(@"\n error: %@ %@:",errorString,[error localizedFailureReason]);
	
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
	
	if ([_delegate respondsToSelector:@selector(googleDidFail:)]) {
		[(id)_delegate googleDidFail:self];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"LOL WUT?x9000!!!!!: %@",_responseString);
	
	if (_request.tag == 0)
	{
		NSScanner *scanner = [NSScanner scannerWithString:_responseString];
		if (![scanner scanUpToString:@"\"translatedText\":\"" intoString:NULL]) {}
		
		if (![scanner scanString:@"\"translatedText\":\"" intoString:NULL]){}
		
		NSString *result = nil;
		if (![scanner scanUpToString:@"\"," intoString:&result]) {}
		
		NSLog(@"Translation: %@", result);
		
		if ([_delegate respondsToSelector:@selector(google:didTranslate:)]) {
			[(id)_delegate google:self didTranslate:result];
		}
	} 
	else if (_request.tag == 1) 
	{
		NSScanner *scanner = [NSScanner scannerWithString:_responseString];
		if (![scanner scanUpToString:@"\"translatedText\":\"" intoString:NULL]) {}
		
		if (![scanner scanString:@"\"translatedText\":\"" intoString:NULL]){}
		
		NSString *result = nil;
		if (![scanner scanUpToString:@"\"," intoString:&result]) {}
		
		NSLog(@"Translation!!!: %@", result);
		
		if ([_delegate respondsToSelector:@selector(google:didTranslate:)]) {
			[(id)_delegate google:self didTranslate:result];
		}
	}
	
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

- (void)dealloc
{
	[super dealloc];
}

@end
