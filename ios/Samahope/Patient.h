//
//  Patient.h
//  Samahope
//
//  Created by Sarat Tallamraju on 3/4/15.
//  Copyright (c) 2015 Samahope Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patient : NSObject

#pragma mark Constructors
- (id)initWithDictionary: (NSDictionary *)dictionary;

#pragma mark Core Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageUrlString;
@property (nonatomic, strong) NSString *personalDescription;

@end
