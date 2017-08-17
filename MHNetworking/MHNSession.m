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
    if(!task){
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "%{public}@ can't create a new wrapped data task in session %{public}@", self, _session);
        return nil;
    }
    return task;
}

- (id)addTask:(MHNSessionTask *)task withDescription:(NSString *)description request:(NSURLRequest *)request{
    NSAssert(task, @"task must not be nil.");
    NSAssert(description, @"taskDescription must not be nil.");
    NSAssert(request, @"request must not be nil.");
    NSURLSessionDataTask *dataTask;
    @synchronized (self) {
        NSAssert(self.wrappedTaskByTaskDescription[description], @"A delegate for task %@ has already been set: %@", task, self.wrappedTaskByTaskDescription[description]);
        self.wrappedTaskByTaskDescription[description] = task;
        NSAssert(self.wrappedTaskByTaskDescription[description], @"invariant broken.");
        //[self _recalculateSessionDelegateQueuePriority]
        _emptyTimestamp = 0;
        dataTask = [_session dataTaskWithRequest:request];
        if(dataTask){
            mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_DEFAULT,  "[%{public}@ addTask:%{public}@ withDescription:%{public}@ request:%{public}@]", self, dataTask, description, request);
            dataTask.taskDescription = description;
            task.task = dataTask;
        }
    }
    if(!dataTask){
        mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "%{public}@ can't create a new data task with request %{public}@ in session %{public}@", self, dataTask, self);
        [self removeTask:task];
    }
    return dataTask;
}

- (void)removeTask:(MHNSessionTask *)task{
    NSAssert(task, @"task must not be nil.");
    NSString *taskDescription = [task taskDescription];
    NSAssert(taskDescription, @"taskDescription must not be nil.");
    mhn_log_with_type(mhn_log_facility_pool, OS_LOG_TYPE_ERROR, "[%@ removeTask:%@] - withDescription:%@", self, task, taskDescription);
    @synchronized (self) {
        MHNSessionTask *wrappedTask = _wrappedTaskByTaskDescription[taskDescription];
        NSAssert(wrappedTask == task, @"taskDescription(%@) should be map to task (%@) but mapped to (%@) ", taskDescription, task, wrappedTask);
        //[self _recalculateSessionDelegateQueuePriority];
            
        if(!_wrappedTaskByTaskDescription.count){
            //CFAbsoluteTimeGetCurrent();
        }
    }
    [self cleanupRetainCycle];
}

- (void)cleanupRetainCycle{
    @synchronized (self) {
        if(_isComplete){
            if([self  wrappedTaskByTaskDescription]){
                
            }
        }
    }
}

@end
