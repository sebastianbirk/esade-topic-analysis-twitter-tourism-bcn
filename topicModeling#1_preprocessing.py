# -*- coding: utf-8 -*-

"""
Created on Mon Jul 16 16:06:05 2018
Updated on Wed Sept 19 15:23:00 2018
@author: Sebastian Birk

References:
Corpora and Vector Spaces: https://radimrehurek.com/gensim/tut1.html
https://markroxor.github.io/gensim/static/notebooks/lda_training_tips.html
"""

#%%
## import packages
from gensim import corpora
import pandas as pd
import logging
import nltk
from nltk.stem.wordnet import WordNetLemmatizer
from gensim.models import Phrases
import io

#%%
## download stopwords and lemmatizer from nltk package
nltk.download("stopwords")
nltk.download("wordnet")

#%%
## log events
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

#%%
## read data with timestamp as index
tweets = pd.read_csv("tweets.csv", encoding="latin1", parse_dates=True, 
                     index_col="created", usecols=range(1,28))

#%%
## divide dataset according to language: extract english language
english_tweets = tweets[tweets["language3"] == "ENGLISH"].copy()

#%%
## apply some cleaning to twitter text (preprocessing)
# remove links
english_tweets["text_clean"] = english_tweets["text"].str.replace(r"http\S+", "")
# remove emoticons
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"<.*>", "")
# remove @s
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"@", "")
# remove punctuation and special characters
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"&amp", "")
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"\.", "")
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"\,", "")
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"\;", "")
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"\-", "")
english_tweets["text_clean"] = english_tweets["text_clean"].str.replace(r"\"", "")


#%%
## reorder columns
# english_tweets.columns
cols = ['text', 'text_clean', 'favoriteCount', 'replyToSN', 'truncated', 'replyToSID',
       'replyToUID', 'statusSource', 'retweetCount', 'longitude', 'latitude',
       'id_seccion', 'horaPeticion', 'id_distrito', 'grupoHora',
       'id_seccion_xy', 'favoriteCountOutlier', 'retweetCountOutlier',
       'tweetcount', 'movement', 'language3', 'dayofweek', 'weeknumber',
       'month', 'idBarrio_xy', 'idBarrio', 'user']

english_tweets = english_tweets[cols]

#%%
### TRAINING DOCUMENTS PREPARATION 1
## treat every tweet as a document (no pooling)
documents = english_tweets["text_clean"].tolist()

#%%
### TRAINING DOCUMENTS PREPARATION 2
## treat all tweets by one user as a document (user pooling)
user_combined = english_tweets[["text_clean","user"]].groupby("user")["text_clean"].apply(lambda x: "".join(x))
documents_user_pooling = user_combined.tolist()

#%%
### TRAINING DOCUMENTS PREPARATION 3
## treat all tweets with same hashtags as a document (hashtag pooling)
# find all hashtags
english_tweets["hashtags"] = english_tweets["text_clean"].str.findall(r'#.*?(?=\s|$)')

# separate hashtags in columns
hashtags_tweets = pd.DataFrame(english_tweets["hashtags"].tolist(),
                               columns=["hashtag1", "hashtag2", "hashtag3", "hashtag4",
                                        "hashtag5", "hashtag6", "hashtag7", "hashtag8",
                                        "hashtag9", "hashtag10", "hashtag11", "hashtag12",
                                        "hashtag13"])

# join hashtags with tweet text
hashtags_tweets.index = english_tweets.index
hashtags_tweets = english_tweets.join(hashtags_tweets)

# create one dataframe with text for each hashtag column and save them in a dictionary
dict = {}
for index, item in enumerate(["hash1", "hash2", "hash3", "hash4", "hash5",
                              "hash6", "hash7", "hash8", "hash9", "hash10",
                              "hash11", "hash12", "hash13"]):
    dict[item] = hashtags_tweets[["hashtag" + str(index + 1), "text_clean"]].copy()
    dict[item].columns = ["hashtag", "text"]
    dict[item].dropna(inplace=True)

# concatenate all dataframes to one dataframe (the result is a dataframe
# where there is text for each hashtag found)
hashtags = pd.DataFrame()
for item in dict:
    hashtags = pd.concat([hashtags, dict[item]])

