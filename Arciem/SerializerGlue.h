//
//  SerializerGlue.h
//  Arciem
//
//  Created by Robert McNally on 7/22/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//

@import Foundation;

void dispatch_queue_set_specific_glue(dispatch_queue_t queue, NSString *key, NSNumber *context);
NSNumber *dispatch_get_specific_glue(NSString *key);
