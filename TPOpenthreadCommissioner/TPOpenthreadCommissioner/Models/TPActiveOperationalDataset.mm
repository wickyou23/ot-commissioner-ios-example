//
//  TPActiveOperationalDataset.m
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 08/11/2022.
//

#import "TPActiveOperationalDataset.h"
#import <commissioner/commissioner.hpp>
#import <commissioner/network_data.hpp>

using namespace std;
using namespace ot::commissioner;

@implementation TPChannelMask

- (instancetype)initWithChannelMaskEntry:(ChannelMaskEntry)entry {
    if (self = [super init]) {
        _page = entry.mPage;
        _mask = [[NSData alloc] initWithBytes:entry.mMasks.data() length:entry.mMasks.size()];
    }
    
    return self;
}

@end


@implementation TPActiveOperationalDataset

- (instancetype)initWithActiveOperationalDataset:(ActiveOperationalDataset)dataset {
    if (self = [super init]) {
        _activeTimestamp = dataset.mActiveTimestamp.Encode();
        _channelPage = dataset.mChannel.mPage;
        _channel = dataset.mChannel.mNumber;
        _xpanId = [NSString stringWithUTF8String:dataset.mExtendedPanId.str().c_str()];
        _meshLocalPrefix = [NSData dataWithBytes:dataset.mMeshLocalPrefix.data() length:dataset.mMeshLocalPrefix.size()];
        _networkMasterKey = [NSData dataWithBytes:dataset.mNetworkMasterKey.data() length:dataset.mNetworkMasterKey.size()];
        _networkName = [NSString stringWithUTF8String:dataset.mNetworkName.c_str()];
        _panId = dataset.mPanId.mValue;
        _pskc = [NSData dataWithBytes:dataset.mPSKc.data() length:dataset.mPSKc.size()];
        _securityRotationTime = dataset.mSecurityPolicy.mRotationTime;
        _securityFlags = [NSData dataWithBytes:dataset.mSecurityPolicy.mFlags.data()
                                        length:dataset.mSecurityPolicy.mFlags.size()];
        
        NSMutableArray *channelMasks = [NSMutableArray array];
        for (ChannelMaskEntry entry : dataset.mChannelMask) {
            [channelMasks addObject:[[TPChannelMask alloc] initWithChannelMaskEntry:entry]];
        }
    }
    
    return self;
}

@end
