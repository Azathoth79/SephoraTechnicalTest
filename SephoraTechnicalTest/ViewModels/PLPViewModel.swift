//
//  PLPViewModel.swift
//  SephoraTechnicalTest
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import RxSwift

final class PLPViewModel {
    
    private let productsDataProvider: ProductsDataProviderType
    private let disposeBag = DisposeBag()
    private var items: [Product] = []

    var onReloadData: (() -> Void)?

    init(productsDataProvider: ProductsDataProviderType = ProductsDataProvider()) {
        self.productsDataProvider = productsDataProvider
        fetchProducts()
    }

    func numberOfCells() -> Int {
        items.count
    }

    func cell(at index: Int) -> Product {
        items[index]
    }

    func fetchProducts() {
        productsDataProvider
            .getProducts()
            .subscribe(onSuccess: { [weak self] products in
                guard let self = self else { return }
                self.items = self.sortItemsBySpecialBrand(items: products)
                CoreDataManager.shared.saveProducts(self.items) // Save products to Core Data
                self.onReloadData?()
            }, onFailure: { [weak self] _ in
                guard let self = self else { return }
                self.items = CoreDataManager.shared.fetchProducts() // Load products from Core Data
                self.items = self.sortItemsBySpecialBrand(items: self.items)
                self.onReloadData?()
            }).disposed(by: disposeBag)
    }
    
    private func sortItemsBySpecialBrand(items: [Product]) -> [Product] {
        items.sorted(by: { $0.isSpecialBrand && !$1.isSpecialBrand })
    }
}
