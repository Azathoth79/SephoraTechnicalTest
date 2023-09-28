//
//  ProductsDataProviderTests.swift
//  SephoraTechnicalTestTests
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import XCTest
import RxSwift
import RxBlocking

@testable import SephoraTechnicalTest

final class ProductsDataProviderTests: XCTestCase {
    
    var serviceRequesterMock: ServiceRequesterMock!
    
    override func setUp() {
        super.setUp()
        serviceRequesterMock = ServiceRequesterMock()
    }
    
    override func tearDown() {
        serviceRequesterMock = nil
        super.tearDown()
    }
    
    func testGetProductsSuccess() {
        let mock1 = Product.mock(name: "product 1", isSpecialBrand: false)
        let mock2 = Product.mock(name: "product 2", isSpecialBrand: false)
        let mock3 = Product.mock(name: "product 3", isSpecialBrand: true)
        let expectedResponse =  [mock1, mock2, mock3]
        serviceRequesterMock.successResponse = expectedResponse

        let productsDataProvider = ProductsDataProvider(serviceRequester: serviceRequesterMock)

        let resultSingle = productsDataProvider.getProducts()
        
        let receivedEvent = resultSingle
            .toBlocking()
            .materialize()
        switch receivedEvent {
        case .completed(elements: let elements):
            XCTAssertEqual(elements.first?[0].productName, "product 1")
            XCTAssertEqual(elements.first?[0].isSpecialBrand, false)
            XCTAssertEqual(elements.first?[1].productName, "product 2")
            XCTAssertEqual(elements.first?[1].isSpecialBrand, false)
            XCTAssertEqual(elements.first?[2].productName, "product 3")
            XCTAssertEqual(elements.first?[2].isSpecialBrand, true)
        case .failed(_, _):
            XCTFail("Expected success, but received an error")
        }
    }
    
    func testGetProductsFailure() {
        let expectedResponse = NSError(domain: "", code: 400)
        serviceRequesterMock.failureResponse = expectedResponse

        let productsDataProvider = ProductsDataProvider(serviceRequester: serviceRequesterMock)

        let resultSingle = productsDataProvider.getProducts()
        
        let receivedEvent = resultSingle
            .toBlocking()
            .materialize()
        switch receivedEvent {
        case .completed(elements: _):
            XCTFail("Expected failure, but received success")
        case .failed(let elements, let error):
            XCTAssertEqual(error as NSError, expectedResponse)
            XCTAssertEqual(elements.count, 0)
        }
    }
}
