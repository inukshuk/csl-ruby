Feature: Parse CSL localized terms
  As a hacker of CSL styles
  I want to be able to parse CSL localized terms

  Scenario: A few standard terms
    When I parse the CSL string
      """
      <terms>
        <term name="accessed">accessed</term>
        <term name="and">and</term>
        <term name="and others">and others</term>
        <term name="anonymous">anonymous</term>
        <term name="anonymous" form="short">anon.</term>
        <term name="circa">circa</term>
        <term name="circa" form="short">c.</term>
        <term name="cited">cited</term>
        <term name="edition">
          <single>edition</single>
          <multiple>editions</multiple>
        </term>
      </terms>
      """
    Then the nodename should be "terms"
    And the node should have 9 terms
    And the term number 1 should have the attribute "name" set to "accessed"
    And the term number 2 should be a textnode
    And the term number 9 should have the attribute "name" set to "edition"
    And the term number 9 should not be a textnode
