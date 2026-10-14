import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import xarray as xr
import matplotlib.colors as mcolors
from scipy.stats import linregress
###################################
modeln = ["ACCESS1-0","BCC-CSM1-1","BNU-ESM","CCSM4","CESM1-CAM5","CMCC-CESM",
        "CNRM-CM5","CSIRO-Mk3-6-0","CanESM2","EC-EARTH","FGOALS-g2","FGOALS-s2",
        "GFDL-ESM2M","GISS-E2-H","GISS-E2-R","HadCM3","HadGEM2-ES","IPSL-CM5A-LR",
        "IPSL-CM5A-MR","MIROC-ESM-CHEM","MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3",
        "NorESM1-M","inmcm4",
        "ACCESS-ESM1-5","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",
        "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-0","EC-Earth3",
        "FGOALS-f3-L","FGOALS-g3","FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H",
        "INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR",
        "MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM"]
N_CMIP5 = 26

Pairn = ["ACCESS","BCC-CSM","CESM","CanESM","EC-EARTH","FGOALS-g","GFDL-ESM","GISS-E2",
            "IPSL-CM","INM","MIROC","MPI-ESM","NorESM"]
model_ind = [[7,1,4,8,9,10,12,14,17,25 ,20,22,24],
          [N_CMIP5,N_CMIP5+2,N_CMIP5+5,N_CMIP5+7,N_CMIP5+9,N_CMIP5+11,N_CMIP5+13,N_CMIP5+14,
        N_CMIP5+17,N_CMIP5+16,N_CMIP5+20,N_CMIP5+21,N_CMIP5+25]]  

DEI = np.zeros((2,2,len(Pairn)))
DEI_ErrorPenalty = np.zeros((2,2,len(Pairn),3))

dir = "../eval_data/E-AS.eval.DEI."

f = xr.open_dataset(dir+"pr.JJA.climatemean.nc")
istats = np.array(f['stats'])
iDEI = np.array(f['DEI']) / istats[0,2]
iDEI_ErrorPenalty = np.array(f['ErrorPenalty'])/istats[0,2]

ii = 0
for j in range(2):
    for k in range(len(Pairn)):
        DEI[ii,j,k] = iDEI[model_ind[j][k]]
        DEI_ErrorPenalty[ii,j,k,:] = iDEI_ErrorPenalty[model_ind[j][k],:]

f = xr.open_dataset(dir+"tas.JJA.climatemean.nc")
istats = np.array(f['stats'])
iDEI = np.array(f['DEI']) / istats[0,2]
iDEI_ErrorPenalty = np.array(f['ErrorPenalty'])/istats[0,2]**2

ii = 1
for j in range(2):
    for k in range(len(Pairn)):
        DEI[ii,j,k] = iDEI[model_ind[j][k]]
        DEI_ErrorPenalty[ii,j,k,:] = iDEI_ErrorPenalty[model_ind[j][k],:]       


colors = ['skyblue','orange','yellowgreen','gray']


###################################
Ncontri = 3

Np = len(Pairn)
y = np.linspace(Np,1,Np)

fig = plt.figure(figsize=(14,5))
gs = GridSpec(45,25*2, figure = fig)

