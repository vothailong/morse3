
import SwiftUI
//import RealmSwift

struct Itemm: Identifiable {
    
    let id : Int
    var value: String = ""
}

struct KeyBoardListView: View {
    weak var delegate: MorseKeyboardViewDelegate?
    @State private var itemlist = [
        Itemm(id: 1, value: "1"),
        Itemm(id: 2, value: "2"),
        Itemm(id: 3, value: "3"),
        Itemm(id: 4, value: "4"),
        Itemm(id: 5, value: "5"),
        Itemm(id: 6, value: "6"),
        Itemm(id: 7, value: "7"),
        Itemm(id: 8, value: "8")
    ]
    var selected: UUID?
    init() {
        
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    @State private var previousIndex : Int? = nil
    @State var visibleRows: Set<Int> = []
    @State private var visibleList = [Itemm]()
    var body: some View {
        
        ScrollViewReader { proxy in
            VStack {
                Button("Jump to   ") {
                    proxy.scrollTo(2 ,anchor: .top)
                }

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

                        .onAppear {
                           // self.visibleRows.insert(item.id)
                            self.visibleList.append(item)
                        }
                        .onDisappear {
                            visibleList.removeAll { item1 in
                                item1.id == item.id
                            }
                        }
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
                .frame(height: 150)
                .environment(\.defaultMinListRowHeight, 0)// default : 8?
                .listStyle(GroupedListStyle())//remove padding of the entire list
                Spacer()
                
                    Text(getVisibleIndeeex()?.value ?? "novalue")
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
    func getVisibleIndeeex( ) -> Itemm? {
       let s = visibleList.sorted(by: { item1, item2 in
            item1.id < item2.id
        })
        return s.first
        
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
