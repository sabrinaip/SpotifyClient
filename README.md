# SpotifyClient

This client is written for NYC Tech Talent Pipeline, as part of Spotify NYC Technology Fellowship’s take home challenge.

This project is written using Swift 3. It makes HTTP requests to the server, which can be found at [here] (https://powerful-forest-36673.herokuapp.com/people).

## Features

- A searchable table view of all users
- Swipe to delete functionality on table view cells, which updates to the server
- A view controller where users can be added or edited

## HTTP Request Notes 

- The table view makes GET requests to /people.
- Upon tapping the add user button on top right, it segues to a view controller, where a new person’s name and city can be inputted. The client makes a POST request of the new person upon tapping “Save.”
- Upon returning back to the tableview, a new GET request to /people is made, where the new person can be observed.
- Table view cells can be selected, which segues to a view controller that makes a GET request to /people/:id.
- User details are editable, and upon tapping “Save,” a PUT request is made to /people/:id.
- Specific users can be queried through the use of the search bar, which then uses a GET request to /people/:id when selected.
- Swiping on a tableview cell gives the option to delete the person /people/:id from the database, through a DELETE request.
- Upon deletion, a new GET request is made to /people.
