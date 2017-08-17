//
//  MHNSession.h
//  MHNetworking
//
//  Created by Malcolm Hall on 17/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MHNetworking/MHNRequestDelegate.h>
#import <MHNetworking/MHNSessionTask.h>

@class MHNRequestOptions, MHNSession;

@protocol MHNSessionDelegate <NSObject>

- (void)MHNSession:(MHNSession *)session didBecomeInvalidWithError:(NSError *)error;

@end

@interface MHNSession : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, MHNRequestDelegate, MHNSessionDelegate, MHNSessionTaskDelegate> // NSURLSessionTaskDelegatePrivate, NSURLSessionDataDelegatePrivate

- (MHNSession *)initWithSessionIdentifier:(NSString *)identifier options:(MHNRequestOptions *)options sessionDelegate:(id<MHNSessionDelegate>)sessionDelegate;

@property (nonatomic) NSUInteger creatingTaskCounter;
@property (readonly, copy, nonatomic) MHNRequestOptions *options;
@property (readonly, nonatomic) NSURLSession *session;
@property (readonly, nonatomic) NSMutableDictionary *wrappedTaskByTaskDescription;
@property (nonatomic) double emptyTimestamp;
@property (nonatomic) BOOL isComplete;

- (void)willCreateTask;
- (MHNSessionTask *)createTaskWithOptions:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate;
- (id)addTask:(MHNSessionTask *)task withDescription:(NSString *)description request:(NSURLRequest *)request;
- (void)removeTask:(MHNSessionTask *)task;

@end

