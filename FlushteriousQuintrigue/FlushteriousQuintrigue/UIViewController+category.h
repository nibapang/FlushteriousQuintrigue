//
//  UIViewController+category.h
//  FlushteriousQuintrigue
//
//  Created by Sun on 2025/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FQQUINType) {
    FQQUINTypePortrait = 0,
    FQQUINTypeLandRight = 1,
    FQQUINTypeLandLeft = 2,
    FQQUINTypeLandscape = 3,
    FQQUINTypeAll = 4
};
@interface UIViewController (category)
- (NSDictionary *)getAFDic;
- (void)saveAFStringId:(NSString *)recordID;
- (NSString *)getAFIDStr;
- (NSNumber *)getNumber;
- (NSNumber *)getAFString;
- (NSNumber *)getStatus;
- (void)saveStatus:(NSNumber *)status;
- (NSString *)getad;
- (NSString *)gethostUrl;
- (void)showHandData;
- (NSArray *)adParams;
- (void)postLog:(NSString *)eventName;
- (void)postLogDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
