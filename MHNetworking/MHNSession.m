//
//  MHNSession.m
//  MHNetworking
//
//  Created by Malcolm Hall on 17/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MHNSession.h"
#import "MHNLogFacilityWrapper.h"
#import "MHNRequestOptions.h"
#import "MHNSessionTask.h"

@implementation MHNSession

- (MHNSession *)initWithSessionIdentifier:(NSString *)identifier options:(MHNRequestOptions *)options sessionDelegate:(id<MHNSessionDelegate>)sessionDelegate{
    self = [super init];
    if (self) {
        if(!identifier || !options || !sessionDelegate){
            mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "missing required arguments - [C2Session initWithSessionIdentifier:%@ options:%@ sessionDelegate:%@]", identifier, options, sessionDelegate);
        }
        [options sessionConfiguration];
        
    }
    return self;
}

- (void)willCreateTask{
    @synchronized (self) {
        _creatingTaskCounter++;
    }
}

- (MHNSessionTask *)createTaskWithOptions:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate{
    
    mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_DEBUG, "[%{public}@ createDataTaskWithOptions:%{public}@ delegate:%{public}@]", self, options, delegate);
    if(!options || !delegate){
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "missing required arguments - [%{public}@ createTaskWithOptions:%{public}@ delegate:%{public}@]", self, options, delegate);
        return nil;
    }
    NSAssert([[_options sessionConfigurationName] isEqualToString:[options sessionConfigurationName]], @"Sanity check, session configuration name of session and task should always match.");
    MHNSessionTask *task = [[MHNSessionTask alloc] initWithOptions:options delegate:delegate sessionTaskDelegate:self];
    
    return task;
}

@end
