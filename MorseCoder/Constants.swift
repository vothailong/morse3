//
//  Constants.swift
//  IDareU
//
//  Created by Dung Do on 6/19/19.
//  Copyright © 2019 Dung Do. All rights reserved.
//

import UIKit

struct K {
    
    static let userDefault: UserDefaults = UserDefaults.standard
    
//   static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let screenSize: CGSize = UIScreen.main.bounds.size
    
    static let isIphone: Bool = UIDevice.current.model == "iPhone"
    
   // static let isIphoneX: Bool = K.appDelegate.window!.safeAreaInsets.top > 20.0
    
 //   static let isLandscape: Bool = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
    
    static let isSimulator: Bool = Bool(exactly: TARGET_OS_SIMULATOR as NSNumber)!
    
    static let deviceID: String? = UIDevice.current.identifierForVendor?.uuidString
    
    static let appstoreID: String = "XXX"
    
    static var OS: String = UIDevice.current.systemVersion
    
    static var OSVersion: String = UIDevice.current.systemName
    
    static var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    static var appVersion: String {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        return "\(version)(\(build))"
    }
   
    
    static var accessToken: String? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.AccessToken)
        }
        get {
            return K.userDefault.string(forKey: K.Keys.AccessToken)
        }
    }
    
    static var realmPath: URL? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.realmPath)
        }
        get {
            return K.userDefault.url(forKey: K.Keys.realmPath)
        }
    }
    
    static var customToken: String? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.CustomToken)
        }
        get {
            return K.userDefault.string(forKey: K.Keys.CustomToken)
        }
    }
    
    static var refreshToken: String? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.RefreshToken)
        }
        get {
            return K.userDefault.string(forKey: K.Keys.RefreshToken)
        }
    }
    
    static var createdToken: String? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.CreatedToken)
        }
        get {
            return K.userDefault.string(forKey: K.Keys.CreatedToken)
        }
    }
    
    static var ttl: Int? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.TTL)
        }
        get {
            return K.userDefault.integer(forKey: K.Keys.TTL)
        }
    }
    
    static var fcmToken: String? {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.fcmToken)
        }
        get {
            return K.userDefault.string(forKey: K.Keys.fcmToken)
        }
    }
    
    static var isLaunchedBefore: Bool {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.isLaunchedBefore)
        }
        get {
            return K.userDefault.bool(forKey: K.Keys.isLaunchedBefore)
        }
    }
    
    static var countAnimation: Int {
        set {
            K.userDefault.set(newValue, forKey: K.Keys.countAnimation)
        }
        get {
            return K.userDefault.integer(forKey: K.Keys.countAnimation)
        }
    }
    
    
     
    
    static var deviceLanguage: K.Language {
        get {
            let deviceLang = String(Locale.preferredLanguages[0].prefix(2))//correct
            //let deviceLang = Locale.current.languageCode //incorrect
            if  let deviceLang = K.Language(rawValue: deviceLang),  K.Language.allCases.contains(deviceLang) {
                return deviceLang
            } else {
                return .english
            }
        }
    }
    
    enum Language: String, CaseIterable {
        case english    = "en"
        case french     = "fr"
        case spanish    = "es"
        case russian    = "ru"
        case italian    = "it"
        case serbian    = "sr"
        case polish     = "pl"// "pl-PL"
        case chinese    = "zh"// "zh-Hans"
        case deutsch    = "de"//"nl-BE"
    }
    //format: "yyyy-mm-dd'T'hh:mm:ss.SSSZ"
     static let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//original: hour returned: 9
