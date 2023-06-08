//
//  PaymentDataModel.swift
//  Luvo
//
//  Created by BEASiMAC on 21/03/23.
//

import Foundation
protocol PaymentDataModelDelegate {
    func didReceivePaymentDataModelDelegateResponse(PaymentDataModelresponse: PaymentResponse?)
    func didReceivePaymentDataModelDelegateError(statusCode: String?)
}

struct PaymentDataModel
{
    
    var paymentDelegate : PaymentDataModelDelegate?
    
    
    func getpaymentData(token:String) {

        let url1 = Common.WebserviceAPI.donationAPI
        guard let urlStrings = url1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let homeUrl = URL(string: urlStrings)!
        
        let httpUtility = HttpUtility()
        httpUtility.getApiData(requestUrl: homeUrl, token: token, resultType: PaymentResponse.self) { result, error in
            DispatchQueue.main.async {
                if (error == nil) {
                    self.paymentDelegate?.didReceivePaymentDataModelDelegateResponse(PaymentDataModelresponse: result)
                } else {
                    debugPrint(error!)
                    self.paymentDelegate?.didReceivePaymentDataModelDelegateError(statusCode: error)
                }
            }
        }
    }
}
