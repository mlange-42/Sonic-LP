# Morricone 001

[[_TOC_]]

The main bassline uses the first 8 bars of Ennio Morricone's famous "The Good, the Bad and the Ugly":

X: 1
T: The Good, the Bad and the Ugly
C: Ennio Morricone
M: 4/4
L: 1/16
"b11" AdAd A8 F4|"b21" G4 D12|\\
"b11" AdAd A8 F4|"b22" G4 c12|\\
"b11" AdAd A8 F4|"b23" E2D2 C12|\\
"b12" AdAd A8 G4|"b24" D4 D12|

In Sonic Pi code we get the following, where `1` is the length of a quarter note:

```ruby
#- file:Dubstep/Morricone-001.rb
# First bar
b11 = [[:a3, :d4, :a3, :d4, :a3, :f3], [0.25, 0.25, 0.25, 0.25, 2, 1]]
b12 = [[:a3, :d4, :a3, :d4, :a3, :g3], [0.25, 0.25, 0.25, 0.25, 2, 1]]
# Second bar
b21 = [[:g3, :d3], [1, 3]]
b22 = [[:g3, :d4], [1, 3]]
b23 = [[:e3, :d3, :c3], [0.5, 0.5, 3]]
b24 = [[:d3], [4]]
```
