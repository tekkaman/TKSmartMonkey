TKSmartMonkey
=============
TKSmartMonkey is an automation test tool for iOS&amp;OSX applications，written in objective-c。
All Code was written by tekkaxie. There're so many features of TKSmartMonkey that I can not 
cover all the these in this article. If you're interested, pull and read the code.

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
the monkey maybe will stay on that scene for a long time. If the size of the button is 10*10, the opportunity
of exiting the scene will be 10*10/320*480 = 0.0651%.
Functionality. Fox example, enumerate the entire view-hierarchy will cost 5+ seconds.
and so on ...

With so many problems, I constructed this project. TKSmartMonkey Kit resolves all the problems as mentioned above.

The major feature of TKSmartMonkey
-------------
1. The problems mentioned above all have been resolved.
1. It was written in objc which makes TKSmartMonkey really efficient.
2. You don't need add any codes into your own project, you just need inclue TKSmartMonkey source files 
into your project and compile it, and then it just works.
3. With crash log support, once your program crash, you can always get the symbolicated crash log.
4. You need not connect you device with the computer, you can test your program at any location and 
any time as you like.
5. The execution is really efficient. I will cover this topic in the section below.
6. You can see how long you program has run, even though it has crashed.

Techniques behind the scene
-------------
### 1. How to simulate UIEvent?
		1) I subclass UIEvent into SMEvent. SMEvent provides what UIEvent provides to UIViews 
		and UIViewControllers.
		2) I subclass UITouch into SMTouch. SMTouch provides what UITouch provides to UIviews
		and UIViewControllers.
		With the 2 methods mentioned above, we can simulate the event.
		
### 2. What makes TKSmartMonkey so smart?
		First I filter out the views that can be touchable right now through the vew hierarchy.
		Then I random take one the touchable views out and random simulate a actions(tap、scroll、etc)
		on it. So all the actions the TKSmartMonkey does will accurate effect on the target. It's really 
		efficient.
		
### 3. Why TKSmartMonkey so efficient?
		1) TKSmartMonkey was written in objc. Since we know objc is much more efficient than javascript. 
		We can enumerate the view hierarchy within less than 1 seconds. (generally less than 0.1 second)
		2) TKSmartMonkey is not random scratch around the entire screen. It first pick out the valid view
		(userInteraction = YES, alpha > 0, enabled = YES, frame in screen, etc ...), and then random select
		one the view to act. So TKSmartMonkey is totally different from UIAutomation Monkey.And this approach
		makes TKSmartMonkey so efficient.
		
### 4. Is TKSmartMonkey convenient?
		1) You need not plug your device into your computer. You can run TKSmartMonkey any where & any time.
		2) You never lose the symbolicated crash log. And you're free to symbolicate the crash log. 
		TKSmartMonkey do this for you.
		3) You never lose the running time. You can see the running time on the screen. And once
		your program crash, you can see the runnning time in the crash log.
		4) You can pause the TKSmartMonkey, and the start again. If really convenient to swtich
		state.
		
### 5. Why TKSmartMonkey so stable?
		1) You don't need to worry about connection stability between your device and your computer.
		2) You don't need to worry about the freeze of the your computer.
		
How to use TKSmartMonkey
-------------
1、Download the codes, copy SmartMonkey directory into your project.
2、Compile your project and run, you'll see TKSmartMonkey is running with your program.