//
//  NetworkerFile.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import Foundation

public struct NetworkerFile {
    
    let data: Data
    let key: String
    let fileName: String
    let mimeType: String
    
    public enum ImageFormat {
        case jpg(compressionQuality: Float)
        case png
        
        func getFileName(name: String) -> String {
            let fileExtension: String
            switch self {
            case .jpg: fileExtension = "jpg"
            case .png: fileExtension = "png"
            }
            return "\(name).\(fileExtension)"
        }
        
        var mimeType: String {
            switch self {
            case .jpg: return "image/jpeg"
            case .png: return "image/png"
            }
        }
    }
    
    public init(data: Data, key: String, fileName: String, mimeType: String) {
        self.data = data
        self.key = key
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    public init(image: UIImage, key: String, name: String, imageFormat: ImageFormat) {
        switch imageFormat {
        case .jpg(let compressionQuality):
            self.data = UIImageJPEGRepresentation(image, CGFloat(compressionQuality))!
        case .png:
            self.data = UIImagePNGRepresentation(image)!
        }
        
        self.key = key
        self.fileName = imageFormat.getFileName(name: name)
        self.mimeType = imageFormat.mimeType
    }
}
