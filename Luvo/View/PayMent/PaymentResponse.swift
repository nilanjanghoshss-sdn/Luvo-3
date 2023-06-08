//
//  PaymentResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 21/03/23.
//

import Foundation
struct PaymentResponse : Decodable
{
    let status: String?
    let message: String?
    let data: [paymentData]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case data
        
    }
}

struct paymentData : Decodable
{
    
    let amount: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case amount
    }
}
