//
//  TarjetaViewModel.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 1/07/24.
//

import Foundation

@MainActor class TarjetaViewModel: ObservableObject {
    var serialTarjeta = ""
    var errorMessage = ""
    var card: ResponseValidCard? = nil
    var tarjetaTullave: ResponseCardInformation? = nil
    @Published var isLoading = false
    @Published var resultText: String = ""
    @Published var tarjetas: [ResponseCardInformation] = []
    
    func ValidacionTarjeta(serial: String) -> ResponseValidCard? {
        self.isLoading = true
        /*Task {
         if let validateCard = await NetworkApi.validarTullave(serial: serial) {
         self.card = validateCard
         } else {
         self.errorMessage = "Error ValidacionTarjeta TarjetaViewModel"
         }
         }*/
        //mock
        self.card = ResponseValidCard(card: "1010000008550436", isValid: true, status: "0", error: "no error")
        
        return self.card
    }
    
    // terminar de construir metodo de consulta tarjeta
    func ConsultarTarjeta(card: ResponseValidCard) -> ResponseCardInformation? {
        self.isLoading = true
        /*
        Task {
            if card.isValid ?? false {
                if let tarjeta = await NetworkApi.informacionTullave(serial: card.card ?? "0") {
                    self.tarjetaTullave = tarjeta
                    self.resultText = "Tarjeta Registrada"
                    self.isLoading = false
                }else {
                    self.errorMessage = "Error ConsultarTarjeta TarjetaViewModel"
                }
            } else {
                self.resultText = "Error Tarjeta No Valida"
            }
        }*/
        //mock
        self.resultText = "Tarjeta Registrada"
        self.tarjetaTullave = ResponseCardInformation(cardNumber: "1010000008550436", profileCode: "ad2", profile: "ad", profile_es: "adulto", bankCode: "23",
                                                      bankName: "bbva", userName: "mockeador", userLastName: "mocksito")
        self.isLoading = false
        //fin mock
        return tarjetaTullave
    }
}
