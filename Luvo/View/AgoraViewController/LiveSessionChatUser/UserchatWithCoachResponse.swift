//
//  UserchatWithCoachResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 28/12/22.
//

import Foundation

struct UserchatWithCoachResponse: Decodable
{
    
    let status:String?
    let message:String?
    let results: ResultData?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case results
    }
    
    
    
    
}

struct ResultData: Decodable
{
    let _id: String?
    let hatBy: String?
    let chatOn: String?
    let text: String?
    let sessionId: String?
   // let __v: String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id
        case hatBy
        case chatOn
        case text
        case sessionId
    }

}
