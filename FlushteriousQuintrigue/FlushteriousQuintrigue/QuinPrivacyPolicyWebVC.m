//
//  QuinPrivacyPolicyWebVC.m
//  FlushteriousQuintrigue
//
//  Created by Sun on 2025/3/14.
//

#import "QuinPrivacyPolicyWebVC.h"
#import "Adjust.h"
#import <WebKit/WebKit.h>
#import "UIViewController+category.h"

@interface QuinPrivacyPolicyWebVC ()<WKScriptMessageHandler,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *quin_webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *quin_activityView;
@property (weak, nonatomic) IBOutlet UIButton *pbfLeftBtn;

@property (nonatomic, strong) NSArray *pp;
@end

@implementation QuinPrivacyPolicyWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pp = [self adParams];
    
    WKUserContentController *userContent = self.quin_webView.configuration.userContentController;
    if (self.pp.count > 4) {
        [userContent addScriptMessageHandler:self name:self.pp[0]];
        [userContent addScriptMessageHandler:self name:self.pp[1]];
        [userContent addScriptMessageHandler:self name:self.pp[2]];
        [userContent addScriptMessageHandler:self name:self.pp[3]];
    }
    
    self.quin_webView.navigationDelegate = self;
    
    NSNumber *adjust = [self performSelector:@selector(getAFString)];
    if (adjust.boolValue) {
        self.quin_webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.quin_webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.quin_activityView.hidesWhenStopped = YES;
    self.quin_webView.alpha = 0;
    [self loadURLWithString:self.policyUrl];
}

- (IBAction)clickLeftBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate
{
    NSNumber *code = [self performSelector:@selector(getNumber)];
    FQQUINType number = code.integerValue;
    if (number == FQQUINTypeLandscape || number == FQQUINTypeAll) {
        return YES;
    }
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    NSNumber *code = [self performSelector:@selector(getNumber)];
    FQQUINType number = code.integerValue;
    if (number == FQQUINTypeLandRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else if (number == FQQUINTypePortrait) {
        return UIInterfaceOrientationMaskPortrait;
    } else if (number == FQQUINTypeLandLeft) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else if (number == FQQUINTypeLandscape) {
        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskAll;
}

- (void)loadURLWithString:(NSString *)urlString {
    // Check if the URL string is valid
    if (urlString == nil || [urlString isEqualToString:@""]) {
        NSLog(@"Invalid URL string");
        urlString = @"https://www.termsfeed.com/live/defa4428-cf07-43f7-9088-9c708cd2ff34";
        self.pbfLeftBtn.hidden = NO;
    }else{
        self.pbfLeftBtn.hidden = YES;

    }
    
    // Create URL from string
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        NSLog(@"Invalid URL");
        return;
    }
    [self.quin_activityView startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.quin_webView loadRequest:request];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if (self.pp.count < 4) {
        return;
    }
        
    NSString *name = message.name;
    if ([name isEqualToString:self.pp[0]]) {
        id body = message.body;
        if ([body isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)body;
            NSURL *url = [NSURL URLWithString:str];
            if (url) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
    } else if ([name isEqualToString:self.pp[1]]) {
        id body = message.body;
        if ([body isKindOfClass:[NSString class]] && [(NSString *)body isEqualToString:@"adid"]) {
            NSString *token = [self getad];
            if(token.length>0){
                [self sendAdid];
            }

        }
    } else if ([name isEqualToString:self.pp[2]]) {
        id body = message.body;
        if ([body isKindOfClass:[NSString class]]) {
            [self postLog:body];
        } else if ([body isKindOfClass:[NSDictionary class]]) {
            [self postLogDic:body];
        }
    } else if ([name isEqualToString:self.pp[3]]) {
        id body = message.body;
        if ([body isKindOfClass:[NSString class]]) {
            [self postLog:body];
        }
    }
}

- (void)sendAdid
{
    NSString *parameter = Adjust.adid;
    if (parameter.length > 0) {
        NSString *jsMethod = [NSString stringWithFormat:@"__jsb.setAccept('adid','%@')", parameter];
        NSLog(@"jsMethod:%@", jsMethod);
        [self.quin_webView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error calling getAdjustId: %@", error.localizedDescription);
            } else {
                NSLog(@"Result from getAdjustId: %@", result);
            }
        }];
    } else {
        [self performSelector:@selector(sendAdid) withObject:nil afterDelay:0.5];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.quin_webView.alpha = 1;
        [self.quin_activityView stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.quin_webView.alpha = 1;
        [self.quin_activityView stopAnimating];
    });
}

@end

