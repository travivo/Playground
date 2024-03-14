/*
 PROBLEM:
 Ekahau just hired Ella Musk to create a bleeding edge robot to deliver Ekahau
 confidential documents. Ekahau's documents is arrange as follows:
 Papers are contained inside Folders
 Folders are arranged inside Boxes
 Let's call papers as P, folders as F and boxes as B for simplicity.
 Example scenario: A box containing 3 folders arrives,
 1st Folder contains paper 1 and paper 2
 2nd Folder contains paper 3 and paper 4
 3rd Folder contains paper 5 and paper 6
 for simplicity, we can write the above scenario as:
 P1, P2, F1, P3, P4, F2, P5, P6, F3, B1
 (the number denotes its unique id)
 
 Everyday, the robot will delivery boxes to Ekahau that contains papers and folders. Now
 here's the tricky part: If an object is already sent in previous days, we should be able to
 include it in the previous box it belongs to. for example:
 Monday: P1 P2 F1 B1
 Tuesday: P2 F1 P3 F2 B1
 
 Contents of the Tuesday box will be put inside Monday's box because clearly its an
 updated version of Monday's box
 So the resulting configuration after Tuesday shipment is: P1 P2 F1 P3 F2 B1 (bold are
 the ones updated or new that day)
 Another scenario
 Monday P1 P2 F1 B1
 Tuesday P3 F2 B2
 Wednesday P2 P3 F1 B2
 
 Now that's a messed up shipment from the robot! Tuesday, we still have 2 boxes. but
 Wednesday shipment comes and we realized that P2 and P3 should be inside the same
 folder F1 so we need to merge both B1 and B2 boxes contents! resulting configuration
 after Wednesday as follows: P1 P2 P3 F1 B1
 */

/*
 SOLUTION
 This Swift code defines several classes: Paper, Folder, Box, and Robot, each serving a specific purpose within a virtual organizational system. Here's a breakdown of what each class does:

 1. Paper:
    Represents a paper document with a unique identifier.
    Initialized with an ID.
 
 2. Folder:
    Represents a folder that can contain multiple papers.
    Initialized with an ID and an empty array of papers.
    Methods:
    - addPapers: Adds an array of papers to the folder.
    - removePaper: Removes a paper from the folder based on its ID.
 3. Box:
    Represents a box that can contain multiple folders.
    Initialized with an ID and an empty array of folders.
    Methods:
    - addFolders: Adds an array of folders to the box.
    - addFolder: Adds a single folder to the box.
    - searchFolder: Searches for a folder by ID within the box.
    - removeFolder: Removes a folder from the box based on its ID.
 4. Robot:
    Represents a robot responsible for managing boxes, folders, and papers.
    Initialized with an empty array of boxes.
    Methods:
    - searchFolder: Searches for a folder by ID across all boxes.
    - searchBox: Searches for a box by ID within the robot.
    - removeExistingPapersIn: Removes existing papers in a folder from all boxes.
    - removePapers: Removes specified papers from all folders across all boxes.
    - addEntry: Processes daily entries and adds them to the system.
    - transformEntries: Transforms daily entry strings into instances of Box, Folder, and Paper classes.
    - printAll: Prints the IDs of all papers, folders, and boxes currently in the system.
 
 The code concludes with the creation of a Robot instance named robot. This instance can be used to manage the virtual organizational system.
 */

import UIKit

class Paper {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

class Folder {
    var id: Int
    var papers: [Paper]
    
    init(id: Int) {
        self.id = id
        self.papers = []
    }
    
    func addPapers(_ newPapers: [Paper]) {
        papers.append(contentsOf: newPapers)
    }
    
    func removePaper(removeId: Int) {
        papers.removeAll(where: { $0.id == removeId })
    }
}

class Box {
    var id: Int
    var folders: [Folder]
    
    init(id: Int) {
        self.id = id
        self.folders = []
    }
    
    func addFolders(_ newFolders: [Folder]) {
        folders.append(contentsOf: newFolders)
    }
    
    func addFolder(_ newFolder: Folder) {
        folders.append(newFolder)
    }
    
    func searchFolder(searchId: Int) -> Folder? {
        var f = folders.first{$0.id == searchId}
        return (f != nil) ? f: nil
    }
    
    func removeFolder(searchId: Int) {
        folders.removeAll(where: { $0.id == searchId })
    }

}

class Robot {
    var boxes: [Box]
    
    init() {
        boxes = []
    }
    
    func searchFolder(searchId: Int) -> Folder? {
        for box in boxes {
            if let existingFolder = box.searchFolder(searchId: searchId) {
                return existingFolder
            }
        }
        
        return nil
    }
    
    func searchBox(searchId: Int) -> Box? {
        var b = boxes.first{$0.id == searchId}
        return (b != nil) ? b: nil
    }
    
    func removeExistingPapersIn(folder: Folder) {
        for paper in folder.papers {
            for box in boxes {
                for oldFolder in box.folders {
                    if oldFolder.papers.contains(where: { p in
                        p.id == paper.id
                    }) {
                        folder.removePaper(removeId: paper.id)
                    }
                }
            }
        }
    }
    
