//
//  NetworkMonitor.swift
//  CryptoTracker
//
//  Created by Fernando González González on 25/01/22.
//

import Foundation
import UIKit
import Network


final class NetworkMonitor{
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected:Bool = false
    public private(set) var connectionType:ConnectionType = .unowned
    
    enum ConnectionType{
        case Wifi
        case Cell
        case unowned
    }
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {
            [weak self] (path) in
            print("Iniciando monitoreo")
            print(path.status)
            self?.isConnected = path.status != .unsatisfied
            self?.getConnetionType(path: path)
            
        }
    }
    
    public func stopMonitoring(){
        print("Parando el monitoreo de red")
        monitor.cancel()
    }
    
    private func getConnetionType(path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .Wifi
        }else if path.usesInterfaceType(.cellular){
            connectionType = .Cell
        }else{
            connectionType = .unowned
        }
    }
}
