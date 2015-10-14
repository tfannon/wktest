//
//  SDataGridWrapper.h
//  Dev
//
//  Created by Ryan Grey on 19/02/2013.
//
//

#import <Foundation/Foundation.h>

//Private class used as the base class for wrapping SGrid objects to be used in the SDataGrid API
@interface SDataGridWrapper : NSObject

- (id) init;
- (id) initWithObjectToWrap:(id) objectToWrap;
+ (Class) wrappedObjectType;

@end
