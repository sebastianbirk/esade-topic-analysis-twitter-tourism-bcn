# -*- coding: utf-8 -*-
"""
Created on Mon Jul 16 11:29:11 2018

@author: Sebastian Birk
"""

# config
data_exploration = True

# import packages
import pandas as pd
from gensim.test.utils import common_corpus, common_dictionary
from gensim.models import HdpModel
import nltk
import topicmodel_preprocessing as tmppr

# read data
tweets = pd.read_csv("tweets.csv", encoding="latin1", parse_dates=True,
                     index_col="timestamp" )

# explore data
if data_exploration:
    print(tweets.head())
    print(tweets.info())
   
#%%

dictionary, corpus = prep_corpus(docs['tokens'])


#%%

# train hdp model
hdp = HdpModel(common_corpus, common_dictionary)

unseen_document = [(1, 3.), (2, 4)]
doc_hdp = hdp[unseen_document]
    
#%%
topic_info = hdp.print_topics(num_topics=20, num_words=10)
print(topic_info)