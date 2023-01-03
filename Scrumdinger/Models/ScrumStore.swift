//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/12/26.
//

import Foundation
import SwiftUI

class ScrumStore: ObservableObject {  /// ObservableObject is a class-constrained protocol for connecting external model data to SwiftUI views.
    @Published var scrums: [DailyScrum] = []
    /// An ObservableObject includes an objectWillChange publisher that emits when one of its @Published properties is about to change. Any view observing an instance of ScrumStore will render again when the scrums value changes.
    /// Scrumdinger will load and save scrums to a file in the user’s Documents folder.
    /// Add a function that makes accessing that file more convenient: Add a private static throwing function named fileURL that returns a URL.
    private static func fileURL() throws -> URL {  /// "throw" is used inside do-catch statement.
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)  /// You use the shared instance of the FileManager class to get the location of the Documents directory for the current user.
        .appendingPathComponent("scrums.data")  /// Call appendingPathComponent(_:) to return the URL of a file named scrums.data.
    }
    
    static func load() async throws -> [DailyScrum] {  ///  For throwing functions, write async before the throws keyword.
        try await withCheckedThrowingContinuation { continuation in
            /// suspends the load function, then passes a continuation into a closure that you provide. A continuation is a value that represents the code after an awaited function.
            load { result in  /// call the legacy load function with a completion handle ----- "result". The completion handler receives a Result<[DailyScrum], Error> enumeration.
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)  /// The array of scrums becomes the result of the withCheckedThrowingContinuation call when the async task resumes.
                }
            }
        }
    }
    
    /// Add a static function to load data.
    static func load(completion: @escaping (Result<[DailyScrum], Error>)->Void) {  /// The load function accepts a completion closure that it calls asynchronously with either an array of scrums or an error.
        /// use dispatch queues to choose which tasks run on the main thread or background threads.
        DispatchQueue.global(qos: .background).async {
            /// Create an asynchronous block on a background queue. Dispatch queues are first in, first out (FIFO) queues to which your application can submit tasks. Background tasks have the lowest priority of all tasks.
            do {
                /// Add a do-catch statement to handle any errors with loading data.
                ///ref: https://www.hackingwithswift.com/example-code/language/how-to-use-try-catch-in-swift-to-handle-exceptions
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {  /// Create a file handle for reading scrums.data.
                        DispatchQueue.main.async {
                            completion(.success([]))  /// Because scrums.data doesn’t exist when a user launches the app for the first time, you call the completion handler with an empty array if there’s an error opening the file handle.
                            // TODO: how to use a completion handle?
                            // TODO: what does this .success() do?
                        }
                        return
                    }
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)  /// Decode the file’s available data into a local constant named dailyScrums.
                DispatchQueue.main.async {        ///On the main queue, pass the decoded scrums to the completion handler. You perform the longer-running tasks of opening the file and decoding its contents on a background queue. When those tasks complete, you switch back to the main queue.
                    completion(.success(dailyScrums))   /// A completion closure is used to update the store on the main queue after the background work completes.
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Create a static function named save that asynchronously returns an Int.
    ///  The save function returns a value that callers of the function may not use. The @discardableResult attribute disables warnings about the unused return value.
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .success(let scrumsSaved):
                        continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    
    /// Add a save method at the bottom of the file.
    /// This method accepts a completion handler that accepts either the number of saved scrums or an error.
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}
