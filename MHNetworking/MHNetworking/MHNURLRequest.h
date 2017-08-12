typedef void (^CDUnknownBlockType) ();
//
//  MHNURLRequest.h
//  MHNetworking
//
//  Created by Malcolm Hall on 12/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CKDResponseBodyParser;

@interface MHNURLRequest : NSObject

@property (readonly) BOOL isFinished;
@property (strong) NSError *error;
@property (getter=isCancelled) BOOL cancelled;
@property (strong) NSURLRequest *request;
@property (readonly, nonatomic) NSURL *url;
@property (strong) NSURLSession *urlSession;
@property (strong) NSURLSessionDataTask *urlSessionTask;
@property (readonly, nonatomic) BOOL usesBackgroundSession;
@property (readonly, nonatomic) NSString *httpMethod;
@property (strong, nonatomic) CKDResponseBodyParser *responseBodyParser;
@property (nonatomic) BOOL didReceiveResponseBodyData;
@property (readonly, nonatomic) BOOL expectsResponseBody;
@property (strong) NSHTTPURLResponse *response;
@property (readonly, nonatomic) NSDictionary *responseHeaders;
@property (strong, nonatomic) NSMutableSet *responseObjectUUIDs;
@property (copy, nonatomic) CDUnknownBlockType responseProgressBlock;
@property (readonly, nonatomic) NSInteger responseStatusCode;
@property (readonly, nonatomic) BOOL hasRequestBody;
@property (readonly, nonatomic) NSString *requestContentType;
@property (readonly, nonatomic) NSArray *requestOperationClasses;
@property (readonly, nonatomic) NSArray *requestOperations; // @synthesize requestOperations=_requestOperations;
@property (copy, nonatomic) CDUnknownBlockType requestProgressBlock;
@property (strong, nonatomic) NSDictionary *requestProperties;
@property (readonly, nonatomic) NSString *requestUUID;
@property (strong, nonatomic) dispatch_queue_t lifecycleQueue;
@property (copy, nonatomic) CDUnknownBlockType completionBlock;

- (void)performRequest;
- (id)defaultParserForContentType:(id)arg1;
- (id)generateRequestOperations;
- (id)operationRequestWithType:(int)arg1;
- (void)prepareRequestWithCompletion:(CDUnknownBlockType)arg1;
- (void)requestDidParse509CertObject:(NSData *)object;
- (void)requestDidParseJSONObject:(id)arg1;
- (void)requestDidParseNodeFailure:(id)arg1;
- (void)requestDidParsePlaintextObject:(NSData *)object;
- (void)requestDidParsePlistObject:(id)arg1;
- (id)requestDidParseProtobufObject:(id)arg1;
- (void)finishWithError:(NSError *)error;
- (BOOL)markAsFinished;
- (void)performOnLifecycleQueueIfNotFinished:(CDUnknownBlockType)arg1;
- (id)ckShortDescription;
- (void)cancel;

@end
