import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import xarray as xr
import matplotlib.colors as mcolors
from scipy.stats import linregress
###################################
id = 'E-AS.Pr'
fig = plt.figure(figsize=(9,8))


GCMn = ["ACCESS-ESM1-5","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",\
        "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-1","EC-Earth3",\
        "FGOALS-f3-L","FGOALS-g3","FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H",\
        "INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR",\
        "MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM"]

fn = "../eval_data/E-AS.eval.DEI.pr.JJA.climatemean.nc"

colors = ['skyblue','orange','yellowgreen','gray']

import matplotlib.colors as mcolors

for i in range(3):
    print(colors[i],'-----')
    color1 = mcolors.to_rgb(colors[i])
    R_mat = np.linspace(1,color1[0],40)
    G_mat = np.linspace(1,color1[1],40)
    B_mat = np.linspace(1,color1[2],40)

###################################
f = xr.open_dataset(fn)
ErrorPenalty = np.array(f['ErrorPenalty'])
RCon = ErrorPenalty/np.reshape(np.repeat(np.sum(np.array(f['ErrorPenalty']),axis = 1),3),ErrorPenalty.shape)*100
RCon = RCon[26:,:]
print("ME: ",np.min(RCon[:,0]),',',np.max(RCon[:,0]))
print('AnoA: ',np.min(RCon[:,1]),',',np.max(RCon[:,1]))
print('AnoS: ',np.min(RCon[:,2]),',',np.max(RCon[:,2]))
print(RCon[:,2])
Nmodel = len(GCMn)
Ncontri = 3
y = np.linspace(Nmodel,1,Nmodel)

gs = GridSpec(28,40, figure = fig)

#Relative Contribution
axes = fig.add_subplot(gs[2:20,1:16])
for i in range(Nmodel):
    bar0 = 0
    for j in range(Ncontri):
        
        bar0 = bar0 + RCon[i,j]
        axes.barh(y[i], bar0, color=colors[j], height = 0.7, zorder=Ncontri-j)

        if RCon[i,j] == np.max(RCon[i,:]):
            axes.text(bar0-0.5*RCon[i,j], y[i], '%.0f'%RCon[i,j]+'%', fontsize=8,  fontdict={'color': 'white'},\
                      horizontalalignment='center',verticalalignment='center', weight='bold')
            
#axes.text(-35, y[0]+1, titlen, fontsize=15,  fontdict={'color': 'black'}, weight = 'bold',\
#                      horizontalalignment='center',verticalalignment='center',fontfamily='Helvetica')
        
axes.set_xlim([0,100])
axes.set_ylim([0.5,Nmodel+0.5])
axes.set_xticks([0,20,40,60,80])
axes.tick_params(axis='x', labelsize='7')
axes.set_xlabel('Relative Contribution to nDEI$^{2}$ of JJA pr (%)',fontsize=9,fontfamily='Helvetica')
axes.set_yticks(y)
axes.set_yticklabels(GCMn,fontsize=8,fontfamily='Helvetica')

axes.spines['top'].set_visible(False)
axes.spines['right'].set_visible(False)

xlim = axes.get_xlim()
ylim = axes.get_ylim()

axes.text(-40,Nmodel+1.8, 'a',\
        va = 'center', ha = 'left', fontdict={'size':14, 'weight':'bold'})

#legend
axes = fig.add_subplot(gs[21:25,0:])

axes.set_xlim([0,30])
axes.set_ylim([0,10])


labels = ['Mean error','Anomaly amptitude error','Anomaly similarity error']

xdis = [0,7,15]

from matplotlib.patches import Rectangle

for it in range(len(labels)):
    axes.add_patch(Rectangle(xy=(1,6-0.1-2*it), width=1,
        height=1, facecolor=colors[it], edgecolor='white'))
    axes.text(2.3, 4+0.7-0.5+2.1-2*it, labels[it], fontsize=8, 
        horizontalalignment='left',verticalalignment='center',fontfamily='Helvetica')
    


    
axes.yaxis.set_visible(False)
axes.xaxis.set_visible(False)
axes.set_axis_off()

plt.savefig('Fig.4a.png',bbox_inches='tight', dpi=600)            