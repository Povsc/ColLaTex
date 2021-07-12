Original App Design Project
===

# ColLaTeX

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
The app serves primarily as a $\LaTeX$ editor on the go. More importantly, the app aims to be a collaborative editor, allowing multiple users to edit the same document simultaneously and compile it independently.

### App Evaluation
- **Category:** Utilities/Productivity
- **Mobile:** Options for comprehensive, mobile $\TeX$ editors are scarce; moreover, I have not found a collaborative editor that has a dedicated app (e.g. OverLeaf only works through the browser). This idea is intrinsically mobile because it aims to offer a on-the-go, real-time editing experience.
- **Story:** The app, once completed, will be attractive only to a niche population. However, to regular $\LaTeX$ users, it will serve as a good option when they don't have access to a computer.
- **Market:** Again, the target audience is somewhat niche and well defined. What the app offers should be clear to that audience.
- **Habit:** The app will not be very addictive, but there may be a subset of users who might constantly use the app. The average user creates and shares documents through the app.
- **Scope:** The app should not be difficult to finish if not all features are implemented, but offering the full set of tools within 5 weeks may be a little challenging. However, a stripped down version of the app is still interesting.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register a new account
* User can log in/out
* User can create a new document
* User can share an existing document
* User can be invited to 'join' an existing document
* User can navigate through the documents they have access to through a home screen
* Different users can edit a single document (independently)
* User can create a new PDF file with their code
    * User can export the PDF file

**Optional Nice-to-have Stories**

* The app has some basic auto-complete features
* Users can simultaneously edit text
* The editor provides a specialized keyboard (e.g. \\ , { , and } should be in the main keyboard)
* User can select different themes (e.g. dark mode, etc.)
* User can choose to split their editor's screen to display the uncomplied and compiled documents simultaneously
* User can change a document's sharing settings (i.e. view only, etc.)
* User can edit their profile
* Global feed
* User can search for documents

### 2. Screen Archetypes

* Login 
    * User can log in
* Register
   * User can register a new account
* Stream
    * User can navigate through the documents they have access to through a home screen
* Detail
    * User can create a new document
    * User can be invited to 'join' an existing document
    * User can (independently) compile/view compiled document
* Create 
    * Users can simultaneously edit text
* Settings 
    * User can share an existing document

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* My documents
* Shared with me
* (optional) Profile

**Flow Navigation** (Screen to Screen)

* Forced Log-in 
    * Account creation if no log in is available
* My documents
    * Open existing document
        * Document editing
            * View compiled document
    * Create new document
        * Document creation
            * View compiled document
    * Share existing document
* Shared with me
    * Open existing document
        * Document editing
            * View compiled document
* Porfile settings

## Wireframes
![202107071210131000](https://user-images.githubusercontent.com/73599216/124794199-c3ae7200-df1c-11eb-936c-13f54a682cb9.jpg)


<!-- ### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype
 -->
## Schema 
### Models
#### User

   | Property        | Type     | Description |
   | -------------   | -------- | ------------|
   | objectId        | String   | unique id for the user (default field) |
   | name            | String   | username of user |
   | password        | String   | user's hashed password |
   | profilePicture  | File     | user's profile image |
   | sharedDocuments | Array    | contains pointers to document objects shared with the user |
#### Document

   | Property        | Type     | Description |
   | -------------   | -------- | ------------|
   | objectId        | String   | unique id for the document (default field) |
   | name            | String   | username of user |
   | attachments     | Array    | contains File objects to be included in the document |
   | content         | String   | uncompiled tex (i.e. plain text) |
   | owner           | Pointer  | pointer to user object |
   | sharedWith      | Array    | contains pointers to user objects who can access and edit the file |
   | createdAt       | DateTime | date when post is created (default field) |
   | updatedAt       | DateTime | date when post is last updated (default field) |
### Networking
#### List of network requests by screen
   - My Documents
      - (Read/GET) Query all documents where user is owner
         ```objective-c
         PFQuery *documentQuery = [Document query];
         [documentQuery whereKey:@"owner" equalsTo: currentUser];
         [documentQuery orderByDescending:@"updatedAt"];
         [documentQuery includeKey:@""];
         documentQuery.limit = 20;

         [documentQuery findObjectsInBackgroundWithBlock:^(NSArray<Document *> * _Nullable documents, NSError * _Nullable error) {
            if (posts) {
                  self.arrayOfDocuments = [documents mutableCopy];
            }
            else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
         ```
   - Document Creation Screen
      - (Create/POST) Create new document
   - Shared with Me
      - (Read/GET) Query all documents shared with user
   - Edit Document
      - (Read/GET) Query document's content
      - (Update/PUT) Update document's content
   - Document Settings Page
      - (Read/GET) Query document's data
      - (Updated/PUT) Update document's data
   - Profile Page
      - (Read/GET) Query user's information
      - (Update/PUT) Update user's information
#### [OPTIONAL:] Existing API Endpoints
##### LaTeX Online
- Base URL - [https://latexonline.cc](https://latexonline.cc)

   HTTP Verb | Endpoint | Parameters | Description
   ----------|----------|------------|-------------------
    `GET`    | /compile | ?text=     | compiled PDF file