#Contribution to CVEI2 change
for i in range(2):
    RC_DEI = (DEI[i,1,:] -DEI[i,0,:])/DEI[i,0,:]*100
    Con_DEI2 = (DEI_ErrorPenalty[i,1,:,:] - DEI_ErrorPenalty[i,0,:,:])
    RCon_DEI2 = np.zeros((Np,3))

       
        
    axes = fig.add_subplot(gs[0:35,(25*i):(25*i+17)])

    for j in range(Np):
        RCon_DEI2[j,:] = Con_DEI2[j,:] /np.sum(Con_DEI2[j,:])*100

        bar0_posi = 0
        bar0_nega = 0

        if np.abs(RC_DEI[j]) > 2:

            if RC_DEI[j] > 0:
                imax = np.max(Con_DEI2[j,:])
            else:
                imax = np.min(Con_DEI2[j,:])

            for jj in range(Ncontri):
                    if Con_DEI2[j,jj] == imax:
                        jtx = np.where(Con_DEI2[j,jj]>0, bar0_posi + Con_DEI2[j,jj]/2, bar0_nega + Con_DEI2[j,jj]/2)

                    if Con_DEI2[j,jj] > 0:
                        bar0_posi = bar0_posi + Con_DEI2[j,jj]
                        axes.barh(y[j], bar0_posi, color=colors[jj], height = 0.4, zorder=Ncontri-jj)
                    else:
                        bar0_nega = bar0_nega + Con_DEI2[j,jj]
                        axes.barh(y[j], bar0_nega, color=colors[jj], height = 0.4, zorder=Ncontri-jj)

                    if Con_DEI2[j,jj] == imax:
                        print(Pairn[j],':',jtx)
                        if imax < 0:
                            print("*")
                            axes.plot(jtx, y[j],marker='^',markersize=3.5,color='white', zorder=Ncontri+1)
                            axes.text(jtx, y[j]+0.2, '%.0f'%(RCon_DEI2[j,jj])+'%', fontsize=10,  fontdict={'color': colors[jj]},
                                horizontalalignment='center',verticalalignment='bottom',weight = 'bold')
                        else:
                            print("*")
                            axes.plot(jtx, y[j],marker='v',markersize=3.5,color='white', zorder=Ncontri+1)
                            axes.text(jtx, y[j]+0.2, '%.0f'%(RCon_DEI2[j,jj])+'%', fontsize=10,  fontdict={'color': colors[jj]},
                                horizontalalignment='center',verticalalignment='bottom',weight = 'bold')
                
            
    xlim = axes.get_xlim()
    if id == 'wind.DJF':
            axes.set_xlim([xlim[0],0.1]) 
    
        
         
    xlim = axes.get_xlim()

 
    for j in range(Np):
            if RC_DEI[j] < 0:
                tcolor = 'blue'
            else:
                tcolor = 'red'

            #axes.text(xlim[1]+(xlim[1]-xlim[0])*0.12, y[i], '%.2f'%CVEI2_chg[i], fontsize=9, 
            #        fontdict={'color': tcolor}, horizontalalignment='right', verticalalignment='center',)  
            axes.text(xlim[1]+(xlim[1]-xlim[0])*0.16, y[j], '%.0f'%RC_DEI[j]+'%', fontsize=10, 
                    fontdict={'color': tcolor}, horizontalalignment='right', verticalalignment='center',) 
    
            axes.plot(xlim,[y[j],y[j]], linewidth=1., color='gainsboro', zorder = -1)

    axes.text(xlim[1]+(xlim[1]-xlim[0])*0.2, y[0]+1.5, 'Relative', fontsize=9, weight = 'bold',
                    fontdict={'color': 'black'}, horizontalalignment='right', verticalalignment='center',) 
    #axes.text(xlim[1]+(xlim[1]-xlim[0])*0.12, y[0]+0.8, ' Relative Chg.', fontsize=9, weight = 'bold',
    #                fontdict={'color': 'black'}, horizontalalignment='right', verticalalignment='center',) 
    axes.text(xlim[1]+(xlim[1]-xlim[0])*0.2, y[0]+0.8, 'nDEI Chg.', fontsize=9, weight = 'bold',
                    fontdict={'color': 'black'}, horizontalalignment='right', verticalalignment='center',) 
    axes.text(xlim[0], y[0]+1.5, ['JJA Pr','JJA Tas'][i], fontsize=12, weight = 'bold',
                    fontdict={'color': 'black'}, horizontalalignment='right', verticalalignment='center',) 
        
    if i == 0:
            axes.text(xlim[0]-(xlim[1]-xlim[0])*0.17, y[0]+2.5, ['a','b'][0], fontsize=19, weight = 'bold',
                    fontdict={'color': 'black'}, horizontalalignment='right', verticalalignment='center',) 
#axes.text(xlim[0]-(xlim[1]-xlim[0])*0.2, y[0]+1, 'b', fontsize=15,  fontdict={'color': 'black'},weight = 'bold',
#                      horizontalalignment='center',verticalalignment='center')

    axes.set_xlim(xlim)

    axes.set_ylim([0.5,Np+0.5])
    axes.tick_params(axis='x', labelsize='10')
    axes.set_xlabel('Changes in error penalty term in nDEI$^{2}$',fontsize=12)
    axes.set_yticks(y)
    axes.set_yticklabels(Pairn,fontsize=12)

    axes.spines['top'].set_visible(False)
    axes.spines['right'].set_visible(False)


    axes.fill_between([0,xlim[1]],0.5,Np+1,fc='gainsboro',alpha=0.3, zorder=-10)

    axes.text(0, Np+1.2, 'Improve ', fontsize=10,  fontdict={'color': 'blue'},weight = 'bold',
                      horizontalalignment='right',verticalalignment='center')
    axes.text(0, Np+1.2, ' Degrade', fontsize=10,  fontdict={'color': 'red'},weight = 'bold',
                      horizontalalignment='left',verticalalignment='center')

#legend
axes = fig.add_subplot(gs[40:44,10:36])

axes.set_xlim([0,30])
axes.set_ylim([0,10])


labels = ['Mean error','Anomaly amptitude error','Anomaly similarity error']

xdis = [0,7,19]

from matplotlib.patches import Rectangle

for it in range(len(labels)):
    axes.add_patch(Rectangle(xy=(1+xdis[it],3-0.1), width=1,
        height=2, facecolor=colors[it], edgecolor='white'))
    axes.text(2.3+xdis[it], 3+0.7, labels[it], fontsize=11, 
        horizontalalignment='left',verticalalignment='center')
    
axes.yaxis.set_visible(False)
axes.xaxis.set_visible(False)
axes.set_axis_off()


 


plt.savefig('Fig.6a.png',bbox_inches='tight',dpi=900) 
             
    


  
   