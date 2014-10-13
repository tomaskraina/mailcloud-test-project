//
//  EditViewController.m
//  PatientsRegistry
//
//  Created by Tom K on 12/10/14.
//  Copyright (c) 2014 Tom Kraina. All rights reserved.
//

#import "EditViewController.h"

#import "Patient+Create.h"

@interface EditViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

// to scroll text input when keyboard is displayed
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIView<UITextInput> *activeTextInput;
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
        self.navigationItem.title = NSLocalizedString(@"Edit patient", nil);
        
        self.nameTextField.text = self.patient.name;
        self.noteTextView.text = self.patient.note;
        self.genderSegmentedControl.selectedSegmentIndex = [self segmentedControlValueForPatient:self.patient];
        if (self.patient.birth) {
            self.birthDatePicker.date = self.patient.birth;
        }
    }
    else {
        self.navigationItem.title = NSLocalizedString(@"New patient", nil);
    }
}

#pragma mark - UIViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Set date of birth in the future should not be possible
    self.birthDatePicker.maximumDate = [NSDate date];
    
    // Add gesture recognizer to dismiss keyboard when tapped outside text input
    UITapGestureRecognizer* tapBackground = [ [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tapBackground.numberOfTapsRequired = 1;
    tapBackground.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapBackground];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)save:(id)sender
{
    // Validation
    if (![self validateUserInput]) return;
    
    // Update model object
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
    
    // reconfigure view for saved patient
    [self configureView];
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

- (BOOL)validateUserInput
{
    // Simple validation logic
    // for more complex validation perhaps "Managed Object Validation" should be used
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdValidation.html
    if (self.nameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing name", nil)
                                    message:NSLocalizedString(@"Enter patient's name", nil) delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          otherButtonTitles:nil] show];
        return NO;
    }
    
    return YES;
}

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

#pragma mark - keyboard and text input handlers
// more info in Apple's doc
// https://developer.apple.com/Library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// TODO: make sure the textview is not taller than the visible area above keyboard
// (important on iphone in landscape mode)

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextInput.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextInput.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextInput = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextInput = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.activeTextInput = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeTextInput = nil;
}

@end
