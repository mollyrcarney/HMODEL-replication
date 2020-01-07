globals [
  years_BP ;; state variable to record time (ticks) in years BP
  list-of-hearths-on-surface ;; List of all hearths on surface at the end of the simulation, used in collecting data
  list-of-hearths-excavated ;; list of hearths that have been revealed by excavation, used in data collection
]

turtles-own [
  hearth_age ;; date equal to the creation/use/radiocarbon value of each hearth
]

patches-own[
  sediment_ages ;; ordered list of sedimentary layers on landscape
]





to setup

clear-all

random-seed seed  ;;always need a seed variable for model replicability

set list-of-hearths-on-surface [] ;; create list for data collection

set list-of-hearths-excavated [] ;; create list for data collection

set years_BP 2000 ;; Set this variable to simulate the late Holocene time period.

ask patches [
  set sediment_ages (list 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032 2033 2034 2035 2036 2037 2038 2039 2040) ;; create list of sedimentary layers older than human occupation of the landscape
]

reset-ticks

end





to go

  tick ;; time passes

  set years_BP 2000 - ticks ;; set years BP value

if ticks <= 1800 ;; condition simulating transition from prehistoric to historic hearth creation
[
    crt 5
  [
     setxy random-xcor random-ycor
     set hearth_age years_BP ;;give turtles a variable (hearth) with the date they are created
   ]
]
if random-float 1 <= event_interval ;;set probability of large-scale flood, if this randomly pulled number is <= event interval slider, a geomorph event occurs
  [event]

  if ticks = 2000 ;; or when time is equivalent to the present
 [
    collectdata  ;;
    stop
  ]
end




to event
  ask patches [
  if random-float 1 > stability ;; select random subset of patches (discrete spatial units) for a geomorph event
  [
    ifelse random-float 1 < erosion_proportion
    [erosion] ;; remove a sedimentary layer
    [deposition] ;; deposit a layer

  ]
  ]
end




to erosion
if length sediment_ages > 0
[
ask turtles-here with [hearth_age <= item 0 sediment_ages] ;; select hearths on the surface
[

  die ;;Hearths that are the same age or younger than the most recent sedimentary layer (i.e. on the surface) are eroded away and dispersed.
  ]

;;show sediment_ages    ;;for testing



  set sediment_ages remove-item 0 sediment_ages ;; remove a sedimentary layer

;;show sediment_ages ;;for testing
]

end



to deposition
  ;;show sediment_ages ;;for testing
  set sediment_ages fput years_BP sediment_ages ;; add a layer
  ;;show sediment_ages ;;for testing
end



to collectdata

if experiment = "survey" ;; this experiment simulates survey data, or surficial archaeological deposits
[
ask turtles with [hearth_age <= item 0 sediment_ages]
[
set list-of-hearths-on-surface fput hearth_age list-of-hearths-on-surface ;; list-of-hearths-on-surface is a global list of all hearths on the surface at the present
]

ifelse length list-of-hearths-on-surface > 99

    [file-open "HMODEL15_survey_500yrfld_5.csv"

  let sample-surface-hearths n-of 100 list-of-hearths-on-surface ;; randomly pull 100 hearths from all hearths on the surface
  set sample-surface-hearths sort sample-surface-hearths ;;this sorts them in ascending order
  ;;show sample-surface-hearths  ;;for testing

  set-plot-pen-mode 2  ;;this plots to the interface
  let y 1
  foreach sample-surface-hearths
  [ ?1 ->
   plotxy ?1 y
   set y y + 1
  ]

  foreach sample-surface-hearths  ;;this writes it out to the .csv file
  [ ?1 ->
  file-write ?1 file-write ","  ;;you can delete "file-write ","" if you want a space separated file. As it stands, you'll probably have to go into the .csv file and replace all of the " with nothing in order to import into excel or R nicely--this added find and replace only takes a second.
  ]
  file-print "" file-print " "

;;[
 ;;error "There were less than 100 hearths on the surface."  ;;custom run-time error LSP
;;]
file-close
]

  [file-open "HMODEL15_outtake.csv"
    foreach list-of-hearths-on-surface
[ ?1 ->
  file-write ?1 file-write ","  ;;you can delete "file-write ","" if you want a space separated file. As it stands, you'll probably have to go into the .csv file and replace all of the " with nothing in order to import into excel or R nicely--this added find and replace only takes a second.
  ]
  file-print "" file-print ""
]
]


end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
11
64
74
97
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
75
64
138
97
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
103
182
136
stability
stability
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
10
139
182
172
erosion_proportion
erosion_proportion
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
10
19
102
52
seed
seed
0
1000
996.0
1
1
NIL
HORIZONTAL

PLOT
7
225
207
375
plot 1
hearth age
age rank
0.0
2000.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

BUTTON
140
65
203
98
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
7
379
196
424
experiment
experiment
"survey"
0

SLIDER
11
174
183
207
event_interval
event_interval
0
.1
0.002
.001
1
NIL
HORIZONTAL

@#$#@#$#@
# ODD
## Purpose
The purpose of this model is to:
1. Explore variability in dateable surficial archaeological features and their subsequent radiocarbon date distribution.
2. Model and create a dissectible sedimentary sequence based on the concept of episodic geomorphic erosional and depositional events.
3. Examine the role of subsurface excavation in the radiocarbon date distribution, and it’s influence on estimates of prehistoric population density.

## Entities, State Variables, and Scales
To model the effects of geomorphic events on surface archaeology, two primary entities are used: _hearths_ and _patches_. A _patch_ is a discrete unit of space within a gridded toroidal world. This world is 32x32 patches. Each patch contains an ordered list of sedimentary layers called **sediment_ages**. Each sedimentary layer is associated with the date it was deposited.