# combine text for each hashtag
hashtags_combined = hashtags.groupby("hashtag")["text"].apply(lambda x: "".join(x))

# remove some generic hashtags that cover a lot of different topics
hashtags_combined.drop(["#Barcelona", "#Catalunya", "#Spain", "#BCN", "#BARCELONA",
                        "#Espana", "#BarcelonaSpain"], inplace=True)

# create documents
documents_hashtag_pooling = hashtags_combined.tolist()

#%%
### TEST DOCUMENTS PREPARATION
## merge all tweets from each district (district pooling)
district_combined = english_tweets[["text_clean","idBarrio"]].groupby("idBarrio")["text_clean"].apply(lambda x: "".join(x))
documents_district_pooling = district_combined.tolist()

#%%
### SAVE TRAINING AND TEST DOCUMENTS
with io.open('documents.txt', 'w', encoding='utf-8') as f:
    for item in documents:
        f.write(item)
with io.open('documents_user_pooling.txt', 'w', encoding='utf-8') as f:
    for item in documents_user_pooling:
        f.write(item)
with io.open('documents_hashtag_pooling.txt', 'w', encoding='utf-8') as f:
    for item in documents_hashtag_pooling:
        f.write(item)
with io.open('documents_district_pooling.txt', 'w', encoding='utf-8') as f:
    for item in documents_district_pooling:
        f.write(item)

#%%
### TOKENIZE TRAINING DOCUMENTS 1
## tokenize
texts_no_pooling = [[word for word in document.lower().split()]
          for document in documents]

#%%
### TOKENIZE TRAINING DOCUMENTS 2
## tokenize
texts_user_pooling = [[word for word in document.lower().split()]
          for document in documents_user_pooling]

#%%
### TOKENIZE TRAINING DOCUMENTS 3
## tokenize
texts_hashtag_pooling = [[word for word in document.lower().split()]
          for document in documents_hashtag_pooling]

#%%
### FURTHER PREPROCESSING AFTER TOKENIZATION
# Remove numbers, but not words that contain numbers.
texts_no_pooling = [[token for token in doc if not token.isnumeric()] for doc in texts_no_pooling]
texts_user_pooling = [[token for token in doc if not token.isnumeric()] for doc in texts_user_pooling]
texts_hashtag_pooling = [[token for token in doc if not token.isnumeric()] for doc in texts_hashtag_pooling]

#%%
# Remove words that are only one character.
texts_no_pooling = [[token for token in doc if len(token) > 1] for doc in texts_no_pooling]
texts_user_pooling = [[token for token in doc if len(token) > 1] for doc in texts_user_pooling]
texts_hashtag_pooling = [[token for token in doc if len(token) > 1] for doc in texts_hashtag_pooling]

#%%
# lemmatize all words in all documents.
lemmatizer = WordNetLemmatizer()
texts_no_pooling = [[lemmatizer.lemmatize(token) for token in doc] for doc in texts_no_pooling]
texts_user_pooling = [[lemmatizer.lemmatize(token) for token in doc] for doc in texts_user_pooling]
texts_hashtag_pooling = [[lemmatizer.lemmatize(token) for token in doc] for doc in texts_hashtag_pooling]

#%%
#==============================================================================
# ## Compute bigrams
# # Add bigrams and trigrams to docs (only ones that appear 5 times or more).
# bigram = Phrases(texts_no_pooling, min_count=10)
# for idx in range(len(texts_no_pooling)):
#     for token in bigram[texts_no_pooling[idx]]:
#         if '_' in token:
#             # Token is a bigram, add to document.
#             texts_no_pooling[idx].append(token)
#             
# bigram = Phrases(texts_user_pooling, min_count=10)
# for idx in range(len(texts_user_pooling)):
#     for token in bigram[texts_user_pooling[idx]]:
#         if '_' in token:
#             # Token is a bigram, add to document.
#             texts_user_pooling[idx].append(token)
#             
# bigram = Phrases(texts_hashtag_pooling, min_count=10)
# for idx in range(len(texts_hashtag_pooling)):
#     for token in bigram[texts_hashtag_pooling[idx]]:
#         if '_' in token:
#             # Token is a bigram, add to document.
#             texts_hashtag_pooling[idx].append(token)
#==============================================================================

