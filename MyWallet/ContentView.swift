import SwiftUI
import Charts
import SwiftData

struct ContentView: View {
    @State private var selectedAmount: Double? = nil
    @StateObject var moneyManager = MoneyManager()
    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Date()
    @State private var filteredData: [Category] = []
    @State private var isFiltering: Bool = false
    
    var cumulativeIncomes: [(category: String, range: Range<Double>)] {
        var cumulative = 0.0
        return moneyManager.data.map {
            let newCumulative = cumulative + Double($0.cost)
            let result = (category: $0.cat, range: cumulative..<newCumulative)
            cumulative = newCumulative
            return result
        }
    }
    
    var donationsIncomeDataSorted: [Category] {
        moneyManager.data.sorted { $0.cost > $1.cost }
    }
    
    var selectedCategory: Category? {
        if let selectedAmount,
           let selectedIndex = cumulativeIncomes
            .firstIndex(where: { $0.range.contains(selectedAmount) }) {
            return moneyManager.data[selectedIndex]
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    Spacer(minLength: 70)
                    Text("Your Wallet Chart")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    DatePicker("From", selection: $fromDate, in: ...Date(), displayedComponents: .date)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.horizontal, 110.0)
                        .offset(x: -80, y: -5)
                    
                    DatePicker("To", selection: $toDate, in: ...Date(), displayedComponents: .date)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.horizontal, 110.0)
                        .offset(x: -80, y: -5)
                    
                    Button(action: {
                        filterData()
                    }) {
                        Text("Filter")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .offset(x: 30)
                            Spacer()
                    }
                    
                    if isFiltering {
                        ZStack {
                            Chart {
                                ForEach(filteredData) { d in
                                    SectorMark(angle: .value("Cost", Double(d.cost)),
                                               innerRadius: .fixed(110),
                                               outerRadius: .fixed(selectedCategory == d ? 180 : 160),
                                               angularInset: 3)
                                        .foregroundStyle(by: .value("Category", d.cat))
                                        .cornerRadius(25)
                                }
                            }
                            .chartAngleSelection(value: $selectedAmount)
                            .chartLegend( alignment: .bottom) {
                                Text("🟠 Investments  🟢 Business  🔵 Salary                       🔴 Others  🟣 Gifts  🟡 Groceries 🩵 Utilities").foregroundColor(.white)
                            }
                            .overlay(
                                Text("Click on category\n  to display data")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .opacity(selectedCategory == nil ? 1 : 0)
                                    .offset(y: -20)
                            )
                            .chartBackground { chartProxy in
                                GeometryReader { geometry in
                                    let frame = geometry[chartProxy.plotFrame!]
                                    VStack(spacing: 0) {
                                        if let selectedCategory = selectedCategory {
                                            Text(selectedCategory.cat)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                                .multilineTextAlignment(.center)
                                                .font(.title2)
                                                .foregroundStyle(.secondary)
                                                .frame(width: 120, height: 80)
                                            Text(String(format: "€%.2f", selectedCategory.cost))
                                                .font(.title.bold())
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .position(x: frame.midX, y: frame.midY)
                                }
                            }
                            .offset(y: -30)
                        }
                        .padding()
                    } else {
                        ZStack {
                            Chart {
                                ForEach(moneyManager.data) { d in
                                    SectorMark(angle: .value("Cost", Double(d.cost)),
                                               innerRadius: .fixed(110),
                                               outerRadius: .fixed(selectedCategory == d ? 180 : 160),
                                               angularInset: 3)
                                        .foregroundStyle(by: .value("Category", d.cat))
                                        .cornerRadius(25)
                                }
                            }
                            .chartAngleSelection(value: $selectedAmount)
                            .chartLegend( alignment: .bottom) {
                                Text("🟠 Investments  🟢 Business  🔵 Salary                       🔴 Others  🟣 Gifts  🟡 Groceries 🩵 Utilities").foregroundColor(.white)
                            }
                            .overlay(
                                Text("Click on category\n  to display data")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .opacity(selectedCategory == nil ? 1 : 0)
                                    .offset(y: -20)
                            )
                            .chartBackground { chartProxy in
                                GeometryReader { geometry in
                                    let frame = geometry[chartProxy.plotFrame!]
                                    VStack(spacing: 0) {
                                        if let selectedCategory = selectedCategory {
                                            Text(selectedCategory.cat)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                                .multilineTextAlignment(.center)
                                                .font(.title2)
                                                .foregroundStyle(.secondary)
                                                .frame(width: 120, height: 80)
                                            Text(String(format: "€%.2f", selectedCategory.cost))
                                                .font(.title.bold())
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .position(x: frame.midX, y: frame.midY)
                                }
                            }
                            .offset(y: -30)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    HStack {
                        NavigationLink(destination: PlusView().environmentObject(moneyManager)) {
                            Image("plus")
                        }
                        Spacer()
                            .frame(width: 50.0)
                        NavigationLink(destination: MinusView().environmentObject(moneyManager)) {
                            Image("minus")
                        }
                    }
                }
            }
        }
    }
    
    func filterData() {
        filteredData = moneyManager.data.filter { category in
            guard let date = category.date else { return false }
            return date >= fromDate && date <= toDate
        }
            isFiltering = true
          
        }
    }



#Preview {
    ContentView()
}
