Feature: Converting numbers to ordinals using CSL locales
  In order to support the requirements of CSL styles that use ordinals
  As a hacker of CSL styles
  I want to be able to convert numbers to ordinals

  @v1.0 @locale @ordinals @i18n @lang-en
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

  @v1.0.1 @locale @ordinals @i18n @lang-en
  Scenario: English CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="en">
        <terms>
          <term name="ordinal">th</term>
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
      | num    | form  | gender    | number   |
      | 0      |       |           |          |
      | 1      |       |           |          |
      | 2      |       |           |          |
      | 3      |       |           |          |
      | 4      |       |           |          |
      | 5      |       |           |          |
      | 10     |       |           |          |
      | 11     |       |           |          |
      | 12     |       |           |          |
      | 13     |       |           |          |
      | 20     |       |           |          |
      | 21     |       |           |          |
      | 22     |       |           |          |
      | 23     |       |           |          |
      | 111    |       |           |          |
      | 112    |       |           |          |
      | 113    |       |           |          |
      | -102   |       |           |          |
      | 1      |       | masculine |          |
      | 2      |       | feminine  |          |
      | 3      |       |           | plural   |
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
      | 1st     |
      | 2nd     |
      | 3rd     |

  @v1.0.1 @locale @ordinals @i18n @gender @lang-de
  Scenario: Gendered German CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="de">
        <terms>
          <term name="ordinal">.</term>

          <term name="long-ordinal-01">erstes</term>
          <term name="long-ordinal-01" gender-form="feminine">
            <single>erste</single>
            <multiple>ersten</multiple>
          </term>
          <term name="long-ordinal-01" gender-form="masculine">
            <single>erster</single>
            <multiple>ersten</multiple>
          </term>
          <term name="long-ordinal-02">zweites</term>
          <term name="long-ordinal-02" gender-form="feminine">zweite</term>
          <term name="long-ordinal-02" gender-form="masculine">zweiter</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    | number   |
      | 0     |       |           |          |
      | 1     |       |           |          |
      | 2     |       |           |          |
      | 3     |       |           |          |
      | 101   |       |           |          |
      | 1     | long  |           |          |
      | 2     | long  |           |          |
      | 3     | long  |           |          |
      | 1     | long  | feminine  |          |
      | 1     | long  | feminine  | plural   |
      | 1     | long  | feminine  | singular |
      | 2     | long  | feminine  |          |
      | 3     | long  | feminine  |          |
      | 1     | long  | masculine |          |
      | 2     | long  | masculine |          |
      | 3     | long  | masculine |          |
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
      | ersten  |
      | erste   |
      | zweite  |
      | 3.      |
      | erster  |
      | zweiter |
      | 3.      |

  @v1.0.1 @locale @ordinals @i18n @gender @lang-fr
  Scenario: Gendered French CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="de">
        <terms>
          <term name="ordinal">
            <single>e</single>
            <multiple>es</multiple>
          </term>
          <term name="ordinal-01" match="whole-number">
            <single>re</single>
            <multiple>res</multiple>
          </term>
          <term name="ordinal-01" gender-form="feminine" match="whole-number">
            <single>re</single>
            <multiple>res</multiple>
          </term>
          <term name="ordinal-01" gender-form="masculine" match="whole-number">
            <single>er</single>
            <multiple>ers</multiple>
          </term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    | number   |
      | 0     |       |           |          |
      | 1     |       |           |          |
      | 1     |       | feminine  |          |
      | 1     |       | masculine |          |
      | 1     |       | neutral   |          |
      | 1     |       | feminine  | plural   |
      | 1     |       | masculine | plural   |
      | 2     |       |           |          |
      | 3     |       |           |          |
      | 3     |       |           | plural   |
      | 999   |       |           |          |
      | 11    |       |           |          |
      | 21    |       |           |          |
      | 101   |       |           |          |
      | 1001  |       |           |          |
      | 301   |       |           |          |
      | 21    |       | masculine |          |
      | 1001  |       | masculine |          |
      | 42    |       | masculine |          |
      | 42    |       | masculine | plural   |
    Then the ordinals should be:
      | ordinal |
      | 0e      |
      | 1re     |
      | 1re     |
      | 1er     |
      | 1re     |
      | 1res    |
      | 1ers    |
      | 2e      |
      | 3e      |
      | 3es     |
      | 999e    |
      | 11e     |
      | 21e     |
      | 101e    |
      | 1001e   |
      | 301e    |
      | 21e     |
      | 1001e   |
      | 42e     |
      | 42es    |

  @v1.0.1 @locale @ordinals @i18n @lang-nl
  Scenario: Dutch CSL 1.0.1 locales (nulde form)
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="nl">
        <terms>
          <term name="ordinal">ste</term>

          <term name="ordinal-00" match="whole-number">de</term>

          <term name="ordinal-02" match="last-two-digits">de</term>
          <term name="ordinal-03" match="last-two-digits">de</term>
          <term name="ordinal-04" match="last-two-digits">de</term>
          <term name="ordinal-05" match="last-two-digits">de</term>
          <term name="ordinal-06" match="last-two-digits">de</term>
          <term name="ordinal-07" match="last-two-digits">de</term>
          <term name="ordinal-09" match="last-two-digits">de</term>
          <term name="ordinal-10">de</term>
          <term name="ordinal-11">de</term>
          <term name="ordinal-12">de</term>
          <term name="ordinal-13">de</term>
          <term name="ordinal-14">de</term>
          <term name="ordinal-15">de</term>
          <term name="ordinal-16">de</term>
          <term name="ordinal-17">de</term>
          <term name="ordinal-18">de</term>
          <term name="ordinal-19">de</term>
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
      | 6      |
      | 7      |
      | 8      |
      | 9      |
      | 10     |
      | 11     |
      | 12     |
      | 13     |
      | 14     |
      | 15     |
      | 16     |
      | 17     |
      | 18     |
      | 19     |
      | 20     |
      | 21     |
      | 22     |
      | 23     |
      | 41     |
      | 52     |
      | 63     |
      | 74     |
      | 88     |
      | 99     |
      | 101    |
      | 102    |
      | 108    |
      | 111    |
      | 112    |
      | 113    |
    Then the ordinals should be:
      | ordinal |
      | 0de     |
      | 1ste    |
      | 2de     |
      | 3de     |
      | 4de     |
      | 5de     |
      | 6de     |
      | 7de     |
      | 8ste    |
      | 9de     |
      | 10de    |
      | 11de    |
      | 12de    |
      | 13de    |
      | 14de    |
      | 15de    |
      | 16de    |
      | 17de    |
      | 18de    |
      | 19de    |
      | 20ste   |
      | 21ste   |
      | 22ste   |
      | 23ste   |
      | 41ste   |
      | 52ste   |
      | 63ste   |
      | 74ste   |
      | 88ste   |
      | 99ste   |
      | 101ste  |
      | 102de   |
      | 108ste  |
      | 111de   |
      | 112de   |
      | 113de   |

  @v1.0.1 @locale @ordinals @i18n @lang-nl
  Scenario: Dutch CSL 1.0.1 locales (nulste form)
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="nl">
        <terms>
          <term name="ordinal">ste</term>

          <term name="ordinal-02" match="last-two-digits">de</term>
          <term name="ordinal-03" match="last-two-digits">de</term>
          <term name="ordinal-04" match="last-two-digits">de</term>
          <term name="ordinal-05" match="last-two-digits">de</term>
          <term name="ordinal-06" match="last-two-digits">de</term>
          <term name="ordinal-07" match="last-two-digits">de</term>
          <term name="ordinal-09" match="last-two-digits">de</term>
          <term name="ordinal-10">de</term>
          <term name="ordinal-11">de</term>
          <term name="ordinal-12">de</term>
          <term name="ordinal-13">de</term>
          <term name="ordinal-14">de</term>
          <term name="ordinal-15">de</term>
          <term name="ordinal-16">de</term>
          <term name="ordinal-17">de</term>
          <term name="ordinal-18">de</term>
          <term name="ordinal-19">de</term>
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
      | 6      |
      | 7      |
      | 8      |
      | 9      |
      | 10     |
      | 11     |
      | 12     |
      | 13     |
      | 14     |
      | 15     |
      | 16     |
      | 17     |
      | 18     |
      | 19     |
      | 20     |
      | 21     |
      | 22     |
      | 23     |
      | 41     |
      | 52     |
      | 63     |
      | 74     |
      | 88     |
      | 99     |
      | 101    |
      | 102    |
      | 108    |
      | 111    |
      | 112    |
      | 113    |
      | 142    |
      | 163    |
      | 1216   |
      | 919    |
      | 379    |
      | 420    |
    Then the ordinals should be:
      | ordinal |
      | 0ste    |
      | 1ste    |
      | 2de     |
      | 3de     |
      | 4de     |
      | 5de     |
      | 6de     |
      | 7de     |
      | 8ste    |
      | 9de     |
      | 10de    |
      | 11de    |
      | 12de    |
      | 13de    |
      | 14de    |
      | 15de    |
      | 16de    |
      | 17de    |
      | 18de    |
      | 19de    |
      | 20ste   |
      | 21ste   |
      | 22ste   |
      | 23ste   |
      | 41ste   |
      | 52ste   |
      | 63ste   |
      | 74ste   |
      | 88ste   |
      | 99ste   |
      | 101ste  |
      | 102de   |
      | 108ste  |
      | 111de   |
      | 112de   |
      | 113de   |
      | 142ste  |
      | 163ste  |
      | 1216de  |
      | 919de   |
      | 379ste  |
      | 420ste  |

  @v1.0.1 @locale @ordinals @i18n @gender @lang-es
  Scenario: Gendered Spanish CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="es">
        <terms>
          <term name="ordinal">.º</term>
          <term name="ordinal" gender-form="masculine">.º</term>
          <term name="ordinal" gender-form="feminine">.ª</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    | number   |
      | 0     |       |           |          |
      | 1     |       |           |          |
      | 2     |       |           |          |
      | 3     |       |           |          |
      | 4     |       |           |          |
      | 5     |       |           |          |
      | 6     |       |           |          |
      | 7     |       |           |          |
      | 8     |       |           |          |
      | 9     |       |           |          |
      | 10    |       |           |          |
      | 1     |       | feminine  |          |
      | 1     |       | masculine |          |
      | 1     |       | masculine | singular |
      | 1     |       | masculine | plural   |
      | 3     |       | feminine  |          |
      | 3     |       | masculine |          |
      | 2     |       | feminine  |          |
      | 23    |       |           |          |
      | 999   |       |           |          |
      | 11    |       |           |          |
      | 11    |       | feminine  |          |
      | 11    |       | masculine |          |
      | 21    |       |           |          |
      | 101   |       |           |          |
      | 1001  |       | feminine  |          |
      | 301   |       |           |          |
      | 21    |       | masculine | singular |
      | 21    |       | masculine | plural   |
      | 1001  |       | masculine |          |
    Then the ordinals should be:
      | ordinal |
      | 0.º     |
      | 1.º     |
      | 2.º     |
      | 3.º     |
      | 4.º     |
      | 5.º     |
      | 6.º     |
      | 7.º     |
      | 8.º     |
      | 9.º     |
      | 10.º    |
      | 1.ª     |
      | 1.º     |
      | 1.º     |
      | 1.º     |
      | 3.ª     |
      | 3.º     |
      | 2.ª     |
      | 23.º    |
      | 999.º   |
      | 11.º    |
      | 11.ª    |
      | 11.º    |
      | 21.º    |
      | 101.º   |
      | 1001.ª  |
      | 301.º   |
      | 21.º    |
      | 21.º    |
      | 1001.º  |


  @v1.0.1 @locale @ordinals @i18n @gender @lang-it
  Scenario: Gendered Italian CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="it">
        <terms>
          <term name="ordinal">º</term>
          <term name="ordinal" gender-form="masculine">º</term>
          <term name="ordinal" gender-form="feminine">ª</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    | number   |
      | 0     |       |           |          |
      | 1     |       |           |          |
      | 2     |       |           |          |
      | 3     |       |           |          |
      | 4     |       |           |          |
      | 5     |       |           |          |
      | 6     |       |           |          |
      | 7     |       |           |          |
      | 8     |       |           |          |
      | 9     |       |           |          |
      | 10    |       |           |          |
      | 1     |       | feminine  |          |
      | 1     |       | masculine |          |
      | 1     |       | masculine | singular |
      | 1     |       | masculine | plural   |
      | 3     |       | feminine  |          |
      | 3     |       | masculine |          |
      | 2     |       | feminine  |          |
      | 23    |       |           |          |
      | 999   |       |           |          |
      | 11    |       |           |          |
      | 11    |       | feminine  |          |
      | 11    |       | masculine |          |
      | 21    |       |           |          |
      | 101   |       |           |          |
      | 1001  |       | feminine  |          |
      | 301   |       |           |          |
      | 21    |       | masculine | singular |
      | 21    |       | masculine | plural   |
      | 1001  |       | masculine |          |
    Then the ordinals should be:
      | ordinal |
      | 0º      |
      | 1º      |
      | 2º      |
      | 3º      |
      | 4º      |
      | 5º      |
      | 6º      |
      | 7º      |
      | 8º      |
      | 9º      |
      | 10º     |
      | 1ª      |
      | 1º      |
      | 1º      |
      | 1º      |
      | 3ª      |
      | 3º      |
      | 2ª      |
      | 23º     |
      | 999º    |
      | 11º     |
      | 11ª     |
      | 11º     |
      | 21º     |
      | 101º    |
      | 1001ª   |
      | 301º    |
      | 21º     |
      | 21º     |
      | 1001º   |

  @v1.0.1 @locale @ordinals @i18n @gender @lang-se
  Scenario: Gendered Swedish CSL 1.0.1 locales
    Given the locale:
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="se">
        <terms>
        <term name="ordinal">:e</term>
        <term name="ordinal-01">:a</term>
        <term name="ordinal-02">:a</term>
        <term name="ordinal-11">:e</term>
        <term name="ordinal-12">:e</term>

          <term name="long-ordinal-01">första</term>
          <term name="long-ordinal-01" gender-form="masculine">förste</term>
          <term name="long-ordinal-02">andra</term>
          <term name="long-ordinal-02" gender-form="masculine">andre</term>
        </terms>
      </locale>
      """
    When I ordinalize these numbers:
      | num   | form  | gender    | number   |
      | 1     |       |           |          |
      | 2     |       |           |          |
      | 3     |       |           |          |
      | 4     |       |           |          |
      | 5     |       |           |          |
      | 6     |       |           |          |
      | 7     |       |           |          |
      | 8     |       |           |          |
      | 9     |       |           |          |
      | 10    |       |           |          |
      | 11    |       |           |          |
      | 12    |       |           |          |
      | 13    |       |           |          |
      | 21    |       |           |          |
      | 22    |       |           |          |
      | 101   |       |           |          |
      | 102   |       |           |          |
      | 111   |       |           |          |
      | 112   |       |           |          |
      | 131   |       |           |          |
      | 132   |       |           |          |
      | 1     | long  |           |          |
      | 2     | long  |           |          |
      | 1     | long  | masculine |          |
      | 2     | long  | masculine |          |
    Then the ordinals should be:
      | ordinal |
      | 1:a     |
      | 2:a     |
      | 3:e     |
      | 4:e     |
      | 5:e     |
      | 6:e     |
      | 7:e     |
      | 8:e     |
      | 9:e     |
      | 10:e    |
      | 11:e    |
      | 12:e    |
      | 13:e    |
      | 21:a    |
      | 22:a    |
      | 101:a   |
      | 102:a   |
      | 111:e   |
      | 112:e   |
      | 131:a   |
      | 132:a   |
      | första  |
      | andra   |
      | förste  |
      | andre   |
