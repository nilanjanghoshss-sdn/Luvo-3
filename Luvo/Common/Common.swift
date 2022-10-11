//
//  Common.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 13/09/21.
//

import Foundation

class Common {
    
    fileprivate enum BaseUrl : String {
      case live = "https://admin.zest2live.com/"    //http://54.190.192.105:9111/"  "mailto:socialid":"113914960338667103461","socialtype":"google","useremail":"apptest.beas@gmail.com"
      case dev  = "http://beas.in:5000/v2/"
      //  case dev  = "http://beas.in:5000/"
    }
    

    
    struct WebserviceAPI {
        static let baseURL                  = Common.BaseUrl.dev.rawValue
        static let loginAPI                 = Common.WebserviceAPI.baseURL + "api/auth/login"
        static let socialLoginAPI           = Common.WebserviceAPI.baseURL + "api/signup/social"
        static let signupAPI                = Common.WebserviceAPI.baseURL + "api/signup"
        static let validateOtpAPI           = Common.WebserviceAPI.baseURL + "api/user/validateOTP"
        static let resendOtpAPI             = Common.WebserviceAPI.baseURL + "api/user/resendOTP"
        static let forgotPasswordAPI        = Common.WebserviceAPI.baseURL + "api/reset-password"
        static let resetPasswordAPI         = Common.WebserviceAPI.baseURL + "api/new-password"
        static let singleQuestionAPI        = Common.WebserviceAPI.baseURL + "api/user/questions/betterlife"
        static let singleAnswerSaveAPI      = Common.WebserviceAPI.baseURL + "api/user/userSaveAns"
        static let getChakraQuestionAPI     = Common.WebserviceAPI.baseURL + "api/user/chakra/questions"
        static let saveChakraAnswerAPI      = Common.WebserviceAPI.baseURL + "api/user/chakra/qtnResponse"
        static let getChakraLevelDisplayAPI = Common.WebserviceAPI.baseURL + "api/user/chakra/levels"
        static let getHomeDataAPI           = Common.WebserviceAPI.baseURL + "api/user/dashboard/"
        static let getProfileAPI            = Common.WebserviceAPI.baseURL + "api/user"
        static let postProfileUpdateAPI     = Common.WebserviceAPI.baseURL + "api/user"
        static let uploadProfilePictureAPI  = Common.WebserviceAPI.baseURL + "api/user"
        static let gratitudeDateList        = Common.WebserviceAPI.baseURL + "api/user/gratitudes"
        static let gratitudeCategoryListAPI = Common.WebserviceAPI.baseURL + "api/user/dashboard/gratitudeCat"
        static let gratitudeAddNewAPI       = Common.WebserviceAPI.baseURL + "api/user/dashboard/addGratitude"
        static let getMeditationLevelAPI    = Common.WebserviceAPI.baseURL + "api/user/chakra/countMusics"
        static let getBlogListAPI           = Common.WebserviceAPI.baseURL + "api/user/blogs"   //"api/user/dashboard/blogs"
        static let getBreathExeciseListAPI  = Common.WebserviceAPI.baseURL + "api/user/dashboard/exercises"
        static let getMeditationAudioAPI    = Common.WebserviceAPI.baseURL + "api/musics/audios"
        static let getSoothingVideoList     = Common.WebserviceAPI.baseURL + "api/musics/videos"
        static let addToFavourites          = Common.WebserviceAPI.baseURL + "api/user/favorites"
        static let postAudioCompleted       = Common.WebserviceAPI.baseURL + "api/user/dashboard/adduserMeditation"
        static let postListenAudioFiveMin   = Common.WebserviceAPI.baseURL + "api/user/dashboard/adduserSeenMusic"
        static let getDailyGoal             = Common.WebserviceAPI.baseURL + "api/user/dailygoal"
        static let putDailyGoal             = Common.WebserviceAPI.baseURL + "api/user/dailygoal"
        static let postBGStepUpdate         = Common.WebserviceAPI.baseURL + "api/user/dashboard/addDistance"
        static let postStepUpdate           = Common.WebserviceAPI.baseURL + "api/user/dashboard/addDistance"   //"api/user/dashboard/addExDistance" ***Expired***
        static let postExerciseStat         = Common.WebserviceAPI.baseURL + "api/user/dashboard/distance"
        static let getDailyWaterGoal        = Common.WebserviceAPI.baseURL + "api/user/dailyWater"
        static let putDailyWaterGoal        = Common.WebserviceAPI.baseURL + "api/user/dailyWater"
        static let postWaterStat            = Common.WebserviceAPI.baseURL + "api/user/dashboard/waterIntaked"
        static let getWaterCupSize          = Common.WebserviceAPI.baseURL + "api/cupsizes"
        static let postWaterCupSize         = Common.WebserviceAPI.baseURL + "api/user/dashboard/addWater"
        static let getWaterReminder         = Common.WebserviceAPI.baseURL + "api/user/reminder"
        static let postWaterReminder        = Common.WebserviceAPI.baseURL + "api/user/reminder"
        static let postMusicUnlock          = Common.WebserviceAPI.baseURL + "api/user/dashboard/openMusic"
        static let getExerciseCheck         = Common.WebserviceAPI.baseURL + "api/musics/audioEx?"
        static let postHeartData            = Common.WebserviceAPI.baseURL + "api/user/dashboard/addHeartRate"
        static let postHeartStatData        = Common.WebserviceAPI.baseURL + "api/user/dashboard/heartrate"
        static let searchAudioList          = Common.WebserviceAPI.baseURL + "api/musics/search?search="
        static let searchBlogList           = Common.WebserviceAPI.baseURL + "api/blogsearch?search="
        static let getChatList              = Common.WebserviceAPI.baseURL + "api/user/messages"
        static let postLike                 = Common.WebserviceAPI.baseURL + "api/user/blogs/likes"
        static let deleteLike               = Common.WebserviceAPI.baseURL + "api/user/blogs/likes"
        static let getBlogComments          = Common.WebserviceAPI.baseURL + "api/user/blogs/comments/"
        static let postBlogComments         = Common.WebserviceAPI.baseURL + "api/user/blogs/comments"
        static let messageList              = Common.WebserviceAPI.baseURL + "api/user/messages"
        static let getSettingNotification   = Common.WebserviceAPI.baseURL + "api/user/settings"
        static let setWaterNotification     = Common.WebserviceAPI.baseURL + "api/user/water_settings/"
        static let setStepNotification      = Common.WebserviceAPI.baseURL + "api/user/step_settings/"
        static let setMaleFemale            = Common.WebserviceAPI.baseURL + "api/user/voice_settings/"
        static let changePassword           = Common.WebserviceAPI.baseURL + "api/user/change-passwd"
        static let aboutUs                  = Common.WebserviceAPI.baseURL + "api/cms/about-us"
        static let termsAndServices         = Common.WebserviceAPI.baseURL + "api/cms/terms-and-conditions"
        static let logoutAPI                = Common.WebserviceAPI.baseURL + "api/user/logout"
        static let contactUsAPI             = Common.WebserviceAPI.baseURL + "api/contact"
        static let updateTimezone           = Common.WebserviceAPI.baseURL + "api/user/timezone"
        static let faqAPI                   = Common.WebserviceAPI.baseURL + "api/faq"
        static let favList                  = Common.WebserviceAPI.baseURL + "api/user/favorites/"
        static let timeTracking             = Common.WebserviceAPI.baseURL + "api/user/dashboard/addtracking"
        static let meditationBadgeAPI       = Common.WebserviceAPI.baseURL + "api/user/dashboard/meditation"
        static let notificationListAPI      = Common.WebserviceAPI.baseURL + "api/user/notification"
        static let moodSetAPI               = Common.WebserviceAPI.baseURL + "api/user/dashboard/addMood"
        static let addSleepAPI              = Common.WebserviceAPI.baseURL + "api/user/dashboard/addSleep"
        static let getSleepAudioAPI         = Common.WebserviceAPI.baseURL + "api/sleep/musics"
        static let postSleepStatAPI         = Common.WebserviceAPI.baseURL + "api/user/sleep_result"
        static let deleteSleepDataAPI       = Common.WebserviceAPI.baseURL + "api/user/dashboard/delSleep"
        static let chakraColorChangeAPI     = Common.WebserviceAPI.baseURL + "api/user/color_settings/"
        static let retakeAPI                = Common.WebserviceAPI.baseURL + "api/user/chakra/allquestions"
        static let retakePostAPI            = Common.WebserviceAPI.baseURL + "api/user/chakra/qtnResponseUpdate"
        static let addSleepDataPostAPI      = Common.WebserviceAPI.baseURL + "api/user/addSleep_data"
        static let addWatchStepDataPostAPI  = Common.WebserviceAPI.baseURL + "api/user/syncStepData"
        static let addWatchHeartRatePostAPI = Common.WebserviceAPI.baseURL + "api/user/dashboard/syncHeartRate"
    
    }
}


