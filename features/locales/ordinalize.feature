Feature: Converting numbers to ordinals using CSL locales
  In order to support the requirements of CSL styles that use ordinals
  As a hacker of CSL styles
  I want to be able to convert numbers to ordinals

  @v1.0 @locale @ordinals @i18n @lang:en
  Scenario: English CSL 1.0 locales
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
      | number |
      | 0      |
      | 1      |
      | 2      |
      | 3      |
      | 4      |
      | 5      |
      | 10     |
      | 11     |
      | 12     |
      | 13     |
      | 20     |
      | 21     |
      | 22     |
      | 23     |
      | 111    |
      | 112    |
      | 113    |
      | -102   |
    Then the ordinals should be:
      | ordinal |
      | 0th     |
      | 1st     |
      | 2nd     |
      | 3rd     |
      | 4th     |
      | 5th     |
      | 10th    |
      | 11th    |
      | 12th    |
      | 13th    |
      | 20th    |
      | 21st    |
      | 22nd    |
      | 23rd    |
      | 111th   |
      | 112th   |
      | 113th   |
      | -102nd  |

  @v1.0.1 @locale @ordinals @i18n @lang:en
  Scenario: English CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="en">
        <terms>
          <term name="ordinal-00">th</term>
          <term name="ordinal-01">st</term>
          <term name="ordinal-02">nd</term>
          <term name="ordinal-03">rd</term>
          <term name="ordinal-11">th</term>
          <term name="ordinal-12">th</term>
          <term name="ordinal-13">th</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | number |
      | 0      |
      | 1      |
      | 2      |
      | 3      |
      | 4      |
      | 5      |
      | 10     |
      | 11     |
      | 12     |
      | 13     |
      | 20     |
      | 21     |
      | 22     |
      | 23     |
      | 111    |
      | 112    |
      | 113    |
      | -102   |
    Then the ordinals should be:
      | ordinal |
      | 0th     |
      | 1st     |
      | 2nd     |
      | 3rd     |
      | 4th     |
      | 5th     |
      | 10th    |
      | 11th    |
      | 12th    |
      | 13th    |
      | 20th    |
      | 21st    |
      | 22nd    |
      | 23rd    |
      | 111th   |
      | 112th   |
      | 113th   |
      | -102nd  |

  @v1.0.1 @locale @ordinals @i18n @gender @lang:de
  Scenario: Gendered German CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="de">
        <terms>
          <term name="ordinal-00">.</term>
          <term name="long-ordinal-01">erstes</term>
          <term name="long-ordinal-01" gender-form="feminine">erste</term>
          <term name="long-ordinal-01" gender-form="masculine">erster</term>
          <term name="long-ordinal-02">zweites</term>
          <term name="long-ordinal-02" gender-form="feminine">zweite</term>
          <term name="long-ordinal-02" gender-form="masculine">zweiter</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    |
      | 0     |       |           |
      | 1     |       |           |
      | 2     |       |           |
      | 3     |       |           |
      | 101   |       |           |
      | 1     | long  |           |
      | 2     | long  |           |
      | 3     | long  |           |
      | 1     | long  | feminine  |
      | 2     | long  | feminine  |
      | 3     | long  | feminine  |
      | 1     | long  | masculine |
      | 2     | long  | masculine |
      | 3     | long  | masculine |      
    Then the ordinals should be:
      | ordinal |
      | 0.      |
      | 1.      |
      | 2.      |
      | 3.      |
      | 101.    |
      | erstes  |
      | zweites |
      | 3.      |
      | erste   |
      | zweite  |
      | 3.      |
      | erster  |
      | zweiter |
      | 3.      |

  @v1.0.1 @locale @ordinals @i18n @gender @lang:fr
  Scenario: Gendered French CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="de">
        <terms>
          <term name="ordinal-00">e</term>
          <term name="ordinal-01">e</term>
          <term name="ordinal-01" gender-form="feminine">ère</term>
          <term name="ordinal-01" gender-form="masculine">er</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    |
      | 0     |       |           |
      | 1     |       |           |
      | 1     |       | feminine  |
      | 1     |       | masculine |
      | 1     |       | neutral   |
      | 2     |       |           |
      | 3     |       |           |
      | 999   |       |           |
      | 11    |       |           |
      | 21    |       |           |
      | 101   |       |           |
      | 1001  |       |           |
      | 301   |       |           |
    Then the ordinals should be:
      | ordinal |
      | 0e      |
      | 1e      |
      | 1ère    |
      | 1er     |
      | 1e      |
      | 2e      |
      | 3e      |
      | 999e    |
      | 11e     |
      | 21e     |
      | 101e    |
      | 1001e   |
      | 301e    |
