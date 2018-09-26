# -*- coding: utf-8 -*-

"""
Created on Thu Sep 20 00:50:55 2018
Updated on Wed Sept 19 15:23:00 2018
@author: Sebastian Birk
"""

#%%
## import packages
import pandas as pd

#%%
## read cleaned data with timestamp as index
tweets = pd.read_csv("tweets.csv", encoding="latin1", parse_dates=True, 
                     index_col="created", usecols=range(1,28))
