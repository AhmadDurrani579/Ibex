//
//  ProfileUpdateViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 10/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ProfileUpdateViewController.h"
#import "LinkedInHelper.h" 
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "Utility.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "InvalidTooltipView.h"
#import "ValidTooltipView.h"
#import "loginResponse.h"
#import "UserProfileResponse.h"
#import "GetJobTitleResponse.h"
#import "JobTitleObject.h"
#import "UpdateResponse.h"

@interface ProfileUpdateViewController (){
    UserProfileResponse *masterObj;
    GetJobTitleResponse *jobTitleList;
    GetJobTitleResponse *industryList;
    GetJobTitleResponse *functionList;
    NSString *selectedFunctionID;
    NSString *selectedIndustryID;
    NSString *selectedJobID;
    NSString *selectedCountryID;
    UIDatePicker *datePicker;
    NSMutableArray *tempViews;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightOfView;

@end

@implementation ProfileUpdateViewController
@synthesize tfIndustry,tfJobTitle,tfCompany,tfEmail,tfName,tfJobFunction, ivProfile,tfFBURL,tfTwitterURL,tfLinkedinURL,tfAngelListURL,viewContainer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tempViews = [[NSMutableArray alloc] init];
    
    tfIndustry.font = [UIFont fontWithName:@"Axiforma-Book" size:tfIndustry.font.pointSize];;
    tfJobTitle.font = [UIFont fontWithName:@"Axiforma-Book" size:tfIndustry.font.pointSize];;
    tfJobFunction.font = [UIFont fontWithName:@"Axiforma-Book" size:tfIndustry.font.pointSize];;
    
    ivProfile.layer.cornerRadius = ivProfile.frame.size.height/2;
    ivProfile.clipsToBounds = YES;
    
    [tfEmail setEnabled:NO];
    
    [self setupTxtFields];
    
    [self fetchUser];
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}



-(void) setupTxtFields{
    [tfJobTitle setShowAutoCompleteTableWhenEditingBegins:YES];
    [tfJobTitle setAutoCompleteTableCellTextColor:[UIColor blackColor]];
    [tfJobTitle setAutoCompleteTableBorderColor:[UIColor blackColor]];
    
    [tfJobTitle setAutoCompleteTableCornerRadius:0.0f];
    [tfJobTitle setMaximumNumberOfAutoCompleteRows:4];
    
    [tfIndustry setShowAutoCompleteTableWhenEditingBegins:YES];
    [tfIndustry setAutoCompleteTableCellTextColor:[UIColor blackColor]];
    [tfIndustry setAutoCompleteTableBorderColor:[UIColor blackColor]];
    
    [tfIndustry setAutoCompleteTableCornerRadius:0.0f];
    [tfIndustry setMaximumNumberOfAutoCompleteRows:4];
    
    [tfJobFunction setShowAutoCompleteTableWhenEditingBegins:YES];
    [tfJobFunction setAutoCompleteTableCellTextColor:[UIColor blackColor]];
    [tfJobFunction setAutoCompleteTableBorderColor:[UIColor blackColor]];
    [tfJobFunction setAutoCompleteTableCornerRadius:0.0f];
    [tfJobFunction setMaximumNumberOfAutoCompleteRows:4];
}

