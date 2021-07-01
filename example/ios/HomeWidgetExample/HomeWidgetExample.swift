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

struct HomeWidgetExampleEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    var body: some View {
        VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
//            Color(red: 91 / 255, green: 146 / 255, blue: 235 / 255).ignoresSafeArea()
            Text(entry.location).bold().font(.title2)
            Text("기온 : " + entry.temperature).font(.body)
            Text(entry.description)
                .font(.body)
                .widgetURL(URL(string: "homeWidgetExample://message?message=\(entry.description)&homeWidget"))
            Text("강수량 : " + entry.rainFall).font(.body)
        }
        )
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
