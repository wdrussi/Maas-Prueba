//
//  TarjetaView.swift
//  Maas-Prueba
//
//  Created by DanielRussi   on 25/06/24.
//

import SwiftUI
import Alamofire

struct Tarjeta: Identifiable, Codable {
    let id : UUID
    var nombreCompleto: String
    let serialTuLlave: String
    let perfilTarjeta: String
    var imgtarjetaTullave: String
}

struct TarjetaView: View {
    @StateObject private var tarjetaViewModel = TarjetaViewModel()

    var body: some View {
        VStack {
            TextField("Numero de Tarjeta", text: $tarjetaViewModel.numeroTarjeta)
                .keyboardType(.numberPad)
                .onChange(of: tarjetaViewModel.numeroTarjeta) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        tarjetaViewModel.numeroTarjeta = filtered
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
                
                Button(action: tarjetaViewModel.borrarTodasLasTarjetas) {
                    Text("Eliminar Todo")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            List {
                ForEach(tarjetaViewModel.listaTarjetas) { tarjeta in
                    HStack {
                        Image("imgtarjetaTullave")
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
                        Button(action: { tarjetaViewModel.borrarTarjeta(tarjeta) }) {
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
            tarjetaViewModel.cargarTarjetas()
        }
    }
    
    func registrarTarjeta()  {
        tarjetaViewModel.ValidacionTarjeta(serial: tarjetaViewModel.numeroTarjeta)
        tarjetaViewModel.numeroTarjeta = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TarjetaView()
    }
}
