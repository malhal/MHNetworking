//
//  MHNSessionTask.m
//  MHNetworking
//
//  Created by Malcolm Hall on 17/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

@import os.activity;
#import "MHNSessionTask.h"
#import "MHNLogFacilityWrapper.h"

@implementation MHNSessionTask{
    os_activity_t _activity;
}

- (id)initWithOptions:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionTaskDelegate:(id<MHNSessionTaskDelegate>)sessionTaskDelegate{
    if(!options || !delegate || !sessionTaskDelegate){
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "missing required arguments - [C2SessionTask initWithOptions:%{public}@ delegate:%{public}@ sessionTaskDelegate:%{public}@]", options, delegate, sessionTaskDelegate);
        return nil;
    }
    self = [super init];
    if(self){
        _options = options;
        _delegate = delegate;
        _sessionTaskDelegate = sessionTaskDelegate;
        _activity = os_activity_create("mhn-request-task", OS_ACTIVITY_CURRENT, 0);
        if(!_activity){
            mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "failed to create os_activity for MHNSessionTask");
        }
    }
    if (!_activity) {
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "failed to create MHNSessionTask");
        _isComplete = YES;
        return nil;
    }
    return self;
}

@end
