//
//  XamarinService.swift
//  xamanager
//
//  Created by Ivan Montiel Cardona on 28/01/24.
//

import Foundation

protocol XamarinManagerService {
    static func getAndroidVersions() -> [XamarinVersion]
    static func getiOSVersions () -> [XamarinVersion]
    static func getMacVersions () -> [XamarinVersion]
    
    // static func getPlatformVersion (_ platform: Platform, version: String) throws
    // static func installSelectedVersion (_ version: XamarinVersion) -> Bool
}


class XamarinManager: XamarinManagerService {
    private static let queue = DispatchQueue(
        label: "dev.begeistert.XamarinManagerService",
        qos: .userInteractive,
        attributes: .concurrent
    )
    
    private static let baseApiUrl = "https://xamanager-api.vercel.app/api/v1.0/xamarin/version"
    
    private static let androidAllVersionsEndpoint = "/android/all"
    private static let iosAllVersionsEndpoint = "/ios/all"
    private static let macosAllVersionsEndpoint = "/macos/all"
    
    static func getAndroidVersions() -> [XamarinVersion] {
        var versions: [XamarinVersion] = []
        do {
            let content = try String(contentsOf: URL(string: baseApiUrl + androidAllVersionsEndpoint)!)
            let decoder = JSONDecoder()
            versions = try decoder.decode([XamarinVersion].self, from: content.data(using: .utf8)!)
        } catch {
          print("Unable to fetch versions", error)
        }
        
        return versions
    }
    
    static func getiOSVersions() -> [XamarinVersion] {
        var versions: [XamarinVersion] = []
        do {
            let content = try String(contentsOf: URL(string: baseApiUrl + iosAllVersionsEndpoint)!)
            let decoder = JSONDecoder()
            versions = try decoder.decode([XamarinVersion].self, from: content.data(using: .utf8)!)
        } catch {
          print("Unable to fetch versions", error)
        }
        
        return versions
    }
    
    static func getMacVersions() -> [XamarinVersion] {
        var versions: [XamarinVersion] = []
        do {
            let content = try String(contentsOf: URL(string: baseApiUrl + macosAllVersionsEndpoint)!)
            let decoder = JSONDecoder()
            versions = try decoder.decode([XamarinVersion].self, from: content.data(using: .utf8)!)
        } catch {
          print("Unable to fetch versions", error)
        }
        
        return versions
    }
    
    static func getAllVersions(
        completionQueue: DispatchQueue = .main,
         completion: @escaping ([XamarinVersion], Error?) -> Void
    ) {
        queue.async {
            do {
                var versionsArray: [XamarinVersion] = getAndroidVersions()
                
                versionsArray += getiOSVersions()
                
                versionsArray += getMacVersions()

                completionQueue.async {
                    completion(versionsArray, nil)
                }
            } catch {
                completionQueue.async {
                    completion([], error)
                }
            }
        }
    }
    
}

