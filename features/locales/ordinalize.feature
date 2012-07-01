Feature: Converting numbers to ordinals using CSL Locales
	In order to support the requirements of CSL styles that use ordinals
  As a hacker of CSL styles
  I want to be able to convert numbers to ordinals

	@v1.0 @locale @ordinalize @i18n
  Scenario: Using English CSL 1.0 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0" xml:lang="en">
        <terms>
          <term name="ordinal-01">st</term>
          <term name="ordinal-02">nd</term>
          <term name="ordinal-03">rd</term>
          <term name="ordinal-04">th</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
		  | 1     |
		  | 2     |
		  | 3     |
		  | 4     |
		  | 5     |
		  | 10    |
		  | 11    |
		  | 12    |
		  | 13    |
		  | 20    |
		  | 21    |
		  | 22    |
		  | 23    |
		  | 111   |
		  | 112   |
		  | 113   |
		Then the ordinals should be:
		  | 1st   |
		  | 2nd   |
		  | 3rd   |
		  | 4th   |
		  | 5th   |
		  | 10th  |
		  | 11th  |
		  | 12th  |
		  | 13th  |
		  | 20th  |
		  | 21st  |
		  | 22nd  |
		  | 23rd  |
		  | 111th |
		  | 112th |
		  | 113th |