-(void) restoreData{
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[masterObj.user.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, masterObj.user.speakerThumbImg]];
    [ivProfile setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
    ivProfile.layer.cornerRadius = ivProfile.frame.size.height/2;
    ivProfile.clipsToBounds = YES;
    
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", masterObj.user.speakerFirstName, masterObj.user.speakerLastName];
    
    [tfName setText:[tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""]];
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerEmailAddress]] ){
        [tfEmail setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerEmailAddress]];
    }
    else{
        [tfEmail setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerCompany]] ){
        [tfCompany setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerCompany]];
    }
    else{
        [tfCompany setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerJobTitle]] ){
        [tfJobTitle setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerJobTitle]];
    }
    else{
        [tfJobTitle setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerIndustry]] ){
    
        [tfIndustry setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerIndustry]];
    }
    else{
        [tfIndustry setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerFunction]] ){
        [tfJobFunction setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerFunction]];
    }
    else{
        [tfJobFunction setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerFBURL]] ){
        [tfFBURL setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerFBURL]];
    }
    else{
        [tfFBURL setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerLinkedinURL]] ){
        [tfLinkedinURL setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerLinkedinURL]];
    }
    else{
        [tfLinkedinURL setText:@""];
    }

    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerTwitterURL]] ){
        [tfTwitterURL setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerTwitterURL]];
    }
    else{
        [tfTwitterURL setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerWebsite]] ){
        [tfAngelListURL setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerWebsite]];
    }
    else{
        [tfAngelListURL setText:@""];
    }
    
    if ([masterObj.user.roleID isEqualToString:@"7"]){
        self.heightOfView.constant = 1136.0 ;
        [tfFBURL setHidden:false];
        [tfTwitterURL setHidden:false];
        [tfLinkedinURL setHidden:false];
        [tfAngelListURL setHidden:false];
        [_fbLabel setHidden:false];
        [_twitter setHidden:false];
        [_lnkedIn setHidden:false];
        [_websiteLbl setHidden:false];


    }else {
        self.heightOfView.constant = 830.0 ;
        [tfFBURL setHidden:true];
        [tfTwitterURL setHidden:true];
        [tfLinkedinURL setHidden:true];
        [tfAngelListURL setHidden:true];
        [_fbLabel setHidden:true];
        [_twitter setHidden:true];
        [_lnkedIn setHidden:true];
        [_websiteLbl setHidden:true];
    }

    
    selectedFunctionID = [NSString stringWithFormat:@"%@", masterObj.user.speakerFunctionID];
    selectedIndustryID = [NSString stringWithFormat:@"%@", masterObj.user.speakerIndustryID];
    selectedJobID = [NSString stringWithFormat:@"%@", masterObj.user.speakerJobTitleID];
    selectedCountryID = [NSString stringWithFormat:@"%@", masterObj.user.countryID];
    
}

- (BOOL) validateLinkedinUrl: (NSString *) candidate {
    
    NSString *urlRegEx = @"(?:(?:http|https):\\/\\/)(?:www.)?linkedin\\.com\\/(.+)";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (BOOL) validateTwitterUrl: (NSString *) candidate {
    
    NSString *urlRegEx = @"(?:(?:http|https):\\/\\/)(?:www.)?twitter\\.com\\/(.+)";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}


- (BOOL) validateFBUrl: (NSString *) candidate {
    
    NSString *urlRegEx = @"(?:(?:http|https):\\/\\/)(?:www.)?facebook\\.com\\/(.+)";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}


- (BOOL) validateUrl: (NSString *) candidate {

    NSString *urlRegEx = @"(https?:\\/\\/(?:www\\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\\.[^\\s]{2,}|www\\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\\.[^\\s]{2,}|https?:\\/\\/(?:www\\.|(?!www))[a-zA-Z0-9]\\.[^\\s]{2,}|www\\.[a-zA-Z0-9]\\.[^\\s]{2,})";
    //NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}


#pragma mark - MLPAutoCompleteTextField DataSource

//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    if([textField isEqual:tfJobTitle]){
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        _heightOfView.constant = 900.0 ;
        for(JobTitleObject *jobObj in jobTitleList.list){
            if([[NSString stringWithFormat:@"%@", jobObj.jobisActive] isEqualToString:@"1"]){
                [tempArr addObject:jobObj.jobTitle];
            }
        }
        
        handler(tempArr);
    }
    else if([textField isEqual:tfIndustry]){
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        
        for(JobTitleObject *jobObj in industryList.list){
            if([[NSString stringWithFormat:@"%@", jobObj.jobisActive] isEqualToString:@"1"]){
                [tempArr addObject:jobObj.jobTitle];
            }
        }
        
        handler(tempArr);
    }
    else {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        _heightOfView.constant = 1000.0 ;

        for(JobTitleObject *jobObj in functionList.list){
            if([[NSString stringWithFormat:@"%@", jobObj.jobisActive] isEqualToString:@"1"]){
                [tempArr addObject:jobObj.jobTitle];
            }
        }
        
        handler(tempArr);
    }

}

