//
//  AgoraUserProfileModel.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 11/12/22.
//

import Foundation
protocol AgoraUserProfileModelDelegate
{

    func didReceiveAgoraUserProfileModelResponse(AgoraResponse: AgoraUserProfileImageResponse?)
    func didReceiveAgoraUserProfileModelError(statusCode: String?)
}


struct AgoraUserProfileModel
{
    var AgoraUserdelegate: AgoraUserProfileModelDelegate?

    func getAgoraliveUerDetails(token: String, SesionId:String)
    {

        let url1 = Common.WebserviceAPI.AgoraLiveUserImageAPI+SesionId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!

        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: AgoraUserProfileImageResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.AgoraUserdelegate?.didReceiveAgoraUserProfileModelResponse(AgoraResponse: result)
                } else {
                    debugPrint(error!)
                    self.AgoraUserdelegate?.didReceiveAgoraUserProfileModelError(statusCode: error)
                }
            }
        }
    }

}
