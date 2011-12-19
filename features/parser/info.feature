Feature: Parse CSL info elements
	As a hacker of CSL styles
	I want to be able to parse CSL info strings
	
	Scenario: A typical style info element
		When I parse the CSL string
			"""
			<info>
		    <title>American Medical Association</title>
		    <id>http://www.zotero.org/styles/ama</id>
		    <link href="http://www.zotero.org/styles/ama" rel="self"/>
		    <author>
		      <name>Julian Onions</name>
		      <email>julian.onions@gmail.com</email>
		    </author>
		    <category citation-format="numeric"/>
		    <category field="medicine"/>
		    <updated/>
		    <summary>The American Medical Association style as used in JAMA.</summary>
		    <link href="http://www.samford.edu/schools/pharmacy/dic/amaquickref07.pdf" rel="documentation"/>
		    <rights>This work is licensed under a Creative Commons Attribution-Share Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/</rights>
		  </info>
			"""
		Then the nodename should be "info"
		And the title should be "American Medical Association"
		And the author name should be "Julian Onions"
		And the author email should be "julian.onions@gmail.com"
