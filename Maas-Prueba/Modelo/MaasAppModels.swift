//
//  MaasAppModels.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 1/07/24.
//

import Foundation

struct ResponseValidCard: Decodable {
    let card: String?
    let isValid: Bool?
    let status: String?
    let error: String?
    /*mock
    init(card: String?, isValid: Bool?, status: String?, error: String?) {
        self.card = card
        self.isValid = isValid
        self.status = status
        self.error = error
    }*/
}

struct ResponseCardInformation:  Decodable {
    
  let cardNumber: String?
  let profileCode: String?
  let profile: String?
  let profile_es: String?
  let bankCode: String?
  let bankName: String?
  let userName: String?
  let userLastName: String?
  let errorMessage: String?
  let errorCode: String?
    /*mock
    init(cardNumber: String?, profileCode: String?, profile: String?, profile_es: String?, bankCode: String?, bankName: String?, userName: String?, userLastName: String?
         ) {
        self.cardNumber = cardNumber
        self.profileCode = profileCode
        self.profile = profile
        self.profile_es = profile_es
        self.bankCode = bankCode
        self.bankName = bankName
        self.userName = userName
        self.userLastName = userLastName
    }*/
}
