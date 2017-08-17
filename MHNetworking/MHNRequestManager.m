//
//  MHNRequestManager.m
//  MHNetworking
//
//  Created by Malcolm Hall on 16/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MHNRequestManager.h"
#import "MHNSessionPool.h"
#import "MHNLogFacilityWrapper.h"
#import "MHNRequestOptions.h"

@implementation MHNRequestManager

+ (instancetype)sharedManager {
    static MHNRequestManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MHNRequestManager alloc] init];
        NSAssert(sharedManager, @"Failed to alloc/init MHNRequestManager, crash.");
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionPool = [[MHNSessionPool alloc] init];
        if(!_sessionPool){
            mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "failed to create MHNSessionPool for MHNRequestManager");
        }
    }else{
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "failed to create MHNRequestManager");
    }
    return self;
}

- (id)createDataTaskWithRequest:(NSURLRequest *)request options:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate{
    return [self createDataTaskWithRequest:request options:options delegate:delegate sessionHandle:nil];
}

- (id)createDataTaskWithRequest:(NSURLRequest *)request options:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionHandle:(NSURLSession **)sessionHandle{
    /// CFAbsoluteTimeGetCurrent();
    return [self.sessionPool createDataTaskWithRequestIdentifier:options.identifier request:request options:options delegate:delegate sessionHandle:sessionHandle];
}

@end
