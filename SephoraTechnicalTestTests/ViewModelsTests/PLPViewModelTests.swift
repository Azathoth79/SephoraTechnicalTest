//
//  PLPViewModelTests.swift
//  SephoraTechnicalTestTests
//
//  Created by Achref LETAIEF on 28/09/2023.
//

import XCTest

@testable import SephoraTechnicalTest

final class PLPViewModelTests: XCTestCase {
    
    var serviceRequesterMock: ServiceRequesterMock!
    var dataProvider: ProductsDataProvider!
    var viewModel: PLPViewModel!
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        // Delete all records before each test
        coreDataManager = CoreDataManager.shared
        coreDataManager.deleteAllProducts()
        serviceRequesterMock = ServiceRequesterMock()
    }
    
    override func tearDown() {
        serviceRequesterMock = nil
        dataProvider = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchProductsSuccess() {
        let mock1 = Product.mock(name: "product 1", isSpecialBrand: false)
        let mock2 = Product.mock(name: "product 2", isSpecialBrand: false)
        let mock3 = Product.mock(name: "product 3", isSpecialBrand: true)
        let expectedResponse =  [mock1, mock2, mock3]
        serviceRequesterMock.successResponse = expectedResponse
        dataProvider = ProductsDataProvider(serviceRequester: serviceRequesterMock)
        viewModel = PLPViewModel(productsDataProvider: dataProvider)
        let expect = expectation(description: "Products fetched")
        
        viewModel.onReloadData = {
            expect.fulfill()
        }
        
        viewModel.fetchProducts()
        
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(viewModel.numberOfCells(), 3)
        XCTAssertEqual(viewModel.cell(at: 0).productName, "product 3")
        XCTAssertEqual(viewModel.cell(at: 0).isSpecialBrand, true)
        XCTAssertEqual(viewModel.cell(at: 1).productName, "product 1")
        XCTAssertEqual(viewModel.cell(at: 1).isSpecialBrand, false)
        XCTAssertEqual(viewModel.cell(at: 2).productName, "product 2")
        XCTAssertEqual(viewModel.cell(at: 2).isSpecialBrand, false)
    }
    
    func testFetchProductsFailure() {
        let expectedResponse =  NSError(domain: "", code: 400)
        serviceRequesterMock.successResponse = nil
        serviceRequesterMock.failureResponse = expectedResponse
        dataProvider = ProductsDataProvider(serviceRequester: serviceRequesterMock)
        viewModel = PLPViewModel(productsDataProvider: dataProvider)
        let expect = expectation(description: "Should not have any products")
        
        viewModel.onReloadData = {
            expect.fulfill()
        }
        
        viewModel.fetchProducts()
        
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(viewModel.numberOfCells(), 0)
    }
}
