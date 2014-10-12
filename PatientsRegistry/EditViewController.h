//
//  EditViewController.h
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Patient.h"

@interface EditViewController : UIViewController
@property (strong, nonatomic) Patient *patient;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 * Use this method for configure this view controller in prepareForSegue:
 */
- (void)configureWithPatient:(Patient *)patient managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
