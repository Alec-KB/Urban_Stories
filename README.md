# Urban Stories App
This is the front-end for my Year 2 Group Project. 
My code is found in the lib folder (the rest is auto-generated flutter stuff)

## What does the app do?
Urban Stories is an app that generates stories while you walk!
Using location data queries, we query the backend (written by the rest of my team) with coordinates.
This then uses a map API to generate some words associated with the surroundings, and sends them to the next stage
This stage then uses GPT2 to generate a set of sentences, which are given back to the front-end to be displayed!

The generated story is shown to the user word by word, with random time intervals inbetween each word. 
This gives the user the impression that the story is being generated constantly, when in reality the server takes around 30 seconds to generate each paragraph.

Generated stories are saved to .txt files in the users device, which can be viewed or deleted at a later date.
