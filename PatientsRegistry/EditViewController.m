//
//  EditViewController.m
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import "EditViewController.h"

#import "Patient+Create.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation EditViewController

typedef NS_ENUM(NSInteger, EditViewControllerGenderSegmentedControlValue) {
    EditViewControllerGenderUnknown = UISegmentedControlNoSegment,
    EditViewControllerGenderMale = 0,
    EditViewControllerGenderFemale = 1
};

#pragma mark - Properties

- (void)configureWithPatient:(Patient *)patient managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self.managedObjectContext = managedObjectContext;
    self.patient = patient;
}

- (void)setPatient:(Patient *)newPatient
{
    if (_patient != newPatient) {
        _patient = newPatient;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.patient) {
        self.nameTextField.text = self.patient.name;
        self.noteTextView.text = self.patient.note;
        self.genderSegmentedControl.selectedSegmentIndex = [self segmentedControlValueForPatient:self.patient];
        if (self.patient.birth) {
            self.birthDatePicker.date = self.patient.birth;
        }
    }
}

#pragma mark - UIViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)save:(id)sender
{
    if (self.patient) {
        self.patient.name = self.nameTextField.text;
        self.patient.birth = self.birthDatePicker.date;
        self.patient.gender = @([self patientGenderFromSegmentedControlValue:self.genderSegmentedControl.selectedSegmentIndex]);
        self.patient.note = self.noteTextView.text;
    }
    else {
        self.patient = [Patient patientWithName:self.nameTextField.text
                                          birth:self.birthDatePicker.date
                                         gender:[self patientGenderFromSegmentedControlValue:self.genderSegmentedControl.selectedSegmentIndex]
                                           note:self.noteTextView.text
                         inManagedObjectContext:self.managedObjectContext];
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - convenience methods

- (EditViewControllerGenderSegmentedControlValue)segmentedControlValueForPatient:(Patient *)patient
{
    switch ((PatientGender)[patient.gender integerValue]) {
        case PatientGenderMale:
            return EditViewControllerGenderMale;
        
        case PatientGenderFemale:
            return EditViewControllerGenderFemale;
            
        default:
            return EditViewControllerGenderUnknown;
    }
}

- (PatientGender)patientGenderFromSegmentedControlValue:(EditViewControllerGenderSegmentedControlValue)value
{
    switch (value) {
        case EditViewControllerGenderMale:
            return PatientGenderMale;
            
        case EditViewControllerGenderFemale:
            return PatientGenderFemale;
            
        default:
            return PatientGenderUnknown;
    }
}

@end
