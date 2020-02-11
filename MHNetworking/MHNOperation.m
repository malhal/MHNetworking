//
//  MHNOperation.m
//  MHNetworking
//
//  Created by Malcolm Hall on 13/08/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MHNOperation.h"
#import "MHNInternalError.h"

@implementation MHNOperation

- (void)start{
    // "[Operation %p] Starting operation"
    // "Starting <%{public}@: %p; %{public}@, %@>"
    // metrics
    if(self.cancelled){
        // "[Operation %p] Operation is already cancelled and finished but it tried to start again"
    }
    
}

-(void)_determineNetworkServiceType{
    // operationInfo.group
    // expectedSendSize expectedReceiveSize]
    // "[Operation %p] Determining Network Service Types"
    // "Determining Network Service Types"
    // setAllowsCellularAccess depending on sizes
    // "Determined Network Service Type %@"
    // handleCheckpointForOperationWithID
    // else  "Using pre-determined Network Service Type %@"
    [self _continueOperationStart];
    
}
- (void)_continueOperationStart{
    if(self.isCancelled){
        //"[Operation %p] Operation was cancelled before it could start"
        MHNInternalError *error = [MHNInternalError errorWithCode:0x1 format:@"Operation %@ was cancelled", self];
        [self finishWithError:error];
        return;
    }
    // "[Operation %p] Continuing operation start"
    [self _registerAttemptForOperation];
    //  "Invoking main for operation <%{public}@: %p; %{public}@, %@>"
    [self main];
}

- (void)_registerAttemptForOperation{
    
}

- (void)finishWithError:(NSError *)error{
    
}

@end
