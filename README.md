I have completed the development of a fully fledged 4x MMO mobile strategy game that I have been working on since 2013. I have spend the last 4 years of my life in sweat, money, energy into completing this game and I hope you enjoy it.
For those of you wondering what a 4x mobile game is, this article is a good read explaining what it is and why it's awesome: https://bothgunsblazingblog.wordpress.com/2016/12/14/game-of-war-4x-games-and-the-future-of-mobile-mid-core/?

Here are my goals I have in mind for open sourcing this game:
1) Community driven game, where everyone can decide what features to add
2) Potential to spawn multiple variations of the game, with interesting themes such as post apocalypse, scifi, space explorations etc..
3) Me and the contributors could provide custom development, support and hosting of the game backends.

The game I have developed is close to Game of War and Mobile Strike. These games are top grossing and rake in on average 1 Million USD a day! It also has a multi city management system which is lacking in these games.

Mobile Strike:
http://www.mobilestrikeapp.com/

Game of War:
http://www.gameofwarapp.com/

Client Side pod’s:
  pod 'Helpshift'
  pod 'SSZipArchive'
  pod 'OBShapedButton'
  pod 'SignalR-ObjC'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'GA-SDK-IOS'

Server Side Requirements:
1) Windows machine running IIS
2) SQL Server
3) Hangfire
4) SignalR

All test cases for the game is in the TestCases folder.

Installation on server is simple, just execute bot sql scripts under the ServerSide folder. This will create the 2 db’s needed to run the game. All the tables and stored procedures will be created. Next drop both the kingdom and kingdom_world1 folders into your wwwroot and create an its app. In Xcode do a search for yourdomain.com and change it to your registered domain name or ip address linking to your IIS server.

Feel free to contact me if you need help setting up the server. Contact me at shankqr@gmail.com
