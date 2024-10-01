//
//  Observable.swift
//  ToDoList
//
//  Created by Argh on 10/1/24.
//

import Foundation

final class Observable<T> {
    
    init(value: T?) {
        self.value = value
    }
    
    var value: T? {
        didSet {
            observableBlock?(value)
        }
    }
    
    private var observableBlock: ((T?) -> Void)?
    
    func bind(_ observableBlock: @escaping ((T?) -> Void)) {
        self.observableBlock = observableBlock
    }
}
