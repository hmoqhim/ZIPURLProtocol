//
//  OYSViewController.m
//  ZIPURLProtocol
//
//  Created by Cameron Spickert on 1/21/14.
//  Copyright (c) 2014 Oyster. All rights reserved.
//

#import "ZIPWebViewController.h"
#import "NSURL+ZIPURLProtocolAdditions.h"

@interface ZIPWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ZIPWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *archiveURL = [[NSBundle mainBundle] URLForResource:@"pg2701" withExtension:@"epub"];
    NSURL *documentURL = [NSURL zip_URLWithArchiveURL:archiveURL entryFileName:@"2701/@public@vhost@g@gutenberg@html@files@2701@2701-h@2701-h-1.htm.html"];
    [[self webView] loadRequest:[NSURLRequest requestWithURL:documentURL]];
}

@end
