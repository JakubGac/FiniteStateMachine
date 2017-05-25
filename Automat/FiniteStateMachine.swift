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
    // first state, second state, expression, number of symbols in expression to check
    private var machineTransitions = Array<(machineStates, machineStates, regexPartsTypes, Int)>()
    // machine working tmp's
    private var currentState: machineStates = .A
    private var rememberedString: String = ""
    private var startState: machineStates = .A
    private var endState: machineStates = .D
    
    init() {
        machineTransitions.append((.A, .B, .leftSide, 1))
        machineTransitions.append((.B, .B, .leftSide, 1))
        machineTransitions.append((.B, .C, .dot, 1))
        machineTransitions.append((.C, .D, .rightSidePL, 2))
        machineTransitions.append((.C, .D, .rightSideCOM, 3))
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
                        var tmp = index
                        var string = ""
                        if index + item.3 <= content.count {
                            while tmp < index + item.3 {
                                string.append(content[tmp])
                                tmp += 1
                            }
                            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: item.3))
                            if matches.count != 0 {
                                // correct symbol
                                // changing machine state
                                currentState = item.1
                                // adding new symbol to remembered string
                                rememberedString.append(string)
                                // marking that the symbol has been recognized
                                matched = true
                                // moving finite machine
                                index += item.3
                            }
                        }
                    }
                }
            }
            
            if matched == false {
                // no match found
                // reset the machine
                currentState = startState
                if rememberedString == "" {
                    // if we don't have any remembered word we want to move forward
                    index += 1
                }
                rememberedString = ""
            }
            
            if currentState == endState {
                // we are in accepted state
                print("Znalezione slowo: \(rememberedString)")
                matched = false
                currentState = startState
                rememberedString = ""
            }
        }
    }
}
