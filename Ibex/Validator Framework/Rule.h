/*
 * Copyright (C) 2012 Mobs and Geeks
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file 
 * except in compliance with the License. You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the 
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language governing permissions and 
 * limitations under the License.
 *
 * @author Balachander.M <chicjai@gmail.com>
 * @version 0.1
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Rule : NSObject {
    @private
    NSString *failureMessage;
    BOOL isValid;
    UITextField *textField;
}
@property (nonatomic, retain) NSString *failureMessage;
@property (nonatomic) BOOL isValid;
@property (nonatomic, retain) UITextField *textField;
@end
