//
//  TPActiveOperationalDataset.h
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 08/11/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPChannelMask : NSObject

@property (nonatomic, assign) uint8_t page;
@property (nonatomic, strong) NSData* mask;

@end

@interface TPActiveOperationalDataset : NSObject

@property (nonatomic, assign) uint64_t activeTimestamp;
@property (nonatomic, assign) uint8_t channelPage;
@property (nonatomic, assign) uint16_t channel;
@property (nonatomic, strong) NSArray<TPChannelMask*>* channelMasks;
@property (nonatomic, strong) NSString* xpanId;
@property (nonatomic, strong) NSData* meshLocalPrefix;
@property (nonatomic, strong) NSData* networkMasterKey;
@property (nonatomic, strong) NSString* networkName;
@property (nonatomic, assign) uint16_t panId;
@property (nonatomic, strong) NSData* pskc;
@property (nonatomic, assign) uint16_t securityRotationTime;
@property (nonatomic, strong) NSData* securityFlags;

@end

NS_ASSUME_NONNULL_END
