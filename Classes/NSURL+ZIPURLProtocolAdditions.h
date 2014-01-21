//
//  NSURL+ZIPURLProtocolAdditions.h
//  ZIPURLProtocol
//
//  Created by Cameron Spickert on 1/22/14.
//  Copyright (c) 2014 Oyster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ZIPURLProtocolAdditions)

+ (instancetype)zip_URLWithArchiveURL:(NSURL *)archiveURL entryFileName:(NSString *)entryFileName;

- (NSURL *)zip_archiveURL;
- (NSString *)zip_entryFileName;
- (NSString *)zip_expectedMIMEType;

@end
