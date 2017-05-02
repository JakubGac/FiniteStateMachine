//
//  FiniteStateMachine.swift
//  Automat
//
//  Created by Jakub Gac on 02.05.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation

// start state - A
// acctepted state - D
private enum machineStates {
    case A
    case B
    case C
    case D
}

private enum regexPartsTypes {
    case leftSide
    case dot
    case rightSidePL
    case rightSideCOM
}

// our regex is [a-z]+.(pl|com)
private struct regexParts {
    let leftSide = "[a-z]"
    let dot = "\\."
    let rightSidePL = "pl"
    let rightSideCOM = "com"
    
    func get(element: regexPartsTypes) -> String {
        switch element {
        case .leftSide: return leftSide
        case .dot: return dot
        case .rightSidePL: return rightSidePL
        case .rightSideCOM: return rightSideCOM
        }
    }
}

class FiniteStateMachine {
    // first state, second state, expression
    private var machineTransitions = Array<(machineStates, machineStates, regexPartsTypes)>()
    // machine working tmp's
    private var currentState: machineStates = .A
    private var rememberedString: String = ""
    private var startState: machineStates = .A
    private var endState: machineStates = .D
    
    init() {
        machineTransitions.append((.A, .B, .leftSide))
        machineTransitions.append((.B, .B, .leftSide))
        machineTransitions.append((.B, .C, .dot))
        machineTransitions.append((.C, .D, .rightSidePL))
        machineTransitions.append((.C, .D, .rightSideCOM))
    }

    func scan(textToScan: String) {
        var content = Array(textToScan.characters)
        var index = 0
        
        while index < content.count {
            var matched = false
            
            for item in machineTransitions {
                if matched == false {
                    if currentState == item.0 {
                        let pattern = regexParts().get(element: item.2)
                        let regex = try! NSRegularExpression(pattern: pattern, options: [])
                        let matches = regex.matches(in: content[index].description, options: [], range: NSRange(location: 0, length: 1))
                        if matches.count != 0 {
                            // correct symbol
                            // changing machine state
                            currentState = item.1
                            // adding new symbol to remembered string
                            rememberedString.append(content[index])
                            // marking that the symbol has been recognized
                            matched = true
                        }
                    }
                }
            }
            
            if matched == false {
                // no match found
                // reset the machine
                currentState = .A
                rememberedString = ""
            }
            
            index += 1
        }
        
        print("koniec skanowania")
        print("aktualny stan automat: \(currentState)")
        print("zapamiętane słowo: \(rememberedString)")
    }
}
