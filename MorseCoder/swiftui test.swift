
import SwiftUI
//import RealmSwift

struct Itemm: Identifiable {
    
    let id : Int
    var value: String = ""
}

struct KeyBoardListView: View {
    weak var delegate: MorseKeyboardViewDelegate?
    @State private var itemlist = [
        Itemm(id: 1, value: "jhfkcvxs"),
        Itemm(id: 2, value: "jhfkxcves"),
        Itemm(id: 3, value: "jhfkfsdfs"),
        Itemm(id: 4, value: "345fds"),
        Itemm(id: 5, value: "5"),
    Itemm(id: 6, value: "f"),
        Itemm(id: 7, value: "5eb")
    ]
    var selected: UUID?
    init() {
        let items = [ """
         This goes
     over multiple
sdfdsfsdfsdfsdfenddfdafsf
lines
sdjhfkjh
"""
                      ,"abc","skdfkfdj","def", "ejflfj"]
//        for (idx, item) in items.enumerated() {
//            let id = UUID()
//            itemlist.append(Itemm(  id: <#UUID#>, id: <#UUID#>, value:item ))
//            if idx == 2 {
//                selected = id
//            }
//        }
        
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    @State private var previousIndex : Int? = nil
    
    var body: some View {
        
        ScrollViewReader { proxy in
            VStack {
                Button("Jump to   ") {
                    proxy.scrollTo(2 ,anchor: .top)
                }
//                List    {
//                    ForEach(itemlist) { item in
//                        Text("\(item.value)")
////                         .id(item)
//                    }
//                    .onDelete { offsets in
//                        itemlist.remove(atOffsets: offsets)
//                        self.previousIndex = offsets.first
//                        print("previous=\(String(describing: previousIndex))")
//                    }
//                    .onChange(of: previousIndex) { (e: Equatable) in
//                        proxy.scrollTo(previousIndex!+2, anchor: .top)
////                        proxy.scrollTo(3, anchor: .top) // will display 1st cell
//                    }
//                }
//                .frame(maxHeight: 50)

                GeneralList(verticalSpacing: 1) {
                    ForEach(itemlist )  { item in
                        
                        HStack {
                            Text(item.value).onTapGesture {
                                 //                               delegate?.insertString(item)
                            }
                            
                            Spacer()
                        }
                        

                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                        .border(Color.gray, width: 1)
                        .font(.footnote)
                        .lineLimit(4)
                        .removeSeparator()
                        
                    }
                    .onDelete { offsets in
                        itemlist.remove(atOffsets: offsets)
                        self.previousIndex = offsets.first
                        print("previous=\(String(describing: previousIndex))")
                    }
                    .onChange(of: previousIndex) { (e: Equatable) in
                        proxy.scrollTo(previousIndex!+2, anchor: .top)
                        //                        proxy.scrollTo(3, anchor: .top) // will display 1st cell
                    }
                    .listRowInsets( EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4) )//default: 8 ?
                    
                }
                .frame(maxHeight: 50)
                .environment(\.defaultMinListRowHeight, 0)// default : 8?
                .listStyle(GroupedListStyle())//remove padding of the entire list
            }
        }
        //.edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            UITableView.appearance().backgroundColor = .blue
            UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            UITableView.appearance().showsVerticalScrollIndicator = false
            
            //UITableViewCell.appearance().selectionStyle = .none
        }
       
       
        
      
        
    }
}




@available(iOS 14.0, *)
struct RowSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.listRowSeparator(.hidden)//iOS 15+
        } else {
            content
        }
        
    }
}
extension View {
    func removeSeparator() -> some View {
        modifier(RowSeparatorModifier())
    }
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        return KeyBoardListView()
    }
}
