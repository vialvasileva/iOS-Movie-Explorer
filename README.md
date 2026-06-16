Ссылка на видео-пример: https://disk.yandex.ru/d/1lgwcywhJBRdGg

# Movie Explorer

Movie Explorer is an iOS application built with **UIKit** and **SwiftUI** that allows users to browse, search, and save movies using the **OMDb API**.

## Features

* Browse movies by categories
* Search movies by title
* View detailed movie information
* Save favorite movies locally
* Image caching for faster loading
* Animated splash screen
* Profile screen with favorites statistics
* Dark Mode support

## Technologies

* Swift
* UIKit
* SwiftUI
* URLSession
* UserDefaults
* NSCache
* Auto Layout
* Async/Await

## API

This project uses the OMDb API:

* Website: [OMDb API](https://www.omdbapi.com/)

## Configuration

Create an `.xcconfig` file (for example `Secrets.xcconfig`):

```text
OMDB_API_KEY=YOUR_API_KEY
```

Add it to your Xcode project configuration and make sure it is excluded from version control.

## Favorites

Favorite movies are stored locally using `UserDefaults`.

## Requirements

* iOS 16+
* Xcode 15+
* Swift 5.9+

## Screens

* Splash
* Home
* Search
* Favorites
* Profile
* Movie Details
