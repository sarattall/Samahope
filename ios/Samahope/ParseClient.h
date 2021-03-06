//
//  ParseClient.h
//  Samahope
//
//  Created by Sarat Tallamraju on 3/4/15.
//  Copyright (c) 2015 Samahope Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseClient : NSObject

+ (ParseClient *)sharedInstance;

- (void)saveUser:(NSDictionary *)fbUser completion:(void (^)(BOOL succeeded, NSError *error))completion;

- (void)getUserById:(NSString *)fbUserId completion:(void (^)(BOOL succeeded, NSError *error))completion;

@end
