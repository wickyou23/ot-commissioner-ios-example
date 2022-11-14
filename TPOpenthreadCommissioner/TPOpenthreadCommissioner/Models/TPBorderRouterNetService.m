//
//  TPBorderRouterNetService.m
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 02/11/2022.
//

#import "TPBorderRouterNetService.h"
#import <sys/types.h>

#include <netinet/in.h>
#include <arpa/inet.h>

NSString* const TPDiscriminator = @"discriminator";
NSString* const TPNetworkName = @"nn";
NSString* const TPExtenedPanId = @"xp";

@implementation TPIPAddressNetService
@end

@interface TPBorderRouterNetService() <NSNetServiceDelegate>
@end

@implementation TPBorderRouterNetService {
    BOOL _isAddressResolved;
    BOOL _isTxtRecordDataResolved;
}

- (instancetype)initWithNetService:(NSNetService*)service andDelegate:(id<TPBorderRouterNetServiceDelegate>)delegate {
    if (self = [super init]) {
        _uuid = [[NSUUID alloc] UUIDString];
        _service = service;
        _service.delegate = self;
        _delegate = delegate;
        
        _isAddressResolved = FALSE;
        _isTxtRecordDataResolved = FALSE;
        
        [_service resolveWithTimeout:5.0f];
        [_service startMonitoring];
    }
    
    return self;
}

- (void)parseIPAddress {
    if (_service == NULL) {
        return;
    }
    
    NSMutableArray *tmpIpv4 = [NSMutableArray array];
    NSMutableArray *tmpIpv6 = [NSMutableArray array];
    for (NSData* data in _service.addresses) {
        struct sockaddr *addressGeneric;
        addressGeneric = (struct sockaddr *) [data bytes];
        
        switch(addressGeneric->sa_family) {
            case AF_INET: {
                struct sockaddr_in *ip4;
                char dest[INET_ADDRSTRLEN];
                ip4 = (struct sockaddr_in *) [data bytes];
                
                TPIPAddressNetService* ipAddress = [[TPIPAddressNetService alloc] init];
                ipAddress.ipAddress = [NSString stringWithUTF8String:inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest)];
                ipAddress.port = ntohs(ip4->sin_port);
                ipAddress.ipAddressType = kIPv4;
                [tmpIpv4 addObject:ipAddress];
                
                NSLog(@"Client Address: %@", [NSString stringWithFormat: @"IP4: %@ Port: %ld", ipAddress.ipAddress, ipAddress.port]);
            }
                break;
                
            case AF_INET6: {
                struct sockaddr_in6 *ip6;
                char dest[INET6_ADDRSTRLEN];
                ip6 = (struct sockaddr_in6 *) [data bytes];
                
                TPIPAddressNetService* ipAddress = [[TPIPAddressNetService alloc] init];
                ipAddress.ipAddress = [NSString stringWithUTF8String:inet_ntop(AF_INET6, &ip6->sin6_addr, dest, sizeof dest)];
                ipAddress.port = ntohs(ip6->sin6_port);
                ipAddress.ipAddressType = kIPv6;
                [tmpIpv6 addObject:ipAddress];
                
                NSLog(@"Client Address: %@", [NSString stringWithFormat: @"IP6: %@ Port: %ld", ipAddress.ipAddress, ipAddress.port]);
            }
                break;
                
            default:
                NSLog(@"Client Address: Unknown family");
                break;
        }
    }
    
    _ipv4 = tmpIpv4;
    _ipv6 = tmpIpv6;
}

- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSDictionary* dict = [NSNetService dictionaryFromTXTRecordData:data];
    NSLog(@"netService %@", dict);
    [sender stopMonitoring]; //Only get one time.
    
    _isTxtRecordDataResolved = TRUE;
    NSData* networkNameData = [dict valueForKey:TPNetworkName];
    NSData* extendedPanId = [dict valueForKey:TPExtenedPanId];
    if (networkNameData == NULL || extendedPanId == NULL) {
        [self sendDelegate];
        return;
    }
    
    _networkName = [[NSString alloc] initWithData:networkNameData encoding:NSUTF8StringEncoding];
    _extendedPanId = extendedPanId;
    [self sendDelegate];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"netServiceDidResolveAddress %@", sender.addresses);
    _isAddressResolved = TRUE;
    [self parseIPAddress];
    [self sendDelegate];
}

- (void)sendDelegate {
    if (_isAddressResolved && _isTxtRecordDataResolved && _delegate != NULL) {
        [_delegate netServiceDidResolveCompleted:self];
        _delegate = NULL;
    }
}

@end
