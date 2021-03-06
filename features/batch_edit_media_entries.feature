Feature: Batch edit media entries

  Foo

  Background: Set up the world and some users
    Given I have set up the world
      And a user called "Helmut Kohl" with username "helmi" and password "saumagen" exists
     When I log in as "helmi" with password "saumagen"
      And I upload some picture titled "Picture One"
      And I upload some picture titled "Picture Two"
      And I upload some picture titled "Picture Three"


  @javascript
  Scenario: Remove two media entries from a set using batch edit
    When I log in as "helmi" with password "saumagen"
     And I create a set titled "Set One"
     And I add the picture "Picture One" to the set "Set One" owned by "Kohl, Helmut"
     And I add the picture "Picture Two" to the set "Set One" owned by "Kohl, Helmut"
     And I add the picture "Picture Three" to the set "Set One" owned by "Kohl, Helmut"
     And I go to the media entries
     And I click the media entry titled "Picture One"
     And I choose the set "Set One" from the media entry
     And I check the media entry titled "Picture One"
     And I check the media entry titled "Picture Two"
     And I press "Aus Set/Projekt entfernen"
     And I go to the media entries
     And I click the media entry titled "Picture Three"
     And I choose the set "Set One" from the media entry
    Then I should not see "Picture One"
     And I should not see "Picture Two"

  @javascript @work
  Scenario: Change metadata on two media entries using batch edit
    When I log in as "helmi" with password "saumagen"
     And I create a set titled "Batch Retitle Set"
     And I add the picture "Picture One" to the set "Batch Retitle Set" owned by "Kohl, Helmut"
     And I add the picture "Picture Two" to the set "Batch Retitle Set" owned by "Kohl, Helmut"
     And I go to the media entries
     And I click the media entry titled "Picture One"
     And I choose the set "Batch Retitle Set" from the media entry
     And I check the media entry titled "Picture One"
     And I check the media entry titled "Picture Two"
     And I wait for 2 seconds
     And all the hidden items become visible
     And I press "Metadaten editieren"
     And I wait for 2 seconds
     And I fill in the metadata form as follows:
     |label    |value                 |
     |Titel    |We are all individuals|
     And I press "Speichern"
     Then I should see "Die Änderungen wurden gespeichert."
     And I should see "We are all individuals"
     And I go to the media entries
     And I click the media entry titled "We are all individuals"
     Then I should see "We are all individuals"
     And I should not see "Picture One"
     And I should not see "Picture Two"
