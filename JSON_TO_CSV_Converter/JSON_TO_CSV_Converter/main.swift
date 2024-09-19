//
//  main.swift
//  JSON_TO_CSV_Converter
//
//  Created by Hameed Ebadi on 9/17/24.
//

import Foundation

// Function to read JSON file and convert it to a dictionary
func readJSON(from filePath: String) -> [[String: Any]]? {
    // Ensure the file exists at the specified path
    guard FileManager.default.fileExists(atPath: filePath) else {
        print("File does not exist at path: \(filePath)")
        return nil
    }

    // Attempt to read the data from the file
    guard let data = FileManager.default.contents(atPath: filePath) else {
        print("Failed to read data from file: \(filePath)")
        return nil
    }

    // Attempt to parse the JSON data
    do {
        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            return jsonArray
        } else {
            print("Failed to cast JSON data to an array of dictionaries.")
        }
    } catch {
        print("Error parsing JSON: \(error.localizedDescription)")
    }
    return nil
}

// Function to convert JSON array to CSV format
func convertToCSV(jsonArray: [[String: Any]]) -> String? {
    guard let firstElement = jsonArray.first else {
        print("JSON data is empty.")
        return nil
    }

    // Get CSV headers from the keys of the first dictionary
    let headers = firstElement.keys.sorted()
    var csvString = headers.joined(separator: ",") + "\n"

    // Get CSV rows
    for item in jsonArray {
        var row = [String]()
        for header in headers {
            if let value = item[header] {
                row.append("\(value)")
            } else {
                row.append("")
            }
        }
        csvString += row.joined(separator: ",") + "\n"
    }

    return csvString
}

// Function to write CSV data to a file
func writeCSV(to filePath: String, content: String) {
    do {
        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        print("CSV file created successfully: \(filePath)")
    } catch {
        print("Failed to write CSV file: \(error.localizedDescription)")
    }
}

// Main function
func main() {
    let inputFilePath = "/Users/hebadi/Documents/Gitlab.OTX/MacSecurity/DerivedData/MacSecurity/Logs/Test/coverage.json"
    let outputFilePath = "/Users/hebadi/Downloads/TestCoverageWSAMACFY24Q4.csv"
    

    // Read and parse the JSON file
    guard let jsonArray = readJSON(from: inputFilePath) else {
        print("Failed to load or parse JSON file.")
        return
    }

    // Convert JSON array to CSV format
    guard let csvContent = convertToCSV(jsonArray: jsonArray) else {
        print("Failed to convert JSON to CSV.")
        return
    }

    // Write the CSV content to a file
    writeCSV(to: outputFilePath, content: csvContent)
}

// Run the main function
main()
