# Movie Recommender App

This is a Flutter Android App that recommends movies based on the users selected genres and liked movies.
It uses Google's Flutter framework for the front end of the Android App and uses python to recommend movies via a Flask API.
Given a database of movies, with their genres and ratings along with other miscellaneous details like plot, cast, directors, year of release, etc., the movies are displayed on the basis of the user’s “liked” movies.

# Background

The algorithm used for suggesting movies based on the user selected genres, is based on the concept of Power Set. A power set is created of the set of genres received from the user and sorted in non-increasing order of the cardinality of the sets of genres.
For movie suggestions for the case where no movies have been liked by the user, the genre of each movie from the dataset of movies is compared with each set of the power set iteratively. If the comparison returns a true value, then the movie along with its data, is appended to a list, which is then sent to the front end by the API.
When there are enough number of liked movies ( this number can be set ), the movies are recommended on the basis of their similarity by any one of the two methods:
1) A Cosine Similarity Function
2) Using the .corr() built-in Pandas method
