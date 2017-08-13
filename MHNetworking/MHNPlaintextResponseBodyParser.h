//
//  MHNPlaintextResponseBodyParser.h
//  MHNetworking
//
//  Created by Malcolm Hall on 12/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <MHNetworking/MHNResponseBodyParser.h>

@interface MHNPlaintextResponseBodyParser : MHNResponseBodyParser

- (void)finishWithCompletion:(CDUnknownBlockType)arg1;
- (void)processData:(id)arg1;

@end
