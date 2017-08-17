//
//  MHNProtocolTranslator.h
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//
// class to have properties used in all the conversions from the app classes to the transport classes.
// because we don't always have a subclass to put a toDictionary method in.

#import <Foundation/Foundation.h>

@interface MHNProtocolTranslator : NSObject

- (id)pObjectFromObject:(id)object error:(NSError **)error;

@end
