//
//  ContentView.swift
//  BetterRest
//
//  Created by Константин on 14.02.2024.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("Please do you want to wake up")
                    .font(.headline)

                }
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                Section {
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                } header: {
                    Text("Daily ccoffee in take")
                }
                VStack {
                    Text(calculateBedTime())
                }
                
//                VStack(alignment: .leading) {
//                    Text("Please do you want to wake up")
//                        .font(.headline)
//                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//                }
//                VStack(alignment: .leading) {
//                    Text("Desired amount of sleep")
//                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//                }
//                VStack(alignment: .leading) {
//                    Text("Daily ccoffee in take")
//                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
//                }
            }
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate") {
//                    calculateBedTime()
//                }
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("Ok") { }
//            } message: {
//                Text(alertMessage)
//            }
        }
    }
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60 * 60
            
            let prediction = try model.prediction(wake: Int64((hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
//            alertTitle = "Your ideal bedtime is..."
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch  {
            return "Error"
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
//        showingAlert = true
    }
}

#Preview {
    ContentView()
}
