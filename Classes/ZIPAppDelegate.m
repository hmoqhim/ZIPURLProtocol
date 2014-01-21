//
//  OYSAppDelegate.m
//  ZIPURLProtocol
//
//  Created by Cameron Spickert on 1/21/14.
//  Copyright (c) 2014 Oyster. All rights reserved.
//

#import "ZIPAppDelegate.h"
#import "ZIPURLProtocol.h"

@implementation ZIPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSURLProtocol registerClass:[ZIPURLProtocol class]];
    
    return YES;
}

@end
