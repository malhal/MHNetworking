//
//  MHNURLRequest.m
//  MHNetworking
//
//  Created by Malcolm Hall on 12/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

@import os.log;
#import "MHNURLRequest.h"
#import "MHNPlaintextResponseBodyParser.h"
#import "MHNInternalError.h"

@interface MHNURLRequest()

- (void)_performRequest;
- (id)_errorFromHTTPResponse:(id)arg1;
- (void)_loadRequest:(id)arg1;
- (CDUnknownBlockType)_xmlObjectParsedBlock;
- (void)_finishOnLifecycleQueueWithError:(NSError *)error;
- (BOOL)_onLifecycleQueue;

@end

@implementation MHNURLRequest

- (void)performRequest{
    
}

- (id)defaultParserForContentType:(NSString *)contentType{
    // rangeOfString @"application/x-protobuf"
    //
    
    MHNPlaintextResponseBodyParser *parser = [[MHNPlaintextResponseBodyParser alloc] init];
    __weak typeof(self) weakSelf = self;
    parser.objectParsedBlock = ^(id object, NSError *error) {
        [weakSelf performOnLifecycleQueueIfNotFinished:^{
            //weakSelf._xmlObjectParsedBlock();
            [weakSelf requestDidParsePlaintextObject:object];
        }];
    };
    return parser;
}

- (void)requestDidParsePlaintextObject:(NSData *)object{
    NSString *s = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
    
    MHNInternalError *error = [MHNInternalError errorWithCode:1005 format:@"Received a plaintext response that we weren't expecting: %@", s];
    [self _finishOnLifecycleQueueWithError:error];
}
                              
- (void)_finishOnLifecycleQueueWithError:(NSError *)error{
    // _wrapErrorIfNecessary
    if(os_log_type_enabled(OS_LOG_DEFAULT, OS_LOG_TYPE_ERROR)){
        os_log_error(OS_LOG_DEFAULT, "[Request %p] Finishing request with error %p", self, error);
    }
    if([self markAsFinished]){
        if(self.isCancelled) {
            MHNInternalError *error = [MHNInternalError errorWithCode:1 format:@"Request %@ was cancelled", self.requestUUID];
        }
        if(self.completionBlock){
            if(os_log_type_enabled(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG)){
                os_log(OS_LOG_DEFAULT, "[Request %p] Calling completion block", self);
            }
            self.completionBlock();
            self.completionBlock = nil;
        }
        self.requestProgressBlock = nil;
        self.responseProgressBlock = nil;
        if(os_log_type_enabled(OS_LOG_DEFAULT, OS_LOG_TYPE_DEBUG)){
            os_log(OS_LOG_DEFAULT, "[Request %p] Did finish", self);
        }
    }
    else{
//        if(os_log_type_enabled(ck_log, OS_LOG_TYPE_DEBUG)){
//            os_log(ck_log, "req: %{public}@, \"Warn: %@, request %@ was already marked as finished\"", self.requestUUID, NSStringFromSelector(_cmd), [self ckShortDescription]);
//        }
        
    }
    // "[Request %p] Finishing request with no error"
}

- (void)finishWithError:(NSError *)error{
    if([self _onLifecycleQueue]){
        [self _finishOnLifecycleQueueWithError:error];
    }
    else{
        dispatch_sync(self.lifecycleQueue, ^{
            [self _finishOnLifecycleQueueWithError:error];
        });
    }
}

- (void)requestDidParse509CertObject:(NSData *)object{
    MHNInternalError *error = [MHNInternalError errorWithCode:1005 format:@"Received a 509 cert response that we weren't expecting: %@", object];
    [self _finishOnLifecycleQueueWithError:error];
}

- (BOOL)_onLifecycleQueue{
    return dispatch_get_specific((__bridge const void * _Nonnull)(self.lifecycleQueue));
}

@end