    func removePapers(papers: [Paper]) {
        for paper in papers {
            for box in boxes {
                for folder in box.folders {
                    folder.removePaper(removeId: paper.id)
                }
            }
        }
    }

    
    func addEntry(entries: [String]) {
        var transformedEntries = transformEntries(entries: entries)
        
        var removeBoxIndexes = [Int]()
        var index = 0
        for entry in transformedEntries {
            
            // Check folders of box/entry
            for folder in entry.folders {
                
                if !folder.papers.isEmpty {
                    // remove all existing papers of the current folder first before adding the new ones to avoid duplicate
                    removeExistingPapersIn(folder: folder)
                    
                    // folder is existing, let's put all the papers in the existing folder and remove the new folder(we don't need empty folder)
                    if let existingFolder = searchFolder(searchId: folder.id) {
                        existingFolder.addPapers(folder.papers)
                        entry.removeFolder(searchId: folder.id)
                    }
                    // box is existing, let's put our new folder in the existing box
                    else if let existingBox = searchBox(searchId: entry.id) {
                        // check if folder is not empty
                        if !folder.papers.isEmpty {
                            existingBox.addFolder(folder)
                        }
                        entry.removeFolder(searchId: folder.id)
                    }
                    else {
                        // new folder in a new box, we'll append all new items at the end
                    }
                }
                
                // final check if folder is now empty
                if folder.papers.isEmpty {
                    entry.removeFolder(searchId: folder.id)
                }
            }

            // check if box is empty
            if entry.folders.isEmpty {
                removeBoxIndexes.append(index)
            }
            
            index += 1;
        }
        
        // remove empty boxes
        for removeBoxIndex in removeBoxIndexes {
            transformedEntries.remove(at: removeBoxIndex)
        }
        
        // add the remaining new entries
        boxes.append(contentsOf: transformedEntries)
    }
    
    // transform the daily entry to array of class
    func transformEntries(entries: [String]) -> [Box] {
        
        var papers = [Paper]()
        var folders = [Folder]()
        var boxes = [Box]()
        
        for entry in entries {
            let type = String(entry.first!)
            let id = Int(String(entry.last!))
            
            switch type.uppercased() {
            case "P":
                papers.append(Paper(id: id!))
                break
            case "F":
                let newFolder = Folder(id: id!)
                newFolder.addPapers(papers.sorted { $0.id > $1.id })
                folders.append(newFolder)
                papers.removeAll()
                break
            case "B":
                let newBox = Box(id: id!)
                newBox.addFolders(folders.sorted { $0.id > $1.id })
                boxes.append(newBox)
                folders.removeAll()
                break
            default:
                break
            }
        }
        
        return boxes
    }
    
    
    
    func printAll() {
        var description = ""
        for box in boxes {
            for folder in box.folders {
                for paper in folder.papers {
                    description.append("P\(paper.id), ")
                }
                description.append("F\(folder.id), ")
            }
            description.append("B\(box.id), ")
        }
        
        print(description)
    }
}

let robot = Robot()

///Day 1
robot.addEntry(entries: ["P1", "F1", "P2", "F2", "B1"])
robot.printAll()

///Day 2
robot.addEntry(entries: ["P3", "P4", "F3", "B2"])
robot.printAll()

///Day 3
robot.addEntry(entries: ["P5", "F4", "B3"])
robot.printAll()

///Day 4
robot.addEntry(entries: ["P5", "B5"])
robot.printAll()
//expected: P2, F2, P1, F1, B1, P4, P3, F3, B2, P5, F4, B3
//result  : P2, F2, P1, F1, B1, P4, P3, F3, B2, P5, F4, B3,

///Day 5
robot.addEntry(entries: ["P2", "F2", "P1", "F6", "B1"])
robot.printAll()
//expected: P2, F2, P1, F1, B1, P4, P3, F3, B2, P5, F4, B3
//result  : P2, F2, P1, F1, B1, P4, P3, F3, B2, P5, F4, B3

///Day 6
robot.addEntry(entries: ["P6", "F7", "B4"])
robot.printAll()
//expected: P2, F2, P1, F1, B1, P4, P3, F3, B2, P5, F4, B3, P6, F7, B4
//result  : P2, F2, P1, F1, B1, P4, P3, F3, B2, P5, F4, B3, P6, F7, B4,


///Day 7
robot.addEntry(entries: ["P2", "F2", "P1", "P7", "F6", "B1", "P4", "P8", "F8", "B6"])
robot.printAll()
//expected: P2, F2, P1, P7, F1, B1, P4, P3, P8, F3, B2, P5, F4, B3, P6, F7, B4
//result:   P2, F2, P1, F1, P7, F6, B1, P4, P3, F3, B2, P5, F4, B3, P6, F7, B4, P8, F8, B6
// Why did P7 from F6 go to F1? Also P8 from F8 go to F3?
