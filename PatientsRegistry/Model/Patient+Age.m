//
//  Patient+Age.m
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import "Patient+Age.h"

NSInteger const PatientAgeUnknown = -1;

@implementation Patient (Age)

- (NSInteger)age
{
    if (!self.birth) {
        return PatientAgeUnknown;
    }
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                       fromDate:self.birth
                                                                         toDate:[NSDate date]
                                                                        options:0];
    
    return [dateComponents year];
}

@end
