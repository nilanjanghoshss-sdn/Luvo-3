//
//  AgoraUserProfileImageResponse.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 11/12/22.
//

import Foundation


struct AgoraUserProfileImageResponse: Decodable
{

    let status: String?
    let message: String?
    let userdetails: [UserDetails]?

    enum CodingKeys: String, CodingKey {

        case status
        case message
        case userdetails

    }

}

struct UserDetails: Decodable
{
    let chakraRes: Int?
    let dailyGoal: Int?
    let dailyWater: Int?
    let setRem: Int?
    let timeZone: String?
    let _id: String?
    let userId: String?
    let userName: String?
    let userEmail: String?
    let mobileNo: String?
    let profileImg: String?
    let location: String?
    let regDate: String?
    let status: String?
    let socialId: String?

    enum CodingKeys: String, CodingKey {

        case chakraRes
        case dailyGoal
        case dailyWater
        case setRem
        case timeZone
        case _id
        case userId
        case userName
        case userEmail
        case mobileNo
        case profileImg
        case location
        case regDate
        case status
        case socialId


    }

}


