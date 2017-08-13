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
#import "MHNStreamWriter.h"
#import "MHNJSONStreamWriter.h"

@interface MHNURLRequest()

- (void)_performRequest;
- (id)_errorFromHTTPResponse:(id)arg1;
- (void)_loadRequest:(id)arg1;
- (CDUnknownBlockType)_xmlObjectParsedBlock;
- (void)_finishOnLifecycleQueueWithError:(NSError *)error;
- (BOOL)_onLifecycleQueue;
- (void)_tearDownStreamWriter;
- (void)_registerRequestOperationTypesForOperations:(id)arg1;

@end

@implementation MHNURLRequest{
    NSArray *_requestOperations; // or synthesize
    //MHNStreamWriter *_streamWriter;
    BOOL _didSendRequest;
}

@synthesize streamWriter = _streamWriter;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpMethod = @"POST";
        _requestUUID = [NSUUID UUID].UUIDString;
    }
    return self;
}

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

- (id)generateRequestOperations{
    NSAssert(NO, @"To be overridden by subclass");
    return nil;
}

- (NSArray *)requestOperations{
    if(!_requestOperations.count){
        _requestOperations = [self generateRequestOperations];
    }
    return _requestOperations;
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
    return dispatch_get_specific((__bridge const void * _Nonnull)(self.lifecycleQueue)) != nil;
}

- (NSInputStream *)requestBodyStream{
    NSArray *operations = self.requestOperations;
    if(!operations.count){
        if(os_log_type_enabled(OS_LOG_DEFAULT, OS_LOG_TYPE_ERROR)){
            os_log_error(OS_LOG_DEFAULT, "[Request %p] Not returning a request body stream because there are no items to stream", self);
        }
        MHNInternalError* error = [MHNInternalError errorWithCode:0x7d5 format:@"there is no operation associated with this request"];
        [self finishWithError:error];
        return nil;
    }
    //[self _tearDownStreamWriter]; // if they set it we don't want to clear it
    [self _registerRequestOperationTypesForOperations:operations];
    [self.streamWriter setStreamedObjects:nil];
    return [self.streamWriter open];
}

- (MHNStreamWriter *)streamWriter{
    if(!_streamWriter){
        _streamWriter = [[MHNJSONStreamWriter alloc] initWithCompression:NO];
        // _streamWriter setLogRequestObjectBlock
    }
    return _streamWriter;
}

- (void)_tearDownStreamWriter{
    @synchronized (self) {
        if(_streamWriter){
            _streamWriter = nil;
        }
    }
}

- (void)dealloc
{
    [self _tearDownStreamWriter];
    NSAssert(self.isFinished || !_didSendRequest, @"<%@ %p>: Requests must be finished before deallocation", NSStringFromClass([self class]), self);
    NSAssert(!self.urlSessionTask, @"<%@ %p>: The URL session data task should be nil: %p", NSStringFromClass([self class]), self, self.urlSessionTask);
}

@end
