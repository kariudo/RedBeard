Feature: Get Shows
  In order to determine if we need to get a new episode
  when a user or the system request an update
  return current episode and compare to our last episode

Scenario: Check requested show for new episodes
  Given a show with 6 total episodes matching the name "FLCL"
  And we have 5 episodes of "FLCL"
  When I request an update for "FLCL"
  Then Check for new availability of episodes of "FLCL"