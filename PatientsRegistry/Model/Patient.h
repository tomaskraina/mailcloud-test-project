//
//  Patient.h
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSDate * birth;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;

@end
