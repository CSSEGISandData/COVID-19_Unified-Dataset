#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 27 15:07:48 2020

@author: ghkerr
"""
# Load font
import sys
if 'mpl' not in sys.modules:
    import matplotlib.font_manager
    prop = matplotlib.font_manager.FontProperties(
            fname='/Users/ghkerr/Library/Fonts/cmunbmr.ttf')
    matplotlib.rcParams['font.family'] = prop.get_name()
    prop = matplotlib.font_manager.FontProperties(
        fname='/Users/ghkerr/Library/Fonts/cmunbbx.ttf')
    matplotlib.rcParams['mathtext.bf'] = prop.get_name()
    prop = matplotlib.font_manager.FontProperties(
        fname='/Users/ghkerr/Library/Fonts/cmunbmr.ttf')
    matplotlib.rcParams['mathtext.it'] = prop.get_name()
    matplotlib.rcParams['axes.unicode_minus'] = False
    # change width and thickness of ticks/spines
    matplotlib.rcParams['axes.linewidth'] = 1.0
    matplotlib.rcParams['xtick.major.width'] = 1.0
    matplotlib.rcParams['xtick.minor.width'] = 1.0
    matplotlib.rcParams['ytick.major.width'] = 1.0
    matplotlib.rcParams['ytick.minor.width'] = 1.0

# # # # # FIGURE 1
# import numpy as np
# import matplotlib.pyplot as plt
# import matplotlib as mpl
# import cartopy
# import cartopy.io.shapereader as shpreader
# import cartopy.feature as cfeature
# import cartopy.crs as ccrs
# from matplotlib import cm
# from cartopy.util import add_cyclic_point
# import matplotlib
# from collections import Counter
# # Read shapefile and extract country names
# shpfilename = shpreader.natural_earth(resolution='50m',
#     category='cultural', name='admin_0_countries')
# reader = shpreader.Reader(shpfilename)
# # All country names in shapefile
# globalcountries = []
# countries = reader.records()
# for country in countries:
#     globalcountries.append(country.attributes['NAME'])
# # Singapore, Bahrain, Liechtenstein, Guadeloupe, Reunion, San Marino
# # Eswatini, Antigua and Barbuda, Saint lucia, Mayotte, Mauritius, Aruba, 
# # Barbados, Seychelles, Monaco, French Guinea, French Guyana, Andorra, 
# # Malta, Macedonia, Martinique, Maldives in shapefiles 
# shi2020 = ['China']
# xie2020 = ['China']
# tosepu2020 = ['Indonesia']
# qi2020 = ['China']
# kassem2020 = ['United States of America', 'Italy', 'Spain', 'China', 
#     'Germany', 'France', 'United Kingdom', 'South Korea', 'Australia', 
#     'Sweden', 'Malaysia', 'Japan', 'Russia', 'Philippines', 'Thailand', 
#     'Finland', 'Singapore', 'Hong Kong',  'Taiwan', 'Vietnam', 'Sri Lanka', 
#     'Cambodia', 'Macau', 'Nepal', 'Iran', 'Switzerland', 'Belgium', 
#     'Netherlands', 'Austria', 'Brazil', 'Israel', 'Norway', 'Ireland', 
#     'Czechia', 'Denmark', 'Argentina', 'Egypt', 'Iraq', 'Lebanon']
# ficetola2020 = ['Albania', 'Algeria', 'Argentina', 'Australia', 'Austria', 
#     'Bahrain', 'Belarus', 'Belgium', 'Brazil', 'Brunei', 'Bulgaria', 
#     'Canada', 'Chile', 'China', 'Costa Rica', 'Croatia', 'Cyprus', 
#     'Czechia', 'Denmark','Ecuador', 'Egypt', 'Estonia', 'Finland', 
#     'France', 'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', 
#     'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 
#     'Japan', 'South Korea',  'Kuwait', 'Latvia', 'Lebanon', 'Luxembourg', 
#     'Malaysia', 'Mexico', 'Netherlands', 'Norway', 'Pakistan', 'Panama', 
#     'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania', 
#     'Russia', 'Saudi Arabia', 'Serbia', 'Singapore', 'Slovakia', 
#     'Slovenia', 'South Africa', 'Spain', 'Sweden', 'Switzerland', 'Taiwan', 
#     'Thailand', 'United Arab Emirates', 'United Kingdom', 
#     'United States of America', 'Vietnam']
# ma2020 = ['China']
# correaaraneda2020 = ['Chile']
# auler2020 = ['Brazil']
# kapoor2020 = ['United States of America']
# jwang2020 = ['China']
# sahin2020 = ['Turkey']
# ahmadi2020 = ['Iran']
# roy2020 = ['India']
# yao2020 = ['China']
# bannistertyrrell2020 = ['Canada', 'United States', 'Brazil', 'Nigeria', 
#     'Egypt', 'Algeria', 'Oman', 'Israel', 'Lebanon', 'Spain', 'France', 
#     'United Kingdom', 'Belgium', 'Netherlands', 'Germany', 'Italy', 
#     'Croatia', 'Austria', 'Russia', 'Switzerland', 'Norway', 'Sweden', 
#     'Finland', 'Estonia', 'Lithuania', 'Georgia', 'Iraq', 'Iran', 
#     'United Arab Emirates', 'Bahrain', 'Afghanistan', 'Pakistan', 
#     'India', 'Sri Lanka', 'Nepal', 'Thailand', 'Malaysia', 'Vietnam', 
#     'Cambodia', 'China', 'South Korea', 'Japan', 'Philippines', 
#     'Australia', 'Palestine', 'Liechtenstein', 'Romania']
# oliverios2020 = ['China'] 
# chen2020 = ['China']
# mollalo2020 = ['United States of America']
# ujiie2020 = ['Japan']
# poirier2020 = ['China']
# guo2020 = ['China']
# yudistira2020 = ['Indonesia']
# bukhari2020 = ['China', 'Italy', 'Iran', 'Spain', 'Germany', 'France',
#     'South Korea', 'Switzerland', 'United Kingdom', 'Netherlands', 
#     'Austria', 'Belgium', 'Norway', 'Sweden', 'United States of America',
#     'Denmark', 'Japan', 'Malaysia', 'Portugal', 'Czechia', 'Israel',
#     'Brazil', 'Ireland', 'Qatar', 'Pakistan', 'Greece', 'Finland', 
#     'Poland', 'Singapore', 'Luxembourg', 'Iceland', 'Indonesia', 
#     'Australia', 'Slovenia', 'Bahrain', 'Romania', 'Saudi Arabia', 
#     'Thailand', 'Estonia', 'Canada', 'Egypt', 'Chile', 'Peru', 
#     'Philippines', 'Ecuador', 'Russia', 'India', 'Iraq', 'Turkey', 
#     'Lebanon', 'South Africa', 'Kuwait', 'United Arab Emirates', 
#     'Slovakia', 'San Marino', 'Mexico', 'Armenia', 'Panama', 'Taiwan',
#     'Croatia', 'Serbia', 'Colombia', 'Argentina', 'Bulgaria', 'Algeria',
#     'Latvia', 'Vietnam', 'Uruguay', 'Brunei', 'Hungary', 'Costa Rica', 
#     'Jordan', 'Cyprus', 'Albania', 'Bosnia and Herz.', 'Morocco',
#     'Sri Lanka', 'Andorra', 'Malta', 'Belarus', 'Moldova', 'Macedonia', 
#     'Oman', 'Azerbaijan', 'Kazakhstan', 'Venezuela', 'Georgia', 
#     'Tunisia', 'Cambodia', 'Lithuania', 'Dominican Rep.', 
#     'Burkina Faso', 'Guadeloupe', 'Senegal', 'Liechtenstein',
#     'New Zealand', 'Martinique', 'Uzbekistan', 'Afghanistan', 
#     'Bangladesh', 'Ukraine', 'Jamaica', 'Congo', 'Reunion', 'Cameroon',
#     'Maldives', 'Bolivia', 'Honduras', 'Cuba', 'French Guiana', 
#     'Ghana', 'Paraguay', 'CÃ´te d\'Ivoire', 'Guatemala', 
#     'Trinidad and Tobago', 'Nigeria', 'Rwanda', 'Guyana', 'Kenya', 
#     'Monaco', 'Eq. Guinea', 'Ethiopia', 'Mongolia', 'Seychelles',
#     'Tanzania', 'Barbados', 'Aruba', 'Bahamas', 'Congo', 'Kyrgyzstan',
#     'Mauritius', 'Mayotte', 'Montenegro', 'Namibia', 'Benin', 'Kosovo',
#     'Liberia', 'Mauritania', 'Saint Lucia', 'Sudan', 'Zambia', 
#     'Antigua and Barbuda', 'Bhutan',  'Central African Rep.', 'Chad',
#     'Djibouti', 'El Salvador', 'eSwatini', 'Fiji']
# mwang2020 = ['China', 'Taiwan', 'Australia', 'Belgium', 'Brazil', 
#     'Cambodia', 'Canada', 'Finland', 'France', 'Germany', 'India', 
#     'Italy', 'Japan', 'South Korea', 'Malaysia', 'Nepal', 'Philippines', 
#     'Russia', 'Singapore', 'Spain', 'Sri Lanka', 'Sweden', 'Thailand', 
#     'United Arab Emirates', 'United Kingdom', 'United States of America', 
#     'Vietnam']
# sajadi2020 = ['China', 'Japan', 'Iran', 'Italy', 'South Korea',  
#     'United States of America', 'United Kingdom', 'Germany', 'Spain', 
#     'Norway', 'Egypt', 'Thailand', 'Australia', 'Philippines', 
#     'Indonesia', 'France', 'Canada', 'Russia', 'Colombia', 'Brazil', 
#     'Finland', 'Iraq', 'Mexico', 'Cuba', 'Nicaragua', 'El Salvador', 
#     'Argentina', 'Chile', 'Paraguay', 'Uruguay', 'Saudi Arabia', 
#     'Senegal', 'Nigeria', 'Angola', 'Ethiopia', 'Mozambique', 
#     'South Africa', 'Greece', 'Poland', 'Algeria', 'Ukraine', 'Israel', 
#     'Kazakhstan', 'India', 'Vietnam', 'Cambodia', 'Malaysia', 'Sri Lanka', 
#     'New Zealand', 'Papua New Guinea']
# islam2020 = ['China', 'Italy', 'Iran', 'South Korea', 'France', 'Spain', 
#     'Germany', 'Norway', 'Switzerland', 'Japan', 'Denmark', 'Sweden', 
#     'Netherlands', 'United Kingdom', 'United States of America', 
#     'Belgium', 'Austria', 'Qatar', 'Ukraine', 'Turkey', 'Togo', 
#     'Reunion', 'Nepal', 'Mongolia', 'Liechtenstein', 'Jordan', 
#     'Holy See', 'Guyana', 'CÃ´te d\'Ivoire', 'Congo', 'Canada', 'Bhutan', 
#     'Andorra', 'Sri Lanka', 'Nigeria', 'Monaco', 'Jamaica', 'Honduras', 
#     'Denmark', 'Cameroon', 'Burkina Faso', 'Bolivia', 'Moldova', 
#     'Martinique', 'Lithuania', 'Cuba', 'Cambodia', 'Bangladesh',
#     'Australia', 'Senegal', 'Armenia', 'Paraguay', 'New Zealand', 
#     'French Guiana', 'Dominican Rep.', 'Morocco', 'Malta', 'Cyprus', 
#     'Tunisia', 'Macedonia', 'Bulgaria', 'Afghanistan', 'Maldives', 
#     'Colombia', 'Latvia', 'Panama', 'Brunei', 'Bosnia and Herz.',
#     'Azerbaijan', 'Mexico', 'Belarus', 'Hungary', 'Peru', 'Slovakia', 
#     'Estonia', 'South Africa', 'Ecuador', 'Oman', 'Serbia', 'Luxembourg', 
#     'Croatia', 'Argentina', 'Pakistan', 'Costa Rica', 'Chile', 'Albania', 
#     'Georgia', 'Algeria', 'Russia', 'Indonesia', 'Vietnam', 'Ireland', 
#     'Saudi Arabia', 'Taiwan', 'Romania', 'Poland', 'Philippines', 'Brazil', 
#     'Portugal', 'Finland', 'Lebanon', 'Egypt', 'San Marino', 'Thailand', 
#     'Iraq', 'India', 'Kuwait', 'United Arab Emirates', 'Slovenia', 
#     'Czechia', 'Greece', 'Iceland', 'Israel', 'Malaysia', 'Singapore', 
#     'Bahrain']
# merow2020 = ['China', 'Iceland', 'Estonia', 'Burkina Faso', 'Sweden', 
#     'Cambodia', 'San Marino', 'Iraq', 'Latvia', 'Kuwait', 'Finland', 
#     'Norway', 'Brunei', 'Liechtenstein', 'Slovakia', 'Bahrain', 'Qatar', 
#     'Senegal', 'Belarus', 'Vietnam', 'Trinidad and Tobago', 'Palestine', 
#     'Georgia', 'Oman', 'Venezuela', 'Taiwan', 'Paraguay', 'Denmark', 
#     'Malta', 'Albania', 'Japan', 'Slovenia', 'United Arab Emirates', 
#     'Sri Lanka', 'Lithuania', 'Netherlands', 'Nigeria', 'Singapore', 
#     'CÃ´te d\'Ivoire', 'Egypt', 'Uruguay', 'Hungary', 'Ghana', 'Jordan', 
#     'Rwanda', 'Ireland', 'Montenegro', 'Uzbekistan', 'Dem. Rep. Congo', 
#     'Bulgaria', 'Poland', 'Tunisia', 'Lebanon', 'Cyprus', 
#     'United Kingdom', 'Bangladesh', 'Croatia', 'Moldova', 'Belgium', 
#     'Bosnia and Herz.', 'Luxembourg', 'Greece', 'Azerbaijan', 
#     'New Zealand', 'Germany', 'Kazakhstan', 'Australia', 'Kyrgyzstan', 
#     'Macedonia', 'Thailand', 'Mauritius', 'Honduras', 'Serbia', 
#     'Algeria', 'Romania', 'Afghanistan', 'Cameroon', 'Czechia', 
#     'Costa Rica', 'Saudi Arabia', 'France', 'Bolivia', 'Russia', 'Andorra', 
#     'Cuba', 'Morocco', 'Armenia', 'South Africa', 'India', 'Indonesia', 
#     'Argentina', 'Austria', 'Ukraine', 'South Korea', 'Malaysia', 
#     'Panama', 'Pakistan', 'Dominican Rep.', 'Israel', 'Colombia', 
#     'Canada', 'Philippines', 'Switzerland', 'Italy', 'Mexico', 
#     'Ecuador', 'Chile', 'Peru', 'Portugal', 'Spain', 
#     'United States of America', 'Iran', 'Turkey', 'Brazil']
# carleton2020 = ['Greenland', 'French Guiana', 'W. Sahara', 'Mali', 
#     'Libya', 'Sierra Leone', 'Guinea-Bissau', 'Burundi', 'Malawi', 
#     'Botswana', 'Lesotho', 'Palestine', 'Syria', 'Yemen', 'Turkmenistan', 
#     'Tajikistan', 'Myanmar', 'Laos', 'North Korea']
# carleton2020 = set(globalcountries)-set(carleton2020)
# araujo2020 = globalcountries
# xu2020 = globalcountries
# notari2020 = ['Argentina', 'Australia', 'Belgium', 'Brazil', 'Canada', 
#     'Chile', 'China', 'Czechia', 'Denmark', 'Egypt', 'Finland', 'France', 
#     'Germany', 'Greece', 'Iceland', 'India', 'Indonesia', 'Iran', 
#     'Ireland', 'Israel', 'Italy', 'Lebanon', 'Japan', 'Malaysia', 
#     'Netherlands', 'Norway', 'Philippines', 'Poland', 'Portugal', 
#     'Romania', 'Saudi Arabia', 'Singapore', 'Slovenia', 'South Korea', 
#     'Spain', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand', 
#     'United Arab Emirates', 'United Kingdom', 'United States of America', 
#     'Albania', 'Andorra', 'Algeria', 'Armenia', 'Austria', 'Bahrain', 
#     'Bosnia and Herz.', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Cambodia', 
#     'Colombia', 'Costa Rica', 'Croatia', 'Cyprus', 'Dominican Rep.', 
#     'Ecuador', 'Estonia', 'Hungary', 'Iraq', 'Jordan', 'Kazakhstan',
#     'Kuwait', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Mexico', 
#     'Moldova', 'Morocco', 'New Zealand', 'Macedonia', 'Oman', 'Panama', 
#     'Pakistan', 'Peru', 'Qatar', 'Russia', 'Senegal', 'Serbia', 
#     'Slovakia', 'South Africa', 'Tunisia', 'Turkey', 'Ukraine', 'Uruguay', 
#     'Vietnam', 'Belarus', 'Bolivia', 'Cameroon', 'Congo', 
#     'CÃ´te d\'Ivoire', 'Cuba', 'Dem. Rep. Congo', 'Djibouti', 
#     'El Salvador', 'Georgia', 'Ghana', 'Guatemala', 'Guinea', 'Honduras', 
#     'Jamaica', 'Kenya', 'Kosovo', 'Kyrgyzstan', 'Madagascar', 'Mali', 
#     'Mauritius', 'Montenegro', 'Niger', 'Nigeria', 'Paraguay', 'Rwanda', 
#     'Sri Lanka', 'Togo', 'Trinidad and Tobago', 'Uganda', 
#     'Uzbekistan', 'Venezuela', 'Zambia']
# runkle2020 = ['United States of America']
# caspi2020 = ['United Kingdom', 'Switzerland', 'Netherlands', 'Belgium', 
#     'Iceland', 'Italy', 'Canada', 'Austria', 'France', 'Germany', 'Norway',
#     'Spain', 'Sweden', 'Egypt', 'Bahrain', 'Singapore', 'Malaysia', 
#     'Australia', 'Thailand', 'Iraq', 'United States of America',
#     'Japan', 'Greece', 'South Korea']
# bashir2020 = ['United States of America']
# to2020 = ['Canada']
# taiwo2020 = ['Nigeria']
# byass2020 = ['China']
# ropsario2020 = ['Brazil']
# kaplin2020 = ['Algeria', 'Armenia', 'Austria', 'Belgium', 
#     'Bosnia and Herz.', 'Croatia', 'Czechia', 'Egypt', 'Estonia', 
#     'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Iceland', 'India', 
#     'Iran', 'Iraq', 'Ireland', 'Israel', 'Japan', 'Kuwait', 'Lebanon', 
#     'Malaysia', 'Mexico', 'Moldova', 'Morocco', 'Netherlands', 'Norway', 
#     'Oman', 'Pakistan', 'Philippines', 'Poland', 'Portugal', 'Qatar', 
#     'Romania', 'Saudi Arabia', 'Serbia', 'Singapore', 'Slovakia', 'Slovenia', 
#     'South Korea', 'Spain', 'Sweden', 'Switzerland', 'Thailand', 'Turkey', 
#     'United Arab Emirates', 'United Kingdom', 'Vietnam']
# lin2020 = ['United States of America']
# ma2020 = ['United States of America']
# jamil2020 = ['United States of America', 'Spain', 'China', 'South Africa', 
#     'South Korea', 'Turkey', 'Austria', 'Germany', 'Bangladesh', 'France',
#     'United Kingdom', 'Saudi Arabia', 'Canada', 'Netherlands', 'Italy', 
#     'Australia', 'Israel', 'Cameroon', 'Djibouti', 'Switzerland', 'Portugal',
#     'Philippines', 'Malaysia', 'India', 'Russia', 'Algeria', 'Belarus', 
#     'Belgium', 'Peru', 'United Arab Emirates', 'Luxembourg', 'Argentina',
#     'Thailand', 'Romania', 'New Zealand', 'Ukraine', 'Iran', 'Uzbekistan', 
#     'Poland', 'Chile', 'Azerbaijan', 'Indonesia', 'Czechia', 'Panama',
#     'Colombia', 'Serbia', 'Norway', 'Maldives', 'Brazil', 'Pakistan', 'Zambia',
#     'Ireland', 'Tunisia', 'Tajikistan', 'Haiti', 'Moldova', 'Armenia', 'Nepal',
#     'Morocco', 'Croatia', 'Sudan', 'Hungary', 'Iceland', 'Guinea-Bissau', 
#     'Guinea', 'Sweden', 'Lithuania', 'Dominican Rep.', 'Iraq', 'Ecuador', 
#     'Bosnia and Herz.', 'Honduras', 'Kyrgyzstan', 'Greece', 'Finland', 
#     'Costa Rica', 'Oman', 'Denmark', 'Estonia', 'Nigeria', 'Singapore', 
#     'Macedonia', 'Kosovo', 'Lebanon', "CÃ´te d'Ivoire", 'Mexico', 'Kazakhstan', 
#     'Slovenia', 'Qatar', 'Gabon', 'Kuwait', 'Ghana', 'Cuba', 'Somalia', 
#     'Japan', 'Latvia', 'Afghanistan', 'Bolivia', 'Mali', 'Guatemala', 
#     'Slovakia', 'Egypt', 'El Salvador', 'Senegal', 'Bahrain', 'Albania', 
#     'Congo', 'Bulgaria', 'Ethiopia', 'Sri Lanka', 'Kenya', 'Eq. Guinea',
#     'Venezuela']
# # Concatenate studies' countries
# studies = np.concatenate([shi2020, xie2020, tosepu2020, 
#     qi2020, kassem2020, ficetola2020, ma2020, correaaraneda2020, 
#     auler2020, kapoor2020, jwang2020, sahin2020, ahmadi2020, roy2020, 
#     yao2020, bannistertyrrell2020, oliverios2020, chen2020, mollalo2020, 
#     ujiie2020, poirier2020, guo2020, yudistira2020, bukhari2020,
#     mwang2020, sajadi2020, islam2020, merow2020, list(carleton2020), 
#     araujo2020, xu2020, notari2020, runkle2020, caspi2020, bashir2020, 
#     to2020, taiwo2020, byass2020, ropsario2020, kaplin2020, lin2020, ma2020,
#     jamil2020])
# # Count occurrences in list
# counts_studies = Counter(studies)
# # Initialize figure, axis
# fig = plt.figure(figsize=(12,4))
# ax = plt.subplot2grid((1,2),(0,0), projection=ccrs.Miller(
#     central_longitude=0))
# ax2 = plt.subplot2grid((1,2),(0,1))
# ax.set_title('(a)', fontsize=14, loc='left')
# ax2.set_title('(b)', fontsize=14, loc='left')
# ocean_50m = cfeature.NaturalEarthFeature('physical', 'ocean', '50m',
#     edgecolor=None, facecolor='lightgrey', alpha=0.6)
# ax.add_feature(ocean_50m)
# land_50m = cfeature.NaturalEarthFeature('physical', 'land', '50m',
#     edgecolor='k', linewidth=0.05, facecolor=None)
# ax.add_feature(land_50m)
# ax.add_feature(cfeature.BORDERS.with_scale('50m'), zorder=10, 
#     linewidth=0.05)
# ax.set_extent([-180, 180, -58, 85], ccrs.PlateCarree())
# # # Reinitialize countries
# countries = reader.records()
# vmin = 1
# vmax = 18
# # Define the bins and normalize
# bounds = np.arange(vmin-1, vmax+1, 1)
# cmap = plt.get_cmap('YlGnBu_r')
# norm = mpl.colors.BoundaryNorm(bounds, cmap.N)
# # extract all colors from the .jet map
# cmaplist = [cmap(i) for i in range(cmap.N)]
# # create the new map
# cmap = mpl.colors.LinearSegmentedColormap.from_list(
#     'Custom cmap', cmaplist, cmap.N)
# for country in countries:
#     # Loop through countries with COVID-climate studies
#     # if country.attributes['NAME'] in counts_studies.keys():
#     geom = [country.geometry]
#     # Look up number of studies focused on particular country 
#     frequency = counts_studies[country.attributes['NAME']]
#     facecolor = cmap(norm(frequency))
#     g = ax.add_geometries(geom, ccrs.PlateCarree(), facecolor=facecolor, 
#         linewidth=0.05, edgecolor='k')
# plt.subplots_adjust(left=0.01)
# # Custom colorbar
# position=fig.add_axes([ax.get_position().x0, 0.14,
#     ax.get_position().x1-ax.get_position().x0, 0.02])
# cb = fig.colorbar(mpl.cm.ScalarMappable(cmap=cmap, norm=norm),
#     cax=position, boundaries=bounds, extend='max',
#     ticks=bounds, spacing='proportional', orientation='horizontal')
# # Center ticks
# loc = np.array(bounds) + .5
# cb.set_ticks(loc[::2])
# cb.set_ticklabels(bounds[::2])
# cb.set_label(label='Number of studies', size=14)
# cb.ax.tick_params(labelsize=11)
# # Second subplot
# shi2020 = ['temperature', 'humidity']
# xie2020 = ['temperature', 'humidity', 'pressure', 'wind']
# sobral2020 = ['temperature', 'precipitation']
# carleton2020 = ['temperature', 'precipitation', 'humidity']
# ficetola2020 = ['temperature', 'humidity']
# tosepu2020 =  ['temperature', 'humidity', 'precipitation']
# qi2020 = ['temperature', 'humidity']
# kassem2020 = ['temperature']
# ma2020 = ['temperature', 'humidity']
# correaaraneda2020 = ['temperature', 'humidity', 'precipitation', 'pressure', 
#     'radiation', 'wind']
# auler2020 = ['temperature', 'humidity', 'precipitation']
# kapoor2020 = ['temperature', 'precipitation']
# jwang2020 = ['temperature', 'humidity']
# sahin2020 = ['temperature', 'humidity', 'wind']
# ahmadi2020 = ['temperature', 'precipitation', 'humidity', 'wind', 'radiation']
# roy2020 = ['temperature', 'humidity']
# yao2020 = ['temperature', 'humidity', 'radiation']
# bannistertyrrell2020 = ['temperature']
# oliverios2020 = ['temperature', 'humidity', 'precipitation', 'wind']
# chen2020 = ['temperature', 'wind', 'visibility']
# merow2020 = ['temperature', 'humidity', 'radiation']
# araujo2020 = ['temperature', 'precipitation', 'radiation', 'evapotranspiration'] 
# notari2020 = ['temperature']
# mwang2020 = ['temperature']
# sajadi2020 = ['temperature', 'humidity']
# islam2020 = ['temperature', 'wind', 'humidity']
# poirier2020 = ['temperature', 'humidity']
# guo2020 = ['temperature', 'humidity']
# yudistira2020 = ['radiation']
# xu2020 = ['temperature', 'humidity', 'pressure', 'precipitation', 
#     'snowfall', 'wind', 'radiation']
# bukhari2020 = ['temperature', 'humidity', 'wind']
# mollalo2020 = ['temperature']
# ujiie2020 = ['temperature']
# bashir2020 = ['temperature', 'precipitation', 'humidity', 'wind']
# caspi2020 = ['temperature', 'humidity', 'wind', 'precipitation']
# runkle2020 = ['temperature', 'humidity', 'radiation']
# to2020 = ['temperature']
# taiwo2020 = ['temperature']
# byass2020 = ['temperature', 'radiation', 'precipitation']
# rosario2020 = ['temperature', 'humidity', 'radiation', 'wind', 'precipitation']
# jamil2020 = ['temperature']
# kaplin2020 = ['temperature', 'humidity']
# lin2020 = ['humidity']
# ma2020 = ['temperature', 'humidity']
# # Concatenate studies' variables
# studies = np.concatenate([shi2020, xie2020, tosepu2020, 
#     qi2020, kassem2020, ficetola2020, ma2020, correaaraneda2020, 
#     auler2020, kapoor2020, jwang2020, sahin2020, ahmadi2020, roy2020, 
#     yao2020, bannistertyrrell2020, oliverios2020, chen2020, mollalo2020, 
#     ujiie2020, poirier2020, guo2020, yudistira2020, bukhari2020,
#     mwang2020, sajadi2020, islam2020, merow2020, carleton2020, 
#     araujo2020, xu2020, notari2020, bashir2020, caspi2020, runkle2020, 
#     to2020, taiwo2020, byass2020, rosario2020, jamil2020, kaplin2020, lin2020,
#     ma2020])
# unique_variables, variable_counts = np.unique(studies, return_counts=True)
# # Kludgey; this part is done manually 
# variables = ['Temperature', 
#     'Humidity', 
#     'Precipitation', 
#     'Wind', 
#     'Radiation',
#     'Pressure', 
#     'Other']
# counts = [41, # Temperature
#     29, # Humidity
#     13, # Precipitation
#     12, # Wind
#     10, # Radiation
#     3, # Pressure 
#     3] # Other = evapotranspiration, snowfall, visibility
# bar_l = np.arange(1, len(variables)+1, 1)
# # Plotting
# # f, (ax) = plt.subplots(1, 1, figsize=(8.5,5))
# ax2.bar(variables, counts, color='silver')
# # Add number of studies above each plot 
# counts_labels = ['41', '29', '13', '12', '10', '3', '3*']
# for i, v in enumerate(counts):
#     ax2.text(i,v+0.5, counts_labels[i], color='k', ha='center', fontsize=11)
# # Add text below plot to explain "Other"
# ax2.text(3.2, 32, '*', fontsize=11)
# ax2.text(3.4, 30.8, 'Visibility (1), Snowfall (1),\nEvapotranspiration (1)', 
#     fontsize=11)
# # Aesthetics
# ax2.xaxis.set_tick_params(labelsize=11)
# ax2.set_ylabel('Number of studies', fontsize=14)
# ax2.set_ylim([0, 42])
# ax2.set_yticks([0, 7, 14, 21, 28, 35, 42])
# ax2.set_yticklabels(['0', '7', '14', '21', '28', '35', '42'], fontsize=11)
# # Hide the right and top spines
# ax2.spines['right'].set_visible(False)
# ax2.spines['top'].set_visible(False)
# # Shift ax2 to match ax
# ax_pos = ax.get_position()
# ax2.set_position([0.48, ax_pos.y0, (ax_pos.x1-ax_pos.x0)+0.1, 
#     (ax_pos.y1-ax_pos.y0)])
# plt.savefig('/Users/ghkerr/COVID/figs/'+'fig1_revised.pdf', dpi=1000)





   

# import numpy as np
# import pandas as pd
# import matplotlib.pyplot as plt
# import matplotlib.patches as mpatches
# columns = ['Citation', 'HindcastStart', 'HindcastEnd', 
#             'TempRelationship', 'TempNotes',
#             'HumidityRelationship', 'HumidityNotes']
# carleton2020 = ['Carleton et al. (2020)$^\mathbf{{\dagger}}$',
#                 '2020-01-01',
#                 '2020-04-10',
#                 'Non-significant',
#                 'Cumulative effects of tempreature and humidity are not statistically significant',
#                 'Non-significant',
#                 'Cumulative effects of tempreature and humidity are not statistically significant']

# merow2020 = ['Merow & Urban (2020)$^\mathbf{{\dagger}}$',
#               '2020-02-01',
#               '2020-04-13',
#               'Positive',
#               'Temperature significantly positively affects growth rate',
#               'Non-significant',
#               'Humidity negatively decreased growth rates, but not significantly']

# jwang2020 = ['J. Wang et al. (2020)', 
#             '2020-01-21',
#             '2020-01-23',
#             'Negative',
#             'A 1$^{\circ}$C increase in temperature significantly lowers R$_e$ '+
#             'by 0.0225',
#             'Negative',
#             'A 1% increase in relative humidity significantly lowers R$_e$ by 0.0158']

# ma2020 = ['Ma et al. (2020)$^\mathbf{{\dagger}}$', 
#           '2020-01-20',
#           '2020-02-29',
#           'Positive',
#           'A positive association is found between daily death counts and diurnal\ntemperature range',
#           'Negative',
#           'Absolute humidity is negatively associated with daily death counts']

# bannister2020 = ['Meyer et al. (2020)$^\mathbf{{\dagger}}$',
#                   '2020-01-01',
#                   '2020-02-29',
#                   'Negative',
#                   'There is a negative correlation in the number of cases for temperature > 1$^{\circ}$C',
#                   '',
#                   '']

# sajadi2020 = ['Sajadi et al. (2020)$^\mathbf{{\dagger}}$',
#               '2020-01-01',
#               '2020-02-29',
#               'Neutral',
#               'Regions with significant community spread have average temperatures of 5-11$^{\circ}$C',
#               'Neutral',
#               'Regions with significant community spread have an average specific humidity of 3-6 g kg$^{-1}$\nand an average absolute humidity of 4-7 g m$^{-3}$']

# araujo2020 = ['Araújo & Naimi (2020)',
#               '2020-01-22',
#               '2020-03-22',
#               'Neutral',
#               'Positive cases are associated with a mean temperature of 5.81$^{\circ}$C', 
#               '',
#               '']

# bukhari2020 = ['Bukhari et al. (2020)$^\mathbf{{\dagger}}$',
#                 '2020-01-20',
#                 '2020-03-19',
#                 'Neutral',
#                 'A majority of cases (> 90%) occur when temperatures are in the range 3-17$^{\circ}$C', 
#                 'Neutral',
#                 'A majority of cases developed in regions with an absolute humidity of 3-9 g m$^{-1}$']
               
# chen2020 = ['Chen et al. (2020)',
#             '2020-01-20',
#             '2020-03-11',
#             'Non-significant',
#             'Changes in a single weather factor do not correlate\nwell '+
#             'with cases',
#             'Non-significant',
#             'Changes in a single weather factor do not\ncorrelate well '+
#             'with cases']

# shi2020 = ['Shi et al. (2020)',
#             '2020-01-20',
#             '2020-02-29',
#             'Negative',
#             'Transmission rate significantly decreases as temperature increases',
#             'Non-significant',
#             'No significant relationship between incidence and absolute humidity\nwas found']

# xu2020 = ['Xu et al. (2020)',
#           '2019-12-12',
#           '2020-04-22',
#           'Negative',
#           'For temperature > 25$^{\circ}$C, there is a significant 3.1% reduction in $\widehat{\mathregular{R}}$',
#           'Negative',
#           'For temperature > 25$^{\circ}$C, a 10% increase in relative humidity is\nassociated with a 1.2% decrease in transmission']
 
# oliveiros2020 = ['Oliveiros et al. (2020)',
#             '2020-01-23',
#             '2020-03-01',
#             'Negative',
#             'A 20$^{\circ}$C temperature increase significantly delays the doubling\ntime by 1.8 days',
#             'Positive',
#             'There is a significant negative association between doubling time and\nhumidity']

# qi2020 = ['Qi et al. (2020)$^\mathbf{{\dagger}}$',
#           '2019-12-01',
#           '2020-02-11',
#           'Negative',
#           'A 1$^{\circ}$C increase in temperature leads to a signficant decrease '+
#           'in cases by 36-57%',
#           'Negative',
#           'Relative humidity is significantly negatively associated with cases']


# xie2020 = ['Xie & Zhu (2020)$^\mathbf{{\dagger}}$',
#           '2020-01-23',
#           '2020-02-29',
#           'Positive',
#           'A 1$^{\circ}$C increase in mean temperature (for temperature < 3$^{\circ}$C) was\nassociated with a significant 5% increase in the daily confirmed cases',
#           '',
#           '']

# guo2020 = ['Guo et al. (2020)$^\mathbf{{\dagger}}$',
#             '2020-01-24',
#             '2020-02-13',
#             'Negative',
#             'R$_{0}$ significantly decreases as the temperature increases ($r$(T, R$_{0}$) < 0)',
#             'Negative',
#             'R$_{0}$ significantly decreases as the humidity increases ($r$(RH, R$_{0}$) < 0)']

# mwang2020 = ['M. Wang et al. (2020)',
#               '2020-01-20',
#               '2020-02-04',
#               'Neutral',
#               'The effect of temperature on cases is non-linear, and transmission reaches a maximum for temperatures of 0-10$^{\circ}$C',
#               '',
#               '']

# poirier2020 = ['Poirier et al. (2020)$^\mathbf{{\dagger}}$',
#             '2020-01-22',
#             '2020-02-26',
#             'Non-significant',
#             'Temperature and humidity cannot explain the variability of R$_{0}$', 
#             'Non-significant',
#             'Temperature and humidity cannot explain the variability of R$_{0}$']

# alvarezramirez2020 = ['Alvarez-Ramirez\net al. (2020)',
#     '2020-01-29',
#     '2020-03-06',
#     'Negative',
#     'The correlation between temperature and cases is negative\nwhen temperature is lagged by 6 days',
#     'Positive',
#     'The correlation between relative humidity and cases is positive\nand acheives a maximum value when humidity is lagged\n6-7 days']

# yao2020 = ['Yao et al. (2020)$^\mathbf{{\dagger}}$',
#         '2020-01-01',
#         '2020-03-01',
#         'Non-significant',
#         'There is no signficant association of maximum or minimum\ntemperature with the incidence rate or R$_{0}$',
#         'Non-significant',
#         'Relative humidity is not signficantly associated with the incidence rate\nor R$_{0}$']

# sobral2020 = ['Sobral et al. (2020)$^\mathbf{{\dagger}}$',
#         '2019-12-01',
#         '2020-03-28',
#         'Negative',
#         'There was a negative significant correlation between the average temperature per country\nand the number of cases (6.4 cases/day reduction for 1$^{\circ}$F temperature increase)', 
#         '',
#         '']

# kassem2020 = ['Kassem et al. (2020)',
#               '2020-01-01',
#               '2020-04-05',
#               'Non-significant',
#               'Countries with their first cases reported in Janaury do not\nshow a significant association with temperature', 
#               '',
#               '']

# kassem2020b = ['Kassem et al. (2020)',
#               '2020-02-01',
#               '2020-04-05',
#               'Negative',
#               'Countries with their first cases reported in February show a significant negative\nrelationship between temperature and cases',
#               '',
#               '']

# caspi2020 = ['Caspi et al. (2020)',
#               '2020-01-01',
#               '2020-03-19',
#               'Negative',
#               'Temperature moderately negatively correlated with replication rate ($r$=-0.69) and rate of spread ($r$=-0.72)',
#               'Non-significant',
#               'Humidity is not significantly correlated with rate of spread or replication rate']

# jamil2020 = ['Jamil et al. (2020)$^\mathbf{{\dagger}}$',
#     '2020-02-01',
#     '2020-05-31', 
#     'Non-significant',
#     'There is no evidence for thermal\ndependence of the transmission\nacross the 1-34$^{\circ}$C temperature\nrange across the affected countries',
#     '',
#     '']

# kaplin2020 = ['Kaplin et al. (2020)',
#     '2020-01-22', 
#     '2020-04-06', 
#     'Negative',
#     'This corresponds to a 1.03% decrease in confirmed cases for each degree increase\nin temperature and a 3.68% increase for each degree decrease',
#     '', 
#     '']

# byass2020 = ['Byass (2020)$^\mathbf{{\dagger}}$',
#     '2020-01-01',
#     '2020-02-28',
#     'Positive',
#     'Incident of infections was markedly lower at very low temperatures,\nimplying'+
#     'the pandemic will simply go away given summer weather',
#     '',
#     '']


# # # # FIGURE 2
# # Studies focused on temperature over global domain
# studies_global_temp = np.array([carleton2020, merow2020, bannister2020, 
#     sajadi2020, araujo2020, xu2020, bukhari2020, mwang2020, kassem2020, 
#     kassem2020b, sobral2020, caspi2020, jamil2020, kaplin2020])
# studies = pd.DataFrame(studies_global_temp, columns=columns)
# studies.index = studies['Citation']
# studies['HindcastStart'] = pd.to_datetime(studies['HindcastStart'], 
#     format='%Y-%m-%d')
# studies['HindcastEnd'] = pd.to_datetime(studies['HindcastEnd'], 
#     format='%Y-%m-%d')
# # Sort by Hindcast start date
# studies = studies.sort_values(by='HindcastStart', ascending=True)
# start = studies['HindcastStart'].values[0]
# end = studies['HindcastEnd'].sort_values().values[-1]+ np.timedelta64(40,'D')
# study_length = (studies['HindcastEnd']-studies['HindcastStart']) / np.timedelta64(1, 'D')
# length_fromstart = (studies['HindcastStart']-start) / np.timedelta64(1, 'D')
# # Define time for x-axis
# dates = pd.date_range(start=start, end=end)
# xticks = np.where(np.in1d(dates, dates[::20])==True)[0]
# xticklabels = dates[::20]
# xticklabels = [x.strftime('%Y-%m-%d') for x in xticklabels]
# # Initialize figure, axes
# fig = plt.figure(figsize=(15,10.3))
# ax = plt.subplot2grid((18,2),(0,0),colspan=2, rowspan=12)
# ax2 = plt.subplot2grid((18,2),(12,0),colspan=2, rowspan=6)
# # For global studies focused on temperature
# citations = studies.index.values
# y_pos = np.arange(len(citations))
# # Define colormap
# colors, edges, edges_dummy, hatches = [], [], [], []
# for index, study in studies.iterrows():
#     relationship = study['TempRelationship']
#     if relationship == 'Positive':
#         colors.append('#d7191c')
#         edges.append('#d7191c')
#         edges_dummy.append('#d7191c')
#         hatches.append('')
#     elif relationship == 'Negative':
#         colors.append('#2c7bb6')
#         edges.append('#2c7bb6')
#         edges_dummy.append('#2c7bb6')        
#         hatches.append('')        
#     elif relationship == 'Neutral':
#         colors.append('#bababa')   
#         edges.append('#bababa')    
#         edges_dummy.append('#bababa')        
#         hatches.append('')    
#     elif relationship == 'Non-significant':
#         colors.append('None')
#         edges.append('k')
#         hatches.append('///')  
#         edges_dummy.append(None)        
# # Dummy empty bars to offset start of period
# for i in np.arange(0, len(y_pos), 1):
#     ax.barh(y_pos[i], length_fromstart[i], align='center', color='w', alpha=0.)
#     ax.barh(y_pos[i], study_length[i], edgecolor=edges[i], linewidth=0.0, 
#         align='center', left=length_fromstart[i], color=colors[i], 
#         hatch=hatches[i])
#     ax.barh(y_pos[i], study_length[i], edgecolor=edges_dummy[i], 
#         align='center', left=length_fromstart[i], color='None')    
# # Add summaries of studies 
# for i, txt in enumerate(studies['TempNotes'].values):
#     ax.annotate(txt, ((length_fromstart+study_length)[i]+1, y_pos[i]), 
#         va='center', fontsize=9)
# ax.set_xticks(xticks)
# ax.set_xticklabels([], fontsize=11)
# ax.set_yticks(y_pos)
# ax.set_yticklabels(citations, fontsize=11)
# ax.invert_yaxis()
# ax.set_title('(a) Temperature', loc='left', fontsize=14)
# # For global studies focused on humidity
# studies_global_humidity = np.array([carleton2020, merow2020, sajadi2020, 
#     bukhari2020, xu2020, caspi2020])
# studies = pd.DataFrame(studies_global_humidity, columns=columns)
# studies.index = studies['Citation']
# studies['HindcastStart'] = pd.to_datetime(studies['HindcastStart'], 
#     format='%Y-%m-%d')
# studies['HindcastEnd'] = pd.to_datetime(studies['HindcastEnd'], 
#     format='%Y-%m-%d')
# # Sort by Hindcast start date
# studies = studies.sort_values(by='HindcastStart', ascending=True)
# study_length = (studies['HindcastEnd']-studies['HindcastStart'])/np.timedelta64(1, 'D')
# length_fromstart = (studies['HindcastStart']-start) / np.timedelta64(1, 'D')
# # Define time for x-axis
# dates = pd.date_range(start=start, end=end)
# xticks = np.where(np.in1d(dates, dates[::20])==True)[0]
# xticklabels = dates[::20]
# xticklabels = [x.strftime('%Y-%m-%d') for x in xticklabels]
# citations = studies.index.values
# y_pos = np.arange(len(citations))
# # Define colormap
# colors, edges, edges_dummy, hatches = [], [], [], []
# for index, study in studies.iterrows():
#     relationship = study['HumidityRelationship']
#     if relationship == 'Positive':
#         colors.append('#d7191c')
#         edges.append('#d7191c')
#         edges_dummy.append('#d7191c')
#         hatches.append('')
#     elif relationship == 'Negative':
#         colors.append('#2c7bb6')
#         edges.append('#2c7bb6')
#         edges_dummy.append('#2c7bb6')        
#         hatches.append('')        
#     elif relationship == 'Neutral':
#         colors.append('#bababa')   
#         edges.append('#bababa')    
#         edges_dummy.append('#bababa')        
#         hatches.append('')    
#     elif relationship == 'Non-significant':
#         colors.append('None')
#         edges.append('k')
#         hatches.append('///')  
#         edges_dummy.append('w')        
# # Dummy empty bars to offset start of period
# for i in np.arange(0, len(y_pos), 1):
#     ax2.barh(y_pos[i], length_fromstart[i], align='center', color='w', alpha=0.)
#     ax2.barh(y_pos[i], study_length[i], edgecolor=edges[i], linewidth=0.0, 
#         align='center', left=length_fromstart[i], color=colors[i], 
#         hatch=hatches[i])
#     ax2.barh(y_pos[i], study_length[i], edgecolor=edges_dummy[i], 
#         align='center', left=length_fromstart[i], color='None')    
# # Add summaries of studies 
# for i, txt in enumerate(studies['HumidityNotes'].values):
#     ax2.annotate(txt, ((length_fromstart+study_length)[i]+1, y_pos[i]), 
#         va='center', fontsize=9)
# ax2.set_xticks(xticks)
# ax2.set_xticklabels(xticklabels, fontsize=11)
# ax2.set_xlabel('Hindcast Period', fontsize=14)
# ax2.set_yticks(y_pos)
# ax2.set_yticklabels(citations, fontsize=11)
# ax2.invert_yaxis()
# ax2.set_title('(b) Humidity', loc='left', fontsize=14)
# plt.subplots_adjust(left=0.16, right=0.95, top=0.95, bottom=0.05, hspace=5)
# # Add legend
# pos_patch = mpatches.Patch(color='#d7191c', label='Positive')
# neg_patch = mpatches.Patch(color='#2c7bb6', label='Negative')
# neut_patch = mpatches.Patch(color='#bababa', label='Optimal range')
# ns_patch = mpatches.Patch(edgecolor='k', facecolor='w', lw=0., 
#     hatch='////', label='No relationship')
# plt.legend(handles=[pos_patch, neg_patch, neut_patch, ns_patch], loc=3, 
#     frameon=False, fontsize=14)
# fig.text(.85, .955, r'$\bf{^{\dagger}}$ Peer-reviewed', 
#       ha='left', fontsize=14)
# # Saving
# plt.savefig('/Users/ghkerr/COVID/figs/'+'fig2_revised.pdf', dpi=1000)

# # # # FIGURE 4
# # Studies focused on temperature over China domain
# studies_china_temp = np.array([ma2020, jwang2020, poirier2020, chen2020, 
#     shi2020, oliveiros2020, qi2020, xie2020, guo2020, alvarezramirez2020,
#     yao2020, byass2020])
# studies = pd.DataFrame(studies_china_temp, columns=columns)
# studies.index = studies['Citation']
# studies['HindcastStart'] = pd.to_datetime(studies['HindcastStart'], 
#     format='%Y-%m-%d')
# studies['HindcastEnd'] = pd.to_datetime(studies['HindcastEnd'], 
#     format='%Y-%m-%d')
# # Sort by Hindcast start date
# studies = studies.sort_values(by='HindcastStart', ascending=True)
# start = studies['HindcastStart'].values[0]
# end = studies['HindcastEnd'].sort_values().values[-1]+ np.timedelta64(40,'D')
# study_length = (studies['HindcastEnd']-studies['HindcastStart']) / np.timedelta64(1, 'D')
# length_fromstart = (studies['HindcastStart']-start) / np.timedelta64(1, 'D')
# # Define time for x-axis
# dates = pd.date_range(start=start, end=end)
# xticks = np.where(np.in1d(dates, dates[::20])==True)[0]
# xticklabels = dates[::20]
# xticklabels = [x.strftime('%Y-%m-%d') for x in xticklabels]
# # Initialize figure, axes
# fig = plt.figure(figsize=(15,12))
# ax = plt.subplot2grid((21,2),(0,0),colspan=2, rowspan=11)
# ax2 = plt.subplot2grid((21,2),(11,0),colspan=2, rowspan=10)
# # For global studies focused on temperature
# citations = studies.index.values
# y_pos = np.arange(len(citations))
# # Define colormap
# colors, edges, edges_dummy, hatches = [], [], [], []
# for index, study in studies.iterrows():
#     relationship = study['TempRelationship']
#     if relationship == 'Positive':
#         colors.append('#d7191c')
#         edges.append('#d7191c')
#         edges_dummy.append('#d7191c')
#         hatches.append('')
#     elif relationship == 'Negative':
#         colors.append('#2c7bb6')
#         edges.append('#2c7bb6')
#         edges_dummy.append('#2c7bb6')        
#         hatches.append('')        
#     elif relationship == 'Neutral':
#         colors.append('#bababa')   
#         edges.append('#bababa')    
#         edges_dummy.append('#bababa')        
#         hatches.append('')    
#     elif relationship == 'Non-significant':
#         colors.append('None')
#         edges.append('k')
#         hatches.append('///')  
#         edges_dummy.append('w')        
# # Dummy empty bars to offset start of period
# for i in np.arange(0, len(y_pos), 1):
#     ax.barh(y_pos[i], length_fromstart[i], align='center', color='w', alpha=0.)
#     ax.barh(y_pos[i], study_length[i], edgecolor=edges[i], linewidth=0.0, 
#         align='center', left=length_fromstart[i], color=colors[i], 
#         hatch=hatches[i])
#     ax.barh(y_pos[i], study_length[i], edgecolor=edges_dummy[i], 
#         align='center', left=length_fromstart[i], color='None')    
# # Add summaries of studies 
# for i, txt in enumerate(studies['TempNotes'].values):
#     ax.annotate(txt, ((length_fromstart+study_length)[i]+1, y_pos[i]), 
#         va='center', fontsize=9)
# ax.set_xticks(xticks)
# ax.set_xticklabels([], fontsize=11)
# ax.set_yticks(y_pos)
# ax.set_yticklabels(citations, fontsize=11)
# ax.invert_yaxis()
# ax.set_title('(a) Temperature', loc='left', fontsize=14)
# # For global studies focused on humidity
# studies_china_humidity = np.array([qi2020, oliveiros2020, shi2020, chen2020, 
#     jwang2020, ma2020, guo2020, poirier2020, yao2020, 
#     alvarezramirez2020])
# studies = pd.DataFrame(studies_china_humidity, columns=columns)
# studies.index = studies['Citation']
# studies['HindcastStart'] = pd.to_datetime(studies['HindcastStart'], 
#     format='%Y-%m-%d')
# studies['HindcastEnd'] = pd.to_datetime(studies['HindcastEnd'], 
#     format='%Y-%m-%d')
# # Sort by Hindcast start date
# studies = studies.sort_values(by='HindcastStart', ascending=True)
# study_length = (studies['HindcastEnd']-studies['HindcastStart'])/np.timedelta64(1, 'D')
# length_fromstart = (studies['HindcastStart']-start) / np.timedelta64(1, 'D')
# # Define time for x-axis
# dates = pd.date_range(start=start, end=end)
# xticks = np.where(np.in1d(dates, dates[::20])==True)[0]
# xticklabels = dates[::20]
# xticklabels = [x.strftime('%Y-%m-%d') for x in xticklabels]
# citations = studies.index.values
# y_pos = np.arange(len(citations))
# # Define colormap
# colors, edges, edges_dummy, hatches = [], [], [], []
# for index, study in studies.iterrows():
#     relationship = study['HumidityRelationship']
#     if relationship == 'Positive':
#         colors.append('#d7191c')
#         edges.append('#d7191c')
#         edges_dummy.append('#d7191c')
#         hatches.append('')
#     elif relationship == 'Negative':
#         colors.append('#2c7bb6')
#         edges.append('#2c7bb6')
#         edges_dummy.append('#2c7bb6')        
#         hatches.append('')        
#     elif relationship == 'Neutral':
#         colors.append('#bababa')   
#         edges.append('#bababa')    
#         edges_dummy.append('#bababa')        
#         hatches.append('')    
#     elif relationship == 'Non-significant':
#         colors.append('None')
#         edges.append('k')
#         hatches.append('///')  
#         edges_dummy.append('w')        
# # Dummy empty bars to offset start of period
# for i in np.arange(0, len(y_pos), 1):
#     ax2.barh(y_pos[i], length_fromstart[i], align='center', color='w', alpha=0.)
#     ax2.barh(y_pos[i], study_length[i], edgecolor=edges[i], linewidth=0.0, 
#         align='center', left=length_fromstart[i], color=colors[i], 
#         hatch=hatches[i])
#     ax2.barh(y_pos[i], study_length[i], edgecolor=edges_dummy[i], 
#         align='center', left=length_fromstart[i], color='None')    
# # Add summaries of studies 
# for i, txt in enumerate(studies['HumidityNotes'].values):
#     ax2.annotate(txt, ((length_fromstart+study_length)[i]+1, y_pos[i]), 
#         va='center', fontsize=9)
# ax2.set_xticks(xticks)
# ax2.set_xticklabels(xticklabels, fontsize=11)
# ax2.set_xlabel('Hindcast Period', fontsize=14)
# ax2.set_yticks(y_pos)
# ax2.set_yticklabels(citations, fontsize=11)
# ax2.invert_yaxis()
# ax2.set_title('(b) Humidity', loc='left', fontsize=14)
# plt.subplots_adjust(left=0.16, right=0.95, top=0.95, bottom=0.05, hspace=5)
# # Add legend
# pos_patch = mpatches.Patch(color='#d7191c', label='Positive')
# neg_patch = mpatches.Patch(color='#2c7bb6', label='Negative')
# neut_patch = mpatches.Patch(color='#bababa', label='Optimal range')
# ns_patch = mpatches.Patch(edgecolor='k', facecolor='w', lw=0., 
#     hatch='////', label='No relationship')
# plt.legend(handles=[pos_patch, neg_patch, neut_patch, ns_patch], loc=3, 
#     frameon=False, fontsize=14)
# fig.text(.85, .955, r'$\bf{^{\dagger}}$ Peer-reviewed', 
#       ha='left', fontsize=14)
# # Saving
# plt.savefig('/Users/ghkerr/COVID/figs/'+'fig4_revised.pdf', dpi=1000)

# # # # # FIGURE 3
# fig = plt.figure(figsize=(10,10))
# ax = plt.subplot2grid((2,2),(0,0), rowspan=2)
# ax2 = plt.subplot2grid((2,2),(0,1), rowspan=2)
# # Study, control environmental, control non-environmental
# studies = [['Ahmadi et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Alvarez-Ramirez & Meraz (2020)', 0, 0],
#     ['Araújo & Naimi (2020)', 0, 0],
#     ['Auler et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Bashir et al. (2020)$^\mathbf{{\dagger}}$', 0 ,0],
#     ['Bukhari et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Byass (2020)$^\mathbf{{\dagger}}$', 2, 1],
#     ['Caspi et al. (2020)', 0, 0],
#     ['Carleton et al. (2020)$^\mathbf{{\dagger}}$', 2, 8],
#     ['Chen et al. (2020)', 0, 0],
#     ['Correa-Araneda et al. (2020)', 0, 0],
#     ['Guo et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Jamil et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Kaplin et al. (2020)', 0, 3],
#     ['Kapoor et al. (2020)', 2, 4],
#     ['Kassem et al. (2020)', 0, 0],
#     ['Lin et al. (2020)', 0, 3], 
#     ['M. Wang et al. (2020)', 0, 0],
#     ['Ma, Zhao et al. (2020)$^\mathbf{{\dagger}}$', 6, 2],
#     ['Ma, Pei et al. (2020)', 1, 13],
#     ['Merow & Urban (2020)$^\mathbf{{\dagger}}$', 0, 3], #population density, proportion of population over 60years, country effects
#     ['Meyer et al. (2020)$^\mathbf{{\dagger}}$', 0, 2],
#     ['Mollalo et al. (2020)', 0, 0],
#     ['Notari et al. (2020)', 0, 0],
#     ['Oliveiros et al. (2020)', 0, 0],
#     ['Poirier et al. (2020)$^\mathbf{{\dagger}}$', 0, 0], 
#     ['Qi et al. (2020)$^\mathbf{{\dagger}}$', 0, 2],
#     ['Roy & Kar (2020)', 0, 0], 
#     ['Runkle et al. (2020)$^\mathbf{{\dagger}}$', 0, 2],
#     ['Rosario et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Şahin (2020)$^\mathbf{{\dagger}}$', 0, 0], 
#     ['Sajadi et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Shi et al. (2020)', 0, 0],
#     ['Sobral et al. (2020)$^\mathbf{{\dagger}}$', 0, 3],
#     ['Tawio & Fashola (2020)', 0, 0],
#     ['To et al. (2021)$^\mathbf{{\dagger}}$', 2, 1],
#     ['Tosepu et al. (2020)$^\mathbf{{\dagger}}$', 0, 0],
#     ['Ujiie et al. (2020)$^\mathbf{{\dagger}}$', 0, 3],
#     ['J. Wang et al. (2020)', 0, 4], 
#     ['Xie & Zhu (2020)$^\mathbf{{\dagger}}$', 3, 2] ,
#     ['Xu et al. (2020)', 0, 3],
#     ['Yudistira et al. (2020)', 0, 0],
#     ['Yao et al. (2020)$^\mathbf{{\dagger}}$', 3, 0]]
# studies1 = np.array(studies)[:21]
# counter = np.arange(0, len(studies1), 1)
# environ = [float(x) for x in (studies1[:,1])]
# environx = np.ones(shape=counter.shape[0])
# nonenviron = [float(x) for x in (studies1[:,2])]
# nonenvironx = np.ones(shape=counter.shape[0])*2.
# scale = 2.2
# for x in counter:
#     ax.scatter(environx[x], counter[x], s=(environ[x]*2)**scale, color='k', zorder=5)
#     ax.scatter(nonenvironx[x], counter[x], s=(nonenviron[x]*2)**scale, color='k', zorder=5)
# # Indicate time-varying studies 
# # Byass 
# ax.scatter(1, 6, s=(environ[6]*2)**scale, color='r', zorder=6)
# ax.scatter(2, 6, s=(nonenviron[6]*2)**scale, color='r', zorder=6)
# # Kaplin 
# ax.scatter(2, 13, s=(nonenviron[13]*2)**scale, color='r', zorder=6)
# # Lin
# ax.scatter(2, 16, s=(nonenviron[16]*2)**scale, color='r', zorder=6)
# # Ma, Pei 
# ax.scatter(1, 19, s=(nonenviron[20]*2)**scale, color='r', zorder=6)
# # Carleton
# ax.scatter(1, 8, s=(environ[8]*2)**scale, color='r', zorder=6)    
# ax.scatter(2, 8, s=(nonenviron[8]*2)**scale, color='r', zorder=6)
# # Ma, Zhao
# ax.scatter(1, 18, s=(environ[18]*2)**scale, color='r', zorder=6)    
# ax.scatter(2, 18, s=(nonenviron[18]*2)**scale, color='r', zorder=6)
# ax.set_yticks(counter)
# ax.set_ylim([-0.5, len(studies1)-0.5])
# ax.set_yticklabels(studies1[:,0], fontsize=11)
# ax.set_xlim([0.8, 2.2])
# ax.set_xticks([1, 2])
# ax.set_xticklabels(['Environmental', 'Non-\nenvironmental'], fontsize=12)
# ax.grid(True,linestyle="-", lw=0.5, color='silver', zorder=1)
# ax.invert_yaxis()
# studies2 = np.array(studies)[21:]
# counter = np.arange(0, len(studies2), 1)
# environ = [float(x) for x in (studies2[:,1])]
# environx = np.ones(shape=counter.shape[0])
# nonenviron = [float(x) for x in (studies2[:,2])]
# nonenvironx = np.ones(shape=counter.shape[0])*2.
# for x in counter:
#     ax2.scatter(environx[x], counter[x], s=(environ[x]*2)**scale, color='k', zorder=5)
#     ax2.scatter(nonenvironx[x], counter[x], s=(nonenviron[x]*2)**scale, color='k', zorder=5)
# # Indicate time-varying studies    
# # Meyer 
# ax2.scatter(2, 0, s=(nonenviron[0]*2)**scale, color='r', zorder=6)
# # To
# ax2.scatter(1, 14, s=(environ[14]*2)**scale, color='r', zorder=6)
# # Sobral
# ax2.scatter(2, 12, s=(nonenviron[12]*2)**scale, color='r', zorder=6)    
# # Xie & Zhu
# ax2.scatter(1, 18, s=(environ[18]*2)**scale, color='r', zorder=6)    
# ax2.scatter(2, 18, s=(nonenviron[18]*2)**scale, color='r', zorder=6)
# # Qi 
# ax2.scatter(2, 5, s=(nonenviron[5]*2)**scale, color='r', zorder=6)
# # Runkle
# ax2.scatter(2, 7, s=(nonenviron[7]*2)**scale, color='r', zorder=6)
# ax2.set_yticks(counter)
# ax2.set_ylim([-0.5, len(studies2)-0.5])
# ax2.set_yticklabels(studies2[:,0], fontsize=11)
# ax2.set_xlim([0.8, 2.2])
# ax2.set_xticks([1, 2])
# ax2.set_xticklabels(['Environmental', 'Non-\nenvironmental'], fontsize=12)
# ax2.grid(True,linestyle="-", lw=0.5, color='silver', zorder=1)
# ax2.invert_yaxis()
# plt.subplots_adjust(left=0.28, wspace=1.1)
# # Remove spines
# for axtemp in [ax, ax2]:
#     axtemp.spines['right'].set_visible(False)
#     axtemp.spines['top'].set_visible(False)
#     axtemp.spines['bottom'].set_visible(False)
#     axtemp.spines['left'].set_visible(False)
# from matplotlib.lines import Line2D
# legend_elements = [Line2D([0], [0], color='w', marker='o', markerfacecolor='k',
#     markeredgecolor='k', markersize=15, label='Static'), Line2D([0], [0], 
#     marker='o', color='w', markersize=15, markerfacecolor='r', 
#     markeredgecolor='r', label='Time-varying')]
# # Create the figure
# ax.legend(handles=legend_elements, ncol=2, frameon=False, loc='upper center',
#           bbox_to_anchor=[0.9, 1.1], fontsize=14)    
# ax.set_title(r'$\bf{^{\dagger}}$ Peer-reviewed', x=-0.43, y=1.045, 
#     fontsize=14)    
# ax.tick_params(axis='both', length=0)
# ax2.tick_params(axis='both', length=0)
# plt.savefig('/Users/ghkerr/COVID/figs/'+'fig3_revised.pdf', dpi=1000)