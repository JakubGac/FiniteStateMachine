//
//  main.swift
//  Automat
//
//  Created by Jakub Gac on 02.05.2017.
//  Copyright © 2017 Jakub Gac. All rights reserved.
//

import Foundation

let menu = Menu()

if CommandLine.argc < 2 {
    ConsoleIO.printInfo()
} else {
    menu.staticMode()
}

