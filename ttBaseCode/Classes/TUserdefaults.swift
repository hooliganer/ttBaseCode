//
//  TUserdefaults.swift
//  ttBaseCode
//
//  Created by 谭滔 on 2024-06-06.
//

import Foundation

public class TUserdefaults {
    static func set<T: Codable>(_ value: T, key: Key<T>) {
        UserDefaults.standard.setValue(value, forKey: key.key)
        UserDefaults.standard.synchronize()
//        if isSwiftCodableType(ValueType.self) || isFoundationCodableType(ValueType.self) {
//            userDefaults.set(value, forKey: key._key)
//            return
//        }
//
//        do {
//            let encoder = JSONEncoder()
//            // https://stackoverflow.com/questions/59473051/userdefault-property-wrapper-not-saving-values-ios-versions-below-ios-13/59475086#59475086
//            let encoded = try encoder.encode(Wrapper(wrapped: value))
//            userDefaults.set(encoded, forKey: key._key)
//            userDefaults.synchronize()
//        } catch {
//            #if DEBUG
//                print(error)
//            #endif
//        }
    }
    
    static func get<T: Codable>(_ key: Key<T>) -> T? {
        UserDefaults.standard.value(forKey: key.key) as? T
    }
    
    static func clear<T: Codable>(_ key: Key<T>) {
        UserDefaults.standard.setValue(nil, forKey: key.key)
    }
    
    public struct Key<T: Codable> {
        let key: String
        public init(_ key: String) {
            self.key = key
        }
    }
}

protocol LegalUserdefaultsDelegate {
    
}

@propertyWrapper
public struct TOptionalWrap<T: Codable> {
        
    public var wrappedValue: T? {
        get {
            TUserdefaults.get(key)
        }
        set {
            if let newValue = newValue {
                TUserdefaults.set(newValue, key: key)
            } else {
                TUserdefaults.clear(key)
            }
        }
    }
    
    var key: TUserdefaults.Key<T>
    
    init(_ key: String) {
        self.key = TUserdefaults.Key(key)
    }
}

@propertyWrapper
public struct TDefaultWrap<T: Codable> {
        
    var key: TUserdefaults.Key<T>
    
    var defaultValue: T
    
    public var wrappedValue: T {
        get {
            TUserdefaults.get(key) ?? defaultValue
        }
        set {
            TUserdefaults.set(newValue, key: key)
        }
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = TUserdefaults.Key(key)
        self.defaultValue = defaultValue
    }
}
