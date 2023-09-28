//
//  Product.swift
//  SephoraTechnicalTest
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import Foundation

struct ImageURLs: Codable {
    let small: String
    let large: String
}

struct Brand: Codable {
    let id: String
    let name: String
}

struct Product: Codable {
    let productId: Int
    let productName: String
    let description: String
    let price: Double
    let imagesUrl: ImageURLs
    let cBrand: Brand
    let isProductSet: Bool
    let isSpecialBrand: Bool
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productName = "product_name"
        case description
        case price
        case imagesUrl = "images_url"
        case cBrand = "c_brand"
        case isProductSet = "is_productSet"
        case isSpecialBrand = "is_special_brand"
    }
}
