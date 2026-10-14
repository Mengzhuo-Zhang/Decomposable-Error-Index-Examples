import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import xarray as xr
import matplotlib.colors as mcolors
from scipy.stats import linregress
###################################
modeln = ['CanESM5','FGOALS-f3-L'] #E-SA, JJA, UV
ME1, SD_m1, SD_o1, CORR1 = 0.176558, 1.52898, 1.62493, 0.908454
ME2, SD_m2, SD_o2, CORR2 = 0.180122, 1.44889, 1.62493, 0.961723

Decompose_error = [[[(ME1/SD_o1)**2, (SD_m1/SD_o1-1)**2, 2*(1-CORR1)],\
        [(ME2/SD_o2)**2, (SD_m2/SD_o2-1)**2, 2*(1-CORR2)]],\
                [[(ME1/SD_o1)**2, (SD_m1/SD_o1-1)**2, (1-CORR1)**2],\
                    [(ME2/SD_o2)**2, (SD_m2/SD_o2-1)**2, (1-CORR2)**2]]]

fig = plt.figure(figsize=(6,3))
gs = GridSpec(40, 90, figure=fig)

colors = ['skyblue','orange','yellowgreen','gray']
y = [1,2]

for i in range(2):
    axes = fig.add_subplot(gs[5:15,i*37+2:(i*37+28+2)])

    for im in range(2):
        bar0 = 0
        for j in range(3):
            bar0 = bar0 + Decompose_error[i][im][j]
            axes.barh(y[im], bar0, color=colors[j], height = 0.5, zorder=3-j)

    axes.set_ylim([0.5,2.5])
    axes.set_yticks([1,2])
    if i == 0:
        axes.set_yticklabels(modeln, fontsize=7)
    else:
        axes.set_yticklabels([' ',' '], fontsize=7)
    axes.tick_params(axis='x', labelsize=6)

    axes.set_xlabel('Decompose '+['nDVEI$^2$','(KGE$^{\prime\prime}$+1)$^2$'][i]+' for JJA UV', fontsize=7)

    axes.spines['top'].set_visible(False)
    axes.spines['right'].set_visible(False)

    if i == 0:
        axes.set_xlim([0,0.25])
    else:
        axes.set_xlim([0,0.025])

    if i==1: 
        xlim = axes.get_xlim()

        axes.text(xlim[1]+(xlim[1]-xlim[0])*0.3,y[0], f'{ME1/SD_o1:.2f}'+'    '+f'{SD_m1/SD_o1:.2f}'+'    '+f'{CORR1:.2f}',\
                va = 'center', ha = 'left', fontdict={'size':7})
        axes.text(xlim[1]+(xlim[1]-xlim[0])*0.3,y[1], f'{ME2/SD_o2:.2f}'+'    '+f'{SD_m2/SD_o2:.2f}'+'    '+f'{CORR2:.2f}',\
                va = 'center', ha = 'left', fontdict={'size':7})
        axes.text(xlim[1]+(xlim[1]-xlim[0])*0.3,2.5, 'VME   cRMSL  cVSC',\
                va = 'center', ha = 'left', fontdict={'size':7})
        
        
    else:
        axes.text(-0.14,3, 'c',\
                va = 'center', ha = 'left', fontdict={'size':14, 'weight':'bold'})
    '''

    if i == 0:
        for j in range(3):
            deltax = 0.07
            xstr = 0.0
            if j == 0:
                axes.text(xstr+deltax*j,y[0]+0.3, f'{Decompose_error[i][0][j]:.3f}',\
                        va = 'center', ha = 'left', fontdict={'size':5,'color':colors[j],'weight':'bold'})
                axes.text(xstr+deltax*j,y[1]+0.3, f'{Decompose_error[i][1][j]:.3f}',\
                        va = 'center', ha = 'left', fontdict={'size':5,'color':colors[j],'weight':'bold'})
            if j == 1:
                axes.text(xstr+0.04,y[0]+0.3, f'{Decompose_error[i][0][j]:.3f}',\
                        va = 'center', ha = 'left', fontdict={'size':5,'color':colors[j],'weight':'bold'})
                axes.text(xstr+0.03,y[1]+0.3, f'{Decompose_error[i][1][j]:.3f}',\
                        va = 'center', ha = 'left', fontdict={'size':5,'color':colors[j],'weight':'bold'})
            if j == 2:
                axes.text(xstr+0.12,y[0]+0.3, f'{Decompose_error[i][0][j]:.3f}',\
                        va = 'center', ha = 'left', fontdict={'size':5,'color':colors[j],'weight':'bold'})
    '''        

            

#legend
axes = fig.add_subplot(gs[16:,:])

axes.set_xlim([0,30])
axes.set_ylim([0,10])

labels = ['Mean error','Anomaly amptitude error','Anomaly similarity error']


xdis = [0,6,17]

from matplotlib.patches import Rectangle

for it in range(len(labels)):
    axes.add_patch(Rectangle(xy=(1+xdis[it]-1.3,4-0.1+2), width=1,
        height=1, facecolor=colors[it], edgecolor='white'))
    axes.text(1+xdis[it], 4+0.7-0.5+2.1, labels[it], fontsize=7, 
        horizontalalignment='left',verticalalignment='center')
    
 
axes.yaxis.set_visible(False)
axes.xaxis.set_visible(False)
axes.set_axis_off()

plt.savefig('Fig.3c.png',bbox_inches='tight', dpi=600)          