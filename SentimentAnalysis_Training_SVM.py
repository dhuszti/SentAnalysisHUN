# -*- coding: utf-8 -*-
import os, sys, nltk, numpy, csv, pickle, re, goslate, tempfile, subprocess
from sklearn import svm



#####################################################################################
## Functions for word extraction, feature extraction				   ##
#####################################################################################

def get_words_in_tweets(tweets):
    all_words = []
    for words in tweets:
      all_words.extend(words)
    return all_words

def get_word_features(wordlist):
    wordlist = nltk.FreqDist(wordlist)
    word_features = wordlist.keys()
    return word_features

def extract_features(tweets, word_features):
    features = []  
    for array_element in sorted(tweets):
	temp = []
	for it in sorted(word_features):
		if it not in array_element:
			temp.append(0)
		else:
			temp.append(1)
	features.append(temp)
    return features

def save(classifier, name):
	f = open(name, 'wb')
	pickle.dump(classifier, f, -1)
	f.close()



#####################################################################################
## Sentiment dictionaries load from file - formerly translated 			   ##
#####################################################################################

# GLOBAL PARAMETERS - Tweets and ratings are going to be saved here
tweets = []
ratings = []
sent_dic = []

# TODO: shell script parameter

# Sentiment dictionaries morphological analysis in order to import analyzed form into the dictionaries
subprocess.call(['./SHELL_SCRIPT_SENTIMENT_DICTIONARY_MORPH.sh'])

file_url = "/home/hd/onlab2/sentiment_dictionaries/hu_pos_morph.txt"

with open(file_url) as dic_file:
	for line in dic_file:
		sent_dic.append(line.replace('\n','').replace('\r',''))

file_url = "/home/hd/onlab2/sentiment_dictionaries/hu_neg_morph.txt"

with open(file_url) as dic_file:
	for line in dic_file:
		sent_dic.append(line.replace('\n','').replace('\r',''))



#####################################################################################
# Get ratings from sentiment corpus
#####################################################################################
file_url = "/home/hd/onlab2/sentiment_corpus/OpinHuBank_20130106 (copy).csv"

with open(file_url) as single_file:
	csvreader = csv.reader(single_file, delimiter=',', quotechar='"')
	
	# Extract avg ratings - into an array called ratings
	for element in csvreader:
		avg_rating = 0
		for i in range(6,10):
			if element[i] == "1":
				avg_rating = avg_rating + 1
			elif element[i] == "-1":
				avg_rating = avg_rating - 1		
		ratings.append(avg_rating/5.0)



#####################################################################################
# Morphological analysis on sentiment corpus lines
#####################################################################################

subprocess.call(['./SHELL_SCRIPT_SENTIMENT_CORPUS_MORPH.sh'])

file_url = "/home/hd/morph_ki.txt"

with open(file_url) as morph_results:
	csvreader = csv.reader(morph_results, delimiter='\t')
	
	temp = []
	for line in csvreader:			
		if line[0] == 'thisistheending':
			tweets.append(temp)			
			temp = []
		# Filter words only in sentiment dicitonary to reduce matrix size
		elif line[1] != 'UNKNOWN' and '/ART' not in line[1] and '/CONJ' not in line[1]:
			if line[1] in sent_dic:
				temp.append(line[1])


#####################################################################################
# Extract features and classifier functions
#####################################################################################

# Word features extractor
word_features = get_word_features(get_words_in_tweets(tweets))

# Save word features
save(word_features, 'SVM_wordfeatures')

# SVM classifier
clf = svm.SVR()
classification = clf.fit(extract_features(tweets, word_features), ratings)

# SVM classifier save
save(classification, 'SVM_classfier')

