//
//  HomeWidgetExample.swift
//  HomeWidgetExample
//
//  Created by Anton Borries on 04.10.20.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.com.swfact.home"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExampleEntry {
        ExampleEntry(date: Date(), temperature: "Placeholder temperature", description: "Placeholder description", rainFall: "Placeholder rainFall", location: "Placeholder location")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ExampleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
        let entry = ExampleEntry(date: Date(), temperature: data?.string(forKey: "temperature") ?? "No temperature Set", description: data?.string(forKey: "description") ?? "No description Set", rainFall: data?.string(forKey: "rainFall") ?? "No rainFall Set", location: data?.string(forKey: "location") ?? "No location Set")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ExampleEntry: TimelineEntry {
    let date: Date
    let temperature: String
    let description: String
    let rainFall: String
    let location: String
}

struct Emoji{
    let icon: String
    let status: String
}

struct HomeWidgetExampleEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily

    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    let emojis = [
        Emoji(icon: "☀️", status: "맑음"),
        Emoji(icon: "🌤", status: "구름조금"),
        Emoji(icon: "⛅️", status: "구름많음"),
        Emoji(icon: "☁️", status: "흐림"),
        Emoji(icon: "☔️", status: "비"),
        Emoji(icon: "🌦", status: "소나기"),
        Emoji(icon: "☃️", status: "눈"),
        Emoji(icon: "🌫", status: "안개"),
    ]
    
    

    func select_emoji() -> String {
        var emoji : String
        emoji = "➖"
        for item in emojis{
            if(entry.description == item.status){
                emoji = item.icon
            }
        }
        return emoji
    }
    
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack{
                Color(red: 46 / 255, green: 103 / 255, blue: 198 / 255)
                VStack(alignment: .leading, spacing: 10){
                    Text(entry.location).bold().font(.caption).foregroundColor(Color.white)
                    VStack(alignment: .leading, spacing: 2){
                        HStack{
                            Text(self.select_emoji()).font(.title)
                            Text(entry.temperature).font(.body).foregroundColor(Color.white)
                        }
                        HStack(spacing: 30){
                            Text(entry.description)
                                .font(.body).foregroundColor(Color.white)
                            HStack{
                                Text("💧" + entry.rainFall).font(.caption).foregroundColor(Color.white)
                            }
                        }
                    }
                }
            }
        case .systemMedium:
            ZStack{
                Color(red: 46 / 255, green: 103 / 255, blue: 198 / 255)
                
                VStack(alignment: .leading, spacing: 10){
                    Text(entry.location).bold().font(.title3).foregroundColor(Color.white)
                    HStack(spacing: 100){
                        HStack(){
                            Text(self.select_emoji()).font(.title).foregroundColor(Color.white)
                            Text(entry.temperature).font(.title).foregroundColor(Color.white)
                        }
                        VStack(alignment: .trailing){
                            Text(entry.description)
                                .font(.body).foregroundColor(Color.white)
                            Text("💧" + entry.rainFall).font(.body).foregroundColor(Color.white)
                        }
                    }
                }
            }
        case .systemLarge:
            ZStack{
                Color(red: 46 / 255, green: 103 / 255, blue: 198 / 255)
                VStack(spacing: 20){
                    Text(entry.location).bold().font(.title2).foregroundColor(Color.white)
                    Text(self.select_emoji()).font(.largeTitle)
                    Text(entry.description)
                        .font(.largeTitle).foregroundColor(Color.white)
                    HStack(spacing: 30){
                        Text("🌡 " + entry.temperature).font(.title2).foregroundColor(Color.white)
                        HStack{
                            Text("💧" + entry.rainFall).font(.title2).foregroundColor(Color.white)
                        }
                    }
                }
            }
        default:
            Text("unknown")
        }

        
        
    }
}

@main
struct HomeWidgetExample: Widget {
    let kind: String = "HomeWidgetExample"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetExampleEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HomeWidgetExample_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetExampleEntryView(entry: ExampleEntry(date: Date(), temperature: "Example temperature", description: "Example description", rainFall: "Example rainFall", location: "Example location"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
