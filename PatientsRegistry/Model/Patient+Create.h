//
//  Patient+Create.h
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import "Patient.h"

@interface Patient (Create)

typedef NS_ENUM(NSInteger, PatientGender) {
    PatientGenderUnknown,
    PatientGenderMale,
    PatientGenderFemale
};

+ (Patient *)patientWithName:(NSString *)name
                       birth:(NSDate *)birth
                      gender:(PatientGender)gender
                        note:(NSString *)note
      inManagedObjectContext:(NSManagedObjectContext *)context;


@end
