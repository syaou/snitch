# Snitch

An accountability app for friends.

**GitHub repo:** https://github.com/syaou/snitch

## What is Snitch?

Snitch is a fun and interactive app which is aimed at keeping you and your friends on track with your goals! The goals can be anything, from gym, study, sleep, screen time or whatever you have set out to complete for yourself. You set a goal, post a photo as proof you did it, and your friends can swipe to approve it or call you out by snitching on proof that looks dodgy. A leaderboard shows who is staying the most consistent as motivation.

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
- Swipe right to approve a proof, swipe left to snitch on it
- Group vote decides whether a proof is approved or rejected
- Leaderboard ranking friends by consistency
- Profile screen with your stats

More features are still being brainstormed.

## iOS frameworks and tools we are using

This is a beginner subject so we have chosen frameworks that are achievable in the assignment time frame and that each map to a clear feature in the app.

| Framework | What it is used for |
| --- | --- |
| **SwiftUI** | The whole user interface, navigation and layout |
| **PhotosUI** | Letting users pick a proof photo from their library using `PhotosPicker` |
| **UIKit** | `UIImagePickerController` for the camera capture flow |
| **UserDefaults** | Saving goals, proof posts, groups and user profiles between launches via JSON encoding |
| **Combine** (light usage) | Powering `@Published` view model updates so the UI refreshes automatically |

We deliberately avoided things that need a backend server (CloudKit, Firebase, real friend syncing) because the brief says no backend is required and they would not be realistic to build in a beginner subject.

## Architecture

Snitch follows the **MVVM** pattern (Model, View, ViewModel). Each folder has a single job:

```
Snitch/
├── Snitch/             App entry point and main tab navigation
├── Models/             Plain data types (Goal, ProofPost, SnitchGroup, UserProfile, ProofVote, ScoreChange, plus status enums)
├── ViewModels/         The logic layer that prepares data for each screen
├── Views/              The screens (Feed, Goals, Leaderboard, Profile, Upload Proof, etc.)
├── Components/         Small reusable UI pieces (cards, rows)
├── Helpers/            Shared bits (colours, sample data, persistence)
└── Snitch.xcodeproj/   The Xcode project file
```

The point of MVVM is that each screen does not have to know how the data is stored or where it came from. That makes it easier for two of us to work on different screens without breaking each other's code.

## How to run the app

1. Make sure you have **Xcode 26 or later** installed.
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

Sana built the initial UI structure (tabs, feed, goals, leaderboard, profile, upload, friends, flagging) and refined the scoring system. Natalie set up the repository, persistence using UserDefaults with JSON, the swipe to vote interaction on the feed, the groups feature, and a code cleanup pass for the final demo.
