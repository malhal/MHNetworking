//
//  MHNCodable.h
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHNCodable : NSObject

@property (readonly, nonatomic) NSData *data;

+ (id)options;
+ (BOOL)supportsSecureCoding;
- (id)dictionaryRepresentation;
- (void)encodeWithCoder:(id)arg1;
- (id)formattedText;
- (id)init;
- (id)initWithCoder:(id)arg1;
- (id)initWithData:(id)arg1;
- (BOOL)readFrom:(id)arg1;
- (void)writeTo:(id)arg1;

@end
