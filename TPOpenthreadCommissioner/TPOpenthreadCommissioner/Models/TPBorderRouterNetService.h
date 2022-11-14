//
//  TPBorderRouterNetService.h
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 02/11/2022.
//

#import <Foundation/Foundation.h>
#import <Network/Network.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TPBorderRouterNetServiceDelegate;

typedef enum : NSUInteger {
    kIPv4,
    kIPv6
} TPIPAddressType;


@interface TPIPAddressNetService : NSObject
@property (nonatomic, strong) NSString* ipAddress;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, assign) TPIPAddressType ipAddressType;
@end


@interface TPBorderRouterNetService : NSObject
@property (nonatomic, strong, readonly) NSString* uuid;
@property (nonatomic, strong, readonly) NSNetService* service;
@property (nonatomic, strong) NSString* networkName;
@property (nonatomic, strong) NSData* extendedPanId;
@property (nonatomic, strong) NSMutableArray* ipv4;
@property (nonatomic, strong) NSMutableArray* ipv6;
@property (nullable, assign) id<TPBorderRouterNetServiceDelegate> delegate;

- (instancetype)initWithNetService:(NSNetService*)service andDelegate:(id<TPBorderRouterNetServiceDelegate>)delegate;

@end

@protocol TPBorderRouterNetServiceDelegate <NSObject>
- (void)netServiceDidResolveCompleted:(TPBorderRouterNetService*)borderRouterService;
@end

NS_ASSUME_NONNULL_END
