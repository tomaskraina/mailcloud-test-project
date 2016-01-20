iOS Developer Exercise
=======================

*Patients Registry*

All systems at the hospital went bust. We need to quickly write a patients registry app that will allow doctors and staff keep track of incoming patients.

*Functional Requirements*

The app will need to have 3 features:

- Add a Patient (Name, Birth, Gender, Note)
- Display Patients list (Name, Age)
- Delete Patient from list
- Display Patient's details (Name, Birth, Gender, Note)

*Other Requirements*

- Responsive/Adaptive user interface, so it can be used on iPads and iPhones
- Written in Swift or Objective-C

Implementation
---------------------
- Minimum Viable Product that fulfills all requirements
- Written in Objective-C
- Uses CoreData as a persistent storage for patients records
- Uses auto layout constraints
- Utilizes adaptive design, specific constraints are configured for size class `w-Any h-Compact` (all iPhones in landscape)
- Usage of adaptive design is inspired by Apple's code sample "AdaptivePhotos"
- Most of the CoreData code is from the CoreData Xcode template