#pragma mark - MLPAutoCompleteTextField Delegate

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    /*NSString *filename = [autocompleteString stringByAppendingString:@".png"];
     filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
     filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
     [cell.imageView setImage:[UIImage imageNamed:filename]];*/
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
    
    if([textField isEqual:tfJobFunction]){
        _heightOfView.constant = 860.0 ;

        for(JobTitleObject *jobObj in functionList.list){
            if([[NSString stringWithFormat:@"%@", jobObj.jobTitle] isEqualToString:[NSString stringWithFormat:@"%@", tfJobFunction.text]]){
                selectedFunctionID = [NSString stringWithFormat:@"%@", jobObj.jobID];
                break;
            }
        }
    }
    else if([textField isEqual:tfIndustry]){
        for(JobTitleObject *jobObj in industryList.list){
            if([[NSString stringWithFormat:@"%@", jobObj.jobTitle] isEqualToString:[NSString stringWithFormat:@"%@", tfIndustry.text]]){
                selectedIndustryID = [NSString stringWithFormat:@"%@", jobObj.jobID];
                break;
            }
        }
    }
    else if ([textField isEqual:tfJobTitle])
    {
        
        
        for(JobTitleObject *jobObj in jobTitleList.list){
            if([[NSString stringWithFormat:@"%@", jobObj.jobTitle] isEqualToString:[NSString stringWithFormat:@"%@", tfJobTitle.text]]){
                selectedJobID = [NSString stringWithFormat:@"%@", jobObj.jobID];
                break;
            }
        }
        
    }
}

-(void) fetchJobTitleList{
    [[Webclient sharedWeatherHTTPClient] getJobTitles:WEBSERVICE_GET_JOBTITLE viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        jobTitleList = (GetJobTitleResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", jobTitleList.success] isEqualToString:@"1"]){
            
            [tfJobTitle reloadInputViews];
            
            [self fetchIndustry];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          
                                                                      }];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      
                                                                  }];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}

-(void) fetchIndustry{
    [[Webclient sharedWeatherHTTPClient] getJobTitles:WEBSERVICE_GET_INDUSTRY viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        industryList = (GetJobTitleResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", jobTitleList.success] isEqualToString:@"1"]){
            
            [tfIndustry reloadInputViews];
            [self fetchFunction];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          
                                                                      }];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      
                                                                  }];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}

-(void) fetchFunction{
    [[Webclient sharedWeatherHTTPClient] getJobTitles:WEBSERVICE_GET_FUNCTION viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        functionList = (GetJobTitleResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", jobTitleList.success] isEqualToString:@"1"]){
            
            [tfJobFunction reloadInputViews];
            
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          
                                                                      }];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      
                                                                  }];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}

