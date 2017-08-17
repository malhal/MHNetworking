//
//  MHNRequestOptions.m
//  MHNetworking
//
//  Created by Malcolm Hall on 16/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MHNRequestOptions.h"

@implementation MHNRequestOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        _identifier = [NSUUID UUID].UUIDString;
        _qualityOfService = NSQualityOfServiceDefault;
    }
    return self;
}

- (NSURLRequest *)copyAndDecorateRequest:(NSURLRequest *)request{
    NSMutableURLRequest* request2 = [request mutableCopy];
    if(request2){
        if(self._timeoutIntervalForRequest > 0){
            request2.timeoutInterval = self._timeoutIntervalForRequest;
        }
    }
    return request2;
}

- (NSURLSessionConfiguration *)defaultSessionConfiguration{
    NSString *name = [self sessionConfigurationName];
    if(!name){
        return nil;
    }
    NSString *UUID = [NSUUID UUID].UUIDString;
    if(!UUID){
        return nil;
    }
    NSURLSessionConfiguration *config;
    if(self.outOfProcess){
        config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"%@:uuid:%@", name, UUID]];
        // set_allowsRetryForBackgroundDataTasks YES
    }
    else{
        config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    }
    config.URLCredentialStorage = nil;
    config.HTTPCookieStorage = nil;
    config.URLCache = nil;
    config.requestCachePolicy = NSURLCacheStorageAllowedInMemoryOnly;
//    config._TCPAdaptiveReadTimeout:0x3];
//    config._TCPAdaptiveWriteTimeout:0x3];
//    config._timingDataOptions:0x17];
    return config;
}

- (NSString *)sessionConfigurationName{
    NSMutableString *s = [NSMutableString string];
    if (self._sourceApplicationBundleIdentifier) {
        [s appendFormat:@"app=%@", self._sourceApplicationBundleIdentifier];
    }
    return s;
}

- (NSURLSessionConfiguration *)sessionConfiguration{
    NSURLSessionConfiguration *config = [self defaultSessionConfiguration];
    if(!config){
        return nil;
    }
    if(self.outOfProcess){
        config.discretionary = self.outOfProcessDiscretionary;
    }
    return config;
}

@end
