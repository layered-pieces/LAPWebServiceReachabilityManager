//
//  LAPWebServiceReachabilityManager.m
//  LAPWebServiceReachabilityManager
//
//  Created by Oliver Letterer on 01.11.13.
//  Copyright 2018 Layed Pieces gemeinnützige Unternehmergesellschaft. All rights reserved.
//

#import "LAPWebServiceReachabilityManager.h"

@interface NSUUID (LAPWebServiceReachabilityManagerToken) <LAPWebServiceReachabilityManagerToken>

@end

@interface LAPWebServiceReachabilityManager ()

@property (nonatomic, readonly) NSMutableDictionary<NSUUID *, void(^)(LAPWebServiceReachabilityManager *manager, LAPWebServiceReachabilityStatus status)> *observer;

@property (nonatomic, assign) LAPWebServiceReachabilityStatus status;
@property (nonatomic, nullable, strong) NSTimer *timer;

@end

@implementation LAPWebServiceReachabilityManager

#pragma mark - setters and getters

- (void)setStatus:(LAPWebServiceReachabilityStatus)status
{
    if (status != _status) {
        _status = status;
        
        [self.observer enumerateKeysAndObjectsUsingBlock:^(NSUUID * _Nonnull key, void (^ _Nonnull obj)(LAPWebServiceReachabilityManager *, LAPWebServiceReachabilityStatus), BOOL * _Nonnull stop) {
            obj(self, status);
        }];
    }
}

#pragma mark - initialisation

- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest timeInterval:(NSTimeInterval)timeInterval
{
    if (self = [super init]) {
        _urlRequest = urlRequest.copy;
        _timeInterval = timeInterval;
        _status = LAPWebServiceReachabilityStatusUnknown;
        _acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 200)];
        _observer = [NSMutableDictionary dictionary];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_stopMonitoring) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_startMonitoring) name:UIApplicationWillEnterForegroundNotification object:nil];

        [self _startMonitoring];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self _stopMonitoring];
}

#pragma mark - instance methods

- (id<LAPWebServiceReachabilityManagerToken>)addStatusObserver:(void(^)(LAPWebServiceReachabilityManager *manager, LAPWebServiceReachabilityStatus status))observer
{
    NSUUID *token = NSUUID.UUID;
    while (self.observer[token] != nil) {
        token = NSUUID.UUID;
    }
    
    self.observer[token] = observer;
    return token;
}

- (void)removeStatusObserver:(id<LAPWebServiceReachabilityManagerToken>)observerToken
{
    [self.observer removeObjectForKey:(NSUUID *)observerToken];
}

- (void)checkReachabilityWithCompletionHandler:(void(^ _Nullable)(LAPWebServiceReachabilityManager *manager, LAPWebServiceReachabilityStatus status))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:self.urlRequest
                                            completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if ([self.acceptableStatusCodes containsIndex:httpResponse.statusCode]) {
                                                        self.status = LAPWebServiceReachabilityStatusReachable;
                                                    } else {
                                                        self.status = LAPWebServiceReachabilityStatusNotReachable;
                                                    }
                                                    
                                                    if (completionHandler) {
                                                        completionHandler(self, self.status);
                                                    }
                                                });
                                            }];
    
    [task resume];
}

#pragma mark - private category implementation ()

- (void)_startMonitoring
{
    assert(NSThread.currentThread.isMainThread);
    assert(self.timer == nil);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(_checkReachability) userInfo:nil repeats:YES];
    [self checkReachabilityWithCompletionHandler:nil];
}

- (void)_stopMonitoring
{
    assert(NSThread.currentThread.isMainThread);
    [self.timer invalidate]; self.timer = nil;
}

- (void)_checkReachability
{
    [self checkReachabilityWithCompletionHandler:nil];
}

@end
