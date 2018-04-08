# outlook-calendar

# More potential TO-DOs

I have already mentioned some TO-DO s in the code comments which also include some bugs (search for TO-DO)

1.  I need to move all constants (strings, UX dimensions etc. to separate const files)

2.  Localization - Strings have to be localized and separate resource files have to be created for all supported languages

3.  Accessibility - Accessibility has to be built into the app, right now I just gave identifiers for a couple of elements to be used in tests

4.  Tests - This is the first time I am trying to use the UI tests and I am kind of apprehensive about its stability after some experiments.
	Over my years at Microsoft, I have seen/fixed my share of tests and I believe visual parity (comparing screenshots with a baseline) have proved
	worthy to an extent.  Trying to simulate user actions thru code have been flaky, unstable and usually caused more test bugs than product bugs.
	But this is my observation after having invested a few hours on the UI tests provided by XCode, I have written some comments in OutlookCalendarUITests.swift
	on what failed in each of my attempts to test something.  Also, the best way to test UI is to USE the product !
	
5.  I need to integrate the weather service