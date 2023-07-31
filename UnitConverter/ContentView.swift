//
//  ContentView.swift
//  UnitConverter
//
//  Created by Abu Sayeed Roni on 2023-07-28.
//

import SwiftUI

struct ContentView: View {
    
    // States and constants.
    @State private var inputValue: Double = 0.0
    @FocusState private var isFocusedinputValue: Bool
    private var outputValue: Double {
        if inputUnit == outputUnit {
            return inputValue
        }
        
        if inputUnit == "kelvin" {
            // The output unit will be either "fahrenheit" or "celcius"
            if outputUnit == "fahrenheit" {
                return ContentView.convertToFahrenheit(from: inputValue)
            }
            return ContentView.convertToCelcius(from: inputValue)
        }
        
        // The input unit is not kelvin.
        // First stage conversion. I.e. to kelvin.
        let kelvin: Double
        if inputUnit == "celcius" {
            kelvin = ContentView.convertToKelvin(fromCelcius: inputValue)
        } else {
            kelvin = ContentView.convertTokelvin(fromFahrenheit: inputValue)
        }
        
        // Second stage conversion.
        if outputUnit == "kelvin" {
            return kelvin
        }
        if outputUnit == "celcius" {
            return ContentView.convertToCelcius(from: kelvin)
        }
        return ContentView.convertToFahrenheit(from: kelvin)
    }
    
    let units = ["celcius", "fahrenheit", "kelvin"]
    @State private var inputUnit = "celcius"
    @State private var outputUnit = "fahrenheit"
    
    // Conversion to a base unit functions.
    private static func convertTokelvin(fromFahrenheit: Double) -> Double {
        return 5.0 / 9.0 * (fromFahrenheit + 459.67)
    }
    private static func convertToKelvin(fromCelcius: Double) -> Double {
        return fromCelcius + 273.15
    }
    
    // Conversion to desired unit functions.
    private static func convertToCelcius(from kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    private static func convertToFahrenheit(from kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9.0 / 5.0 + 32
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Input magnitude", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocusedinputValue)
                    
                    Picker("From", selection: $inputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    
                    Picker("To", selection: $outputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                } header: {
                    Text("Input")
                }
                
                Section {
                    Text(outputValue, format: .number)
                } header: {
                    Text("Output")
                }
            }
            .navigationTitle("Temperature Converter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocusedinputValue = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
