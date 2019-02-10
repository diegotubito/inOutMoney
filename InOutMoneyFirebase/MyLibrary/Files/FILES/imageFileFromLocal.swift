//
//  imageFileFromLocal.swift
//  photoAlbum
//
//  Created by David Diego Gomez on 30/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

/*

import Cocoa

class _imageFilesFromLocal {
    static let instance = _imageFilesFromLocal()

    func getImageFiles(fromFolder: String, size: NSSize, progressTask: (Double) -> Void, gotImage: (NSImage?, [String: Any]?) -> Void) {
        let nombres = getFileNames(fromFolder: fromFolder)
        for (x,i) in nombres.enumerated() {
            
            
            getFile(nombre: i, size: size, completion: {
                image, info -> Void in
                
                if image != nil {
                    gotImage(image, info)
                } else {
                    gotImage(nil, nil)
                }
            })
            progressTask(Double(x + 1) / Double(nombres.count))
        }
        
        
    }
    
    func getFileNames(fromFolder: String) -> [String] {
        //  let url = getDocumentsDirectory()
        let urlString = "file://" + fromFolder
       // let urlstring = "file:///Users/diegodavid_77/Downloads"
        let url = NSURL(string: urlString)
        
        
        let items = contentsOf(folder: url! as URL)
        var cantidadImagenesCaragadas = 0
        var listado = [String]()
        for i in items {
            if i.pathExtension == "png" || i.pathExtension == "jpeg" || i.pathExtension == "jpg" {
                listado.append(i.lastPathComponent)
                cantidadImagenesCaragadas += 1
                
            }
        }
        print("cantidad de archivos: \(cantidadImagenesCaragadas)")
        return listado
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
    
   
    func getFile(nombre: String, size: NSSize?) -> NSImage? {
        let documentsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(nombre).path
        
        
        
        if FileManager.default.fileExists(atPath: filePath) {
            let image = NSImage(contentsOfFile: filePath)
            
            if size != nil {
                let imageReducida = image?.crop(size: size!)
                return imageReducida
            }
            return image
        }
        return nil
    }
    
  
    func getFile(nombre: String, size: NSSize?, completion: (NSImage?, [String: Any]?) -> Void) {
        let documentsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(nombre).path
        
        
        
        if FileManager.default.fileExists(atPath: filePath) {
            let image = NSImage(contentsOfFile: filePath)
            let info = infoAbout(filePath: filePath)
            
            if size != nil {
                let imageReducida = image?.crop(size: size!)
                completion(imageReducida, info)
            } else {
                completion(image, info)
            }
        }
        completion(nil, nil)
    }
    
    
    func contentsOf(folder: URL) -> [URL] {
        // 1
        let fileManager = FileManager.default
        
        // 2
        do {
            // 3
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
            
            // 4
            let urls = contents.map { return folder.appendingPathComponent($0) }
            return urls
        } catch {
            // 5
            return []
        }
    }
    
    
    func infoAbout(filePath: String) -> [String : Any]? {
       // 1
        let url = URL(fileURLWithPath: filePath)
        
        do {
            let info = try FileManager.default.attributesOfItem(atPath: filePath)
            var report = [String: Any]()
            
            report["extension"] = url.pathExtension
            
            // 4
            report["nombre"] = url.lastPathComponent
            for (key, value) in info {
                // ignore NSFileExtendedAttributes as it is a messy dictionary
                if key.rawValue == "NSFileExtendedAttributes" { continue }
                
                report[key.rawValue] = value
                
            }
            
            return(report)
        } catch {
            // 6
            print("No information available for \(url.path)")
            return nil
        }
        
        
    }
    
    
}
 
 */

