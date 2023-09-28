//
//  CoreDataManagerTests.swift
//  SephoraTechnicalTestTests
//
//  Created by Achref LETAIEF on 28/09/2023.
//

import XCTest
import CoreData
@testable import SephoraTechnicalTest

final class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        mockPersistentContainer = createMockPersistentContainer()
        coreDataManager.persistentContainer = mockPersistentContainer
    }

    override func tearDown() {
        coreDataManager = nil
        mockPersistentContainer = nil
        super.tearDown()
    }

    func createMockPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Item")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)

            if let error = error {
                fatalError("Create an in-memory coordinator failed \(error)")
            }
        }

        return container
    }

    func testSaveAndFetchProducts() {
        let mock1 = Product.mock(id: 1, name: "special product", isSpecialBrand: true, brandName: "chanel")
        let mock2 = Product.mock(id: 2, name: "another special product", isSpecialBrand: true, brandName: "dior")
        coreDataManager.saveProducts([mock1, mock2])
        let fetchedProducts = coreDataManager.fetchProducts()

        XCTAssertEqual(fetchedProducts.count, 2)
        XCTAssertEqual(fetchedProducts.first?.productName, "special product")
        XCTAssertEqual(fetchedProducts.first?.cBrand.name, "chanel")
        XCTAssertEqual(fetchedProducts[1].productName, "another special product")
        XCTAssertEqual(fetchedProducts[1].cBrand.name, "dior")
    }

    func testDeleteAllProducts() {
        let mock = Product.mock(name: "deleted product", isSpecialBrand: false)

        coreDataManager.saveProducts([mock])
        coreDataManager.deleteAllProducts()
        let fetchedProducts = coreDataManager.fetchProducts()

        XCTAssertEqual(fetchedProducts.count, 0)
    }
}
