//
//  FirstScreenModel.swift
//  CostTracking
//
//  Created by Ян Нурков on 24.12.2022.
//

import Foundation

struct Product: Decodable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: Bpi
}

// MARK: - Bpi
struct Bpi: Decodable {
    let USD: USD
    let GBP: USD
    let EUR: USD
    
    enum CodingKeys: String, CodingKey {
        case USD
        case GBP
        case EUR
    }
}

// MARK: - Usd
struct USD: Decodable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rate_float: Double
    
    enum CodingKeys: String, CodingKey {
        case code
        case symbol
        case rate
        case description
        case rate_float
    }
}

// MARK: - Time
struct Time: Decodable {
    let updated: String
    let updateduk: String
}





