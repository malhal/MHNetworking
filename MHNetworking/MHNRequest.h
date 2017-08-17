//
//  MHNRequest.h
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <MHNetworking/MHNCodable.h>

@interface MHNRequest : MHNCodable

- (unsigned int)requestTypeCode;
- (Class)responseClass;

@end
