# 4X MMO Strategy Game for iOS

I have spent 4 years of my life and a significant amount of money into completing this game and I hope you enjoy it.
For those of you wondering what a 4x strategy game is, this article is a good read explaining what it is and why it's awesome: https://bothgunsblazingblog.wordpress.com/2016/12/14/game-of-war-4x-games-and-the-future-of-mobile-mid-core/?

![1](https://user-images.githubusercontent.com/3216424/27571005-10f73774-5b35-11e7-9a84-c0b720280fc1.jpeg) ![2](https://user-images.githubusercontent.com/3216424/27571006-1127fada-5b35-11e7-9878-17f412dcc03f.jpeg) ![3](https://user-images.githubusercontent.com/3216424/27571007-115beae8-5b35-11e7-9356-fe3b9ba223a6.jpeg)

Here are my goals for open sourcing this game:

* Community driven game, where everyone can decide what features to add
* Potential to spawn multiple variations of the game, with interesting themes such as post apocalypse, sci-fi, space explorations etc..
* I could provide custom development, support and hosting of the game and the backends.

## The Game

My game is similar to Game of War and Mobile Strike. These games are top grossing on the app store’s and rake in on average 1 Million USD a day!

Mobile Strike:
http://www.mobilestrikeapp.com/

Game of War:
http://www.gameofwarapp.com/


## The Code

Client Side dependencies:

* Helpshift
* SSZipArchive
* OBShapedButton
* SignalR-ObjC
* Fabric
* Crashlytics
* GA-SDK-IOS

Server Side dependencies:

* Windows machine running IIS
* MS SQL Server
* Hangfire
* SignalR

All test cases for the game is in the TestCases folder.

## Setup

Installation on server is simple, just execute both sql scripts under the ServerSide folder. This will create all the tables and stored procedures needed to power the game. Next drop both the kingdom and kingdom_world1 folders into your wwwroot and create an IIS app. In Xcode do a search for yourdomain.com and replace it to your registered domain name or ip address linking to your server.

Feel free to contact me if you need help setting up the server.


### Contributing

Any contributions are more than welcome! If you do make improvements to it, remember to put yourself in the “Credits” page to get yourself credit.

#### Contributors

* Shankar Nathan - Programming (shankqr@gmail.com) (me)
* Shikin Himzal - Artwork and Design (shikqn@gmail.com)
* Tom Griffiths - Testing and Writing (griffithstechservices@gmail.com)


## Licence

GNU General Public License.
