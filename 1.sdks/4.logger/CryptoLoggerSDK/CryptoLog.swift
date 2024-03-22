//
//  OSLogExtension.swift
//  CryptoLoggerSDK
//
//  Created by francesco scalise on 12/11/21.
//

import Foundation
@_exported import os.log

public class CryptoLog {
    
    public private(set) var oslog: OSLog
    
    public var logLevel: CustomLogLevel = .debug
    public var isSystemLogEnabled: Bool = true
    
    public init(_ bundle: Bundle = .main, category: String? = nil) {
        oslog = OSLog(bundle, category: category)
    }
    
    public init(_ aClass: AnyClass, category: String? = nil) {
        oslog = OSLog(aClass, category: category)
    }
}

// MARK: CryptoLogger + Disable

public extension CryptoLog {
 
    func disable() {
        oslog = OSLog.disabled
    }
}

// MARK: CryptoLogger + CustomLogLevel

public extension CryptoLog {
    
    @inlinable func debug(_ message: String) {
        guard logLevel >= .debug else { return }

        oslog.debug(message)
    }
    
    @inlinable func info(_ message: String) {
        guard logLevel >= .info else { return }

        oslog.info(message)
    }
    
    @inlinable func error(_ message: String) {
        guard logLevel >= .error else { return }

        oslog.error(message)
    }
    
    @inlinable func fault(_ message: String) {
        guard logLevel >= .fault else { return }

        oslog.fault(message)
    }
    
    func print(_ value: @autoclosure () -> Any) {
        guard isSystemLogEnabled else { return }
        
        oslog.print(value())
    }
    
    func dump(_ value: @autoclosure () -> Any) {
        guard isSystemLogEnabled else { return }
        
        oslog.dump(value())
    }
    
    func trace() {
        guard isSystemLogEnabled else { return }
        
        oslog.trace()
    }

}

// MARK: OSLog + CustomLogLevel

extension OSLog {
        
    convenience init(_ bundle: Bundle = .main, category: String? = nil) {
        self.init(subsystem: bundle.bundleIdentifier ?? "com.intesigroup.logging.system", category: category ?? "")
    }
    
    convenience init(_ aClass: AnyClass, category: String? = nil) {
        self.init(Bundle(for: aClass), category: category ?? String(describing: aClass))
    }
    
}

extension OSLog {
    //    @inlinable func log(_ message: String) {
    //        log("%@", message)
    //    }
    
    @inlinable func debug(_ message: String) {
#if DEBUG
        let m = CustomLogLevel.debug.rawValue + " " + message
        debug("%{public}@", m)
#else
        debug("%{private}@", message)
#endif
    }
    
    @inlinable func info(_ message: String) {
#if DEBUG
        let m = CustomLogLevel.info.rawValue + " " + message
#else
        let m = message
#endif
        info("%{public}@", m)
    }
    
    @inlinable func error(_ message: String) {
#if DEBUG
        let m = CustomLogLevel.error.rawValue + " " + message
#else
        let m = message
#endif
        error("%{public}@", m)
    }
    
    @inlinable func fault(_ message: String) {
#if DEBUG
        let m = CustomLogLevel.fault.rawValue + " " + message
        let icon = "🚨"
#else
        let m = message
        let icon = ""
#endif
        fault("%{public}@", m)
        fault("%{public}@%{public}@", icon, Thread.callStackSymbols)
    }
    
    func print(_ value: @autoclosure () -> Any) {
#if DEBUG
        guard isEnabled(type: .debug) else { return }
        os_log("%{public}@", log: self, type: .debug, String(describing: value()))
#endif
    }
    
    func dump(_ value: @autoclosure () -> Any) {
#if DEBUG
        guard isEnabled(type: .debug) else { return }
        var string = String()
        Swift.dump(value(), to: &string)
        os_log("%{public}@", log: self, type: .debug, string)
#endif
    }
    
    func trace(file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
#if DEBUG
        guard isEnabled(type: .debug) else { return }
        let file = URL(fileURLWithPath: String(describing: file)).deletingPathExtension().lastPathComponent
        var function = String(describing: function)
        function.removeSubrange(function.firstIndex(of: "(")!...function.lastIndex(of: ")")!)
        os_log("%{public}@.%{public}@():%ld", log: self, type: .debug, file, function, line)
#endif
    }
    
}

extension OSLog {
    
    //    @inlinable func log(_ message: StaticString, _ args: CVarArg...) {
    //        log(message, type: .default, args)
    //    }
    
    @usableFromInline func debug(_ message: StaticString, _ args: CVarArg...) {
        log(message, type: .debug, args)
    }
    
    @usableFromInline func info(_ message: StaticString, _ args: CVarArg...) {
        log(message, type: .info, args)
    }
    
    @usableFromInline func error(_ message: StaticString, _ args: CVarArg...) {
        log(message, type: .error, args)
    }
    
    @usableFromInline func fault(_ message: StaticString, _ args: CVarArg...) {
        log(message, type: .fault, args)
    }
    
    @usableFromInline func log(_ message: StaticString, type: OSLogType, _ a: [CVarArg]) {
        // The Swift overlay of os_log prevents from accepting an unbounded number of args
        // http://www.openradar.me/33203955
        assert(a.count <= 5)
        switch a.count {
        case 5: os_log(message, log: self, type: type, a[0], a[1], a[2], a[3], a[4])
        case 4: os_log(message, log: self, type: type, a[0], a[1], a[2], a[3])
        case 3: os_log(message, log: self, type: type, a[0], a[1], a[2])
        case 2: os_log(message, log: self, type: type, a[0], a[1])
        case 1: os_log(message, log: self, type: type, a[0])
        default: os_log(message, log: self, type: type)
        }
    }
    
    
}

public enum CustomLogLevel: Comparable {
    case fault
    case error
    case info
    case debug
    
    public var rawValue: String {
        switch self {
        case .fault:
            return "🚨 FAULT"
        case .error:
            return "❌ ERROR"
        case .info:
            return "ℹ️ INFO"
        case .debug:
            return "🔬 DEBUG"
        }
    }
}


