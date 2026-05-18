
# Drive Me | Carsharing 🚗
 A modern, native iOS carsharing platform with an administration panel, built entirely with SwiftUI and Supabase.
 <img width="200" alt="DriveMeImg" src="https://github.com/user-attachments/assets/897d0a5d-2431-40b7-a1c1-3d0a52166b77" />


![iOS](https://img.shields.io/badge/iOS-26.0+-blue)
![Swift](https://img.shields.io/badge/Swift-6.0-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-green)
![Supabase](https://img.shields.io/badge/Supabase-Database-47C279)


## 📱 App Gallery

<table align="center">
  <tr>
    <td align="center"><b>Client: Car Explorer</b></td>
    <td align="center"><b>Client: Interactive Map</b></td>
    <td align="center"><b>Сlient: Search by Date</b></td>
    <td align="center"><b>Client: My Bookings </b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/28aa7cef-d8d8-4f39-9995-0c102c12c713" width="220" alt="Client Car List"/></td>
    <td><img src="https://github.com/user-attachments/assets/b3e85c72-3b1c-4f19-8b0c-e1c540b545dc" width="220" alt="Client Map"/></td>
    <td><img src="https://github.com/user-attachments/assets/ac7c41ff-a778-4793-9d70-53b3f75ff2c9" width="220" alt="Admin Dashboard"/></td>
    <td><img src="https://github.com/user-attachments/assets/e6f2a36f-686c-463e-a9b2-55f53587476e" width="220" alt="Admin Map Configuration"/></td>
  </tr>

  <tr>
    <td align="center"><b>Admin: Request Managing</b></td>
    <td align="center"><b>Admin: Location Adding</b></td>
    <td align="center"><b>Admin: Fleet Dashboard</b></td>
    <td align="center"><b>Admin: Adding Car to Fleet</b></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/72f00291-5a1c-4b58-b679-7e67b8dfb8c9" width="220" alt="Client Car List"/></td>
    <td><img src="https://github.com/user-attachments/assets/12d42df3-ea19-4fbb-a252-660509c08ab0" width="220" alt="Client Map"/></td>
    <td><img src="https://github.com/user-attachments/assets/1abdfa36-b4ec-4a8b-a3f5-d1e15a516749" width="220" alt="Admin Dashboard"/></td>
    <td><img src="https://github.com/user-attachments/assets/84935e4c-72d9-445b-bc4b-64574133e52b" width="220" alt="Admin Map Configuration"/></td>
  </tr>
</table>

## 🎥 Full Video Walkthrough
### Client 
<div>
  <a href="https://youtu.be/sFWXtmEY3Pk">
    <img src="https://img.youtube.com/vi/sFWXtmEY3Pk/maxresdefault.jpg" width="500" alt="Drive Me Video Demo">
  </a>
</div>

### Admin 
<div>
  <a href="https://youtu.be/R37m2jU5R8I">
    <img src="https://img.youtube.com/vi/R37m2jU5R8I/maxresdefault.jpg" width="500" alt="Drive Me Video Demo">
  </a>
</div>

## 📖 Overview

Drive Me is a full-featured carsharing application designed to provide a seamless vehicle rental experience. The project consists of a unified iOS app that intelligently serves two types of users:

**Clients:** Browse available cars, view rental zones on an interactive map, and manage bookings.

**Administrators:** A powerful, dedicated dashboard to manage the fleet, configure map locations, and process rental requests in real-time.

## ✨ Features

### 👤 Client Panel
* **Modern Car List:** See available cars for rent, explore their transmission type, endgine, pricing. Check dates car is available for you.

* **Interactive Map:** Browse available locations for Pickup and Drop-off and allowed driving zones using MapKit.

* **Detailed Date Picker:** High-quality date picker where you can see available cars for selected dates or car's free dates.

* **Booking System:** Seamless rental request flow with real-time status updates.

### 🛡️ Admin Dashboard
* **Fleet Management:** Add, edit, or remove vehicles. Toggle car availability instantly.
* **Map Configuration:** Set up "Pickup & Drop-off" or "Drop-off Only" locations using interactive reverse geocoding directly on the map.
* **Request Handling:** Monitor and process incoming rental requests (Approve/Decline).
* **Photo Editor:** Upload and manage vehicle images with dynamic caching.

## 🛠️ Tech Stack

* **UI Framework:** SwiftUI
* **Architecture:** MVVM (Model-View-ViewModel)
* **Maps:** MapKit ( New IOS updates, including `MapCameraPosition`, `UserAnnotation` and `MKReverseGeocodingRequest`.)
* **Backend & Database:** [Supabase](https://supabase.com/) (PostgreSQL)
* **Storage:** Supabase Storage (Vehicle bucket)
* **Concurrency:** Swift Concurrency (`async`/`await`)
* **Dependencies:** BetterSwiftUITextEditor

## 🚀 Getting Started

Follow these steps to build and run the project locally.

### Requirements
* Xcode 16.0 or later
* iOS 26.0+ Simulator or physical device
* A [Supabase](https://supabase.com/) account

### 1. Database Setup
To replicate the backend environment, you need to set up the database using the provided schema.
1. Create a new project in Supabase.
2. Go to the SQL Editor in your Supabase dashboard.
3. Open the `schema.sql` file located in the root of this repository, copy its contents, and run it in the SQL Editor. This will create all necessary tables and RLS policies.
4. After running an app and registration some email, go to your Supabase -> Table Editor -> schema.public profiles -> change role from `client` to `admin` to see the Admin Panel features.і

### 2. Configure Secrets
For security reasons, API keys are not included in this repository.
1. Locate the `Secrets-Template.swift` file in the project directory.
2. Rename the file to `Secrets.swift`.
3. Open the file and replace the placeholder strings with your actual Supabase URL and Anon Key (found in Supabase Project Settings -> API).

```swift
// Secrets.swift
import Foundation

enum Secrets_Template {
    static let supabaseURL = "YOUR_SUPABASE_URL_HERE"
    static let supabaseKey = "YOUR_SUPABASE_ANON_KEY_HERE"
}
```
### 3. Build and Run
1. Open `Drive Me.xcodeproj` in Xcode
2. Let the SPM resolve dependencies
3. Select an iOS 26.0+ simulator or your connected iPhone.
4. Hit `Cmd + R` to build and run the application.

## 🗂️ Supabase Architecture
<img width="600" height="400" alt="supabase-schema-lwbygkdwscthfqnkkmnl" src="https://github.com/user-attachments/assets/04bb124c-3256-4bf7-8103-9c89ffaff5df" />

## 👨‍💻 Author
**Paul Bovtach** *iOS Software Engineer*
📫 **Let's connect:**
* [LinkedIn](https://www.linkedin.com/in/pavlo-bovtach-458a3225a/)
* [Email](mailto:natanbov@gmail.com)

