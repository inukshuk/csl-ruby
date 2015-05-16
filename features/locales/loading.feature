Feature: Loading CSL Locales
  As a hacker of CSL styles
  I want to be able to parse CSL locales

  Scenario: Loading a locale from a string
    When I load the locale from the string
      """
      <?xml version="1.0" encoding="utf-8"?>
      <locale xmlns="http://purl.org/net/xbiblio/csl" version="1.0" xml:lang="de-AT">
        <style-options punctuation-in-quote="false"/>
        <date form="text">
          <date-part name="day" suffix=". "/>
          <date-part name="month" suffix=" "/>
          <date-part name="year"/>
        </date>
        <date form="numeric">
          <date-part name="day" form="numeric-leading-zeros" suffix="."/>
          <date-part name="month" form="numeric-leading-zeros" suffix="."/>
          <date-part name="year"/>
        </date>
        <terms>
          <term name="accessed">zugegriffen</term>
          <term name="and others">und andere</term>
          <term name="edition">
            <single>Auflage</single>
            <multiple>Auflagen</multiple>
          </term>
          <term name="edition" form="short">Aufl.</term>
          <term name="et-al">u. a.</term>
          <term name="forthcoming">i. E.</term>
          <term name="from">von</term>
          <term name="ibid">ebd.</term>
          <term name="in">in</term>
          <term name="presented at">gehalten auf der</term>
          <term name="reference">
            <single>Referenz</single>
            <multiple>Referenzen</multiple>
          </term>
          <term name="reference" form="short">
            <single>Ref.</single>
            <multiple>Ref.</multiple>
          </term>
          <term name="retrieved">abgerufen</term>

          <!-- LONG ROLE FORMS -->
          <term name="author">
            <single/>
            <multiple/>
          </term>
        </terms>
      </locale>
      """
    Then the language should be "de"
    And the region should be "AT"
    And the attribute "version" should be "1.0"
    And the locale should should have 14 terms
    And the plural of the term "reference" should be "Referenzen"
