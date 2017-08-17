//
//  MHNSessionTask.h
//  MHNetworking
//
//  Created by Malcolm Hall on 17/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHNSession, MHNRequestOptions, MHNSessionTask;
@protocol MHNSessionDelegate, MHNRequestDelegate;

@protocol MHNSessionTaskDelegate <NSObject>
- (void)MHNSession:(MHNSession *)session task:(MHNSessionTask *)task didCompleteWithError:(NSError *)error;
@end

@interface MHNSessionTask : NSObject <MHNSessionTaskDelegate>

- (id)initWithOptions:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionTaskDelegate:(id<MHNSessionTaskDelegate>)sessionTaskDelegate;

@property (readonly, nonatomic) id<MHNRequestDelegate> delegate;
@property (nonatomic) BOOL isComplete;
@property (readonly, copy, nonatomic) MHNRequestOptions *options;
@property (strong, nonatomic) id<MHNSessionTaskDelegate> sessionTaskDelegate;
@property (strong, nonatomic) NSURLSessionDataTask *task;

- (NSString *)taskDescription;

@end
