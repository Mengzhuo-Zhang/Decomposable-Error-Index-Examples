import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import xarray as xr
import matplotlib.colors as mcolors
from scipy.stats import linregress
###################################
res = [1.88*1.25,0.94**2,1.13**2,1.13**2,1.25*0.94,1.25*0.94,1.25*0.94,2.81**2,1,0.7**2,2.25*2,1,1.25*0.94,\
    1.25*1,2.25*2,2.25*2,1.88*1.25,2.5*1.16,1.88*1.25,3.75*2.25,1.41**2,1.88**2,0.94**2,1.25**2,1.875**2,1.25*0.94]

       
res = np.sqrt(np.array(res)) 
#res = np.array(res)
#print(res)
colors = ['#FF6B6B', "#0DD9CB","#F89E0D", "#21BF63","#3099DF",'#A8E6CF', "#EC16E1"]


###################################
varn = ['pr.DJF','pr.JJA','uv.DJF','uv.JJA']
N_CMIP5 = 26


fig = plt.figure(figsize=(12,6))
gs = GridSpec(20,40, figure = fig)

axes = fig.add_subplot(gs[0:16,0:16])

biasn = ['Pr DJF','Pr JJA','UV DJF','UV JJA']



for i in range(len(varn)):
    fn = "../eval_data/E-AS.eval.DEI."+varn[i]+".climatemean.nc"
    f = xr.open_dataset(fn)
    y = np.array(f['ErrorPenalty'])[N_CMIP5:,2]/np.array(f['stats'])[0,2]


    plt.scatter(res,y,marker='d',c=colors[i],s=12)
    
    slope, intercept, r_value, p_value, std_err = linregress(res, y)
    line = [np.min(res) * slope + intercept, np.max(res) * slope + intercept]
        
    print(r_value,',',p_value)
    plt.plot([np.min(res),np.max(res)], line, '--', linewidth=1.5, c=colors[i], 
             label = '1')

    #axes.set_ylim([0,0.8])
    axes.tick_params(axis='x', labelsize='10')
    axes.tick_params(axis='y', labelsize='10')
    axes.set_ylabel('E$_{AnoS}$',fontsize=12)
    axes.set_xlabel('Horizontal resolution',fontsize=13)

    axes.text(3,3.4-i*0.3,f'{biasn[i]}, R = {r_value:.3f}'+[' ','*','**','**'][i],weight='bold',
                  fontsize=12,  fontdict={'color': colors[i]},
                  horizontalalignment='left',verticalalignment='bottom')
    print(r_value )
    
        #axes.text(2,0.04,'Mean bias, R² = {r_value**2:.3f}',
        #          fontsize=10,  fontdict={'color': 'black'},
        #          horizontalalignment='center',verticalalignment='bottom')

        
    #axes.text(-15, y[0]+0.7, 'CMIP'+['5','6'][ic], weight = 'bold',\
    #                    horizontalalignment='center',verticalalignment='bottom')
    axes.spines['top'].set_visible(False)
    axes.spines['right'].set_visible(False)




plt.savefig('Fig.7.png',bbox_inches='tight',dpi=600)           
    


  
        
