//
//  MHNPrettyError.h
//  MHNetworking
//
//  Created by Malcolm Hall on 12/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHNPrettyError : NSError

+ (id)errorWithCode:(NSInteger)arg1 format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);

@end
