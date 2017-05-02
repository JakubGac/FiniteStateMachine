//
//  File.swift
//  Automat
//
//  Created by Jakub Gac on 02.05.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation

class Menu {
    let consoleIO = ConsoleIO()
    
    func staticMode() {
        let argument = CommandLine.arguments[1] // pobieramy tutaj pierwszy argument
        let (option, value) = consoleIO.getOption(option: argument.substring(from: argument.characters.index(argument.startIndex, offsetBy: 1))) // dopasowujemy go z istniejącymi
        
        switch option {
        case .interactive:
            interactiveMode()
        case .fileName:
            checkAndReadFile()
        case .help:
            print("Witam w pomocy dla programu sprawdzajacego wyrazenie regularne [a-z]+/.(pl|com)")
        case .unknown:
            consoleIO.writeMessage("Błąd. Nie znam takiej opcji wywołania - \(value)", to: .error)
            consoleIO.writeMessage("Kończę działanie")
        default:
            consoleIO.writeMessage("Kończę działanie")
            break
        }
    }
    
    private func interactiveMode() {
        consoleIO.writeMessage("Witaj w trybie interaktywnym. Możesz dowolnie używać następujących opcji:")
        print("a -> tryb sprawdzania")
        print("f -> wywołanie z nazwą pliku do sprawdzenia")
        print("q -> zakończenie działania programu")
        
        var shouldQuit = false
        while !shouldQuit {
            let (option, _) = consoleIO.getOption(option: consoleIO.getInput())
            
            switch option {
            case .fileName:
                checkAndReadFile()
            case .quit:
                shouldQuit = true
                consoleIO.writeMessage("Kończę działanie")
            default:
                consoleIO.writeMessage("Błąd. Nie znam takiej opcji wywołania", to: .error)
                consoleIO.writeMessage("Podaj inna wartosc")
            }
        }
    }
    
    private func checkAndReadFile() {
        if CommandLine.arguments.count < 3 {
            consoleIO.writeMessage("Brak nazwy pliku", to: .error)
            consoleIO.writeMessage("Sróbuj ponownie")
        } else if CommandLine.arguments.count > 3 {
            consoleIO.writeMessage("Za dużo argumentów wywołania", to: .error)
            consoleIO.writeMessage("Sróbuj ponownie")
        } else {
            do {
                let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileDestinationURL = documentDirectoryURL.appendingPathComponent(CommandLine.arguments[2])
                do {
                    let readedText = try String(contentsOf: fileDestinationURL)
                    let finiteStateMachine = FiniteStateMachine()
                    finiteStateMachine.scan(textToScan: readedText)
                } catch let error as NSError {
                    consoleIO.writeMessage("Błąd w trakcie odczytu pliku", to: .error)
                    consoleIO.writeMessage(error.localizedDescription, to: .error)
                    consoleIO.writeMessage("Kończę działanie")
                }
            } catch let error as NSError {
                consoleIO.writeMessage("Błąd w trakcie odczytu katalogu", to: .error)
                consoleIO.writeMessage(error.localizedDescription, to: .error)
                consoleIO.writeMessage("Kończę działanie")
            }
        }
    }
}
