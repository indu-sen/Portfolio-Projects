#!/usr/bin/env python
# coding: utf-8

# # Movie Genre Data Analysis

# ## Introduction

# We are going to focus highly on genres's. I want to know everything about Genre's. 
# 
# Here are some things I want to look at:

# ### Research Questions (Q):
# 
# 1. Which genres are the most common (number of movies made)?
# 2. Which genres have high avg. budget and revenue?
# 3. Which genres have high avg. profit?
# 4. Which genres have high avg. popularity?
# 5. Which genres have highest number of movies with a voting avg. >=8?

# ### Research Hypotheses (H): 
# 
# 1. The best movies according to vote avg. return high profit and revenue. 
# 2. The best movies according to popularity return high profit and revenue. 
# 3. Highly budgeted movies return high revenue and profit. 
# 4. Highly budged movies have a high popularity. 

# In[94]:


import pandas as pd


# In[4]:


movies = pd.read_csv(r'/Users/indusen/Downloads/imdb_movies.csv')


# In[5]:


pd.set_option('display.max.rows', 11000)
pd.set_option('display.max.rows', 22)


# In[6]:


movies.head()


# In[10]:


movies[movies.duplicated()]


# In[11]:


movies.drop_duplicates(inplace = True)


# In[12]:


movies[movies.duplicated()]


# In[13]:


movies.dropna(subset = ['genres'], inplace = True)


# In[14]:


movies.info()


# In[15]:


movies['profit'] = movies['revenue']- movies['budget']


# In[17]:


movies_genre=movies[['popularity','budget','revenue','original_title','runtime','genres','release_date','vote_count','vote_average','profit']]


# In[19]:


movies_genre.head()


# In[55]:


from pandas import Series, DataFrame


# In[26]:


split = movies_genre['genres'].str.split('|').apply(Series,1).stack()
split.index = split.index.droplevel(-1)
split.name = 'genres_split'
del movies_genre['genres']
movies_genre = movies_genre.join(split)


# #### Research Questions (Q):
# 
# 1. Which genres are the most common (number of movies made)?
# 

# In[56]:


genres_count = pd.DataFrame(movies_genre.groupby('genres_split').original_title.nunique()).sort_values('original_title', ascending = True)


# In[50]:


genres_count


# In[51]:


genres_count['original_title'].plot.pie(title = 'Movies Per Genre in %', autopct = '%1.1f%%', figsize=(10,10))


# In[52]:


genres_count['original_title'].plot.barh(title = 'Movies Per Genre', color = 'DarkBlue', figsize = (10,9))


# #### Research Questions (Q):
# 
# 2. Which genres have high avg. budget and revenue?

# In[60]:


genres_avg = movies_genre.groupby('genres_split').mean(numeric_only=True)
pd.options.display.float_format = '{:2f}'.format

genres_avg


# In[62]:


genres_avg.sort_values('revenue', ascending = True, inplace = True)


# In[63]:


genres_avg[['budget','revenue']].plot.barh(title = 'Budget and Revenue by Genre', color = ('DarkBlue','c'), figsize = (10,9))


# #### Research Questions (Q):
# 
# 3. Which genres have high avg. profit?

# In[95]:


genres_avg


# In[67]:


genres_avg.sort_values('profit', ascending = True, inplace = True)


# In[68]:


genres_avg['profit'].plot.barh(title = 'Profit by Genre', color = 'DarkBlue',figsize = (10,9))


# #### Research Questions (Q):
# 
# 4. Which genres have high avg. popularity?

# In[96]:


genres_avg


# In[97]:


genres_avg.sort_values('popularity', ascending = True, inplace = True)


# In[71]:


genres_avg['popularity'].plot.barh(title = 'Popularity by Genre', color = 'DarkBlue',figsize = (10,9))


# #### Research Questions (Q):
# 
# 5. Which genres have highest number of movies with a voting avg. >=8?

# In[73]:


movies_genre.head()


# In[74]:


vote_fifty = movies_genre[(movies_genre['vote_count'] >= 50) & (movies_genre['vote_average'] >= 8)]
vote_zero = movies_genre[movies_genre['vote_average'] >= 8]


# In[75]:


genres_vote = pd.DataFrame(vote_zero.groupby('genres_split').vote_average.nunique()).sort_values('vote_average', ascending = True)


# In[76]:


genres_vote


# In[77]:


genres_vote['vote_average'].plot.barh(title = 'Vote Average by Genre', color = 'DarkBlue',figsize = (10,9))


# #### Research Hypotheses (H):
# 
# 1. The best movies according to vote avg. return high profit and revenue. 

# In[83]:


movies.drop_duplicates(inplace = True)
movies['profit'] = movies['revenue'] - movies['budget']
movies_genre = movies[['popularity','budget','revenue','original_title','runtime','genres','release_date','vote_count','vote_average','profit']]


# In[85]:


movies_counted = movies_genre[movies_genre['vote_count'] >= 50]

movies_counted.corr(method = 'spearman',numeric_only = True)


# In[88]:


import seaborn as sns

sns.regplot(x = 'vote_average', y = 'revenue', data = movies_counted, line_kws = {"color": 'red'})


# #### Research Hypotheses (H):
# 
# 2. The best movies according to popularity return high profit and revenue. 

# In[89]:


movies_counted.corr(method = 'spearman',numeric_only = True)


# In[90]:


import matplotlib.pyplot as plt
sns.regplot(x = 'popularity', y = 'revenue', data = movies_counted, line_kws = {"color": 'red'})
plt.figure(figsize = (10,5))
plt.show()


# #### Research Hypotheses (H):
# 
# 3. Highly budgeted movies return high revenue and profit. 

# In[91]:


movies_counted.head()


# In[92]:


sns.regplot(x = 'budget', y = 'profit', data = movies_counted, line_kws = {"color": 'red'})
plt.figure(figsize = (10,5))
plt.show()


# #### Research Hypotheses (H):
# 
# 4. Highly budged movies have a high popularity. 

# In[93]:


sns.regplot(x = 'budget', y = 'popularity', data = movies_counted, line_kws = {"color": 'red'})
plt.figure(figsize = (10,5))
plt.show()


# In[ ]:





# In[ ]:




