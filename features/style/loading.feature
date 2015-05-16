Feature: Loading CSL Style
  As a hacker of CSL styles
  I want to be able to parse CSL styles

  Scenario: Loading a style from a string
    When I load the style from the string
      """
      <?xml version="1.0" encoding="utf-8"?>
      <style xmlns="http://purl.org/net/xbiblio/csl" class="in-text" version="1.0" demote-non-dropping-particle="never">
        <info>
          <title>American Psychological Association 6th Edition</title>
          <id>http://www.zotero.org/styles/apa</id>
          <link href="http://www.zotero.org/styles/apa" rel="self"/>
          <link href="http://owl.english.purdue.edu/owl/resource/560/01/" rel="documentation"/>
          <author>
            <name>Simon Kornblith</name>
            <email>simon@simonster.com</email>
          </author>
          <contributor>
            <name>Bruce D'Arcus</name>
          </contributor>
          <contributor>
            <name>Curtis M. Humphrey</name>
          </contributor>
          <contributor>
            <name>Richard Karnesky</name>
            <email>karnesky+zotero@gmail.com</email>
            <uri>http://arc.nucapt.northwestern.edu/Richard_Karnesky</uri>
          </contributor>
          <contributor>
            <name>Sebastian Karcher</name>
          </contributor>
          <category field="psychology"/>
          <category field="generic-base"/>
          <category citation-format="author-date"/>
          <updated>2010-01-27T20:08:03+00:00</updated>
          <rights>This work is licensed under a Creative Commons Attribution-Share Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/</rights>
        </info>
        <locale xml:lang="en">
        <terms>
          <term name="translator" form="short">
          <single>trans.</single>
          <multiple>trans.</multiple>
          </term>
        </terms>
        </locale>
      </style>
      """
    Then the info title should be "American Psychological Association 6th Edition"
    And the locale 1 should should have 1 term
    And the locale 1 language should be "en"
    And the locale 1 region should be "US"
    And the style should have 4 contributors
