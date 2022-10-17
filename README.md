# location_tracker

a simple location tracker app using Firebase Auth and Cloud Firestore.

On first launch, the app lets users sign in with Firebase. (use anonymous sign-in for
simplicity).

After sign in, the app shows a page where the user can:

● Enter his/her details (name, phone number) into a form and submit it

● Save this along with the current time into Firestore

● Each truck driver can start a shipment by inserting the shipment_id

● Upon starting a shipment the location of the truck driver will be sent
automatically to the database for that shipment with its timestamp

● View a list of all shipments, sorted by most recent date.

● Each shipment will display the list of locations stored as a route on a map

● The app should update in realtime when the data changes on Firestore.
