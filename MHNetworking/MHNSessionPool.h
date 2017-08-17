//
//  MHNSessionPool.h
//  MHNetworking
//
//  Created by Malcolm Hall on 16/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MHNetworking/MHNSession.h>

@class MHNRequestOptions, MHNSessionTask;
@protocol MHNRequestDelegate;

@interface MHNSessionPool : NSObject <MHNSessionDelegate>

@property (nonatomic) dispatch_queue_t cleanUp_queue;
@property (strong, nonatomic) NSMutableDictionary *sessionConfigurationNameToPinnedSession;
@property (strong, nonatomic) NSMutableDictionary *sessionConfigurationNameToUnpinnedSession;

- (MHNSessionTask *)createDataTaskWithRequestIdentifier:(NSString *)identifier request:(NSURLRequest *)request options:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionHandle:(NSURLSession **)sessionHandle;
    
@end
