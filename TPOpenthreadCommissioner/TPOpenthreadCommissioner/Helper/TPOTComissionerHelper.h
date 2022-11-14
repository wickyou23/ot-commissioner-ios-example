//
//  TPOTComissionerHelper.h
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 07/11/2022.
//

#import <Foundation/Foundation.h>
#import <TPOpenthreadCommissioner/TPBorderRouterNetService.h>
#import <TPOpenthreadCommissioner/TPActiveOperationalDataset.h>


NS_ASSUME_NONNULL_BEGIN

@interface TPOTComissionerHelper : NSObject

+ (instancetype)shared;

- (NSData* _Nullable)computePskcWithNetService:(TPBorderRouterNetService*)service andPassphrase:(NSString*)passphrase;
- (TPActiveOperationalDataset* _Nullable)getActiveOperationalDatasetWithService:(TPBorderRouterNetService*)service
                                                                        andPSKC:(NSData*)pskc;

@end

NS_ASSUME_NONNULL_END
