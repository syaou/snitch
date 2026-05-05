# Snitch

An accountability app for friends.

**GitHub repo:** https://github.com/syaou/snitch

## What is Snitch?

Snitch is a fun and interactive app which is aimed at keeping you and your friends on track with your goals! The goals can be anything, from gym, study, sleep, screen time or whatever you have set out to complete for yourself. You set a goal, post a photo as proof you did it, and your friends can cheer you on, leave a comment, or call you out by flagging proof that looks dodgy. A leaderboard shows who is staying the most consistent as motivation

## The problem we are solving

Most habit tracker apps are solo as most individuals keep their goals locked away. Relying on you being honest with yourself, and most people quietly give up after a small amount of time. Even if you do discuss goals with a friend, they stay in the chat history and scroll up and away. The is no easy way to track who actually did the thing.

Snitch combines the social pressure of a group chat with the visual proof of a photo app and the structure of a habit tracker, all in one place.

## Target audience

Our audience isn't set to one stict age group. It can be a family bonding activity where you've all set to accomplish a goal (or get chores done...) or to young adults who already share things with their friend group online and want a fun way to stay accountable without nagging each other in DMs. 

Think uni students keeping gym streaks, study sessions, sleep schedules, or no phone time.

The app is built so it would still suit older users so everybody is welcome!

## Snitch's Features

Goals + photo proof + friend group + leaderboard + flagging + more

## Features in the current MVP

- Set personal or shared goals
- Upload a photo as proof you completed a goal
- Friends list (sample data for now, no backend)
- Feed of recent proof posts from your friends
- Comment on a friend's proof
- Flag a proof that looks dishonest
- Leaderboard ranking friends by consistency
- Profile screen with your stats

More features are still being brainstormed.

## iOS frameworks and tools we are using

This is a beginner subject so we have chosen frameworks that are achievable in the assignment time frame and that each map to a clear feature in the app.

| Framework | What it is used for |
| --- | --- |
| **SwiftUI** | The whole user interface, navigation and layout |
| **PhotosUI** | Letting users pick a proof photo from their library using `PhotosPicker` |
| **UserNotifications** | Local reminders, for example "post your proof by 8 pm tonight" |
| **SwiftData** | Saving goals and proof posts so they survive closing the app |
| **UserDefaults** | Small per user settings such as display name and current streak |
| **Combine** (light usage) | Powering `@Published` view model updates so the UI refreshes automatically |

We deliberately avoided things that need a backend server (CloudKit, Firebase, real friend syncing) because the brief says no backend is required and they would not be realistic to build in a beginner subject.

## Architecture

Snitch follows the **MVVM** pattern (Model, View, ViewModel). Each folder has a single job:

```
Snitch/
├── Snitch/             App entry point and main tab navigation
├── Models/             Plain data types (Goal, ProofPost, UserProfile, Comment, LeaderboardUser)
├── ViewModels/         The logic layer that prepares data for each screen
├── Views/              The screens (Feed, Goals, Leaderboard, Profile, Upload Proof, etc.)
├── Components/         Small reusable UI pieces (cards, rows)
├── Helpers/            Shared bits (colours, sample data)
└── Snitch.xcodeproj/   The Xcode project file
```

The point of MVVM is that each screen does not have to know how the data is stored or where it came from. That makes it easier for two of us to work on different screens without breaking each other's code.

## How to run the app

1. Make sure you have **Xcode 15 or later** installed (needed for SwiftData).
2. Clone the repo:
   ```
   git clone https://github.com/syaou/snitch.git
   ```
3. Open `Snitch.xcodeproj` in Xcode.
4. Pick an iPhone simulator from the toolbar (for example iPhone 15).
5. Press the play button (or `Cmd + R`) to build and run.

## Team

| Name | Student ID |
| --- | --- |
| Sana Yousefi | 24963338 |
| Natalie Michael | 24817761 |

Subject: iOS App Development, UTS.
Assessment: Group Project (Assessment Task 3).

## Project status

This is a work in progress. Sana built the initial UI structure (tabs, feed, goals, leaderboard, profile, upload, friends, flagging, comments). Natalie is working on repository setup, persistence with SwiftData, and notifications. More features and polish to follow as we iterate towards the final demo. 
