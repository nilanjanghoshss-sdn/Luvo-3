//
//  HomeViewModel.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 05/10/21.
//

import Foundation

protocol HomeViewModelDelegate {
    func didReceiveHomeResponse(homeResponse: HomeResponse?)
    func didReceiveHomeError(statusCode: String?)
}

protocol TimezoneDelegate {
    func didReceiveTimezoneResponse(timezoneResponse: TimezoneResponse?)
    func didReceiveTimezoneError(statusCode: String?)
}

protocol LogoutDelegate {
    func didReceiveLogoutResponse(logoutResponse: LogoutResponse?)
    func didReceiveLogoutError(statusCode: String?)
}

struct HomeViewModel {
    
    var delegate : HomeViewModelDelegate?
    var timezoneDelegate: TimezoneDelegate?
    var logoutDelegate: LogoutDelegate?
    
    func getHomeData(token: String, date: String) {
        let url = Common.WebserviceAPI.getHomeDataAPI+date
        guard let urlStrings = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: HomeResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.delegate?.didReceiveHomeResponse(homeResponse: result)
                } else {
                    debugPrint(error!)
                    self.delegate?.didReceiveHomeError(statusCode: error)
                }
            }
        }
    }
    
    //MARK: ----GTM Update
    func postGMTData(timezoneRequest: TimezoneRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.updateTimezone)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(timezoneRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.PUT, requestBody: postBody, token: token, resultType: TimezoneResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.timezoneDelegate?.didReceiveTimezoneResponse(timezoneResponse: result)
                    } else {
                        debugPrint(error!)
                        self.timezoneDelegate?.didReceiveTimezoneError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: ----Logout
    func postLogoutData(logoutRequest: LogoutRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.logoutAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(logoutRequest)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: LogoutResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.logoutDelegate?.didReceiveLogoutResponse(logoutResponse: result)
                    } else {
                        debugPrint(error!)
                        self.logoutDelegate?.didReceiveLogoutError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
}
