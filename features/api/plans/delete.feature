Feature: Plan deletion
  In order to get rid of a plan that I don't like any more
  As a provider
  I want to delete it.

  #TODO test it for other plan types
  @javascript
  Scenario: Delete Application plan
    Given a provider "foo.3scale.localhost"
    And an application plan "PlanName" of provider "foo.3scale.localhost"
    And current domain is the admin domain of provider "foo.3scale.localhost"
    When I log in as provider "foo.3scale.localhost"
    And I go to the application plans admin page
    And I select option "Delete" from the actions menu for plan "PlanName"
    Then I should see "The plan was deleted"
    And I should not see plan "PlanName"

  #TODO test it for other plan types
  @javascript
  Scenario: Delete Application plan is not allowed if has applications
    Given a provider "foo.3scale.localhost"
    And a published plan "PlanName" of provider "foo.3scale.localhost"
    And plan "PlanName" has applications
    And current domain is the admin domain of provider "foo.3scale.localhost"
    When I log in as provider "foo.3scale.localhost"
    And I go to the application plans admin page
    And I should not see option "Delete" from the actions menu for plan "PlanName"
