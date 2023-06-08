//
//  StripePaymentRequest.swift
//  Luvo
//
//  Created by BEASiMAC on 29/03/23.
//

import Foundation
struct StripePaymentRequest : Encodable
{
        var amount: String?
        var currency: String?
        var customerName: String?
        var customerEmail: String?

}
