//
//  ListManager.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

class AppPlistManager: AppPlistInterface {
    
    func readAkData() -> String {
        guard let path = Bundle.main.path(forResource: PlistName.appValues.rawValue, ofType: "plist") else {
            print("Cannot find plist")
            return ""
        }

        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)

            guard let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String:String] else {
                print("Cannot find values in plist")
                return ""
            }
            
            var akValue: String = ""
            let first: String? = plist.first { $0.key == "AkOne" }?.value
            let second: String? = plist.first { $0.key == "AkTwo" }?.value
            let third: String? = plist.first { $0.key == "AkThree" }?.value
            
            if let first {
                akValue += first
            }
            if let second {
                akValue += second
            }
            if let third {
                akValue += third
            }
            
            return akValue
            
        } catch {
            print("Read plist Error: \(error.localizedDescription)")
            return ""
        }
        
    }
    
}

protocol AppPlistInterface {
    
    func readAkData() -> String
    
}
