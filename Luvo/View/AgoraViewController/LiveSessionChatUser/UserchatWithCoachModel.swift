//
//  UserchatWithCoachModel.swift
//  Luvo
//
//  Created by BEASiMAC on 28/12/22.
//

import Foundation
protocol UserchatWithCoachModelDelegate {
    func didReceiveUserchatWithCoachResponse(ChatResponse: UserchatWithCoachResponse?)
    func didReceiveUserchatWithCoachError(statusCode: String?)
}

struct UserchatWithCoachModel
{
    var Chatdelegate: UserchatWithCoachModelDelegate?

    func postChatJoinData(Chat: UserChatRequest, token: String) {
        let url = URL(string: Common.WebserviceAPI.userChatAPI)!
        let httpUtility = HttpUtility()
        do {
            let postBody = try JSONEncoder().encode(Chat)
            httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: UserchatWithCoachResponse.self) { (result, error) in
                DispatchQueue.main.async {
                    if (error == nil) {
                        self.Chatdelegate?.didReceiveUserchatWithCoachResponse(ChatResponse: result)
                    } else {
                        debugPrint(error!)
                        self.Chatdelegate?.didReceiveUserchatWithCoachError(statusCode: error)
                    }
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
}
