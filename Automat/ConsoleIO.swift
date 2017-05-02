//
//  ConsoleIO.swift
//  Automat
//
//  Created by Jakub Gac on 02.05.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation

enum OptionType: String {
    case help = "h"
    case quit = "q"
    case interactive = "i"
    case fileName = "f"
    case unknown
    
    init(value: String) {
        switch value {
        case "h": self = .help
        case "i": self = .interactive
        case "f": self = .fileName
        case "q": self = .quit
        default: self = .unknown
        }
    }
}

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    
    class func printInfo() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("Brak argumentów wywołania.")
        print("Dostępne wywołania programu:")
        print(" \(executableName) -i -> tryb interaktywny")
        print(" \(executableName) -f -> wywołanie z nazwą pliku do sprawdzenia")
        print(" \(executableName) -h -> informacje o programie")
    }
    
    func getOption(option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\u{001B}[;m\(message)")
        case .error:
            fputs("\u{001B}[0;31m\(message)\n", stderr)
        }
    }
    
    func getInput() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}
