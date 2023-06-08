//
//  AllUserChatModel.swift
//  Luvo
//
//  Created by BEASiMAC on 28/12/22.
//

import Foundation
protocol AllUserChatModelDelegate {
    func didReceiveAllUserChatResponse(ChatAllResponse: AllUserChatResponse?)
    func didReceiveAllUserChatModelError(statusCode: String?)
}

struct AllUserChatModel
{
    
    var AllUserChatdelegate: AllUserChatModelDelegate?
    
    func getChatDetails(token: String, SessionID:String)
    {
        
        let url1 = Common.WebserviceAPI.userAllChatAPI+SessionID

       // let url1 = Common.WebserviceAPI.RecoredeSessionList+catagoryId
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: AllUserChatResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.AllUserChatdelegate?.didReceiveAllUserChatResponse(ChatAllResponse: result)
                } else {
                    debugPrint(error!)
                    self.AllUserChatdelegate?.didReceiveAllUserChatModelError(statusCode: error)
                }
            }
        }
    }
}
