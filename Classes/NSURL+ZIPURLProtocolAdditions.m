//
//  NSURL+ZIPURLProtocolAdditions.m
//  ZIPURLProtocol
//
//  Created by Cameron Spickert on 1/22/14.
//  Copyright (c) 2014 Oyster. All rights reserved.
//

#import "NSURL+ZIPURLProtocolAdditions.h"
#import "ZIPURLScheme.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSURL (ZIPURLProtocolAdditions)

// Create a new URL by encoding archiveURL as the `host` and `entryFileName` as the `path`
+ (instancetype)zip_URLWithArchiveURL:(NSURL *)archiveURL entryFileName:(NSString *)entryFileName
{
    NSString *archiveURLString = [archiveURL absoluteString];
    NSData *archiveURLData = [archiveURLString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Replace "=" with "%3D" to make the string URL-safe
    // Source: http://en.wikipedia.org/wiki/Base64#Variants_summary_table
    NSString *archiveURLBase64String = [[archiveURLData base64EncodedStringWithOptions:0] stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    
    NSURL *newArchiveURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", ZIPURLScheme, archiveURLBase64String]];
    return [NSURL URLWithString:entryFileName relativeToURL:newArchiveURL];
}

// Decode the archive URL from the `host` property
- (NSURL *)zip_archiveURL
{
    // Replace "%3D" with "=" (see above)
    NSString *archiveURLBase64String = [[self host] stringByReplacingOccurrencesOfString:@"%3D" withString:@"="];
    
    NSData *archiveURLData = [[NSData alloc] initWithBase64EncodedString:archiveURLBase64String options:0];
    NSString *archiveURLString = [[NSString alloc] initWithData:archiveURLData encoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:archiveURLString];
}

// Decode the entry file name from the `path` property
- (NSString *)zip_entryFileName
{
    NSString *fileName = [self path];
    if ([fileName rangeOfString:@"/" options:NSAnchoredSearch].location != NSNotFound) {
        fileName = [fileName substringFromIndex:1];
    }
    return fileName;
}

// Infer the MIME type of the resource from its path extension
// Source: http://stackoverflow.com/a/9802467/452816
- (NSString *)zip_expectedMIMEType
{
    CFStringRef type = NULL;
    {
        CFStringRef pathExtension = (__bridge_retained CFStringRef)[[self zip_entryFileName] pathExtension];
        
        type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
        
        if (pathExtension != NULL) {
            CFRelease(pathExtension), pathExtension = NULL;
        }
    }
    
    NSString *MIMEType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    
    if (type != NULL) {
        CFRelease(type), type = NULL;
    }
    
    return MIMEType;
}

@end
