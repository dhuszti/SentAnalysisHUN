# -*- coding: utf-8 -*-
import os, sys, pickle, subprocess, numpy, csv, getopt
from sklearn import svm

# Load function for classification matrix, word features
def load(name):
	f = open(name, 'rb')
	word_features = pickle.load(f)
	f.close()
	return word_features

# Extract features function
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

# Main function
def main(argv):
	typo_in = ''

	try:
		opts, args = getopt.getopt(argv,"hi:",["input="])
	except getopt.GetoptError:
		print 'SentimentAnalysis_Test_SVM.py --input <text>'
		sys.exit(1)
	for opt, arg in opts:
		if opt == '-h':
			print 'SentimentAnalysis_Test_SVM.py --input <text>'
			sys.exit()
		elif opt in ("--input"):
			typo_in = arg

	# Ékezetesítés

	cmd = 'echo ' + typo_in + ' | /home/hd/ekezo/ekito.run | /home/hd/ekezo/p2iso '			
	p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
	(typo_out, err) = p.communicate()

	
	temp_filename = '/home/hd/SA_bemenet.txt'
	temp_file = open(temp_filename, 'w+b')
	temp_file.write(typo_out)	
	temp_file.close()

	

	# TODO: Helyesírás ellenőrzés (bónusz)


	# Szótövezés, morfológiai elemzés

	subprocess.call(['./SHELL_SCRIPT_SENTIMENT_ANALYSIS.sh'])
	
	# tokenizált szavak (szófajjal) lementése ebbe a tömbbe
	tokenized_words = []

	file_url = "/home/hd/morph_ki_SA.txt"

	with open(file_url) as morph_results:
		csvreader = csv.reader(morph_results, delimiter='\t')
	
		temp = []
		for line in csvreader:			
			if line[0] == 'thisistheending':
				tokenized_words.append(temp)			
				temp = []
			else:
				# Filtering
				if line[1] != 'UNKNOWN':
					temp.append(line[1])
	# Delete temp files
	os.remove(temp_filename)
	os.remove(file_url)

	# Word features és classifier betöltése
	word_features = load('SVM_wordfeatures')
	clf = load('SVM_classfier')

	# Osztályozó meghívása
	SVM_results = numpy.array(clf.predict(extract_features(tokenized_words, word_features)))
	print numpy.mean(SVM_results)


if __name__ == "__main__":
   main(sys.argv[1:])
