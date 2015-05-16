Feature: Parse CSL localized date elements
  As a hacker of CSL styles
  I want to be able to parse CSL localized date strings

  Scenario: A text date
    When I parse the CSL string in the Locale scope
      """
      <date form="text">
        <date-part name="month" suffix=" "/>
        <date-part name="day" form="numeric-leading-zeros" suffix=", "/>
        <date-part name="year"/>
      </date>
      """
    Then the nodename should be "date"
    And the attribute "form" should be "text"
    And the node should have 3 parts
    And text? should be "true"
    And the part number 1 should have the attribute "name" set to "month"

  Scenario: A numeric date
    When I parse the CSL string in the Locale scope
      """
      <date form="numeric">
        <date-part name="month" form="numeric-leading-zeros" suffix="/"/>
        <date-part name="day" form="numeric-leading-zeros" suffix="/"/>
        <date-part name="year"/>
      </date>
      """
    Then the nodename should be "date"
    And the attribute "form" should be "numeric"
    And the node should have 3 parts
    And text? should be "false"
    And numeric? should be "true"
    And the part number 3 should have the attribute "name" set to "year"

