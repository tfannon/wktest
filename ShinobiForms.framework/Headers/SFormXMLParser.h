//
//  SFormXMLParser.h
//  ShinobiForms
//
//  Copyright (c) 2014 Scott Logic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShinobiForm;

/** An object capable of prasing XML to create a `ShinobiForm`.
 
 This parser can parse an XML string conforming to the XSD provided with this framework (`ShinobiForms_XSD.xml`).
 */
@interface SFormXMLParser : NSObject

/** Create a form from XML.
 
 Attempts to create a form from the given XML string.
 
 The `xml` string will be validated against the given `xsd` string. If no `xsd` string is provided, this method will attempt to load `ShinobiForms_XSD.xml` from your application's main bundle. If this `xsd` can't be found, the method will return nil.
 
 @param xml The XML string defining the form.
 @param xmlEncoding The encoding of the `xml` string.
 @param xsd The XSD string to validate the `xml` against. If `nil`, an attempt will be made to load `ShinobiForms_XSD.xml` from your application's bundle.
 @param xsdEncoding The encoding of the `xsd` string.
 @return A ShinobiForm model built from the provided `xml` string.
 */
- (ShinobiForm *)formFromXml:(NSString *)xml
                 xmlEncoding:(NSStringEncoding)xmlEncoding
                         xsd:(NSString *)xsd
                 xsdEncoding:(NSStringEncoding)xsdEncoding;

/** Validate a given XML string against a given XSD.
 
 The `xml` string will be validated against the given `xsd` string. If no `xsd` string is provided, this method will attempt to load `ShinobiForms_XSD.xml` from your application's main bundle. If this `xsd` can't be found, the method will return nil.
 
 @param xml The XML string to validate.
 @param xmlEncoding The encoding of the `xml` string.
 @param xsd The XSD string to validate the `xml` against.
 @param xsdEncoding The encoding of the `xsd` string.
 @return A `BOOL` that indicates the validity of the `xml`.
 */
- (BOOL)isValidXml:(NSString *)xml
       xmlEncoding:(NSStringEncoding)xmlEncoding
               xsd:(NSString *)xsd
       xsdEncoding:(NSStringEncoding)xsdEncoding;

@end
