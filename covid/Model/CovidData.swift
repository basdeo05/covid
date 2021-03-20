//
//  CovidModel.swift
//  covid
//
//  Created by Richard Basdeo on 11/10/20.
//

import Foundation

struct CovidData: Codable{
    
    let death: Int
    let hospitalizedCurrently: Int
    let hospitalizedIncrease: Int
    let positiveIncrease: Int
}
