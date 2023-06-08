//
//  UserDetailsForCallModel.swift
//  Luvo
//
//  Created by BEASiMAC on 02/03/23.
//

import Foundation
protocol UserDetailsForCallModelDelegate
{
    func didReceiveUserDetailsForCallModelResponse(UserDetailsForCall: UserDetailsForCallResponse?)
    func didReceiveUserDetailsForCallModelError(statusCode: String?)
}
struct UserDetailsForCallModel
{
    var UserDetailsForCallModeldelegate: UserDetailsForCallModelDelegate?

    func getUserDetailsForCallDetails(token: String, SesionId:String)
    {

        let url1 = Common.WebserviceAPI.CoachSessionStatusAPI+SesionId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!

        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: UserDetailsForCallResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.UserDetailsForCallModeldelegate?.didReceiveUserDetailsForCallModelResponse(UserDetailsForCall: result)
                } else {
                    debugPrint(error!)
                    self.UserDetailsForCallModeldelegate?.didReceiveUserDetailsForCallModelError(statusCode: error)
                }
            }
        }
    }

}
