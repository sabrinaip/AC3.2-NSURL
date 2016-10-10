  ### AC3.2 PickerViews and Delegation
---

### Readings
1. [`NSURL` - Apple](https://developer.apple.com/reference/foundation/nsurl)
2. [`URL` - Apple](https://developer.apple.com/reference/foundation/url) (mostly same as the above, `URL` is new to swift and can be used interchangeably with `NSURL`)
3. [`Creating and Modifying an NSURL in Your Swift App` - Coding Explorer Blog](http://www.codingexplorer.com/creating-and-modifying-nsurl-in-swift/)

#### Part II Readings:
1. [`About the URL Loading System` - Apple](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i)
2. 

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
4. 