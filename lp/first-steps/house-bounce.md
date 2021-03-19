# House bounce

[[_TOC_]]

## Bass

X: 1
M: 4/4
L: 1/4
E4|B4|d3B1|G2A2|\\
E4|B4|d3B1|A2G2|

Sonic Pi notes:

```ruby
#- file:House/HouseBounce.rb
bass1 = [[:e1, :b1, :d2, :b1, :g1, :a1],
         [  4,   4,   3,   1,   2,   2]]
bass2 = [[:e1, :b1, :d2, :b1, :a1, :g1],
         [  4,   4,   3,   1,   2,   2]]
```

## Melody

X: 1
M: 4/4
L: 1/16
E2EG EGE2 E2GE E2D2|E2G2 EGE2 E2GE E2D2|

```ruby
play_timed_synth [:e5,  :e5,  :g5,  :e5,  :g5, :e5], [0.5, 0.25, 0.25, 0.25, 0.25, 0.5], shift: shift
play_timed_synth [:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5], shift: shift

play_timed_synth [:e5,  :g5,  :e5,  :g5,  :e5],      [0.5, 0.5, 0.25, 0.25, 0.5], shift: shift
play_timed_synth [:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5], shift: shift
```
