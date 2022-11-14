//
//  TPCommissionerHandlerDelegate.h
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 07/11/2022.
//

#import <Foundation/Foundation.h>
#import <commissioner/commissioner.hpp>

NS_ASSUME_NONNULL_BEGIN

@protocol TPCommissionerHandlerDelegate <NSObject>
@optional
- (NSString*)onJoinerRequest:(NSData*)aJoinerId;
- (void)onJoinerConnected:(NSData*)aJoinerId andError:(ot::commissioner::Error)aError;
- (BOOL)onJoinerFinalize:(NSData*)aJoinerId
           andVendorName:(NSString*)aVendorName
          andVendorModel:(NSString*)aVendorModel
      andVendorSwVersion:(NSString*)aVendorSwVersion
   andVendorStackVersion:(NSData*)aVendorStackVersion
      andProvisioningUrl:(NSString*)aProvisioningUrl
           andVendorData:(NSData*)aVendorData;
- (void)onKeepAliveResponse:(ot::commissioner::Error)aError;
- (void)onPanIdConflict:(NSString*)aPeerAddr
         andChannelMask:(ot::commissioner::ChannelMask)aChannelMask
               andPanId:(uint64_t)aPanId;
- (void)onEnergyReport:(NSString*)aPeerAddr
        andChannelMask:(ot::commissioner::ChannelMask)aChannelMask
         andVendorData:(NSData*)aEnergyList;

@end

NS_ASSUME_NONNULL_END