A _hearth_ is an archaeological feature, deposited by an invisible agent, from which a radiocarbon date might be obtained. In the model, hearths are represented as agents (turtles) that contain a date, which is a turtle-specific variable, in Years BP coequal to the time of its construction. If a hearth has a date more recent than or equivalent to a patch’s most recent sedimentary layer, it is considered to be a surface feature and visible.

Time is represented by ticks. Every tick is equivalent to one year. A state variable, called **years_BP**, is used to track the passage of time. The model starts at 2000 BP and continues to the present, or 0 BP.

## Process Overview and Scheduling
During each year (step), each of 5 humans moves to a random point on the landscape and creates a hearth with an age value equal to the current value of **years_BP**. At given intervals, determined by the **event_interval** parameter, a geomorphic event occurs which affects a subset of all patches. This subset is determined by the stability parameter, which is the probability of an event occurring. For example, with a stability value of 0.5, there is a 50% chance that all patches will undergo an event, or a likelihood that half of all patches will experience some change. The specific form of that change is determined by the **erosion_proportion** parameter. A random value is drawn from a Bernoulli distribution; if this value is greater than the erosion_proportion value, deposition occurs and the patches list of sedimentary_ages receives a new value equal to years_BP. If the value is less than the erosion_proportion parameter, erosion occurs in that patch and the most recent sedimentary layer is scoured and erased. Any hearths with an age in years_BP that is less than or equal to the sedimentary layer that is erased, is also eroded (i.e., those turtles are killed). At the end of the year (step), the years_BP value is decreased by one.

## Design Concepts
_Emergence_ – Distributions of visible dates emerge through altering the parameter values, providing discrete time period ranges. Frequency of dateable hearths is another emergent property. Finally, this model illustrates gaps or continuums in the radiocarbon distribution, directly relatable to visible archaeological phenomena.

_Interaction_ – Hearths (agents) interact with patches when they are built upon the landscape’s surface. This is a reciprocal relationship, as patches interact with hearths when they are eroded.

_Stochasticity_ – Human agents building hearths move randomly across the landscape, and the patterning of hearth creation is purely random. The probability of geomorphic change and the probability of deposition or erosion is based upon a random draw from a Bernouilli distribution.

_Observation_ – Data is collected at the end of each run, and the method of data collection depends on the experiment parameter. In the survey experiment, the ages of all hearths on the surface were recorded. In the test excavation experiments, the ages of all hearths on the surface and four sedimentary layers down were recorded. Of these dates, 100 are randomly drawn and indexed by relative age.

## Initialization
At the start of the model, all patches are given one sedimentary layer equivalent to the initial time period, 2000 years_BP. There are no hearths on any patches in the world. Initialization is always the same and does not change based upon the scenario (experiment parameter).

## Input
Several parameters can be changed, which affect the overall outcomes of the model. The frequency of geomorphic events can be set to a probability. To simulate real-world fluvial processes, we recommend that this value be set to an equivalent probability to decadal, centurial, or millenial flooding. This simulates catastrophic flooding. The stability proportion, from 0.0-1, can be set in increments of 0.1. This simulates the stability of a landform, and is a simplified number to account for slope, aspect, sediment type, and general “hardness” of a discrete unit of land. The erosion_proportion parameter, from 0.0-1.0, affects the probability that a patch undergoing change will either select erosion or deposition. This roughly simulates steep or young landscapes and older, depositional landscapes such as floodplains. Finally, the experiment parameter defines how the data are measured. In the survey experiment, only surface features are examined. However, the other experiments simulate various numbers of randomly placed test units and how that might affect the chronometric distribution.

## Submodels
In an event interval yeart, there is the probability that a patch will undergo a geomorphic event. In eatch patch, a random number p is drawn from a Bernouilli draw. If it is less than the stability parameter, that patch will experience an event.

p > stability

If a patch undergoes an event, that event will take the form of erosion or deposition. Another random number, q is drawn from a Bernouill distribution. If q is less than the erosion_proportion value, the patch will experience erosion and lose a layer. If q is greater than the erosion_proportion value, a layer will be added to that patch.

q < erosion_proportion = erosion

q > erosion_proportion = deposition

## Credits and References

Thanks to Ben Davies for providing his ODD for HMODEL, which allowed me greater insight in to replicating that model. Thanks also to Luke Premo for all his help in designing the model, coding, and in all other areas.

Davies, Benjamin, Simon J. Holdaway, and Patricia C. Fanning
2016 Modelling the palimpsest: An exploratory agent-based model of surface archaeological deposit formation in a fluvial arid Australian landscape. _The Holocene_ 26(3): 450-463.DOI: https://doi.org/10.1177/0959683615609754.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="100 0.5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="event_interval">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="200 0.5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="100 0.0" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="200 0.0" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 5 200 0.0" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-5&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 5 100 0.0" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-5&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 5 100 0.5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-5&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 5 200 0.5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-5&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 10 200 0.5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-10&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 10 100 0.5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-10&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 10 100 0.0" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-10&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="excavation 10 200 0.0" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <enumeratedValueSet variable="event_interval">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;excavation-10&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="survey_prob_0.002" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="event_interval">
      <value value="0.002"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;survey&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="stability">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="survey prob 0.01" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="stability">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="event_interval">
      <value value="0.01"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="survey_prob.01_stability" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="event_interval">
      <value value="0.01"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="survey_prob_500_stability" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="stability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="event_interval">
      <value value="0.002"/>
    </enumeratedValueSet>
    <steppedValueSet variable="seed" first="1" step="1" last="1000"/>
    <enumeratedValueSet variable="experiment">
      <value value="&quot;survey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="erosion_proportion">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
