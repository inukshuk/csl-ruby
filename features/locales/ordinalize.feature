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
          <term name="ordinal-01" gender-form="feminine">re</term>
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
#      | 21    |       | masculine |
#      | 1001  |       | masculine |
    Then the ordinals should be:
      | ordinal |
      | 0e      |
      | 1e      |
      | 1re     |
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
# These are currently incorrect:
#      | 21e     |
#      | 1001e   |

	@v1.0.1 @locale @ordinals @i18n @lang:nl
	Scenario: Dutch CSL 1.0.1 locales (nulde form)
	  Given the locale:
	    """
	    <?xml version="1.0" encoding="utf-8"?>
	    <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="nl">
	      <terms>
	        <term name="ordinal-00">de</term>

	        <term name="ordinal-01">ste</term>
	        <term name="ordinal-08">ste</term>

	        <term name="ordinal-11">de</term>
	        <term name="ordinal-18">de</term>

	        <term name="ordinal-20">ste</term>
	        <term name="ordinal-22">ste</term>
	        <term name="ordinal-23">ste</term>
	        <term name="ordinal-24">ste</term>
	        <term name="ordinal-25">ste</term>
	        <term name="ordinal-26">ste</term>
	        <term name="ordinal-27">ste</term>
	        <term name="ordinal-29">ste</term>

	        <term name="ordinal-30">ste</term>
	        <term name="ordinal-32">ste</term>
	        <term name="ordinal-33">ste</term>
	        <term name="ordinal-34">ste</term>
	        <term name="ordinal-35">ste</term>
	        <term name="ordinal-36">ste</term>
	        <term name="ordinal-37">ste</term>
	        <term name="ordinal-39">ste</term>

	        <term name="ordinal-40">ste</term>
	        <term name="ordinal-42">ste</term>
	        <term name="ordinal-43">ste</term>
	        <term name="ordinal-44">ste</term>
	        <term name="ordinal-45">ste</term>
	        <term name="ordinal-46">ste</term>
	        <term name="ordinal-47">ste</term>
	        <term name="ordinal-49">ste</term>

	        <term name="ordinal-50">ste</term>
	        <term name="ordinal-52">ste</term>
	        <term name="ordinal-53">ste</term>
	        <term name="ordinal-54">ste</term>
	        <term name="ordinal-55">ste</term>
	        <term name="ordinal-56">ste</term>
	        <term name="ordinal-57">ste</term>
	        <term name="ordinal-59">ste</term>

	        <term name="ordinal-60">ste</term>
	        <term name="ordinal-62">ste</term>
	        <term name="ordinal-63">ste</term>
	        <term name="ordinal-64">ste</term>
	        <term name="ordinal-65">ste</term>
	        <term name="ordinal-66">ste</term>
	        <term name="ordinal-67">ste</term>
	        <term name="ordinal-69">ste</term>

	        <term name="ordinal-70">ste</term>
	        <term name="ordinal-72">ste</term>
	        <term name="ordinal-73">ste</term>
	        <term name="ordinal-74">ste</term>
	        <term name="ordinal-75">ste</term>
	        <term name="ordinal-76">ste</term>
	        <term name="ordinal-77">ste</term>
	        <term name="ordinal-79">ste</term>

	        <term name="ordinal-80">ste</term>
	        <term name="ordinal-82">ste</term>
	        <term name="ordinal-83">ste</term>
	        <term name="ordinal-84">ste</term>
	        <term name="ordinal-85">ste</term>
	        <term name="ordinal-86">ste</term>
	        <term name="ordinal-87">ste</term>
	        <term name="ordinal-89">ste</term>

	        <term name="ordinal-90">ste</term>
	        <term name="ordinal-92">ste</term>
	        <term name="ordinal-93">ste</term>
	        <term name="ordinal-94">ste</term>
	        <term name="ordinal-95">ste</term>
	        <term name="ordinal-96">ste</term>
	        <term name="ordinal-97">ste</term>
	        <term name="ordinal-99">ste</term>
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

	@v1.0.1 @locale @ordinals @i18n @lang:nl
	Scenario: Dutch CSL 1.0.1 locales (nulste form)
	  Given the locale:
	    """
	    <?xml version="1.0" encoding="utf-8"?>
	    <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0.1" xml:lang="nl">
	      <terms>
	        <term name="ordinal-00">ste</term>

	        <term name="ordinal-01">ste</term>
	        <term name="ordinal-08">ste</term>

	        <term name="ordinal-02">de</term>
	        <term name="ordinal-03">de</term>
	        <term name="ordinal-04">de</term>
	        <term name="ordinal-05">de</term>
	        <term name="ordinal-06">de</term>
	        <term name="ordinal-07">de</term>
	        <term name="ordinal-09">de</term>

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
	
	        <term name="ordinal-22">ste</term>
	        <term name="ordinal-23">ste</term>
	        <term name="ordinal-24">ste</term>
	        <term name="ordinal-25">ste</term>
	        <term name="ordinal-26">ste</term>
	        <term name="ordinal-27">ste</term>
	        <term name="ordinal-29">ste</term>

	        <term name="ordinal-32">ste</term>
	        <term name="ordinal-33">ste</term>
	        <term name="ordinal-34">ste</term>
	        <term name="ordinal-35">ste</term>
	        <term name="ordinal-36">ste</term>
	        <term name="ordinal-37">ste</term>
	        <term name="ordinal-39">ste</term>

	        <term name="ordinal-42">ste</term>
	        <term name="ordinal-43">ste</term>
	        <term name="ordinal-44">ste</term>
	        <term name="ordinal-45">ste</term>
	        <term name="ordinal-46">ste</term>
	        <term name="ordinal-47">ste</term>
	        <term name="ordinal-49">ste</term>

	        <term name="ordinal-52">ste</term>
	        <term name="ordinal-53">ste</term>
	        <term name="ordinal-54">ste</term>
	        <term name="ordinal-55">ste</term>
	        <term name="ordinal-56">ste</term>
	        <term name="ordinal-57">ste</term>
	        <term name="ordinal-59">ste</term>

	        <term name="ordinal-62">ste</term>
	        <term name="ordinal-63">ste</term>
	        <term name="ordinal-64">ste</term>
	        <term name="ordinal-65">ste</term>
	        <term name="ordinal-66">ste</term>
	        <term name="ordinal-67">ste</term>
	        <term name="ordinal-69">ste</term>

	        <term name="ordinal-72">ste</term>
	        <term name="ordinal-73">ste</term>
	        <term name="ordinal-74">ste</term>
	        <term name="ordinal-75">ste</term>
	        <term name="ordinal-76">ste</term>
	        <term name="ordinal-77">ste</term>
	        <term name="ordinal-79">ste</term>

	        <term name="ordinal-82">ste</term>
	        <term name="ordinal-83">ste</term>
	        <term name="ordinal-84">ste</term>
	        <term name="ordinal-85">ste</term>
	        <term name="ordinal-86">ste</term>
	        <term name="ordinal-87">ste</term>
	        <term name="ordinal-89">ste</term>

	        <term name="ordinal-92">ste</term>
	        <term name="ordinal-93">ste</term>
	        <term name="ordinal-94">ste</term>
	        <term name="ordinal-95">ste</term>
	        <term name="ordinal-96">ste</term>
	        <term name="ordinal-97">ste</term>
	        <term name="ordinal-99">ste</term>
	
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