-(void) fetchUser{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    [[Webclient sharedWeatherHTTPClient] getUserProfile:[NSString stringWithFormat:@"%@", obj.loginUserID] viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterObj = (UserProfileResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            [self restoreData];
            [self fetchJobTitleList];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", masterObj.message] actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}


- (BOOL)isLinkedInAccessTokenValid {
    return [LinkedInHelper sharedInstance].isValidToken;
}

- (IBAction)syncButtonPressed:(id)sender {
    
    [self fetchUserInformations];
}

-  (void)getUserInfo {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
    //#warning - To fetch user info  automatically without getting authorization code, accessToken must be still valid
    
    if (linkedIn.isValidToken) {
        
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            NSLog(@"user Info : %@", userInfo);
            [self linkedinRestore:userInfo];
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
            [self fetchUserInformations];
        }];
    }
}

- (void)fetchUserInformations {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
    
    NSArray *permissions = @[@(BasicProfile),
                             @(EmailAddress),
                             @(Share),
                             @(CompanyAdmin)];
    
    linkedIn.showActivityIndicator = YES;
    
    //[[Webclient sharedWeatherHTTPClient] showProgressAlertTitle:nil  message:@"Loading" view:self];
    
    
    [linkedIn requestMeWithSenderViewController:self
                                       clientId:@"81nxjzlomfekz6"         // Your App Client Id
                                   clientSecret:@"8FNuqpdm1luawTkz"         // Your App Client Secret
                                    redirectUrl:@"http://northerncalifornia.alumclub.mit.edu"         // Your App Redirect Url
                                    permissions:permissions
                                          state:@""               // Your client state
                                successUserInfo:^(NSDictionary *userInfo) {
                                    // Whole User Info
                                    
                                    NSLog(@"user Info : %@", userInfo);
                                    NSLog(@"Name: %@, Email: %@, Company: %@, picture: %@, public pic: %@, Designation: %@", [userInfo objectForKey:@"firstName"], [userInfo objectForKey:@"emailAddress"], [[[[[userInfo objectForKey:@"positions"] objectForKey:@"values"] lastObject] objectForKey:@"company"] objectForKey:@"name"], [userInfo objectForKey:@"pictureUrl"], [[[userInfo objectForKey:@"pictureUrls"] objectForKey:@"values"] lastObject] ,[[[[userInfo objectForKey:@"positions"] objectForKey:@"values"] lastObject] objectForKey:@"title"] );
                                    [self linkedinRestore:userInfo];
                                }
                              failUserInfoBlock:^(NSError *error) {
                                  NSLog(@"error : %@", error.userInfo.description);
                                  
                                  
                              }
     ];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) linkedinRestore:(NSDictionary*)userinfo{
    DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                            style:DAAlertActionStyleCancel
                                                          handler:^{
                                                              
                                                          }];
    
    [DAAlertController showAlertViewInViewController:self withTitle:@"Success" message:@"Data from linkedin synced successfully.\n\nPlease press 'Update' in the bottom of the form to save." actions:@[dismissAction]];
    
     [tfName setText:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"formattedName"]]];
    
    [tfCompany setText:[NSString stringWithFormat:@"%@",[[[[[userinfo objectForKey:@"positions"] objectForKey:@"values"] firstObject] objectForKey:@"company"] objectForKey:@"name"]]];
    //[tfJobTitle setText:[NSString stringWithFormat:@"%@", [[[[userinfo objectForKey:@"positions"] objectForKey:@"values"] firstObject] objectForKey:@"title"]]];
    
    //[tfEmail setText:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"emailAddress"]]];
    [tfLinkedinURL setText:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"publicProfileUrl"]]];

    [ivProfile setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[[userinfo objectForKey:@"pictureUrls"] objectForKey:@"values"] firstObject]]] placeholderImage:[UIImage imageNamed:@"profilePH"]];
    
    ivProfile.layer.cornerRadius = ivProfile.frame.size.height/2;
    ivProfile.clipsToBounds = YES;
}

-(void) resignKeyboard
{
    
    [self.view endEditing:YES];
}

-(void) validateFormFields{
    
    [self resignKeyboard];
    
    if (_tooltipView != nil)
    {
        [_tooltipView removeFromSuperview];
        _tooltipView = nil;
    }
    
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    
    [validator putRule:[Rules checkRange:NSMakeRange(2, 50) withFailureString:@"Should be in range 2 to 50" forTextField:tfName]];
    [validator putRule:[Rules checkIsValidEmailWithFailureString:@"Please enter correct Email address" forTextField:tfEmail]];
    [validator putRule:[Rules checkRange:NSMakeRange(2, 50) withFailureString:@"Should be in range 2 to 50" forTextField:tfCompany]];
    [validator putRule:[Rules checkRange:NSMakeRange(2, 50) withFailureString:@"Should be in range 2 to 50" forTextField:tfIndustry]];
    [validator putRule:[Rules checkRange:NSMakeRange(2, 50) withFailureString:@"Should be in range 2 to 50" forTextField:tfJobTitle]];
    [validator putRule:[Rules checkRange:NSMakeRange(2, 50) withFailureString:@"Should be in range 2 to 50" forTextField:tfJobFunction]];
    

    
//    if([Utility isEmptyOrNull:tfTwitterURL.text]){
//        [validator putRule:[Rules checkIfShortandURLWithFailureString:@"Please enter correct URL" forTextField:tfTwitterURL]];
//    }
//    
//    if([Utility isEmptyOrNull:tfLinkedinURL.text]){
//        [validator putRule:[Rules checkIfShortandURLWithFailureString:@"Please enter correct URL" forTextField:tfLinkedinURL]];
//    }
//    
//    if([Utility isEmptyOrNull:tfAngelListURL.text]){
//        [validator putRule:[Rules checkIfShortandURLWithFailureString:@"Please enter correct URL" forTextField:tfAngelListURL]];
//    }

    [validator validate];
    
}


