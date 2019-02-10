//
//  storageManager.swift
//  coreGymMobile
//
//  Created by David Diego Gomez on 5/8/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

import Foundation
import Firebase

var tareasPendientes = 0
var tareasRealizadas = 0


let StorageReferenceTest = "gs://body-life-1-2.appspot.com/"
let StorageReferenceBodyShaping =  "gs://bodyshaping-fc85e.appspot.com/"
let StorageReferenceCoreGym = "gs://core-gym.appspot.com"

let StorageReference = StorageReferenceCoreGym


class MLFirebaseStorageService {
    
    static let instance = MLFirebaseStorageService()
    
    func deleteFile(fullPath: String, completion: @escaping (Bool, Error?) -> Void) {
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: StorageReference)
        
        // Create a reference to the file to delete
        let fileRefAtStorage = storageRef.child(fullPath)
        
        // Delete the file
        fileRefAtStorage.delete { error in
            if error != nil {
                // Uh-oh, an error occurred!
                completion(false, error)
            } else {
                // File deleted successfully
                completion(true, nil)
                
            }
        }
    }
    
    func downloadData(fullPath: String, completion: @escaping (Data?, Error?) -> Void, progress: @escaping (Progress) -> Void) {
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: StorageReference)
        
        // Create a reference to the file we want to download
        let dataRef = storageRef.child(fullPath)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        let downloadTask = dataRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
            } else {
                // Data for for the file is returned
                completion(data!, nil)
            }
        }
        //
        
        // Observe changes in status
        downloadTask.observe(.resume) { snapshot in
             print("download started")
            if tareasPendientes == 0 {
                tareasRealizadas = 0
            }
            tareasPendientes += 1
            
            // Download resumed, also fires when the download starts
        }
    
       
        downloadTask.observe(.pause) { snapshot in
            print("download paused")
            // Download paused
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            progress(snapshot.progress!)
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            tareasPendientes -= 1
            tareasRealizadas += 1
            
       }
        
        // Errors only occur in the "Failure" case
        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as NSError?)?.code else {
                return
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
                return
            }
            completion(nil, snapshot.error)
            switch (error) {
            case .objectNotFound:
                // File doesn't exist
                tareasPendientes -= 1
                tareasRealizadas += 1
                break
            case .unauthorized:
                print(error)
                // User doesn't have permission to access file
                break
            case .cancelled:
                // User cancelled the download
                break
                
                /* ... */
                
            case .unknown:
                // Unknown error occurred, inspect the server response
                break
            default:
                // Another error occurred. This is a good place to retry the download.
                break
            }
        }
    }
    
    func uploadData(imageData: Data, fullPath: String, contentType: String, completion: @escaping (Bool, Error?) -> Void, progress: @escaping (Double) -> Void) {
        
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        var storageRef = storage.reference(forURL: StorageReference)
        
        //ruta a subir
        storageRef = storageRef.child(fullPath)
        
        // Create the file metadata
        let metadata = StorageMetadata()
        
        metadata.contentType = contentType
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        let uploadTask = storageRef.putData(imageData, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let complete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress(complete)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            completion(true, nil)
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                
                completion(false, error)
                
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
        
        
    }
    
    
    func uploadFile(fileName: String, fileExtension: String, contentType: String, destinyPath: String, completion: @escaping (Bool, Error?) -> Void, progress: @escaping (Double) -> Void) {
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        var storageRef = storage.reference(forURL: StorageReference)
        
        //primero busco si existe el archivo en mi aplicacion.
        let local = Bundle.main.path(forResource: fileName, ofType: fileExtension)
        if local != nil {
            print("existe el archivo")
        } else {
            print("el archivo no existe")
            return
        }
        
        
        //ruta a subir en storage
        storageRef = storageRef.child("/\(destinyPath)/\(fileName).\(fileExtension)")
        
        // Create the file metadata
        //        "text/csv"
        //        "image/jpeg"
        //        "application/x-plist"
        //        "application/octet-stream"
        let metadata = StorageMetadata()
        metadata.contentType = contentType
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let localFileURL = URL(fileURLWithPath: local!)
        let uploadTask = storageRef.putFile(from: localFileURL, metadata: metadata)
        
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let complete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress(complete)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            completion(true, nil)
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                
                completion(false, error)
                
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
        
        
    }
    
    
    func downloadFile(fullPath: String, localPath: String, fullName: String, completion: @escaping (Bool, Error?) -> Void, progress: @escaping (Double) -> Void) {
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        var storageRef = storage.reference(forURL: StorageReference)
        
        // Create a reference to the file we want to download
        storageRef = storageRef.child(fullPath)
        
        
        //path to local
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent(fullName)
        // let fullDestPathString = fullDestPath.path
        
        // Start the download (in this case writing to a file)
        let downloadTask = storageRef.write(toFile: fullDestPath)
        
        // Observe changes in status
        downloadTask.observe(.resume) { snapshot in
            print("download started")
            // Download resumed, also fires when the download starts
            if tareasPendientes == 0 {
                tareasRealizadas = 0
            }
            tareasPendientes += 1
        }
        
        downloadTask.observe(.pause) { snapshot in
            print("download paused")
            // Download paused
        }
        
        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let complete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            progress(complete)
        }
        
        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            completion(true, nil)
            tareasPendientes -= 1
            tareasRealizadas += 1
            
        }
        
        // Errors only occur in the "Failure" case
        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as NSError?)?.code else {
                return
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
                return
            }
            completion(false, snapshot.error)
            switch (error) {
            case .objectNotFound:
                // File doesn't exist
                // File doesn't exist
                tareasPendientes -= 1
                tareasRealizadas += 1
                
                break
            case .unauthorized:
                print(error)
                // User doesn't have permission to access file
                break
            case .cancelled:
                // User cancelled the download
                break
                
                /* ... */
                
            case .unknown:
                // Unknown error occurred, inspect the server response
                break
            default:
                // Another error occurred. This is a good place to retry the download.
                break
            }
        }
    }
    
}



