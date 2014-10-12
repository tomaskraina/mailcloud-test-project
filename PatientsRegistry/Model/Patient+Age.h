//
//  Patient+Age.h
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import "Patient.h"

extern NSInteger const PatientAgeUnknown;

@interface Patient (Age)
@property (nonatomic, readonly) NSInteger age;
@end
