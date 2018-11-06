//
//  LAPWebServiceReachabilityManager.h
//  LAPWebServiceReachabilityManager
//
//  Created by Oliver Letterer on 01.11.13.
//  Copyright 2018 Layed Pieces gemeinnützige Unternehmergesellschaft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LAPWebServiceReachabilityStatus) {
    LAPWebServiceReachabilityStatusUnknown          = -1,
    LAPWebServiceReachabilityStatusNotReachable     = 0,
    LAPWebServiceReachabilityStatusReachable        = 1,
};

NS_ASSUME_NONNULL_BEGIN

@protocol LAPWebServiceReachabilityManagerToken <NSObject>

@end

__attribute__((objc_subclassing_restricted))
@interface LAPWebServiceReachabilityManager : NSObject

@property (nonatomic, readonly) LAPWebServiceReachabilityStatus status;
@property (nonatomic, readonly) NSURLRequest *urlRequest;
@property (nonatomic, readonly) NSTimeInterval timeInterval;

@property (nonatomic, strong) NSIndexSet *acceptableStatusCodes;

- (id<LAPWebServiceReachabilityManagerToken>)addStatusObserver:(void(^)(LAPWebServiceReachabilityManager *manager, LAPWebServiceReachabilityStatus status))observer;
- (void)removeStatusObserver:(id<LAPWebServiceReachabilityManagerToken>)observerToken;

- (instancetype)init NS_DESIGNATED_INITIALIZER NS_UNAVAILABLE;
- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest timeInterval:(NSTimeInterval)timeInterval NS_DESIGNATED_INITIALIZER;

- (void)checkReachabilityWithCompletionHandler:(void(^ _Nullable)(LAPWebServiceReachabilityManager *manager, LAPWebServiceReachabilityStatus status))completionHandler;

@end

NS_ASSUME_NONNULL_END
