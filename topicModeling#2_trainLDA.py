## -*- coding: utf-8 -*-
"""
Created on Tue Jul 17 10:31:42 2018
Updated on Wed Sept 19 15:23:00 2018
@author: Sebastian Birk

References:
https://radimrehurek.com/gensim/tut2.html #Gensim
https://en.wikipedia.org/wiki/Tf%E2%80%93idf #TFIDF
https://en.wikipedia.org/wiki/Latent_semantic_analysis #LSA
http://proceedings.mlr.press/v15/wang11a/wang11a.pdf #HDP
https://www.kaggle.com/ykhorramz/lda-and-t-sne-interactive-visualization
https://medium.com/@sherryqixuan/topic-modeling-and-pyldavis-visualization-86a543e21f58
https://pypi.org/project/pyLDAvis/1.0.0/
"""

#%%
## load packages
import os.path
from gensim import corpora, models
import logging

#%%
## log events
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

#%%
### LOAD CORPORA
## load no pooling corpus
if (os.path.exists("tourism_no_pooling.dict")):
   dictionary_no_pooling = corpora.Dictionary.load('tourism_no_pooling.dict')
   corpus_no_pooling = corpora.MmCorpus('tourism_no_pooling.mm')
   print("Vectorized no pooling corpus loaded!")
else:
   print("Please run preprocessing script first!")

# load user pooling corpus
if (os.path.exists("tourism_user_pooling.dict")):
   dictionary_user_pooling = corpora.Dictionary.load('tourism_user_pooling.dict')
   corpus_user_pooling = corpora.MmCorpus('tourism_user_pooling.mm')
   print("Vectorized user pooling corpus loaded!")
else:
   print("Please run preprocessing script first!")
   
if (os.path.exists("tourism_hashtag_pooling.dict")):
   dictionary_hashtag_pooling = corpora.Dictionary.load('tourism_hashtag_pooling.dict')
   corpus_hashtag_pooling = corpora.MmCorpus('tourism_hashtag_pooling.mm')
   print("Vectorized hashtag pooling corpus loaded!")
else:
   print("Please run preprocessing script first!")

#%%
### IMPLEMENT LDA MODEL
# train models
lda_model_no_pooling = models.LdaModel(corpus_no_pooling,
                                       id2word=dictionary_no_pooling,
                                       alpha='auto', eta='auto',
                                       eval_every=1,
                                       iterations=200, passes=20, num_topics=6)  

#%%
lda_model_user_pooling = models.LdaModel(corpus_user_pooling,
                                       id2word=dictionary_user_pooling,
                                       alpha='auto', eta='auto',
                                       eval_every=1,
                                       iterations=200, passes=20, num_topics=6)  

#%%
lda_model_hashtag_pooling = models.LdaModel(corpus_hashtag_pooling,
                                       id2word=dictionary_hashtag_pooling,
                                       alpha='auto', eta='auto',
                                       eval_every=1,
                                       iterations=200, passes=20, num_topics=6)  

#%%
lda_model_hashtag_pooling_less_topics = models.LdaModel(corpus_hashtag_pooling,
                                       id2word=dictionary_hashtag_pooling,
                                       alpha='auto', eta='auto',
                                       eval_every=1,
                                       iterations=200, passes=20, num_topics=4)  

#%%
lda_model_hashtag_pooling_more_topics = models.LdaModel(corpus_hashtag_pooling,
                                       id2word=dictionary_hashtag_pooling,
                                       alpha='auto', eta='auto',
                                       eval_every=1,
                                       iterations=200, passes=20, num_topics=8) 

#%%
# print topics of models
_ = lda_model_no_pooling.print_topics()

#%%
_ = lda_model_user_pooling.print_topics()

#%%
_ = lda_model_hashtag_pooling.print_topics()

#%%
_ = lda_model_hashtag_pooling_less_topics.print_topics()

#%%
_ = lda_model_hashtag_pooling_more_topics.print_topics()

#%%
### IMPLEMENT TFIDF MODEL (sometimes improves performance of LDA)
# initialize tfidf model
tfidf_hashtag_pooling = models.TfidfModel(corpus_hashtag_pooling)
   
# run term frequency inverse document frequency transformation
# (transform bag-of-words integer counts corpus to tfidf real-valued weights
# corpus)
corpus_tfidf_hashtag_pooling = tfidf_hashtag_pooling[corpus_hashtag_pooling]
for doc in corpus_tfidf_hashtag_pooling:
    print(doc)

#%% 
### IMPLEMENT LDA MODEL
# train model
lda_model_hashtag_pooling_tfidf = models.LdaModel(corpus_tfidf_hashtag_pooling,
                                       id2word=dictionary_hashtag_pooling,
                                       alpha='auto', eta='auto',
                                       eval_every=1,
                                       iterations=200, passes=20, num_topics=8) 

#%%
# print topics of model
_ = lda_model_hashtag_pooling_tfidf.print_topics()


#%%
import pyLDAvis.gensim
pyLDAvis.enable_notebook()

#%% ignore this part (LSI Model not used)
#==============================================================================
# ## initialize LSI Model
# lsi = models.LsiModel(corpus_tfidf, id2word=dictionary, num_topics=300) # initialize an LSI transformation
# corpus_lsi = lsi[corpus_tfidf] # create a double wrapper over the original corpus: bow->tfidf->fold-in-lsi
# 
# ## run LSI Model
# lsi.print_topics(2)
# 
# for doc in corpus_lsi: # both bow->tfidf and tfidf->lsi transformations are actually executed here, on the fly
#     print(doc)
# 
#==============================================================================
    
## initialize HDP Model
model = models.HdpModel(corpus, id2word=dictionary)

