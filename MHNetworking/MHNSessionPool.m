//
//  MHNSessionPool.m
//  MHNetworking
//
//  Created by Malcolm Hall on 16/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MHNSessionPool.h"
#import "MHNLogFacilityWrapper.h"
#import "MHNRequestOptions.h"
//#import "MHNSession.h"

@implementation MHNSessionPool

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionConfigurationNameToPinnedSession = [NSMutableDictionary dictionary];
        _sessionConfigurationNameToUnpinnedSession = [NSMutableDictionary dictionary];
        if(!_sessionConfigurationNameToPinnedSession || !_sessionConfigurationNameToUnpinnedSession){
            mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_DEFAULT, "failed to create NSMutableDictionary for C2SessionPool");
        }
        _cleanUp_queue = dispatch_queue_create("c2-session-pool-cleanup", dispatch_queue_attr_make_with_autorelease_frequency(nil, DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM));
        if(!_cleanUp_queue){
            mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_DEFAULT, "failed to create dispatch_queue for C2SessionPool");
        }
    }else{
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_DEFAULT, "failed to create C2SessionPool");
    }
    return self;
}

- (MHNSessionTask *)createDataTaskWithRequestIdentifier:(NSString *)identifier request:(NSURLRequest *)request options:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionHandle:(NSURLSession **)sessionHandle{
    if(!identifier || !request || !options){
        return nil;
    }
    else if(!delegate){
        return nil;
    }
    NSString *host = request.URL.host;
    if(!host){
        return nil;
    }
    // if single configuration
    // nil everything and use shared identifier @"com.apple.cloudkit"
    MHNRequestOptions *options2 = [options copyAndDecorateRequest:request];
    if(!options2){
        return nil;
    }
    NSString *name = [options2 sessionConfigurationName];
    if(!name){
        return nil;
    }
    NSString *indentifier = [NSString stringWithFormat:@"host=%@:%@", host, name];
    MHNSession *session;
    @synchronized (self) {
        session = _sessionConfigurationNameToPinnedSession[indentifier];
        if(!session){
            if(!options2.tlsPinning){
                session = _sessionConfigurationNameToUnpinnedSession[indentifier];
            }
            if(!session){
                session = [[MHNSession alloc] initWithSessionIdentifier:indentifier options:options2 sessionDelegate:self];
                if(!session){
                    mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_DEFAULT, "%{public}@ can't create a new session with name: %{public}@", options2, request);
                    return nil;
                }
                else if(options2.tlsPinning){
                    _sessionConfigurationNameToPinnedSession[indentifier] = session;
                }
                else{
                    _sessionConfigurationNameToUnpinnedSession[indentifier] = session;
                }
            }
        }
    }
    MHNSessionTask *task = [session createTaskWithOptions:options2 delegate:delegate];
    return task;
}



@end