-(void) removeAllError{
    for(UIView *view in tempViews){
        InvalidTooltipView *toolTip = [view viewWithTag:101];
        [_tooltipView removeFromSuperview];
    }
}

-(void) addErrorMsg:(UITextField*)txtfield err:(NSString*)err{
    UIView *topView = (UIView*) txtfield.superview;
    
    CGPoint point           = [txtfield convertPoint:CGPointMake(0.0, txtfield.frame.size.height - 4.0) toView:topView];
    CGRect tooltipViewFrame = CGRectMake(point.x, point.y,txtfield.frame.size.width, _tooltipView.frame.size.height);
    
    _tooltipView       = [[InvalidTooltipView alloc] init];
    _tooltipView.frame = tooltipViewFrame;
    _tooltipView.text  = [NSString stringWithFormat:@"%@",err];
    _tooltipView.tag = 101;
    
    [topView addSubview:_tooltipView];
    
    [tempViews addObject:topView];
}


#pragma ValidatorDelegate - Delegate methods

- (void) preValidation
{
    for (UITextField *textField in self.view.subviews) {
        textField.layer.borderWidth = 0;
    }
    
    NSLog(@"Called before the validation begins");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Edit Profile Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


- (void)onSuccess
{
    
    if (_tooltipView != nil)
    {
        [_tooltipView removeFromSuperview];
        _tooltipView  = nil;
    }
    
    [self sendData];
}

-(void) sendData{
    
    if(![Utility isEmptyOrNull:tfFBURL.text]){
        
        if([self validateFBUrl:tfFBURL.text]){
            [self removeAllError];
        }
        else{
            [self addErrorMsg:tfFBURL err:@"Please enter valid facebook URL"];
            return;
        }
    }
    else{
        //[self addErrorMsg:tfFBURL err:@"Please enter valid facebook URL"];
        //return;
    }

    if(![Utility isEmptyOrNull:tfTwitterURL.text]){
        
        if([self validateTwitterUrl:tfTwitterURL.text]){
            [self removeAllError];
        }
        else{
            [self addErrorMsg:tfTwitterURL err:@"Please enter valid twitter URL"];
            return;
        }
    }
    else{
        //[self addErrorMsg:tfTwitterURL err:@"Please enter valid twitter URL"];
        //return;
    }

    
    if(![Utility isEmptyOrNull:tfLinkedinURL.text]){
        
        if([self validateLinkedinUrl:tfLinkedinURL.text]){
            [self removeAllError];
        }
        else{
            [self addErrorMsg:tfLinkedinURL err:@"Please enter valid linkedin URL"];
            return;
        }
    }
    else{
        //[self addErrorMsg:tfLinkedinURL err:@"Please enter valid linkedin URL"];
        //return;
    }

    if(![Utility isEmptyOrNull:tfAngelListURL.text]){
        
        if([self validateUrl:tfAngelListURL.text]){
            [self removeAllError];
        }
        else{
            [self addErrorMsg:tfAngelListURL err:@"Please enter valid URL"];
            return;
        }
    }
    else{
        //[self addErrorMsg:tfAngelListURL err:@"Please enter valid URL"];
        //return;
    }
    
    if(ivProfile.image == nil){
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Alert!" message:@"Please add image to the profile." actions:@[dismissAction]];
        return;
    }
    
    NSArray* stringArr = [[NSString stringWithFormat:@"%@", tfName.text] componentsSeparatedByString: @" "];
    NSString *trueString = [NSString stringWithFormat:@"true"];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     masterObj.user.speakerID,@"Id",
                                     [stringArr objectAtIndex:0], @"FirstName",
                                     [stringArr objectAtIndex:1],@"LastName",
                                     [NSString stringWithFormat:@"%@", tfCompany.text],@"company",
                                     tfLinkedinURL.text, @"LinkedInURL",
                                     tfTwitterURL.text,@"TwitterURL",
                                     tfFBURL.text, @"FacebookURL",
                                     tfAngelListURL.text, @"Website",
                                     selectedJobID, @"JobTitleId",
                                     selectedIndustryID, @"IndustryId",
                                     selectedFunctionID, @"FunctionId",
                                     selectedCountryID, @"CountryId",
                                     masterObj.user.speakerBlog,@"Blog",
                                     trueString     ,    @"IsMobile",
                                     masterObj.user.userType , @"userTypeId" ,
                                     
                                     nil];
        [[Webclient sharedWeatherHTTPClient] updateProfile:parameters newImage:ivProfile.image viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        UpdateResponse *tempObj = (UpdateResponse *) responseObject;
        
        if([tempObj.status isEqualToString:@"1"]){
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          
                                                                      }];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:[NSString stringWithFormat:@"%@", tempObj.message] actions:@[dismissAction]];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                             
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", tempObj.message] actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
}

