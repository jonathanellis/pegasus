# Pegasus Installation Guide

1. Get Pegasus

	You can get Pegasus from the GitHub Repository at
		https://github.com/jonathanellis/pegasus
	
	You can either check out the live code, or see if there are any pre-packaged downloads available on the downloads page (easier for beginners).
	
	You should then have the following directory structure:
	*/Pegasus* - Contains the Pegasus source code.
	*/Sample* - Contains an example project showing how to use Pegasus and sample XML views.
	*/Documentation* - Contains documentation (like this).
	
2. Enable *libxml2* library for TouchXML

	Pegasus uses the TouchXML library to parse XML files. TouchXML utilises the *libxml2* library which you will need to add to your project before you are
	able to proceed.
	
	The following instructions apply to Xcode 4:
	
	1. Select your project (the root) on the Project Navigator (on the left hand side).

	2. In the main project, select your project under "PROJECT" and open the Build Settings tab.

	3. Search for "Header Search Paths" setting and add */usr/include/libxml2* value to it

	4. Search for “Other Linker Flags” setting and add *-lxml2* value

3. Add Pegasus classes to your project

	The easiest way to add the Pegasus files to your project is simply to drag and drop the "Pegasus" folder into the Project Navigator (left hand side in Xcode).
	
	Make sure you don't copy the root Pegasus directory, as that contains all of the sample code and documentation which isn't necessary.
	
	(You should probably opt to copy the Pegasus files into your project's directory if you haven't moved them already.)

4. Import Pegasus to your project

	At the top of the relevant class (or in your .pch file), add the line:

		#import "Pegasus.h"

	This will import all of the necessary Pegasus files into your project.

...and you're done!