//
//  ProductMock.swift
//  SephoraTechnicalTestTests
//
//  Created by Achref LETAIEF on 27/09/2023.
//

@testable import SephoraTechnicalTest

extension Product {
    static func mock(id: Int = 0, name: String, isSpecialBrand: Bool, brandName: String = "random brand") -> Product {
        Product(
            productId: id,
            productName: name,
            description: "some description",
            price: 100.0,
            imagesUrl: ImageURLs(small: "", large: ""),
            cBrand: Brand(id: "", name: brandName),
            isProductSet: false,
            isSpecialBrand: isSpecialBrand
        )
    }
}
