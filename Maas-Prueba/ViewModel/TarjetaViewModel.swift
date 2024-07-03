//
//  TarjetaViewModel.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 1/07/24.
//

import Foundation

class TarjetaViewModel: ObservableObject {
    var card: ResponseValidCard? = nil
    @Published var tarjetaTullave: ResponseCardInformation? = nil
    @Published var numeroTarjeta: String = ""
    @Published var isLoading = false
    @Published var resultText: String = ""
    @Published var listaTarjetas: [Tarjeta] = []
    
    func ValidacionTarjeta(serial: String) {
        self.isLoading = true
        NetworkManager.shared.validarEstado(serial: serial) { result in
            switch result {
            case .success(let data):
                    self.card = data
                    self.ConsultarTarjeta(serial: serial)
            case .failure(let error):
                    print("Error validating card: \(error)")
            }
        }
    }
    
    func ConsultarTarjeta(serial: String) {
        self.isLoading = true
        if self.card?.isValid ?? false {
            NetworkManager.shared.informacionTarjeta(serial: serial) { result in
                switch result {
                case .success(let data):
                        self.tarjetaTullave = data
                        if self.tarjetaTullave?.cardNumber != nil {
                            let nuevoTarjeta = Tarjeta(
                                id: UUID(),
                                nombreCompleto: (self.tarjetaTullave?.userName)! + " " + (self.tarjetaTullave?.userLastName)!,
                                serialTuLlave: (self.tarjetaTullave?.cardNumber)!,
                                perfilTarjeta: (self.tarjetaTullave?.profile_es)!,
                                imgtarjetaTullave: "imgtarjetaTullave"
                            )
                            self.listaTarjetas.append(nuevoTarjeta)
                            self.guardarTarjeta()
                            self.resultText = "Tarjeta Registrada"
                        } else {
                            self.resultText = "Error "+(self.tarjetaTullave?.errorMessage ?? "")
                            
                        }
                case .failure(let error):
                        print("Error validating card: \(error)")
                }
            }
        } else {
            self.resultText = "Error Tarjeta No Valida"
        }
        self.isLoading = false
    }
    
    func borrarTarjeta(_ tarjeta: Tarjeta) {
        if let index = listaTarjetas.firstIndex(where: { $0.id == tarjeta.id }) {
            listaTarjetas.remove(at: index)
            guardarTarjeta()
        }
    }
    
    func guardarTarjeta() {
        do {
            let data = try JSONEncoder().encode(listaTarjetas)
            let url = getDocumentsDirectory().appendingPathComponent("tarjetas.json")
            try data.write(to: url)
        } catch {
            print("Error al guardar tarjetas: \(error.localizedDescription)")
        }
    }
    
    func cargarTarjetas() {
        let url = getDocumentsDirectory().appendingPathComponent("tarjetas.json")
        do {
            let data = try Data(contentsOf: url)
            listaTarjetas = try JSONDecoder().decode([Tarjeta].self, from: data)
        } catch {
            print("Error al cargar tarjetas: \(error.localizedDescription)")
        }
    }
    
    func borrarTodasLasTarjetas() {
        listaTarjetas.removeAll()
        guardarTarjeta()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
