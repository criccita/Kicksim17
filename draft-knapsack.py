""" (attempted) implementation of balcardssp algorithm from Kellerer book 

Inputs:
* items = imported array of strings and values from csv of player data
* c = capacity, or maximum budget ("sum of weights")
* k = choice-number (for k-choice knapsack)

"""

# last mod. 20170802

#from operator import itemgetter #for getting particular slices of list

import numpy as np #for matrix operations
import math

def knapsack(items, c, k):
		
	#sort based on price
	sorted_items = np.sort(items,order='price')
	prices=sorted_items['price']
	

	for i in range(len(prices)):
		prices[i]=int(math.ceil(prices[i]))

	
	#discard all items with weight larger than wmax (for troubleshooting keep "rejects1")
	remove=[]
	for j in range(k,len(sorted_items)):
		wmax = sum(prices[0:k]) + prices[j]
		if wmax > c:
			remove.append(j)
	filt_items=np.delete(sorted_items,remove,0)
	prices2=filt_items['price']
	
	n=len(filt_items)
	
	#calculate weightsum of the first k items of the sorted list	
	v=int(sum(prices2[0:k+1:1]))
	
	print v #just for troubleshooting purposes
	
	#initialize g as an n by c matrix (?), sigma as...nothing?
	g = np.zeros([n,c])
	sigma=[]
	
	#copied the balcardssp algorithm more-or-less verbatim, no clue what's going on tho:
	for weightsum in range(v+1,c):
		g[k,weightsum]=0
	g[k,v]=k+1
	for weightsum in range(int(v+prices2[k+1]),c):
		sigma.insert(weightsum,1)
	for weightsum in range (c+1,int(c+prices2[k])):
		temp_keep=[]
		for j in range(n):
			if prices2[j]<weightsum-c:
				temp_keep.append(j)
		sigma.insert(weightsum,max(temp_keep)+1)
	for b in range(k+1,n):
		for weightsum in range(v,c):
			g[b,weightsum]=g[b-1,weightsum]
		for weightsum in range(v,int(c+prices2[k]-prices2[b])):
			weightsum2=int(weightsum+prices2[b])
			if g[b-1,weightsum]>sigma[weightsum2]:
				for h in range(int(sigma[weightsum2]),int(g[b-1,weightsum]-1)):
					weightsum3=int(weightsum2-prices2[h])
					g[b,weightsum3]=max(g[b,weightsum3],h)
				sigma.insert(weightsum2,g[b-1,weightsum])


#now apply the knapsack function to imported data
			
csv = np.genfromtxt ('dummy_list_subset.csv', delimiter=",", dtype=None, names=['name',
															'club','pos','price','value'])
															
knapsack(csv,30,10)
