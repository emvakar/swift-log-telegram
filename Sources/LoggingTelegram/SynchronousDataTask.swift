import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
import Logging
#endif

extension URLSession {
  func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    let semaphore = DispatchSemaphore(value: 0)

    let dataTask = self.dataTask(with: request) {
      data = $0
      response = $1
      error = $2
      semaphore.signal()
    }
    dataTask.resume()

    _ = semaphore.wait(timeout: .distantFuture)

    return (data, response, error)
  }
}
