//
//  LocalDocumentManager.swift
//  FightProject
//
//  Created by goodgoodStudy on 2022/3/23.
//

import Foundation
import UIKit

enum FileType {
    
    case image //logo图片
    case gif   //成品gif
    case draft //GIF草稿
    
    public var value: String? {
        switch self {
        case .image: return "image"
        case .gif: return "gif"
        case .draft: return "draft"
        }
    }
}

func localBasePath() -> String {
    return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! + "/private_document"
}

func localBasePath(_ file: FileType) -> String {
    return localBasePath() + "/" + file.value!
}

//MARK: 启动时在沙盒创建对应的文件夹
func createDirectory() {
    //启动的时候创建文件夹路径
    let library_selfPath = localBasePath()
    let fileManger = FileManager.default
    if (!fileManger.fileExists(atPath: library_selfPath)){
        try? fileManger.createDirectory(at: URL(fileURLWithPath: library_selfPath), withIntermediateDirectories: true, attributes: nil)
    }
    
    let private_imageDirectory = localBasePath(.image)
    
    if (!fileManger.fileExists(atPath: private_imageDirectory)){
        try? fileManger.createDirectory(at: URL(fileURLWithPath: private_imageDirectory), withIntermediateDirectories: true, attributes: nil)
    }
    
    let private_gifDirectory = localBasePath(.gif)
    
    if (!fileManger.fileExists(atPath: private_gifDirectory)){
        try? fileManger.createDirectory(at: URL(fileURLWithPath: private_gifDirectory), withIntermediateDirectories: true, attributes: nil)
    }
    
    let private_draftDirectory = localBasePath(.draft)
    
    if (!fileManger.fileExists(atPath: private_draftDirectory)){
        try? fileManger.createDirectory(at: URL(fileURLWithPath: private_draftDirectory), withIntermediateDirectories: true, attributes: nil)
    }
}

func writeImageToLibrary(_ image: UIImage?) -> String
{
    let uuid = UUID().uuidString
    let fileName = uuid + ".png"
    let cachePath = localBasePath(.image) + "/" + fileName
    let url = URL.init(fileURLWithPath: cachePath)
    try? image?.jpegData(compressionQuality: 0.8)?.write(to: url)
    return fileName
}

func getImageWith(_ fileName: String) -> UIImage? {
    let cachePath = localBasePath(.image) + "/" + fileName
    return UIImage.init(contentsOfFile: cachePath)
}

func deepSearchAllGifFiles() -> [String]
{
    let filePath = localBasePath(.gif)
    let fileManager = FileManager.default
    let exist = fileManager.fileExists(atPath: filePath)
    
    if exist {
        
        let contents = fileManager.enumerator(atPath: filePath)
        return contents?.allObjects as! [String]
    }else{
        return []
    }
}



