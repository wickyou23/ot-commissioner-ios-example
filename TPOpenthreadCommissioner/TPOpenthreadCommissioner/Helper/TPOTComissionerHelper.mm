//
//  TPOTComissionerHelper.m
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 07/11/2022.
//

#import "TPOTComissionerHelper.h"
#import "ExtentionHelper.h"
#import "TPComissionerLogger.h"
#import "TPCommissionerHandlerDelegate.h"
#import "TPCommissionerHandlerDelegateBrigde.h"

#import <commissioner/commissioner.hpp>
#import <commissioner/network_data.hpp>

using namespace std;
using namespace ot::commissioner;

@interface TPActiveOperationalDataset ()
- (instancetype)initWithActiveOperationalDataset:(ActiveOperationalDataset)dataset;
@end

@interface TPOTComissionerHelper() <TPCommissionerHandlerDelegate>
@end

@implementation TPOTComissionerHelper

+ (instancetype)shared {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSData* _Nullable)computePskcWithNetService:(TPBorderRouterNetService*)service andPassphrase:(NSString*)passphrase {
    if (service == NULL) {
        return NULL;
    }
    
    vector<uint8_t> pskc;
    const uint8_t *bufferExtPanId = (const uint8_t*)[service.extendedPanId bytes];
    vector<uint8_t> extPanId(&bufferExtPanId[0], &bufferExtPanId[sizeof(bufferExtPanId)]);
    Error error = Commissioner::GeneratePSKc(pskc, [passphrase UTF8String], [service.networkName UTF8String], extPanId);
    if (error.GetCode() == ErrorCode::kNone) {
        NSData* data = [[NSData alloc] initWithBytes:pskc.data() length:pskc.size()];
        NSLog(@"pskc hex string: %@", [data hexadecimalString]);
        return data;
    }
    else {
        NSLog(@"[ERROR] pskc hex string error: %s", error.ToString().c_str());
        return NULL;
    }
}

- (TPActiveOperationalDataset* _Nullable)getActiveOperationalDatasetWithService:(TPBorderRouterNetService*)service
                                                                        andPSKC:(NSData*)pskc {
    uint8_t pskcBytes[[pskc length]];
    [pskc getBytes:pskcBytes length:[pskc length]];
    vector<uint8_t> byteArrayPskc(&pskcBytes[0], &pskcBytes[sizeof(pskcBytes)]);
    
    Config config = Config();
    config.mId = "TestComm";
    config.mDomainName = "TestDomain";
    config.mEnableCcm = FALSE;
    config.mEnableDtlsDebugLogging = TRUE;
    config.mPSKc = byteArrayPskc;
    config.mLogger = make_shared<TPComissionerLogger>();
    
    CommissionerHandler handler = TPCommissionerHandlerDelegateBrigde(self);
    auto comissioner = Commissioner::Create(handler);
    Error initError = comissioner->Init(config);
    if (initError.GetCode() != ErrorCode::kNone) {
        NSLog(@"Init commissioner failed: %s", initError.ToString().c_str());
        return NULL;
    }
    
    TPIPAddressNetService* ipv4 = service.ipv4.firstObject;
    if (ipv4 == NULL) {
        NSLog(@"Cannot found ipv6 address for Network Name: %@", service.networkName);
        return NULL;
    }
    
    string existingCommissionerId;
    Error petitionError = comissioner->Petition(existingCommissionerId, [ipv4.ipAddress UTF8String], (uint16_t)ipv4.port);
    if (petitionError.GetCode() != ErrorCode::kNone) {
        NSLog(@"Init commissioner failed: %s", petitionError.ToString().c_str());
        return NULL;
    }
    
    ActiveOperationalDataset dataSet;
    Error getActiveDatasetError = comissioner->GetActiveDataset(dataSet, 0xFFFF);
    if (getActiveDatasetError.GetCode() != ErrorCode::kNone) {
        NSLog(@"Init commissioner failed: %s", getActiveDatasetError.ToString().c_str());
        return NULL;
    }
    
    comissioner->Disconnect();
    return [[TPActiveOperationalDataset alloc] initWithActiveOperationalDataset:dataSet];
}

@end
