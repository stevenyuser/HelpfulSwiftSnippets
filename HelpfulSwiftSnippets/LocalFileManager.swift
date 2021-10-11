//
//  LocalFileManager.swift
//  HelpfulSwiftSnippets
//
//  Created by Steven Yu on 10/10/21.
//

import Foundation
import SwiftUI

// A generic Local File Manager that deals with getting and saving images (UIImages) to the device file manager (Cache)
/*
 saveImage() to save an image to a folder with image name
 getImage() from a folder with image name
 
 Example Usage:
 @Published var image: UIImage? = nil
 private let fileManager = LocalFileManager.instance
 
 private func getCoinImage() {
     if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
         image = savedImage
     } else {
         downloadCoinImage()
     }
 }
 
 private func downloadCoinImage() {
     guard let url = URL(string: coin.image) else { return }
     
     imageSubscription = NetworkingManager.download(url: url)
         .tryMap({ (data) -> UIImage? in
             return UIImage(data: data)
         })
         .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
             guard let self = self, let downloadedImage = returnedImage else { return }
             self.image = downloadedImage
             self.imageSubscription?.cancel()
             self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
         })
 }
 */

class LocalFileManager {
    
    // only a single file manager is needed, only need a singleton
    static let instance = LocalFileManager()
    private init() { }
    
    // function that saves a UIImage to a specified folder with a specified image name
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // create folder if needed
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image and the image data, otherwise return
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
            else { return }
        
        // try to save image to the image url path, otherwise print error
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    // function that gets a UIImage from a specified folder with a specified image name
    // if there is no UIImage, returns nil
    func getImage(imageName: String, folderName: String) -> UIImage? {
        // get a valid url for the image and make sure the image exists, otherwise return nil
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        // return the valid image if there is one
        return UIImage(contentsOfFile: url.path)
    }
    
    // creates folder if there is not one
    private func createFolderIfNeeded(folderName: String) {
        // ensures url for folder is valid, otherwise returns
        guard let url = getURLForFolder(folderName: folderName) else { return }
        // if there is not a folder at the URL, creates one with the name, otherwise prints error
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    // gets folder url from the parent caches directory
    private func getURLForFolder(folderName: String) -> URL? {
        // gets caches url otherwise returns nil
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        // finds the subfolder (folderName) in caches directory and returns the path
        return url.appendingPathComponent(folderName)
    }
    
    // gets image url from folderName and imageName
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        // gets the folder from the folderName
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        // makes the path from imageName.png
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
