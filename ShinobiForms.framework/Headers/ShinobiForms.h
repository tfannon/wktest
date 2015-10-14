//
//  ShinobiForms.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

// Form.
#import "ShinobiForm.h"
#import "SFormView.h"
#import "SFormDelegate.h"

// View Builder.
#import "SFormFormViewBuilder.h"
#import "SFormFieldViewBuilder.h"

// Form elements.
#import "SFormSection.h"
#import "SFormSectionView.h"
#import "SFormTextField.h"
#import "SFormChoiceField.h"
#import "SFormNumberField.h"
#import "SFormEmailField.h"
#import "SFormDateField.h"
#import "SFormSegmentedFieldView.h"
#import "SFormTextFieldView.h"
#import "SFormDateFieldView.h"
#import "SFormRangedNumberField.h"
#import "SFormSliderFieldView.h"
#import "SFormPickerField.h"
#import "SFormPickerFieldView.h"
#import "SFormSubmitButton.h"
#import "SFormBooleanField.h"
#import "SFormSwitchFieldView.h"

// Input Elements.
#import "SFormTextInputElement.h"

// Validation.
#import "SFormInvalidMessageProvider.h"
#import "SFormFieldGroup.h"

// Validation Util.
#import "SFormTextFieldValidators.h"
#import "SFormRangedNumberFieldValidators.h"
#import "SFormDateFieldValidators.h"
#import "SFormChoiceFieldValidators.h"
#import "SFormBooleanFieldValidator.h"
#import "SFormChoiceFieldValidators.h"

// Text Field Validation.
#import "SFormTextFieldValidator.h"
#import "SFormTextFieldRegexValidator.h"
#import "SFormTextFieldEmailValidator.h"
#import "SFormTextFieldNotEmptyValidator.h"
#import "SFormTextFieldNumericValidator.h"
#import "SFormTextFieldComparisonValidator.h"

//Ranged Field Validation.
#import "SFormRangedNumberFieldValidator.h"
#import "SFormRangedNumberFieldComparisonValidator.h"

// Choice Field Validation.
#import "SFormChoiceFieldValidator.h"
#import "SFormChoiceFieldNotEmptyValidator.h"
#import "SFormChoiceFieldComparisonValidator.h"

// Date Field Validation.
#import "SFormDateFieldValidator.h"
#import "SFormDateFieldNotEmptyValidator.h"
#import "SFormDateFieldComparisonValidator.h"

// Picker Field Validation.
#import "SFormPickerFieldValidator.h"
#import "SFormPickerFieldNotEmptyValidator.h"

// Boolean Field Validation
#import "SFormBooleanFieldValidator.h"
#import "SFormBooleanFieldComparisonValidator.h"
#import "SFormBooleanFieldTrueValidator.h"
#import "SFormBooleanFieldFalseValidator.h"

//Converters
#import "SFormDateFieldConverter.h"
#import "SFormPickerFieldConverter.h"
#import "SFormTextFieldConverter.h"
#import "SFormNumberFieldConverter.h"
#import "SFormChoiceFieldConverter.h"
#import "SFormRangedNumberFieldConverter.h"
#import "SFormBooleanFieldConverter.h"

// Appearance.
#import "SFormColors.h"
#import "SFormFonts.h"

// Layout.
#import "SFormLayoutAlignedVertically.h"
#import "SFormSectionLayout.h"
#import "SFormSectionLayoutAlignedVertically.h"
#import "SFormSectionLayoutAlignedVerticallyByInput.h"
#import "SFormFieldLayoutLabelLeftOfInput.h"
#import "SFormFieldLayoutLabelOnTopOfInput.h"
#import "SFormFieldLayoutNoLabel.h"

// Navigation.
#import "SFormToolbar.h"
#import "SFormNavigator.h"
#import "SFormNavigationToolbar.h"
#import "SFormResponderFieldViewIterator.h"
#import "SFormScrollViewManager.h"

// XML

#import "SFormXMLParser.h"

/** A utility class which allows you to set themes and licenseKeys for all the ShinobiForms in your app, rather than having to configure each independently.
 
 This is best done early on, before any forms are created.
 */
@interface ShinobiForms : NSObject

/** Set a licenseKey for all ShinobiForms in your app. */
+ (void)setLicenseKey:(NSString *)key;

/** The licenseKey set for all ShinobiForms in your app. */
+ (NSString *)licenseKey;

/** Returns a string describing the version of the Forms framework being used.
 
 This includes a version number, the type of framework (Standard, or Trial) and the date upon which the version was released.
 */
+(NSString *)getInfo;

@end
