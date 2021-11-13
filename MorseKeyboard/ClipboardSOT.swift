
import Foundation
import RealmSwift

class ClipboardSOT: ObservableObject {
    var lastpasteboardString: String?
    @Published var clipItems: Results<Item>?
    @Published var selectedCategory: Category?
    var categoryService : CategoryViewController
    init(controller: CategoryViewController) {
        self.categoryService = controller
        
        if let cats = controller.loadCategories(){
            selectedCategory = cats.first
            if let selectedCategory = selectedCategory, selectedCategory.items.count > 0 {
                clipItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: false)
            }
        } else {
            controller.createDefaultCategory()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addClipboardItemToDB),
                                               name: NSNotification.Name.UIPasteboardChanged , object: nil)
        addClipboardItemToDB()
        
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
    }
    
    
    //    @objc  func clipboardChanged(){
    //        let pasteboardString: String? = UIPasteboard.general.string
    //        if let theString = pasteboardString {
    //            print("String is \(theString)")
    //            // Put the string into your search bar and do the search
    //        }
    //    }
    func removeItemFromDB(item: Item) {
        categoryService.removeItemFromCategory(item: item, cat: selectedCategory!)
        
    }
    @objc func addClipboardItemToDB() {
        let pasteboardString: String? = UIPasteboard.general.string
        guard let   theString = pasteboardString, let selectedCategory = selectedCategory else { return  }
        lastpasteboardString = clipItems?.first?.content
        
        if  theString == lastpasteboardString {
            print(lastpasteboardString != nil ? "duplicated value:\(theString)" : "no value to show")
        }
        else   {
            lastpasteboardString = theString
            print("String is \(theString)")
            // Put the string into your search bar and do the search
            let newItem = Item()
            newItem.content = theString
            newItem.dateCreated = Date()
            categoryService.addItemToCategory(item: newItem, cat: selectedCategory)
            //    clipItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: false)//no need, because of LIVE updating in Realm
            loadItems()
        }
        
        
    }
    
    func loadItems() {
        guard let clipItems = clipItems else {
            return
        }
        print(  "==============\nNEXT")
        for (index, element) in clipItems.enumerated() {
            print(  "\(index+1)=====\(element.content)")
        }
        //        tableView.reloadData()
    }
}
