//
//  StripePaymentModel.swift
//  Luvo
//
//  Created by BEASiMAC on 29/03/23.
//

import Foundation
protocol StripePaymentDelegate {

        func didReceiveStripeResponse(StripeResponse: Striperesponse?)
        func didReceiveStripeError(statusCode: String?)
    }

struct StripePaymentModel
{
    var StripeDelegate : StripePaymentDelegate?

        func postStripeData(Request: StripePaymentRequest, token: String) {
            let url = URL(string: Common.WebserviceAPI.StripeAPI)!
            let httpUtility = HttpUtility()
            do {
                let postBody = try JSONEncoder().encode(Request)
                httpUtility.postApiData(requestUrl: url, httpMethod: ConstantHttpMethod.POST, requestBody: postBody, token: token, resultType: Striperesponse.self) { (result, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            self.StripeDelegate?.didReceiveStripeResponse(StripeResponse: result)
                        } else {
                            debugPrint(error!)
                            self.StripeDelegate!.didReceiveStripeError(statusCode: error)
                        }
                    }
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }

}
