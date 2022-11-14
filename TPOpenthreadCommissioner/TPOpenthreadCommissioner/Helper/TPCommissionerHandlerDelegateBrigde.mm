//
//  TPCommissionerHandlerDelegateBrigde.m
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 07/11/2022.
//

#import "TPCommissionerHandlerDelegateBrigde.h"

std::string OnJoinerRequest(const ByteArray &aJoinerId)
{
    NSLog(@"OnJoinerRequest");
    return "";
}

void OnJoinerConnected(const ByteArray &aJoinerId, Error aError)
{
    NSLog(@"OnJoinerConnected");
}

bool OnJoinerFinalize(const ByteArray &  aJoinerId,
                      const std::string &aVendorName,
                      const std::string &aVendorModel,
                      const std::string &aVendorSwVersion,
                      const ByteArray &  aVendorStackVersion,
                      const std::string &aProvisioningUrl,
                      const ByteArray &  aVendorData)
{
    return false;
}

void OnKeepAliveResponse(Error aError)
{
    NSLog(@"OnKeepAliveResponse");
}

void OnPanIdConflict(const std::string &aPeerAddr, const ChannelMask &aChannelMask, uint16_t aPanId)
{
    NSLog(@"OnPanIdConflict");
}

void OnEnergyReport(const std::string &aPeerAddr,
                    const ChannelMask &aChannelMask,
                    const ByteArray &  aEnergyList)
{
    NSLog(@"OnEnergyReport");
}
