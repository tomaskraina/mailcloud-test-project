//
//  Patient+Create.m
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import "Patient+Create.h"

@implementation Patient (Create)
+ (Patient *)patientWithName:(NSString *)name
                       birth:(NSDate *)birth
                      gender:(PatientGender)gender
                        note:(NSString *)note
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    Patient *patient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
                                                     inManagedObjectContext:context];
    patient.name = name;
    patient.birth = birth;
    patient.gender = @(gender);
    patient.note = note;
    patient.created = [NSDate date];
    
    return patient;
}

@end
