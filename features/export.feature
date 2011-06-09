Feature: Exporting a file

  Foo

  Background: Set up the world and some users
    Given I have set up the world
      And a user called "Han Solo" with username "hansolo" and password "leia" exists
      And a user called "Obi-Wan Kenobi" with username "obi" and password "sabers" exists
      And a user called "Lando Calrissian" with username "lando" and password "bounty" exists

  @javascript
  Scenario: Changing the core text fields of a media entry
    When I log in as "hansolo" with password "leia"
     And I upload some picture titled "Millenium Falcon, Front View"
     And I go to the home page
     And I click the media entry titled "Millenium Falcon, Front View"
     And I follow "Exportieren"
     
     