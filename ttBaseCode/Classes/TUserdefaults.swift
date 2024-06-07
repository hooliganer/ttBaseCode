//
//  TUserdefaults.swift
//  ttBaseCode
//
//  Created by 谭滔 on 2024-06-06.
//

import Foundation

public class TUserdefaults {
    static func set<T: Codable>(_ value: T, key: Key<T>) {
        if T.self is BaseUserDefaultsType.Type {
            UserDefaults.standard.setValue(value, forKey: key.key)
            UserDefaults.standard.synchronize()
            return
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            UserDefaults.standard.setValue(data, forKey: key.key)
            UserDefaults.standard.synchronize()
        } catch let error {
            debugPrint("===== 【 \(error) 】  =====")
        }
    }
    
    static func get<T: Codable>(_ key: Key<T>) -> T? {
        if T.self is BaseUserDefaultsType.Type {
            return UserDefaults.standard.value(forKey: key.key) as? T
        }
        guard let data = UserDefaults.standard.data(forKey: key.key) else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let value = try decoder.decode(T.self, from: data)
            return value
        } catch let error {
            debugPrint("===== 【 \(error) 】  =====")
            return nil
        }
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
    
    public init(_ key: String) {
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
    
    public init(_ key: String, defaultValue: T) {
        self.key = TUserdefaults.Key(key)
        self.defaultValue = defaultValue
    }
}

protocol BaseUserDefaultsType {}

extension Bool: BaseUserDefaultsType {}
extension Int: BaseUserDefaultsType {}
extension Float: BaseUserDefaultsType {}
extension Double: BaseUserDefaultsType {}
extension String: BaseUserDefaultsType {}
extension URL: BaseUserDefaultsType {}
extension Date: BaseUserDefaultsType {}
extension Data: BaseUserDefaultsType {}
extension Array: BaseUserDefaultsType where Element: BaseUserDefaultsType {}
extension Dictionary: BaseUserDefaultsType where Key == String, Value: BaseUserDefaultsType {}
