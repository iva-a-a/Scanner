//
//  LANService.swift
//  Scanner
//
//  Created by Alena Ivanova on 01.12.2025.
//


import Foundation
internal import Combine
import Network

final class LANService: NSObject, LANServiceProtocol {

    let scanStarted = PassthroughSubject<Void, Never>()
    let scanCompleted = PassthroughSubject<Void, Never>()
    let deviceFound = PassthroughSubject<Device, Never>()
    let errorOccurred = PassthroughSubject<ScanError, Never>()

    private var serviceBrowsers: [NetServiceBrowser] = []
    private var resolving: Set<NetService> = []
    private var timeoutTask: DispatchWorkItem?
    private var scanTimeout: TimeInterval = 15

    private var discoveredHosts = Set<String>()

    private let serviceTypes = [
        "_http._tcp.",
        "_airplay._tcp.",
        "_printer._tcp.",
        "_hap._tcp.",
        "_services._dns-sd._udp.",
        "_googlecast._tcp.",
        "_ssh._tcp.",
        "_ftp._tcp.",
        "_smb._tcp."
    ]

    func startScan(timeout: TimeInterval = 15) {
        scanTimeout = timeout
        discoveredHosts.removeAll()

        scanStarted.send()

        startServiceDiscovery()

        timeoutTask = DispatchWorkItem { [weak self] in
            self?.stopScan()
        }
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutTask)
        }
    }

    func stopScan() {
        timeoutTask?.cancel()
        timeoutTask = nil

        serviceBrowsers.forEach { $0.stop() }
        serviceBrowsers.removeAll()

        resolving.removeAll()

        scanCompleted.send()
    }

    private func startServiceDiscovery() {
        for type in serviceTypes {
            let browser = NetServiceBrowser()
            browser.delegate = self
            serviceBrowsers.append(browser)

            browser.searchForServices(ofType: type, inDomain: "local.")
        }
    }
}

extension LANService: NetServiceBrowserDelegate {

    func netServiceBrowser(_ browser: NetServiceBrowser,
                           didFind service: NetService,
                           moreComing: Bool) {

        resolving.insert(service)
        service.delegate = self
        service.resolve(withTimeout: 4)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser,
                           didNotSearch errorDict: [String : NSNumber]) {
        browser.stop()
        serviceBrowsers.removeAll { $0 === browser }
    }

    func netServiceBrowser(_ browser: NetServiceBrowser,
                           didRemove service: NetService,
                           moreComing: Bool) {
    }
}

extension LANService: NetServiceDelegate {

    func netServiceDidResolveAddress(_ sender: NetService) {
        resolving.remove(sender)

        guard let host = sender.hostName else { return }

        guard !discoveredHosts.contains(host) else { return }
        discoveredHosts.insert(host)

        let device = Device(
            id: UUID(),
            name: sender.name,
            identifier: host,
            secondaryIdentifier: sender.type,
            rssi: nil,
            status: .discovered,
            source: .lan,
            scanSessionId: UUID()
        )

        deviceFound.send(device)
    }

    func netService(_ sender: NetService,
                    didNotResolve errorDict: [String : NSNumber]) {
        resolving.remove(sender)
    }
}
