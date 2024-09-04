//
//  AppBinder.swift
//  assessmentApp
//
//  Created by Waqas Ashraf on 9/2/24.
//

import Foundation

///This is used for binding data
///It makes the object reactive

class Bindable<T>{
    
    init(_ value: T? = nil) {
        self.value = value
    }
    
    var value: T? {
        didSet{
            self.observer?(value)
        }
    }
    
    private var observer: ((T?)-> ())?
    
    func bind(completion: @escaping (T?)-> ()){
        self.observer = completion
    }
    
}
