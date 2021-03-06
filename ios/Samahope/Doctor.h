//
//  Doctor.h
//  Samahope
//
//  Created by Sarat Tallamraju on 3/4/15.
//  Copyright (c) 2015 Samahope Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fund.h"
#import "Patient.h"
#import "Focus.h"

@interface Doctor : NSObject

#pragma mark Constructors
- (id)initWithDictionary: (NSDictionary *)dictionary;

#pragma mark Core Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageUrlString;
@property (nonatomic, strong) NSString *tagLine;
@property (nonatomic, strong) NSString *personalDescription;
@property (nonatomic, strong) NSString *parentOrganization;
@property (nonatomic, strong) NSArray *patients;

#pragma mark Foreign Properties
@property (nonatomic, strong) Fund *fund;
@property (nonatomic, strong) NSArray *focuses;

#pragma mark Optional Properties
@property (nonatomic, strong) NSString *fullScreenImageUrlString;
@property (nonatomic, strong) NSString *videoUrlString;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *humanReadableLocation;

@end
