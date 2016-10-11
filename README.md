### AC3.2 NSURL/URL 
---

### Readings
1. [`NSURL` - Apple](https://developer.apple.com/reference/foundation/nsurl)
2. [`URL` - Apple](https://developer.apple.com/reference/foundation/url) (mostly same as the above, `URL` is new to swift and can be used interchangeably with `NSURL`)
3. [`NSBundle` - Apple](https://developer.apple.com/reference/foundation/nsbundle)
4. [`JSONSerialization` - Apple](https://developer.apple.com/reference/foundation/jsonserialization)
3. [`Creating and Modifying an NSURL in Your Swift App` - Coding Explorer Blog](http://www.codingexplorer.com/creating-and-modifying-nsurl-in-swift/)

#### Other Readings:
1. [`About the URL Loading System` - Apple](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i)

---
### 1. Intro To `NSURL/URL`

We've already works a bit with the concepts of converting `JSON` into data models. We're going to extend this further in this into by showing you how to import data from a local `.json` file, rather than taking an `Dictionary` of values and converting them into your data model. This practice is very common when making web requests, so we'll just be getting our feet wet with this example. 

Locating a file is done via querying the filesystem using `NSURL/URL`. As briefly stated in the official Apple docs for `NSURL/URL`:

> An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.

In the project you will find `Main.storyboard` already containing a `UITableViewController` with an embedded `UINavigationController` that is set to be the "Initial View Controller".

1. Change the custom class of the table view controller to `InstaCatTableViewController`
2. Give the prototype cells an identifier of `InstaCatCellIdentifier` 
3. Switch over to `InstaCatTableViewController.swift` and add in an `InstaCat` struct to house the data for an `InstaCat`
  - For this part, refer to your tests to know how you should construct the model
4. Now add in the following instance variables to the `InstaCatTableViewController` class
```swift
    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal var instaCats: [InstaCat] = []
```

### 2. Planning out your code
Let's start getting used to creating our functions before we start typing them out completely. This will help to understand that a little bit of planning and preparation can go a long way in development. How exactly do we know what we'll need though? We should think of the task as being a series of functions that take an input and return some output. Our goal is to locate a file, get the data of that file, and try to create `[InstaCat]` from that data. Combining those two concepts (series of functions and goals) we can derive a good estimate of what we'll need: 

1. We know that we're going to need to create an array of `InstaCat` from `Data`. That means we know that the input to a function will be `Data` and its output is going to be `[InstaCat]`, but in all likelihood (and as is common practice) we should not guarantee that the data will create `[InstaCat]` so we return an optional. 
2. In order to get that `Data`, we're going to need the file's `URL` so that we can locate it
3. The name of the file is available to us as a `String`, but we'll need a `URL` to be able to do the searching

So, from the above we can deduce: 
```swift
    internal func getResourceURL(from fileName: String) -> URL? {
        
        return nil 
    }
    
    internal func getData(from url: URL) -> Data? {
        
        return nil
    }
    
    internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
        
        return nil
    }
```
  > Note: I have a preference for immediately adding a return value for functions that I write that expect one. I do this only because I prefer not to see pre-compiler errors.
  
And now, in `viewDidLoad`, we can add all of the following, even if we haven't filled out the functions yet:
  
  ```swift 
          guard let instaCatsURL: URL = self.getResourceURL(from: instaCatJSONFileName),
            let instaCatData: NSData = self.getData(from: instaCatsURL),
            let instaCatsAll: [InstaCat] = self.getInstaCats(from: instaCatData) else {
                return
          }
        
        self.instaCats = instaCatsAll
```

---
### 3. Getting a `URL` and `Data`
Each of the projects we've created, compile into a self-encapsulated application bundle (aka. "app bundle"). The `NSBundle/Bundle` class helps with locating resources within your app's bundle - for example a file. For the most part, you're only ever going to be using `Bundle.main` (which refers to the directory within your application bundle where the contents of your project are commonly kept). 

```swift
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
```

Getting the `Data` contents of the file located at `fileURL` is fairly straightforward

```swift
    internal func getData(from url: URL) -> Data? {
        
        // 1. this is a simple handling of a function that can throw. In this case, the code makes for a very short function
        // but it can be much larger if we change how we want to handle errors.
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
```

---
### 4. Exercise
Using the tests provided and following snippet of code (with hints), finish out the rest of this project so that you can parse out the data contained in `InstaCats.json` to create `[InstaCat` and output the info to the `InstaCatTableViewController` as pictured below:

#### InstaCat Model:
```swift
struct InstaCat {
  // fill out necessary ivars and initilizations
  // check the tests to know what you should have
}
```

```swift
      internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
        
        // 1. This time around we'll add a do-catch
        do {
            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // 2. Cast from Any into a more suitable data structure and check for the "cats" key
            
            // 3. Check for keys "name", "cat_id", "instagram", making sure to cast values as needed along the way
            
            // 4. Return something
        }
        catch let error as NSError {
          // JSONSerialization doc specficially says an NSError is returned if JSONSerialization.jsonObject(with:options:) fails
          print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }
```
