//
//  HomeVCExt.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 20/09/21.
//

import Foundation
import UIKit
import SDWebImage

extension HomeViewController {
    func getChakraLevelData() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            chakraDiplayViewModel.getChakraDisplayDetails(token: token)
        }
    }
    func getData() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            debugPrint("token--->",token)
            
            //Get previous date
            let previousDate = Date.yesterday
//            debugPrint("home previous date--->",previousDate)
//            let convertDateFormatter = DateFormatter()
//            convertDateFormatter.timeZone = TimeZone.current
//            convertDateFormatter.dateFormat = "yyyy-MM-dd"
//            let formatDate = convertDateFormatter.string(from: previousDate)
//            debugPrint("home formatDate--->",formatDate)
            
            let formatDate = Date().formatDate(date: previousDate)
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            homeViewModel.getHomeData(token: token, date: formatDate)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {    
    func didReceiveHomeResponse(homeResponse: HomeResponse?) {
        self.view.stopActivityIndicator()
        
        if(homeResponse?.status != nil && homeResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(homeResponse)
            homeData = homeResponse
            setupUI()
            setupUIData()
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveHomeError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    func setupUIData() {
        lblQuotes.text = homeData?.quotes?.quote
        lblQuoteAuthor.text = "-\(homeData?.quotes?.authorName ?? "")"
        
        if let steps = homeData?.distances.steps {
            if let miles = homeData?.distances.miles {
                let mile = String(format: "%.3f", miles)
                lblSteps.text = "\(steps)/\(mile)Miles"
            }
        }
        //Convert mililiter to liter
        if let mLiter = homeData?.waterIntaked?.waterIntake {
            let liter = Double(mLiter) / Double(1000)
            lblWaterIntake.text = "\(mLiter)ML/\(liter)L"
        }
        
        lblMood.text = homeData?.mood?.mood
        
        if let heartRate = homeData?.heartRate?.heartRate {
            lblHeartRate.text = "\(Int(heartRate)) Bpm"
        }
        
        if let sleep = homeData?.sleep?.sleep {
            let (hour, minute, second) = Date().convertSecondsToHourMinutesSecond(sleep)
            lblSleep.text = "\(hour)hr \(minute)min"
        }
        
        if let points = homeData?.point?.totalPoint {
            lblPoints.text = "\(points)"
        }
        
        //If message is blank then pickup category name value
        if let gratitudeMsg = homeData?.gratitude?.message {
            if gratitudeMsg.count > 0 && gratitudeMsg != "" {
                lblGratitude.text = gratitudeMsg
            } else {
                if let gratitudeMsg = homeData?.gratitude?.categoryName {
                    if gratitudeMsg.count > 0 && gratitudeMsg != "" {
                        lblGratitude.text = gratitudeMsg
                    } else {
                        lblGratitude.text = ConstantAlertMessage.GratitudeBlank
                    }
                }
            }
        } else {
            if let gratitudeMsg = homeData?.gratitude?.categoryName {
                if gratitudeMsg.count > 0 && gratitudeMsg != "" {
                    lblGratitude.text = gratitudeMsg
                } else {
                    lblGratitude.text = ConstantAlertMessage.GratitudeBlank
                }
            }
        }
        
        collBreathExercise.reloadData()
        collBlog.reloadData()
        collRec.reloadData()
        collLive.reloadData()
        
        //Store badge count and post local notification to update if the user login from different device
        UserDefaults.standard.set(homeData?.unread_notification, forKey: ConstantUserDefaultTag.udNotificationBadge)
        NotificationCenter.default.post(name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
}

extension HomeViewController: ChakraDisplayViewModelDelegate {
    //MARK: - Delegate
    func didReceiveChakraDisplayResponse(chakraDisplayResponse: ChakraDisplayResponse?) {
        self.view.stopActivityIndicator()
        
        if(chakraDisplayResponse?.status != nil && chakraDisplayResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(chakraDisplayResponse)
            
            let chakraResponse = chakraDisplayResponse
            
            UserDefaults.standard.set(chakraResponse?.prev_level, forKey: ConstantUserDefaultTag.udPrevChakraLevel)
            UserDefaults.standard.set(chakraResponse?.prev_chakra, forKey: ConstantUserDefaultTag.udPrevChakraName)
            UserDefaults.standard.set(chakraResponse?.current_level, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)  //Store blocked chakra level
            UserDefaults.standard.set(chakraResponse?.level_chakra, forKey: ConstantUserDefaultTag.udBlockedChakraName)  //Store blocked chakra name
            UserDefaults.standard.set(chakraResponse?.current_chakraId, forKey: ConstantUserDefaultTag.udBlockedChakraID)   //Store blocked chakra id
            UserDefaults.standard.set(chakraResponse?.default_exercise?.exerciseId, forKey: ConstantUserDefaultTag.udDefaultExerciseID)
            UserDefaults.standard.set(chakraResponse?.default_exercise?.name, forKey: ConstantUserDefaultTag.udDefaultExerciseName)
            UserDefaults.standard.set(chakraResponse?.chakra_color, forKey: ConstantUserDefaultTag.udChakraColorchange)
            UserDefaults.standard.set(chakraResponse?.crownListen, forKey: ConstantUserDefaultTag.udChakraCrownListen)
            
            
//            if(chakraResponse?.chakra_color==0)
//            {
//                UserDefaults.standard.set(chakraResponse?.current_level, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)  udChakraCrownListen
//
//            }
//            else{
//                UserDefaults.standard.set(chakraResponse?.chakra_color, forKey: ConstantUserDefaultTag.udBlockedChakraLevel)
//            }
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveChakraDisplayError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Collection View Delegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collBreathExercise {
//            return CGSize(width: 160.0, height: 120.0)
//        } else {
//            return CGSize(width: 194.0, height: 200.0)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let breathArray = homeData?.exercises else { return 0 }
        guard let blogArray = homeData?.blogs else { return 0 }
        
        
        if collectionView == collBreathExercise {
            return breathArray.count
        } else if collectionView == collBlog{
            return blogArray.count
        } else if collectionView == collRec{
            return 5
        } else
        {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collBreathExercise {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellBreath", for: indexPath) as! CellBreath
            
            if let imgBreath = homeData?.exercises?[indexPath.row].location {
                cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgBreath = homeData?.exercises?[indexPath.row].exercise_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
//                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            cell.lblTitle.text = homeData?.exercises?[indexPath.row].name
            
            return cell
            
        } else if collectionView == collBlog{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellBlog", for: indexPath) as! CellBlog
            
            if let imgBlog = homeData?.blogs?[indexPath.row].location {
                cell.imgView.sd_setImage(with: URL(string: imgBlog), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            }
//            if let imgBlog = homeData?.blogs?[indexPath.row].blog_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBlog
//                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            if let date = homeData?.blogs?[indexPath.row].add_date {
                cell.lblDate.text = convertDateFormat(inputDate: date)
                cell.lblDate.textColor = UIColor.colorSetup()
            }
            
            cell.lblTitle.text = homeData?.blogs?[indexPath.row].title
            cell.lblDesc.attributedText = homeData?.blogs?[indexPath.row].description?.htmlToAttributedString
            
            return cell
        }
        else if collectionView == collRec{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellRecord", for: indexPath) as! CellRecord
            
        //    if let imgBreath = homeData?.exercises?[indexPath.row].location {
              //  cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                
                var yourArray = [String]()
                yourArray.append("7.png")
                yourArray.append("10.png")
                yourArray.append("9.png")
                yourArray.append("1.png")
                yourArray.append("5.png")
            
            var yourArray1 = [String]()
            yourArray1.append("Meditation")
            yourArray1.append("Yoga")
            yourArray1.append("Healthy Eating")
            yourArray1.append("Gratitude")
            yourArray1.append("Meditation Music")
                cell.imgView.image = UIImage(named: yourArray[indexPath.row])
      //      }
//            if let imgBreath = homeData?.exercises?[indexPath.row].exercise_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
//                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            cell.lblTitle.text = yourArray1[indexPath.row]
            
            
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLive", for: indexPath) as! CellLive
            
           // if let imgBreath = homeData?.exercises?[indexPath.row].location {
               // cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
                
                var yourArray = [String]()
                yourArray.append("2.png")
                yourArray.append("6.png")
                yourArray.append("3.png")
                yourArray.append("8.png")
                yourArray.append("4.png")
                cell.imgView.image = UIImage(named: yourArray[indexPath.row])
            
            var yourArray1 = [String]()
            yourArray1.append("Meditation")
            yourArray1.append("Yoga")
            yourArray1.append("Healthy Eating")
            yourArray1.append("Gratitude")
            yourArray1.append("Meditation Music")
       //     }
 //           if let imgBreath = homeData?.exercises?[indexPath.row].exercise_img {
//                let finalImgPath = Common.WebserviceAPI.baseURL + imgBreath
//                cell.imgView.sd_setImage(with: URL(string: finalImgPath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//            }
            
            cell.lblTitle.text = yourArray1[indexPath.row]
            
            return cell
        }
        
   
           // return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collBreathExercise {
            // Default will be current blocked chakra coming from chakra level api
//            guard let blockedChakraID = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraID) as? String else { return }
//            guard let blockedChakraName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udBlockedChakraName) as? String else { return }
            //Temporary data - Root Chakra as default blocked chakra (Bhaiya)----------------
            let blockedChakraID = ConstantChakraID.rootChakra
            let blockedChakraName = ConstantChakraName.rootChakra
            
            UserDefaults.standard.set(false, forKey: "isFromMeditation")
            
            //Store relax breathing & music breathing id and do check on audio player view controller
            if homeData?.exercises?[indexPath.row].exerciseId == ConstantBreathExerciseID.relaxBreath {
                UserDefaults.standard.set(homeData?.exercises?[indexPath.row].exerciseId, forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
                
            }else if homeData?.exercises?[indexPath.row].exerciseId == ConstantBreathExerciseID.musicBreath {
                UserDefaults.standard.set(homeData?.exercises?[indexPath.row].exerciseId, forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID)//Store music breath id
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
                
            } else {
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultMusicBreathingID) //Store music breath id
                UserDefaults.standard.set("999999", forKey: ConstantUserDefaultTag.udDefaultRelaxBreathingID) //Store relax id
            }
            
            let meditationAudioRequestData = MeditationAudioRequest(meditationId: ConstantMeditationID.blockedChakras, chakraId: blockedChakraID, chakraName: blockedChakraName, exerciseId: homeData?.exercises?[indexPath.row].exerciseId, exerciseName: homeData?.exercises?[indexPath.row].name, time: nil, VCName: ConstantMeditationStaticName.blocked)
            
            let exerciseTimeVC = ConstantStoryboard.meditationStoryboard.instantiateViewController(withIdentifier: "MeditationQuestionTimeViewController") as! MeditationQuestionTimeViewController
            exerciseTimeVC.hideSkipBtn = true
            exerciseTimeVC.meditationAudioRequestData =  meditationAudioRequestData
            navigationController?.pushViewController(exerciseTimeVC, animated: true)
            
        } else if collectionView == collBlog{
            let blogDetailVC = ConstantStoryboard.blogStoryboard.instantiateViewController(withIdentifier: "BlogDetailsViewController") as! BlogDetailsViewController
            blogDetailVC.homeBlog = homeData?.blogs?[indexPath.row]
            navigationController?.pushViewController(blogDetailVC, animated: true)
        }else if collectionView == collRec{
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Recorded Sessions is coming soon", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
               
            }))

    //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //              print("Handle Cancel Logic here")
    //        }))

            present(refreshAlert, animated: true, completion: nil)
            
            
        }else{
            
            let refreshAlert = UIAlertController(title: "Luvo", message: "Live Sessions is coming soon", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                  print("Handle Ok logic here")
               
            }))

    //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //              print("Handle Cancel Logic here")
    //        }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func convertDateFormat(inputDate: String) -> String {
        let oldDate = Date().UTCFormatter(date: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.timeZone = TimeZone.current
        convertDateFormatter.dateFormat = "dd-MMM-yyyy"
        
        return convertDateFormatter.string(from: oldDate)
    }
}
