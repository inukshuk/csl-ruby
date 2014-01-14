Feature: Parse CSL choose nodes
	As a hacker of CSL styles
	I want to be able to parse CSL choose nodes
	
	Scenario: Single if nodes 
		When I parse the CSL string
			"""
      <choose>
        <if type="bill legal_case legislation" match="none"></if>
      </choose>
			"""
		Then the nodename should be "choose"
    And the node should have 1 blocks
    And the block number 1's nodename should be "if"
    And the block number 1's class should be "CSL::Style::Choose::Block"

