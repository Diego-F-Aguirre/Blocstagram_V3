//
//  LoginViewController.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/13/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "LoginViewController.h"
#import "DataSource.h"

@interface LoginViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
//@property (nonatomic, strong) UIButton *backButton;

@end

@implementation LoginViewController

NSString *const LoginViewControllerDidGetAccessTokenNotification = @"LoginViewControllerDidGetAccessTokenNotification";

- (NSString *) redirectURI{

    return @"http://diegoa3d.com";
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc]init];
    webview.delegate = self;
    
    [self.view addSubview:webview];
    self.webView = webview;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Go Back") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.title = NSLocalizedString(@"Login", @"Login");
    
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&scope=likes+comments+relationships&redirect_uri=%@&response_type=token", [DataSource instagramClientID], [self redirectURI]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}
                                                                                                                                              
                                                                                                                                              
 - (void) backButtonTapped {
     NSLog(@"Go back");
     [self.webView goBack];
 }
                                                                                                                                              
                                                                                                                                              
                                                                                                                                              
- (void)dealloc {

    // Removing this line can cause a flickering effect when you relaunch the app after logging in, as the web view is briefly displayed, automatically authenticates with cookies, returns the access token, and dismisses the login view, sometimes in less than a second.
    [self clearInstagramCookies];
    
    // see https://developer.apple.com/library/ios/documentation/uikit/reference/UIWebViewDelegate_Protocol/Reference/Reference.html#//apple_ref/doc/uid/TP40006951-CH3-DontLinkElementID_1
    
    self.webView.delegate = nil;
    
}




- (void)viewWillLayoutSubviews {

    self.webView.frame = self.view.bounds;

}

/** Clears Instagram cookies. This prevents caching the credentials in the cookie jar.*/

- (void)clearInstagramCookies {
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies]) {
        
        NSRange domainRange = [cookie.domain rangeOfString:@"instagram.com"];
        if (domainRange.location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookie];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *urlString = request.URL.absoluteString;
    
    NSLog(@"%@",urlString);
    
    if ([urlString hasPrefix:[self redirectURI]]) {
        // This contains our auth token
        NSRange rangeOfAccessTokenParameter = [urlString rangeOfString:@"access_token="];
        NSUInteger indexOfTokenStarting = rangeOfAccessTokenParameter.location + rangeOfAccessTokenParameter.length;
        NSString *accessToken = [urlString substringFromIndex:indexOfTokenStarting];
        NSLog(@"%@",accessToken);
        [[NSNotificationCenter defaultCenter]postNotificationName:LoginViewControllerDidGetAccessTokenNotification object:accessToken];
        
        return NO;
    }
    
    return YES;
}

@end