- (void)onFailure:(Rule *)failedRule
{
    NSLog(@"Failed");
//    failedRule.textField.layer.borderColor   = [UIColor colorWithRed:136.0/255.0 green:204.0/255.0 blue:59.0/255.0 alpha:1.0].CGColor;
//    
//    failedRule.textField.layer.cornerRadius  = 5;
//    failedRule.textField.layer.borderWidth   = 2;
    //136 204 59
    UIView *topView = (UIView*) failedRule.textField.superview;
    
    CGPoint point           = [failedRule.textField convertPoint:CGPointMake(0.0, failedRule.textField.frame.size.height - 4.0) toView:viewContainer];
    CGRect tooltipViewFrame = CGRectMake(failedRule.textField.frame.origin.x+30, point.y, failedRule.textField.frame.size.width, _tooltipView.frame.size.height);
    
    _tooltipView       = [[InvalidTooltipView alloc] init];
    _tooltipView.frame = tooltipViewFrame;
    _tooltipView.text  = [NSString stringWithFormat:@"%@",failedRule.failureMessage];
    _tooltipView.rule  = failedRule;

    [viewContainer addSubview:_tooltipView];
}



- (IBAction)changePictureButtonPressed:(id)sender {
    
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:[NSString stringWithFormat:@"Select Picture"]
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:nil];
    
    
    picker.delegate = self;
    picker.dataSource = self;
    //[picker setNeedFooterView:YES];
    [picker setHeaderBackgroundColor:[UIColor colorWithRed:142.0/255.0f green:204.0/255.0f blue:52.0/255.0f alpha:1.0f]];
    [picker setConfirmButtonBackgroundColor:[UIColor colorWithRed:142.0/255.0f green:204.0/255.0f blue:52.0/255.0f alpha:1.0f]];
    [picker show];
    
    
}

/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    
    return 2;
    
}

/*
 - (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
 attributedTitleForRow:(NSInteger)row{
 
 return @"Helo";
 
 }
 */

/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    
    
    if(row == 0){
        return @"Camera";
    }
    else{
        return @"Gallery";
    }
    
    
}

- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{
    
    if(row==0){
        [self getPhoto];
    }
    else{
        [self selectPhoto];
    }
    
}

-(void)getPhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
}

- (void)selectPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //ivProfilePic.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [self scaleImage:image toSize:CGSizeMake(250,250)];
    
    ivProfile.image = image;
    
    //NSURL *url = [NSURL URLWithString:obj.userPicURL];
    //[ivProfilePic setImageWithURL:url];
    
    ivProfile.layer.cornerRadius = ivProfile.frame.size.height/2;
    ivProfile.clipsToBounds = YES;
    
    //[picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (UIImage *) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)updateButtonPressed:(id)sender {
    
    [self validateFormFields];
}


- (void)updateControlsWithResponseLabel:(BOOL)updateResponseLabel {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
