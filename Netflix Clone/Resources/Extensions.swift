//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Burak on 26.12.2022.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.localizedLowercase.dropFirst()
    }
}
