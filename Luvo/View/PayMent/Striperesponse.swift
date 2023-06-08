//
//  Striperesponse.swift
//  Luvo
//
//  Created by BEASiMAC on 29/03/23.
//

import Foundation
struct Striperesponse : Decodable
{
    let status : String?
    let paymentDetails : paymentDetailsNew?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case paymentDetails
       
    }
}
struct paymentDetailsNew : Decodable
{
    let paymentIntent : String?
    let ephemeralKey : String?
    let customerId : String?
    let customerName : String?
    let customerEmail : String?
    let publishableKey : String?
    
    enum CodingKeys: String, CodingKey {
        case paymentIntent
        case ephemeralKey
        case customerId
        case customerName
        case customerEmail
        case publishableKey
    }
}
