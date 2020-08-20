from random import randrange
from spacy import load
from sklearn.metrics import precision_score, recall_score, accuracy_score, f1_score
import re
nlp = load("fr_core_news_sm", disable = "sentencizer")

#Dictionary used when we match each candidate with its corresponding party
dict_of_candidates = {'#cmr-présidentielle-p80820758': 'Jean-Luc Mélenchon', 
                      '#cmr-présidentielle-p38170599': 'Nicolas Dupont-Aignan',
                      '#cmr-présidentielle-p1976143068' : 'Emmanuel Macron',
                      '#cmr-présidentielle-p551669623' : 'François Fillon',
                      '#cmr-présidentielle-p150201042' : 'Jacques Cheminade',
                      '#cmr-présidentielle-p102722347' : 'Jean Lassalle',
                      '#cmr-présidentielle-p217749896' : 'Marine Lepen',
                      '#cmr-présidentielle-p1003575248' : 'Nathalie Arthaud',
                      '#cmr-présidentielle-p374392774' : 'Philippe Poutou',
                      '#cmr-présidentielle-p200659061' : 'François Asselineau',
                      '#cmr-présidentielle-p14389177' : 'Benoit Hamon'}

#Function to display a random tweet before converting the XML file to a list of dictionaries
def display_random_tweet(body):
    
    ns = {'tei': 'http://www.tei-c.org/ns/1.0'}		#Namespace definition
    tw_no = randrange(40000)						#Creation of a random number between 0 ans 40000

	#This loop is here to generate a new random number if the tweet retrieved is a retweet
    while body[tw_no].find(".//tei:distinct[@type = 'twitter-retweet']", ns) is not None :
        tw_no = randrange(40000)
    
    tweet_author = body[tw_no].attrib["who"]
    tweet_author = dict_of_candidates.get(tweet_author, "Error while fetching name")
    tweet_id = body[tw_no].attrib["{http://www.w3.org/XML/1998/namespace}id"]
    tweet_date = body[tw_no].attrib["when"]
    text = ""
    medium = body[tw_no].findall('.//tei:fs/tei:f[@name = "medium"]/tei:string', ns)
    
	#The try/except allow us to deal with the absence of favourite or retweet tags
    try:
        fav_count = body[tw_no].find('.//tei:fs/tei:f[@name = "favoritecount"]/tei:numeric', ns).get("value")
    except AttributeError:
        fav_count = 0
    
    try:
        rt_count = body[tw_no].find('.//tei:fs/tei:f[@name = "retweetcount"]/tei:numeric', ns).get("value")
    except AttributeError:
        rt_count = 0
    
	#Here, we concatenate the text in a single string, since a text tag after a tag separation cannot be retrieved with the find method
    for twText in body[tw_no].findall('.//tei:p', ns):
        text = "".join(twText.itertext())
        text = text.replace("\n", " ")
    
	#And here we generate text based on the number of favs/rts.
    if fav_count and rt_count != 0:
        print("A tweet was written by: " + tweet_author + 
          ",\nhad the following id: " + tweet_id + 
          ",\nwas written on this date: " + tweet_date + 
          ",\nvia: " + medium[0].text +
          ",\nIt received " + fav_count + " favourites and " + rt_count + " RTs" +
          ",\nAnd the text was: " + text)
        
    elif fav_count != 0:
        print("A tweet was written by: " + tweet_author + 
          ",\nhad the following id: " + tweet_id + 
          ",\nwas written on this date: " + tweet_date + 
          ",\nvia: " + medium[0].text +
          ",\nIt received " + str(fav_count) + " favourites but no RTs" +
          ",\nAnd the text was: " + text)
        
    elif rt_count != 0:
        print("A tweet was written by: " + tweet_author + 
          ",\nhad the following id: " + tweet_id + 
          ",\nwas written on this date: " + tweet_date + 
          ",\nvia: " + medium[0].text +
          ",\nIt did not receive any favourites but was retweeted " + str(rt_count) + " times" +
          ",\nAnd the text was: " + text)
        
    else:
        print("A tweet was written by: " + tweet_author + 
          ",\nhad the following id: " + tweet_id + 
          ",\nwas written on this date: " + tweet_date + 
          ",\nvia: " + medium[0].text +
          "\nIt didn't have any favourites nor retweets" +
          ",\nAnd the text was: " + text)       

#Same as before, but for retweets this time
def display_random_retweet(body):
        
    ns = {'tei': 'http://www.tei-c.org/ns/1.0'}
    tw_no = randrange(40000)
	
	#While we don't find the retweet tag, generate another random number
    while body[tw_no].find(".//tei:distinct[@type = 'twitter-retweet']", ns) is None :
        tw_no = randrange(40000)

    tweet_author = body[tw_no].attrib["who"]
    tweet_author = dict_of_candidates.get(tweet_author, "Error while fetching name")
    tweet_id = body[tw_no].attrib["{http://www.w3.org/XML/1998/namespace}id"]
    tweet_date = body[tw_no].attrib["when"]
    rt_count = body[tw_no].find('.//tei:fs/tei:f[@name = "retweetcount"]/tei:numeric', ns).get("value")
    medium = body[tw_no].findall('.//tei:fs/tei:f[@name = "medium"]/tei:string', ns)

    for twText in body[tw_no].findall('.//tei:p', ns):
        text = "".join(twText.itertext())
    text = text.replace("\n", " ")
        
    print("A retweet was written by: " + tweet_author +
          ",\nhad the following id: " + tweet_id + 
          ",\nwas written on this date: " + tweet_date +
          ",\nvia: " + medium[0].text +
          ",\nit had: " + rt_count + "RTs" +
          ",\nand the text was : " + text)

#Simple tweet print function
def print_tweet(data):
    tw_no = randrange(40000)
    print("The following tweet is the tweet number", tw_no, "\n")
    return(data[tw_no])
	
def clean_input(model):
    sample = input("Please type a tweet to test our ML algorithm: \n")
    sample = re.sub(r'http[s]?\S+', '', sample)
    sample = re.sub(r' +', ' ', sample)
    sample = re.sub(r'# ', '#', sample)
    sample = re.sub('#\w*\s', '', sample)
    sample = re.sub('[^ \w+0-9]', ' ', sample)
    sample = re.sub('^\s', '', sample)
    sample = re.sub('^.\d{1}|\W\d{1}\W', '', sample)
    sample = sample.strip().lower()
    sample = nlp(sample)
    sample = " ".join(word.lemma_ for word in sample)
    sample = re.sub(r' +', ' ', sample)
    guess = " ".join(model.predict([sample]))
    print("\nI'd say it was tweeted by "+guess, "?")
	
def print_results(headline, true_value, pred):
	print(headline)
	print("Accuracy: {}".format(accuracy_score(true_value, pred)))
	print("Precision: {}".format(precision_score(true_value, pred, average = None)))
	print("Recall: {}".format(recall_score(true_value, pred, average = None)))
	print("F1: {}".format(f1_score(true_value, pred, average = None)))