//    static let defaultDateFormat = "yyyy-mm-dd'T'hh:mm:ss.SSSZ"// ok for accept btn : hour returned:09
//        static let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
     //val format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", Locale.US) //android date -> string
     //val format = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)//android string -> date

    static let dateFormatShareEmail  = "h:mm a, dd MMM, yyyy"
    
    
    static let defaultImageCompression: CGFloat = 0.25 // 1.0 represents the least compression (or best quality).
    
    static var limitedTimeLiveStream: TimeInterval = 600
    static var limitedTimeVideo: TimeInterval = 600
    static var limitedTimePhoto: TimeInterval = 600
    static var limitedTimeAddPaymentMethod: TimeInterval = 60
    
    struct AppFont {
        static let Regular  = "SourceSansPro-Regular"
        static let Black    = "SourceSansPro-Black"
        static let Semibold = "SourceSansPro-Semibold"
        static let Light    = "SourceSansPro-Light"
    }
 
    struct Screens {
        static let Splash               = "SplashViewController"
        static let Tutorial             = "TutorialViewController"
        static let Main                 = "MainViewController"
        static let Login                = "LoginViewController"
        static let Loading              = "LoadingViewController"
        static let Challenge            = "ChallengeViewController"
        static let ChallengeList        = "ChallengeListViewController"
        static let ChallengeDetail      = "ChallengeDetailViewController"
        static let Circle               = "CircleViewController"
        static let Nations              = "NationsViewController"
        static let NationDetail         = "NationDetailViewController"
        static let GroupDetail          = "GroupDetailViewController"
        static let Groups               = "GroupsViewController"
        static let Friends              = "FriendsViewController"
        static let CreateChallenge      = "CreateChallengeViewController"
        static let CreateCircle         = "CreateCircleViewController"
        static let Profile              = "ProfileViewController"
        static let MyChallenges         = "MyChallengesViewController"
        static let ProfileDetail        = "ProfileDetailViewController"
        static let Messages             = "MessagesViewController"
        static let Setting              = "SettingViewController"
        static let Search               = "SearchViewController"
        static let SearchChallenges     = "SearchChallengesViewController"
        static let SearchNations        = "SearchNationsViewController"
        static let SearchPeople         = "SearchPeopleViewController"
        static let LiveStream           = "LiveStreamViewController"
        static let SelectItem           = "SelectItemViewController"
        static let Notification         = "NotificationViewController"
        static let Username          	= "UsernameViewController"
        static let DetailSetting        = "DetailSettingViewController"
        static let Vote                 = "VoteViewController"
        static let Donate               = "DonateViewController"
        static let PaymentMethods       = "PaymentMethodsViewController"
        static let Comment              = "CommentViewController"
        static let TakersList           = "TakersListViewController"
        static let Chat                 = "ChatViewController"
        static let ChatMessage          = "ChatMessageViewController"
        static let ChatDetails          = "ChatDetailsViewController"
        static let Container            = "ContainerViewController"
        static let PhotoPicker          = "PhotoPickerViewController"
        static let PhotosReview         = "PhotosReviewViewController"
        static let VideoRecording       = "FacecamViewController"
        static let Member               = "MembersViewController"
        static let Toast                = "ToastViewController"
        static let SuggestedCircles     = "SuggestedCirclesViewController"
        static let Followers            = "FollowersViewController"
        static let ChallengeType        = "ChallengeTypeViewController"
        static let ChallengeCategories  = "ChallengeCategoriesViewController"
        static let ChallengeCause       = "ChallengeCauseViewController"
        static let Media                = "MediaViewController"
    }
    
    struct Keys {
        static let realmPath          = "realmPath"
        static let CurrentLanguage          = "CurrentLanguage"
        static let isLaunchedBefore         = "isLaunchedBefore"
        static let countAnimation           = "countAnimation"
        static let ShowAnimation            = "ShowAnimation"
        static let CurrentUser              = "CurrentUser"
        static let AccessToken              = "AccessToken"
        static let CustomToken              = "CustomToken"
        static let RefreshToken             = "RefreshToken"
        static let CreatedToken             = "CreatedToken"
        static let TTL                      = "TTL"
        static let fcmToken                 = "fcmToken"
        static let ChallengeCreated         = "ChallengeCreated"
        static let ChallengeEdited          = "ChallengeEdited"
        static let CircleCreated            = "CircleCreated"
        static let ChangeViewMode           = "ChangeViewMode"
        static let NotificationsAdded       = "NotificationsAdded"
        static let NotificationsRemoved     = "NotificationsRemoved"
        static let NotificationsViewed      = "NotificationsViewed"
        static let NotificationsRead        = "NotificationsRead"
        static let ChatAdded                = "ChatAdded"
        static let ViewerAdded              = "ViewerAdded"
        static let CommentAdded             = "CommentAdded"
        static let CurrentUserUpdate        = "CurrentUserUpdate"
        static let MessageUnread            = "MessageUnread"
        static let InternetConnected        = "InternetConnected"
        static let InternetDisconnect       = "InternetDisconnect"
        static let AddCardSuccess           = "AddCardSuccess"
        static let DepositSuccess           = "DepositSuccess"
        static let ContributeSuccess        = "ContributeSuccess"
        static let RefeshMessages           = "RefeshMessages"
    }
    
    struct URLs {
        #if DEV
        static let base             = "https://api-dev.idareyou.dirox.dev/api/v1"
        static let baseSharing      = "https://dev.idareyou.dirox.dev/sharing"
        static let s3base           = "https://idareyoudev.s3.ap-southeast-1.amazonaws.com"
        
        static let pingDirox        = "api-dev.idareyou.dirox.dev"
        static let pingApiVideo     = "sandbox.api.video"
        static let pingS3           = "idareyoudev.s3.ap-southeast-1.amazonaws.com"
        static let pingFirebase     = "idareu-3953e.firebaseapp.com"
        #elseif STAGING
        static let base             = "https://api.idareyou.dirox.dev/api/v1"
        static let baseSharing      = "https://dev.idareyou.dirox.dev/sharing"
        static let s3base           = "https://idareyoudev.s3.ap-southeast-1.amazonaws.com"
        
        static let pingDirox        = "api-dev.idareyou.dirox.dev"
        static let pingApiVideo     = "sandbox.api.video"
        static let pingS3           = "idareyoudev.s3.ap-southeast-1.amazonaws.com"
        static let pingFirebase     = "idareu-3953e.firebaseapp.com"
        #else
        static let base             = "https://api.idareyou.dirox.dev/api/v1"
        static let baseSharing      = "https://idareyou.dirox.dev/sharing"
        static let s3base           = "https://idareyoudev.s3.ap-southeast-1.amazonaws.com"
        
        static let pingDirox        = "api-dev.idareyou.dirox.dev"
        static let pingApiVideo     = "sandbox.api.video"
        static let pingS3           = "idareyoudev.s3.ap-southeast-1.amazonaws.com"
        static let pingFirebase     = "idareu-3953e.firebaseapp.com"
        #endif
        
        static var Files              = base + "/Files"
        static var Categorys          = base + "/Categories"
        static let Challenges         = base + "/Challenges"
        static let ChallengeVotes     = base + "/ChallengeVotes"
        static let CharityOrgs        = base + "/CharityOrgs"
        static let CharityCategories  = base + "/CharityCategories"
        static let Circles            = base + "/Circles"
        static let CircleMembers      = base + "/CircleMembers"
        static let Comments           = base + "/Comments"
        static let Followings         = base + "/Followings"
        static let Friendships        = base + "/Friendships"
        static let Likes              = base + "/Likes"
        static let PMessages          = base + "/PMessages"
        static let Notification       = base + "/Notifications"
        static let Payment            = base + "/Payments"
        static let Posts              = base + "/Posts"
        static let Reports            = base + "/Reports"
        static let ReportCategories   = base + "/ReportCategories"
        static let Takers             = base + "/Takers"
        static let Users              = base + "/Users"
        static let Wallets            = base + "/Wallets"
        static let WalletTransactions = base + "/WalletTransactions"
        static let Page               = base + "/Pages"
        static let Settings           = base + "/Settings"
    }
    
}
