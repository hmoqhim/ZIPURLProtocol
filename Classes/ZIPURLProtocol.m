//
//  ZIPURLProtocol.m
//  ZIPURLProtocol
//
//  Created by Cameron Spickert on 1/21/14.
//  Copyright (c) 2014 Oyster. All rights reserved.
//

#import "ZIPURLProtocol.h"
#import "ZIPURLScheme.h"
#import "NSURL+ZIPURLProtocolAdditions.h"
#import <zipzap/zipzap.h>

@implementation ZIPURLProtocol

#pragma mark -
#pragma mark Required NSURLProtocol methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [[[request URL] scheme] caseInsensitiveCompare:ZIPURLScheme] == NSOrderedSame;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSURL *requestURL = [[self request] URL];
    
    ZZArchive *archive = [ZZArchive archiveWithContentsOfURL:[requestURL zip_archiveURL]];
    ZZArchiveEntry *archiveEntry = [[[archive entries] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"fileName = %@", [requestURL zip_entryFileName]]] firstObject];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:requestURL MIMEType:[requestURL zip_expectedMIMEType] expectedContentLength:[archiveEntry uncompressedSize] textEncodingName:nil];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    if (archiveEntry) {
        [[self client] URLProtocol:self didLoadData:[archiveEntry data]];
        [[self client] URLProtocolDidFinishLoading:self];
    } else {
        [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil]];
    }
}

- (void)stopLoading
{
    return;
}

@end
