# Tartanhacks Dashboard
ScottyLabs's mobile and web app for Pittsburgh's largest hackathon. Supports features for hackathon participants, admins, and sponsor representatives to organize their hackathon experience.

## Table of Contents
1. [Setup](#setup)
2. [Custom Widgets](#customw)
4. [Participant Features](#pfeatures)
5. [Admin Features](#afeatures)
6. [Sponsor Features](#sfeatures)

## Setup <a name="setup"></a>
The Tartanhacks Dashboard is a Flutter project, and is compatible with Android, iOS, and web.
### Android
- Open repository in Android Studio
- Connect physical device or open AVD
- Select device from the run menu and run
### iOS
TODO
### Web
- Open repository in Android Studio
- Select web browser from run menu and run

## Custom Widgets <a name="customw"></a>
The Tartanhacks Dashboard uses a collection of custom widgets to simplify styling and maintain consistency across the app.

### Page template widgets
Widgets that make up the "frame" of the app screen, generally common to every page

Background graphics:
- `CurvedTop` and `CurvedBottom`: `CustomPainter` widgets for use with Flutter's `CustomPaint`. Decorative gradient fill blocks with curved edges that fill either the top or bottom half of the screen. Take two colors as input for the gradient.

Top bar:
- `CurvedCorner`: `CustomPainter` widget, solid-color fill block with a curved edge in the top left corner of the screen.
- `TextLogo`: small logo + name of event, scaled to be stacked on top of `CurvedCorner`
- `MenuButton`: opens menu overlay
- `HomeButton`: returns to home screen from anywhere in the app
- `FlagPainter` and `BackFlag`: flag at the top left that navigates back to the last screen. Home/menu buttons will be hidden when this is visible and vice versa.
- `TopBar`: consolidates everything above into a single block that can be dropped into the top of any page

Menu overlay:
- `WhiteOverlay`: white overlay with gradient transparency that serves as a background for the menu overlay
- `MenuChoice`: buttons for each menu option
- `MenuOverlay`: combine `WhiteOverlay` with `MenuChoice` objects to make complete menu overlay
- `SponsorOverlay`: alternate menu for sponsors

### Functional widgets
Styled components used to build pages
- `GradBox`: main container used within the app
- `SolidButton`: main button used within the app
- `GradText`: gradient text
- `errorDialog`: simple pop up dialog containing a message and a button to close
- `LoadingScreen`: solid loading screen with logo that covers the whole page
- `LoadingOverlay`: semi-transparent white overlay with circular progress indicator that covers the page

### Color scheme
Most of the colors in the app are pulled from a centralized `ColorScheme` object, so it is easy to update with new themes. The Tartanhacks Dashboard supports switching between light and dark themes from within the app. Colors for both themes can be edited from `theme_changer.dart`

## Participant Features <a name="pfeatures"></a>
Hackathon participants can use the dashboard to manage their project, team, and schedule.

### Home
Central hub linking to every other major page.
- Hacking Time Left (`flutter_countdown_timer` library): countdown to project submission deadline
- Carousel (`carousel_slider` library): navigation to schedule, check in, leaderboard pages, as well as Discord server link and verification
- Join Team/Project Submission button: navigates to join team page if user is not in a team, navigates to project submission page if user is already in a team

### Project Submission
Participants submit their projects for judging via the in-app form. Details can be edited from the same page any time before the submission deadline. Once a project has been registered, participants can navigate to the prize submission page to select prize categories to enter their project in.

### Teams
If the user does not have a team, the teams button navigates to the team formation page. Here, they can create a new team or send join requests from a list of all registered teams.

### Check-in
Users can select check-in items from a list to self-check in with event QR codes and gain points for completion. The user's personal QR code for admin scan check-in is accessible from this page, as well as from the home screen carousel.

### Schedule
List of events in chronological order with times, locations, and links if applicable. Displays only upcoming events by default, but can be toggled to display past events.

### Profile
View personal profile card displaying information submitted during registration - this is the same profile that is visible to recruiters. Includes links to GitHub account and resume. Leaderboard nickname is editable from this page, as well as from the leaderboard page.

### Leaderboard
Displays points ranking of all hackathon participants (using leaderboard nickname), as well as the current user's own ranking. Leaderboard nickname is editable from this page, as well as from the profile page.

## Admin Features <a name="afeatures"></a>
Admins can use the dashboard to add schedule items and check participants into events.

### Create Schedule Items

### Create Check-in Items

### Scan to Check in Participants

## Sponsor Features <a name="sfeatures"></a>
Sponsors can use the dashboard to bookmark participant profiles.

### Search by Name

### Scan Participant QR Code

### View Bookmarks
