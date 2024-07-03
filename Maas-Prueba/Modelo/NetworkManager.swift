//
//  NetworkManager.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 1/07/24.
//

import Foundation
import Alamofire

actor NetworkManager: GlobalActor {

    static let shared = NetworkManager()
    
    private init() {}
    
    let baseURL: String = "https://osgqhdx2wf.execute-api.us-west-2.amazonaws.com/card/"
    
    let tokenWR = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJtYWFzIiwiaXNzIjoicmJzYXMuY28iLCJjb21wYW55IjoiMTAwMCIsImV4cCI6MTcyMjYxNDU5MSwiaWF0IjoxNzE5OTM2MTkxLCJHcnVwb3MiOiJbXCJVbml2ZXJzYWxSZWNoYXJnZXJcIl0ifQ.UhFLke6LgPeT3uzCRZVEcOkz4RX7Y54Sng2qscPurgpGaAPrDSzieG-ql38stIn92U-UQtj04Wa24UWsDCwhqJQb1Q1HhdZRYpSSk3t0oEAhilPviZG_BiuWzejBruDMWevY3R2beLHRkqAuob7q6yLjfiBA4Kv2WEgxTZKkprmOWmcYhb8kKRnGP_5nfHUgRfxLyBOKo94uR6tNuYpYf6nvA7tQeiwOjgO2LRZkJdy39FRlrKYyh3VYOBdbdJIT4eHD2VFxQiKalF_PzXo019pt8xpwfLg3QqKEhhUWN5OSotM8Feo2UfFdj8VFkbTg6HMynI2F4mdegBrJnGgu1w"
    
    
    func validarEstado(serial: String?) async throws -> Data {
        let headers: HTTPHeaders = [
            "Authorization": tokenWR,
            "Accept": "application/json"
        ]
        let path = "valid/"
        let url = baseURL+path+(serial ?? "")
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                headers: headers//,
            )
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    //configurar sdk para el tema de los mapas parte 2

    func informacionTarjeta(serial: String?) async throws -> Data {
        let headers: HTTPHeaders = [
            "Authorization": tokenWR,
            "Accept": "application/json"
        ]
        let path = "getInformation/"
        let url = baseURL+path+(serial ?? "")
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                headers: headers//,
            )
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
