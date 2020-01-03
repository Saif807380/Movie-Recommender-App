import pandas as pd
import numpy as np
from flask import Flask,request,jsonify
from collections import Counter
import math

# less accurate method
# def counter_cosine_similarity(c1, c2):
#     terms = set(c1).union(c2)
#     dotprod = sum(c1.get(k, 0) * c2.get(k, 0) for k in terms)
#     magA = math.sqrt(sum(c1.get(k, 0)**2 for k in terms))
#     magB = math.sqrt(sum(c2.get(k, 0)**2 for k in terms))
#     return dotprod / (magA * magB)

app = Flask(__name__)

df = pd.read_csv('IMDB-Movie-Data.csv')
df.drop(['Revenue (Millions)','Votes',
       'Metascore'],axis=1,inplace=True)
df.dropna()
df.sort_values(by=['Rating'],ascending=False,inplace=True)
list_of_movies = df.values.tolist()


for i in range(len(list_of_movies)):
    s = list_of_movies[i][2]
    list_of_movies[i].pop(2)
    list_of_movies[i].append(s.split(','))

movies = []
genre = []
liked_movies = []
power_genre =[]
#likes 10 movies for testing
# for i in range(10):
#     liked_movies.append(list_of_movies[250-i])

@app.route('/send_select_genres',methods = ["POST"])
def select_genre():
	global genre
	global liked_movies
	global power_genre
	request_data = request.get_json()
	genre = request_data["Genres"]
	if len(genre) != 0:
		power_genre =[]
		for i in range(0,2**len(genre)):
			temp = []
			for j in range(len(genre)):
				if((i & (1 << j)) > 0):
					temp.append(genre[j])
			power_genre.append(temp)
		power_genre.remove([])
		for i in range(len(power_genre)):
			for j in range(len(power_genre)):
				if(len(power_genre[i]) < len(power_genre[j])):
					power_genre[i],power_genre[j] = power_genre[j],power_genre[i]
		power_genre.reverse()
	return jsonify(request_data)


@app.route('/send_liked_movies',methods = ["POST"])
def send_liked_movies():
	global liked_movies
	request_data = request.get_json()
	liked_movies = request_data["Liked_Movies"]
	return jsonify(request_data)

@app.route('/get_select_genres')
def get_select_genres():
	global genre
	global liked_movies
	return jsonify({"Genres" : genre,"Liked_Movies" : liked_movies})	

@app.route('/suggestions')
def show_movies():	
	l = []
	global movies
	global liked_movies
	global power_genre
	movies.clear()
	if len(liked_movies) <= 5:
		for k in power_genre:
			for movie in list_of_movies:
				if(all(x in movie[-1] for x in k) and movie[-2] >= 7 and movie not in movies):
					movies.append(movie)
	else:
		for lm in liked_movies:
			#counter_lm = Counter(lm[:-1])
			d1 = pd.DataFrame([lm],columns=df.columns)
			for movie in list_of_movies:
				d2 = pd.DataFrame([movie],columns=df.columns)
				similarity = d1.corrwith(d2,axis=1)
				if(similarity[0]>=0.99999 and similarity[0]<1):
					print(similarity[0])
					movies.append(movie)
				#counter_movie = Counter(movie[:-1])
				#if (counter_cosine_similarity(counter_lm,counter_movie) >= 0.1 and movie not in liked_movies and movie not in movies):
				#	movies.append(movie)
	if len(genre) != 0:
		for i in range(min(len(movies),10)):
			l.append({
				"Id" : movies[i][0],
				"Title" : movies[i][1],
				"Description" : movies[i][2],
				"Director" : movies[i][3],
				"Cast" : movies[i][4],
				"Release" : movies[i][5],
				"Runtime" : movies[i][6],
				"Rating": movies[i][7],
				"Genre" : movies[i][8],
			})
	return jsonify({"List" : l})
if __name__ == "__main__":
	app.run(debug=True)