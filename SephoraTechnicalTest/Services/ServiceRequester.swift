//
//  ServiceRequester.swift
//  SephoraTechnicalTest
//
//  Created by Achref LETAIEF on 27/09/2023.
//

import RxSwift

enum APIError: Error {
    case failedToCreateURL
    case serverError
}

protocol ServiceRequesterType {
    func request<T: Codable>(endPoint: String) -> Single<T>
}

final class ServiceRequester: ServiceRequesterType {
    
    private let baseUrl = "https://sephoraios.github.io"
    
    func request<T: Codable>(endPoint: String) -> Single<T> {
        return Single.create { [weak self] single in
            guard let self = self,
                  let url = URL(string: self.baseUrl + endPoint) else {
                single(.failure(APIError.failedToCreateURL))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    single(.failure(APIError.serverError))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    single(.success(model))
                } catch let error {
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
