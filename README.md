TKSmartMonkey
=============

TKSmartMonkey is an automation test tool for iOS&amp;OSX applications，written in objective-c。
All Code was written by tekkaxie.

What is this project used to do?
-------------
Apple provides us UIAutomation framework which we can use to test our program. In general 
we write a monkey based on the UIAutomation which act just like a monkey scratch the screen.
We use this method to test robustness of our program.

There are some problems of the method I mentioned above:

1. Inconvenience 1: We have to connect our device with the computer, only with this can 
we run the monkey to test our program.
2. Inconvenience 2: Monkey's running is relied on Instruments, we have to set up Instrument.
3. Inconvenience 3: The crash log is not symbolicated, once you lost the original .dSYM, you 
cannot symbolicate the crash log in the device.
4. Unstabitily 1: Once you disconnect the device from the computer, the testing is interrupted.
5. Unstability 2: Once your computer or Instruemnts out of response, the testing is interrupted. 
And you cannot see how long did your program has run.
6. Inefficienty 1: The UIAutomation framework is really inefficient, that this feature limits its
7. Inefficienty 2: As the result of clause 6, the monkey relied on UIAutomation is really inefficient.
Because it just act like a real monkey, and it knows nothing about you program. For example, if 
your program has run into a scene that only a small button is touchable, just think about that, 
the monkey will stay on that scene for too long. If the size of the button is 10*10, the opportunity
of exit the scene will be 10*10/320*480 = 0.0651%.
Functionality. Fox example, enumerate the entire view-hierarchy will cost 5+ seconds.
and so on ...

With so many problems, I constructed this project. TKSmartMonkey Kit resolves all the problems as mentioned above.

The major feature of TKSmartMonkey
-------------
1. The problems mentioned above all have been resolved.
1. It was written in objc which makes TKSmartMonkey really efficient.
2. You need not add any codes into your own project, you just need inclue TKSmartMonkey source files 
into your project and compile it, and then it just works.
3. With crash log support, once your program crash, you can always get the symbolicated crash log.
4. You need not connect you device with the computer, you can test your program at any location and 
any time as you like.
5. The execution is really efficient. I will cover this topic in the section below.

