# First Live Dubstep

[[_TOC_]]

## BPM

We use a rather high speed for Dubstep, with 140 bpm.

```ruby
#- BPM
use_bpm 140
```

## Drums

We use a simple, but nicely broken beat using a bass drum and a closed snare.

X: 1
M: 4/4
K: perc
U:n=!style=x!
L: 1/16
V: BD name="Bass drum"
V: SN name="Snare"
[V:BD] E6 E10|E6 E10|E6 E10|E6 E10|\\
E6 E10|E6 E10|E6 E10|E6 E10|
[V:SN] "snare1"z8 nd7 nd1|"snare2"z8 nd3 nd4 nd|\\
"snare1"z8 nd7 nd1|"snare3"z10 nd4 nd2|\\
"snare1"z8 nd7 nd1|"snare2"z8 nd3 nd4 nd|\\
"snare1"z8 nd7 nd1|"snare4"z10 nd3 nd2 nd|

As rhythms, the bass drum and snare bars look like this:

```
Bass dr. |o-----o---------|
Snare 1  |--------x------x|
Snare 2  |--------x--x---x|
Snare 3  |----------x---x-|
Snare 4  |----------x--x-x|
```

The bass drum is realized as a simple Live Loop.

```ruby
#- Bass drum loop
live_loop :bd, sync: :main do
 sample :bd_haus
 sleep 1.5
 sample :bd_haus
 sleep 2.5
end
```

Snare rhythm and volumes are given as arrays.

```ruby
#- Snare rhythm
snare1 = [[  2,  1.75, 0.25],         # sleep time after sample (beats)
          [  0,     1,  0.8]]         # sample amplitude
snare2 = [[  2,  0.75,  1.0,  0.25],
          [  0,     1,    1,   0.8]]
snare3 = [[2.5,   1.0,  0.5],
          [  0,     1,    1]]
snare4 = [[2.5,  0.75,  0.5,  0.25],
          [  0,     1,  0.8,     1]]
```

Cymbals play 16th notes, with some left out with a probability of 10%

## Bass line

The basic notes for the bass line are these:

X: 1
M: 4/4
L: 1/2
"bass1"A2|c^F|"bass1"A2|c^F|"bass1"A2|c^F|"bass2"A2|^FF|

Due to the repetitions, we only need two different patterns in Sonic Pi's notation:

```ruby
#- Bass notes
bass1 = [[:a1,  :c2, :fs1],  # notes
         [  4,    2,    2]]  # durations (beats)
bass2 = [[:a1, :fs1,  :f1],
         [  4,    2,    2]]
```

## Appendix

### File structure

```ruby
#- file:Dubstep/Dubstep-001-live.rb
# ==> File content.
```

The content of the file is structured into three sections.

```ruby
#- File content
# ==> BPM.
############ FUNCTIONS ###########
# ==> Functions.

############### NOTES ##############
# ==> Bass notes.
# ==> Snare rhythm.

############### LOOPS ##############
# ==> Bass drum loop.
```

### Functions

We use two helper functions to more easily play timed notes and samples.

```ruby
#- Functions
define :play_timed_sample do |samp, times, amp = nil|
  for i in 0..times.length-1
    if amp != nil
      sample samp, amp: amp[i]
    else
      sample samp
    end
    sleep times[i]
  end
end

define :play_timed_synth do |syn, notes, times, shift: 0|
  for i in 0..notes.length-1
    control syn, note: notes[i] + shift
    sleep times[i]
  end
end
```
