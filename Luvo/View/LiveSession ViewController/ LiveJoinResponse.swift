//
//  LiveJoinResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 10/12/22.
//

import Foundation

struct LiveJoinResponse: Decodable
{
    let status: String?
    let joinedsessionsdetails: [Details]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case sessionList
    }
    
    
}

struct Details: Decodable
{
    
    
}
