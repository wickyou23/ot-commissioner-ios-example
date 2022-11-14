//
//  TPBorderAgentDiscoverer.h
//  TPOpenthreadCommissioner
//
//  Created by Thang Phung on 01/11/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPBorderAgentDiscover : NSObject

- (BOOL)findBorderRouterServiceWithCompleted:(void(^)(NSArray*))completedBlock;
- (BOOL)findServiceWithIdentifier:(NSString*)identifier andDomain:(NSString*)domain andCompleted:(void(^)(NSArray*))completedBlock;

@end

NS_ASSUME_NONNULL_END
