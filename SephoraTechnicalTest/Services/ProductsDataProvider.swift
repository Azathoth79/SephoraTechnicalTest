//
//  ProductsDataProvider.swift
//  SephoraTechnicalTest
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import RxSwift

protocol ProductsDataProviderType {
    func getProducts() -> Single<[Product]>
}

struct ProductsDataProvider: ProductsDataProviderType {
    
    private let serviceRequester: ServiceRequesterType

    init(serviceRequester: ServiceRequesterType = ServiceRequester()) {
        self.serviceRequester = serviceRequester
    }
    
    func getProducts() -> Single<[Product]> {
        serviceRequester.request(endPoint: "/items.json")
    }
}