#%% ignore this part 
#==============================================================================
# ## save tokenized documents to a txt file for corpus streaming to reduce memory usage
# ## (for big datasets)
# with open('corpus_no_pooling.txt', 'w') as f:
#     for item in texts_no_pooling:
#         f.write("%s\n" % item)
# 
# with open('corpus_user_pooling.txt', 'w') as f:
#     for item in texts_user_pooling:
#         f.write("%s\n" % item)
#         
# with open('corpus_hashtag_pooling.txt', 'w') as f:
#     for item in texts_hashtag_pooling:
#         f.write("%s\n" % item)
#==============================================================================

#%%
### REFINE AND VECTORIZE CORPORA
## define function to refine and vectorize corpus 
## (remove stopwords, very frequent and very infrequent words etc.)
# define stopwords
stpwords = 'for a of the and to in at by spain barcelona #barcelona #spain de la del en las "barcelona #bcn'.split()

def nltk_stopwords():
    return set(nltk.corpus.stopwords.words('english'))

def prep_corpus(docs, 
                additional_stopwords=set(stpwords),
                no_below=2, no_above=0.5,
                dictionary_name='tourism.dict', corpus_name='tourism.mm'):
    print('Building dictionary...')
    dictionary = corpora.Dictionary(docs)
    stopwords = nltk_stopwords().union(additional_stopwords)
    stopword_ids = map(dictionary.token2id.get, stopwords)
    dictionary.filter_tokens(stopword_ids)
    dictionary.compactify()
    dictionary.filter_extremes(no_below=no_below, no_above=no_above, keep_n=None)
    dictionary.compactify()
    dictionary.save(dictionary_name)  # store the dictionary, for future reference
    
    print('Building corpus...')
    corpus = [dictionary.doc2bow(doc) for doc in docs]
    corpora.MmCorpus.serialize(corpus_name, corpus)  # store to disk, for later use
    
    return (corpus, dictionary)
#%%
## run function to vectorize corpora
corpus_no_pooling = prep_corpus(texts_no_pooling,
                                dictionary_name="tourism_no_pooling.dict",
                                corpus_name="tourism_no_pooling.mm")[0]
dictionary_no_pooling = prep_corpus(texts_no_pooling,
                                    dictionary_name="tourism_no_pooling.dict",
                                    corpus_name="tourism_no_pooling.mm")[1]

corpus_user_pooling = prep_corpus(texts_user_pooling,
                                    dictionary_name="tourism_user_pooling.dict",
                                    corpus_name="tourism_user_pooling.mm")[0]
dictionary_user_pooling = prep_corpus(texts_user_pooling,
                                    dictionary_name="tourism_user_pooling.dict",
                                    corpus_name="tourism_user_pooling.mm")[1]

corpus_hashtag_pooling = prep_corpus(texts_hashtag_pooling,
                                    dictionary_name="tourism_hashtag_pooling.dict",
                                    corpus_name="tourism_hashtag_pooling.mm")[0]
dictionary_hashtag_pooling = prep_corpus(texts_hashtag_pooling,
                                    dictionary_name="tourism_hashtag_pooling.dict",
                                    corpus_name="tourism_hashtag_pooling.mm")[1]

#%% ignore this part
#==============================================================================
# ## map tokens to ids
# print(dictionary_no_pooling.token2id)
# print(dictionary_user_pooling.token2id)
# print(dictionary_hashtag_pooling.token2id)
#==============================================================================

#%% ignore this part
#==============================================================================
# ## convert new document to vector
# new_doc = "Sagrada Familia is amazing"
# new_vec_no_pooling = dictionary_no_pooling.doc2bow(new_doc.lower().split())
# print(new_vec_no_pooling)
#==============================================================================

#%% ignore this part
#==============================================================================
# ## corpus streaming: one document at a time
# class MyCorpus(object):
#     def __iter__(self):
#         for line in open("corpus_no_pooling.txt"):
#             # assume there's one document per line, tokens separated by whitespace
#             yield dictionary.doc2bow(line.lower().split())
#             
# corpus_memory_friendly = MyCorpus()  # doesn't load the corpus into memory!
# print(corpus_memory_friendly)
# 
# for vector in corpus_memory_friendly:  # load one vector into memory at a time
#     print(vector)
#==============================================================================