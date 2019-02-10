//
//  csv.swift
//  cvsReader
//
//  Created by David Diego Gomez on 30/7/18.
//  Copyright © 2018 Gomez David Diego. All rights reserved.
//

/*
import Foundation
import CSV

class _configCSV {
    static let instance = _configCSV()
    
    
    //if you want to provide a character encoding
    /*
    let stream = InputStream(fileAtPath: "/path/to/file.csv")!
    let csv = try! CSVReader(stream: stream,
                             codecType: UTF16.self,
                             endian: .big)
    */
    
    
    func readFromFile(stringPath: String, datoHandler: (String) -> Void, completion: (Bool) -> Void ) {
        let stream = InputStream(fileAtPath:stringPath )!
        
        do {
            let csv = try CSVReader(stream: stream)
            
            for (row) in csv {
                //convierto [String] en String.
                let stringRow = row.joined(separator: ".")
                
                datoHandler(stringRow)
            }
        }
        catch {
                print("error al cargar archivo")
        }
        completion(true)
        
    }
    
    func readFirstRowFromFile(stringPath: String, datoHandler: (String) -> Void) {
        let stream = InputStream(fileAtPath:stringPath )!
        
        do {
            let csv = try CSVReader(stream: stream)
            
            for (x,row) in csv.enumerated() {
                //convierto [String] en String.
                let stringRow = row.joined(separator: ".")
                
                if x == 1 {
                    datoHandler(stringRow)
                    return
                }
                
            }
        }
        catch {
            print("error al cargar archivo")
        }
        
    }
    
    
    
    func readHeaderFromFile(stringPath: String, datoHandler: ([String]?) -> Void) {
        let stream = InputStream(fileAtPath:stringPath )!
     
        do {
            let headers = try CSVReader(stream: stream, hasHeaderRow: true)
            
            let headerRow = headers.headerRow!
            datoHandler(headerRow)
        } catch {
            datoHandler(nil)
            print("error al cargar archivo")
        }
    }
    
    //Write to a File
    
    func writeToFile() {
        let stream = OutputStream(toFileAtPath: "/Users/diegodavid_77/Downloads/file.csv", append: false)!
        let csv = try! CSVWriter(stream: stream)
        
        try! csv.write(row: ["id", "name"])
        try! csv.write(row: ["1", "foo"])
        try! csv.write(row: ["1", "bar"])

        
        csv.stream.close()
    }
    
    //Write to memory and get a CSV String
    
    func writeToMemory() -> String{
        let stream = OutputStream(toMemory: ())
        let csv = try! CSVWriter(stream: stream)
        
        // Write a row
        try! csv.write(row: ["id", "name"])
        
        // Write fields separately
        csv.beginNewRow()
        try! csv.write(field: "1")
        try! csv.write(field: "foo")
        csv.beginNewRow()
        try! csv.write(field: "2")
        try! csv.write(field: "bar")
        
        csv.stream.close()
        
        // Get a String
        let csvData = stream.property(forKey: .dataWrittenToMemoryStreamKey) as! NSData
        let csvString = String(data: Data(referencing: csvData), encoding: .utf8)!
        print(csvString)
        return csvString
        // => "id,name\n1,foo\n2,bar"
    }

}
 
 */
