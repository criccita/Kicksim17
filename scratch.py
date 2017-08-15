""" (attempted) implementation of balcardssp algorithm from Kellerer book 

Inputs:
* items = set of [name, value, price] sets
* wmax = maximum budget ("sum of weights")
* k = choice-number (for k-choice knapsack)

"""

# last mod. 20170730
from operator import itemgetter #for getting particular slices of list
import numpy as np #for matrix operations


def knapsack(items, wmax, k):
	
	#sort based on price
	sorted_items = sorted(items, key=itemgetter(2))
	
	#prices=map(itemgetter(2),items)
	
	#initialize subset as the first k items of the sorted list
	subset=sorted_items[0:k+1]
	
	v=sum(map(itemgetter(2),subset))
	
	g = []
	
	for weightsum in range(v+1,wmax):
		g[
		