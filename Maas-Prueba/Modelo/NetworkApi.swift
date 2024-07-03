//
//  NetworkApi.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 1/07/24.
//

import Foundation
import Alamofire

class NetworkApi {
    
    static func validarTullave(serial: String) async -> ResponseValidCard? {
        do {
            let data = try await NetworkManager.shared.validarEstado(serial: serial)
            var result: ResponseValidCard? = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func informacionTullave(serial: String) async -> ResponseCardInformation? {
        do {
            let data = try await NetworkManager.shared.informacionTarjeta(serial: serial)
            var result: ResponseCardInformation? = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static func parseData<T: Decodable>(data: Data) throws -> T? {
        if !data.isEmpty {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch let error {
                print(error.localizedDescription)
                
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found: \(context)")
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: '\(type)' \(context)")
                    case .valueNotFound(let type, let context):
                        print("Value not found for type '\(type)': \(context)")
                    @unknown default:
                        print("An unknown decoding error occurred")
                    }
                } else {
                    print("Error not identified")
                }
                throw NSError(
                    domain: "NetworkAPIError",
                    code: 3,
                    userInfo: [NSLocalizedDescriptionKey: "JSON decode error"]
                )
            }
        } else {
            print("Empty data")
            return nil
        }
    }
}

