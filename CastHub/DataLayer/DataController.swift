//
//  DataController.swift
//  CastHub
//
//  Created by Ibrahim fuseini on 19/12/2025.
//


import SwiftData
import Foundation
import Observation

@Observable
final class DataController {
    static let shared = DataController()
    
    let container: ModelContainer
    let persistenceRepository: PersistenceRepository
    
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        let schema = Schema([PodcastPersistenceModel.self, EpisodePersistenceModel.self])
        
        var config = ModelConfiguration(schema: schema)
        if inMemory {
            config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        } else {
            config = ModelConfiguration(schema: schema)
        }
        
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
        
        self.persistenceRepository = PersistenceRepositoryImpl(modelContext: container.mainContext)
    }
    
    func createSampleData() {
        let context = container.mainContext
        
        for i in 1...5 {
            let podcast = PodcastPersistenceModel(
                id: UUID(),
                title: "",
                feedUrl: "podcast_\(i)",
                //collectionCensoredName: "Sample track \(i)",
                artworkUrl: "sample image \(i)",
                saved: false
                //releasedDate: Date()
            )
            context.insert(podcast)
            
            for j in 1...3 {
                let timestampMilliseconds = Date().timeIntervalSince1970 * 1000 - Double(j * 86400000)
                let timestamp = Date(timeIntervalSince1970: timestampMilliseconds/1000)
                let episode = EpisodePersistenceModel(
                    //id: "episode_\(i)_\(j)",
                    title: "Sample Episode \(j)",
                    pubDate: timestamp,
                    content: "Description for episode \(j)",
                    imageUrl: "image",
                    itunesDuration: TimeInterval(1800 * j),
                    audioUrl: "",
                    type: ""
                )
                episode.podcast = podcast
                context.insert(episode)
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
}
