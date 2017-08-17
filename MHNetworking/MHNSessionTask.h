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

- (id)initWithOptions:(MHNRequestOptions *)options delegate:(id<MHNRequestDelegate>)delegate sessionTaskDelegate:(id<MHNSessionDelegate>)sessionTaskDelegate;

@end
