//
//  ServiceRequesterMock.swift
//  SephoraTechnicalTestTests
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import RxSwift
@testable import SephoraTechnicalTest

final class ServiceRequesterMock: ServiceRequesterType {
    
    var successResponse: Decodable?
    var failureResponse: Error?
    
    func request<T>(endPoint: String) -> Single<T> {
        if let successResponse = successResponse as? T {
            return .just(successResponse)
        } else if let failureResponse = failureResponse {
            return .error(failureResponse)
        } else {
            fatalError("You must set either successResponse or failureResponse for testing.")
        }
    }
    
    
}
