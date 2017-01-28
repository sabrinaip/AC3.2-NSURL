//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-1
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

struct InstaCat {
    let name: String
    let catID: Int
    let instagramURL: URL
    var description: String { return "Nice to me you, I'm \(self.name)" }
}

class InstaCatTableViewController: UITableViewController {
    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal var instaCats: [InstaCat] = []
        internal let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let instaCatsURL: URL = self.getResourceURL(from: instaCatJSONFileName),
            let instaCatData: Data = self.getData(from: instaCatsURL),
            let instaCatsAll: [InstaCat] = self.getInstaCats(from: instaCatData) else {
                return
        }
        self.instaCats = instaCatsAll
    }
    
    // MARK: - Data
    internal func getResourceURL(from fileName: String) -> URL? {
        // 1. There are many ways of doing this parsing, we're going to practice String traversal
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        // 2. The upperbound of a range represents the position following the last position in the range, thus we can use it
        // to effectively "skip" the "." for the extension range
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        // 3. Here is where Bundle.main comes into play
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
        return fileURL
    }
    
    internal func getData(from url: URL) -> Data? {
        // 1. this is a simple handling of a function that can throw. In this case, the code makes for a very short function
        // but it can be much larger if we change how we want to handle errors.
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
        do {
            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // Cast from Any and check for the "cats" key
            guard let instaCatJSONCasted = instaCatJSONData as? [String : AnyObject],
                let instaCatArray: [AnyObject] = instaCatJSONCasted["cats"] as? [AnyObject] else {
                    return nil
            }
            var instaCats: [InstaCat] = []
            instaCatArray.forEach({ instaCatObject in
                guard let instaCatName: String = instaCatObject["name"] as? String,
                    let instaCatIDString: String = instaCatObject["cat_id"] as? String,
                    let instaCatInstagramURLString: String = instaCatObject["instagram"] as? String,
                    // Some of these values need further casting
                    let instaCatID: Int = Int(instaCatIDString),
                    let instaCatInstagramURL: URL = URL(string: instaCatInstagramURLString) else {
                        return
                }
                // append to our temp array
                instaCats.append(InstaCat(name: instaCatName, catID: instaCatID, instagramURL: instaCatInstagramURL))
            })
            return instaCats
        }
        catch let error as NSError {
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        return  nil
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.instaCats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstaCatTableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.instaCats[indexPath.row].name
        cell.detailTextLabel?.text = self.instaCats[indexPath.row].description        
        return cell
    }
}
