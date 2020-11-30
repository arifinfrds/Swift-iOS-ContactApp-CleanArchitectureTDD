//
//  GojekContactAppTests.swift
//  GojekContactAppTests
//
//  Created by Arifin Firdaus on 30/11/20.
//

import XCTest
@testable import GojekContactApp

protocol HTTPClient {
    func get(from url: URL)
}

protocol ContactService {
    func loadContacts()
}

class ContactServiceImpl: ContactService {
    private let client: HTTPClient
    private let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func loadContacts() {
        client.get(from: url)
    }
}


class GojekContactAppTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let _ = ContactServiceImpl(client: client, url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_shouldRequestWithGivenURL() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let sut = ContactServiceImpl(client: client, url: url)
        
        sut.loadContacts()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_shouldRequestWithGivenURLTwice() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let sut = ContactServiceImpl(client: client, url: url)
        
        sut.loadContacts()
        sut.loadContacts()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        
        func get(from url: URL) {
            self.requestedURLs.append(url)
        }
    }

}