//
//  CoreDataManager.swift
//  SephoraTechnicalTest
//
//  Created by Achref LETAIEF on 28/09/2023.
//

import CoreData
import Foundation

final class CoreDataManager {

    static let shared = CoreDataManager()
    private let productEntity = "ProductEntity"

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveProducts(_ products: [Product]) {
        let entity = NSEntityDescription.entity(forEntityName: productEntity, in: context)!
        // Clean all existing products
        deleteAllProducts()
        for product in products {
            let productEntity = NSManagedObject(entity: entity, insertInto: context) as! ProductEntity
            productEntity.productId = Int64(product.productId)
            productEntity.productName = product.productName
            productEntity.productDescription = product.description
            productEntity.price = product.price
            productEntity.isProductSet = product.isProductSet
            productEntity.isSpecialBrand = product.isSpecialBrand

            let brandEntity = BrandEntity(context: context)
            brandEntity.id = product.cBrand.id
            brandEntity.name = product.cBrand.name
            productEntity.brandRelation = brandEntity
            
            let imageURLsEntity = ImageURLsEntity(context: context)
            imageURLsEntity.small = product.imagesUrl.small
            imageURLsEntity.large = product.imagesUrl.large
            productEntity.imageURLsRelation = imageURLsEntity
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchProducts() -> [Product] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "productId", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            
            let productEntities = try context.fetch(request)
            return productEntities.map { productEntity in
                let id = Int(productEntity.productId)
                let name = productEntity.productName ?? ""
                let description = productEntity.productDescription ?? ""
                let price = productEntity.price
                let isProductSet = productEntity.isProductSet
                let isSpecialBrand = productEntity.isSpecialBrand
                
                let brand = Brand(id: productEntity.brandRelation?.id ?? "", name: productEntity.brandRelation?.name ?? "")
                let imageURLs = ImageURLs(small: productEntity.imageURLsRelation?.small ?? "", large: productEntity.imageURLsRelation?.large ?? "")
                
                return Product(productId: id,
                               productName: name,
                               description: description,
                               price: price,
                               imagesUrl: imageURLs,
                               cBrand: brand,
                               isProductSet: isProductSet,
                               isSpecialBrand: isSpecialBrand)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    
    func deleteAllProducts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
