//
//  VideoChacheHandler.swift
//  SoundTrack wireframe
//
//  Created by Ajay Rajput on 08/08/23.
//

import Foundation
import UIKit

public class VideoChacheHandler
{
    static let maxCachedItems = 10
    // Function to get the cached file URL for a given video URL
   class func cachedFileURL(for url: URL) -> URL {
       let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
       let fileName = url.lastPathComponent
       let cachedURL = cacheDirectory.appendingPathComponent(fileName)
       return cachedURL
   }

   // Function to cache a video from a source URL to a destination URL
    class func cacheVideo(at sourceURL: URL, to destinationURL: URL) {
        
        var cachedURLs = getCachedURLs()
                
        // Check if the maximum limit is reached
        if cachedURLs.count > maxCachedItems {
            // Remove the first (oldest) cached URL
            if let firstURL = cachedURLs.first {
                do {
                    try FileManager.default.removeItem(at: firstURL)
                    cachedURLs.removeFirst()
                } catch {
                    print("Error deleting cached URL: \(error)")
                }
            }
        }
        
//           let videoData = try Data(contentsOf: sourceURL)
        URLSession.shared.dataTask(with: sourceURL) { videoData, response, error in
            if let error{
                print("Error caching video:", error.localizedDescription)
            }else{
                do {
                    try videoData?.write(to: destinationURL)
                    cachedURLs.append(destinationURL)
                }
                catch{
                    print("Error caching video:", error.localizedDescription)
                }
                
            }
        }
           
        // Save the updated cached URLs list
        UserDefaults.standard.set(cachedURLs.map { $0.absoluteString }, forKey: "CachedURLs")
   }
    
    class func getCachedURLs() -> [URL] {
        if let cachedURLStrings = UserDefaults.standard.array(forKey: "CachedURLs") as? [String] {
            return cachedURLStrings.compactMap { URL(string: $0) }
        }
        return []
    }

    
}
