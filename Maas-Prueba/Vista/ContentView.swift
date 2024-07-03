//
//  ContentView.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 25/06/24.
//

import SwiftUI
import Alamofire

struct Tarjeta: Identifiable, Codable {
    let id : UUID
    let nombreCompleto: String
    let serialTuLlave: String
    let perfilTarjeta: String
    var imgtarjetaTullave: String
}

struct ContentView: View {
    @StateObject private var tarjetaViewModel = TarjetaViewModel()
    @State private var numeroTarjeta: String = ""
    @State private var listaTarjetas: [Tarjeta] = []
    
    var body: some View {
        VStack {
            TextField("Numero de Tarjeta", text: $numeroTarjeta)
                .keyboardType(.numberPad)
                .onChange(of: numeroTarjeta) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        numeroTarjeta = filtered
                    }
                }
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text(tarjetaViewModel.resultText)
                .foregroundColor(.yellow)
                .opacity(tarjetaViewModel.resultText.isEmpty ? 0 : 1)
                .padding()
            

            HStack {
                Button(action: registrarTarjeta) {
                    Text("Añadir")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: borrarTodasLasTarjetas) {
                    Text("Eliminar Todo")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            List {
                ForEach(listaTarjetas) { tarjeta in
                    HStack {
                        Image(tarjeta.imgtarjetaTullave)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text(tarjeta.nombreCompleto)
                                .font(.headline)
                            Text(tarjeta.serialTuLlave)
                            Text(tarjeta.perfilTarjeta)
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: { borrarTarjeta(tarjeta) }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            
            
            if tarjetaViewModel.isLoading {
                ProgressView("Cargando...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
        .allowsHitTesting(!tarjetaViewModel.isLoading)
        .onAppear{
            cargarTarjetas()
        }
    }
    
    func registrarTarjeta()  {
        let card: ResponseValidCard = tarjetaViewModel.ValidacionTarjeta(serial: numeroTarjeta)!
        let tarjetaTuLlave: ResponseCardInformation = tarjetaViewModel.ConsultarTarjeta(card: card)!
        let nuevoTarjeta = Tarjeta(id: UUID(), nombreCompleto: tarjetaTuLlave.userName! + " " + tarjetaTuLlave.userLastName!,
                                   serialTuLlave: tarjetaTuLlave.cardNumber!, perfilTarjeta: tarjetaTuLlave.profile_es!, imgtarjetaTullave: "imgtarjetaTullave")
        listaTarjetas.append(nuevoTarjeta)
        guardarTarjeta()
        numeroTarjeta = ""
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
