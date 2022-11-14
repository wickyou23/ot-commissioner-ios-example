//
//  TPBorderAgentDiscoverer.m
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 01/11/2022.
//

#import "TPBorderAgentDiscover.h"
#import "TPBorderRouterNetService.h"
#import "ExtentionHelper.h"

#import <Network/Network.h>
#import <commissioner/commissioner.hpp>

NSString* const TPServiceType = @"_meshcop._udp";

NSTimeInterval const TPTimeout = 15.0;

typedef void (^DiscoverCompletedBlock)(NSArray*);

@interface TPBorderAgentDiscover() <NSNetServiceBrowserDelegate, TPBorderRouterNetServiceDelegate>

@property (nonatomic, strong) NSNetServiceBrowser* serviceBrowser;
@property (nonatomic, strong) NSTimer* serviceTimeout;
@property (nonatomic, strong) NSMutableArray* services;
@property (nonatomic, copy, nullable) DiscoverCompletedBlock completedBlock;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, copy) dispatch_queue_t handleQueue;

@end

@implementation TPBorderAgentDiscover {
    NSMutableDictionary* _cache;
}

- (instancetype)init {
    if (self = [super init]) {
        _isSearching = FALSE;
        _serviceBrowser = [[NSNetServiceBrowser alloc] init];
        _handleQueue = dispatch_queue_create("com.tp.borderdiscover.handlequeue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (BOOL)findBorderRouterServiceWithCompleted:(void(^)(NSArray*))completedBlock {
    return [self findServiceWithIdentifier:TPServiceType andDomain:@"local." andCompleted:completedBlock];
}

- (BOOL)findServiceWithIdentifier:(NSString*)identifier andDomain:(NSString*)domain andCompleted:(void(^)(NSArray*))completedBlock {
    if (!_isSearching) {
        _cache = [NSMutableDictionary dictionary];
        _services = [NSMutableArray array];
        _serviceBrowser.delegate = self;
        _completedBlock = completedBlock;
        _serviceTimeout = [NSTimer timerWithTimeInterval:TPTimeout
                                                  target:self
                                                selector:@selector(noServiceFound)
                                                userInfo:NULL
                                                 repeats:FALSE];
        [_serviceBrowser searchForServicesOfType:identifier inDomain:domain];
        _isSearching = TRUE;
        return TRUE;
    }
    
    return FALSE;
}

- (void)noServiceFound {
    [_serviceBrowser stop];
    _isSearching = FALSE;
    
    for (TPBorderRouterNetService* service in _services) {
        service.delegate = NULL;
    }
    
    if (_completedBlock != NULL) {
        _completedBlock(_services);
        _completedBlock = NULL;
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    TPBorderRouterNetService* newService = [[TPBorderRouterNetService alloc] initWithNetService:service andDelegate:self];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_handleQueue, ^{
        typeof(self) strSelf = weakSelf;
        [strSelf->_cache setValue:newService forKey:newService.uuid];
        [strSelf.services addObject: newService];
        
        if (!moreComing) {
            [strSelf.serviceBrowser stop];
            strSelf.isSearching = FALSE;
        }
    });
}

- (void)netServiceDidResolveCompleted:(TPBorderRouterNetService*)borderRouterService {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_handleQueue, ^{
        typeof(self) strSelf = weakSelf;
        [strSelf->_cache removeObjectForKey:borderRouterService.uuid];
        if ([strSelf->_cache count] == 0 && !strSelf.isSearching) {
            [strSelf.serviceTimeout invalidate];
            strSelf.serviceTimeout = NULL;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strSelf.completedBlock != NULL) {
                    strSelf.completedBlock(strSelf.services);
                    strSelf.completedBlock = NULL;
                }
            });
        }
    });
}

@end
