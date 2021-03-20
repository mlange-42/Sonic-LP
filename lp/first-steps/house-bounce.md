# House bounce

After discovering [Sonic Pi](https://sonic-pi.net/) a week before,
and some playing with it in Live Coding, I decided to code a first complete track.

Starting from a simple bass line, it developed into a bouncy House tune. Listen here:

<iframe width="100%" height="165" scrolling="no" frameborder="no" allow="autoplay" src="https://thefuture.fm/track/862/house-experiment-001-sonic-pi/embed"></iframe>

The track uses only built-in samples and synths of Sonic Pi, so the code should
work without any additional setup.

**Contents**

[[_TOC_]]

## Tempo

With 125 BMP, I decided to go for the upper range of typical House tracks.

```ruby
#- Setup
use_bpm 125
```

## Instruments

The track is played by a rather small combo of instruments:
drums, a bass line, and playful bell or xylophone-like melody.

Notes and Sonic Pi code for each of the instruments are presented and explained
in the following sections.

### Drums

I used a standard House drums arrangement with the bass drum playing a
4-to-the-floor rhythm. The snare plays on every second beat, while cymbals
play between beats.

X: 1
M: 4/4
L: 1/16
K: perc
U:n=!style=x!
V: BD name="Bass drum"
V: SN name="Snare"
V: CY name="Cymbal"
[V:BD] F4 F4 F4 F4|
[V:SN] z4 nG4 z4 nG4|
[V:CY] z2 nf2 z2 nf2 z2 nf2 z2 nf2|

In the code, I use the function [play_rhythm_sample](#play_rhythm_sample),
which allows me to easily define drum patterns as strings of e.g. 8th notes.
The bass drum pattern is commented out, as we trigger beats individually (see below).

```ruby
#- Drums
# bd_rhythm =    "x-x-x-x-"
drum_rhythm =    "--x---x-"
cymbals_rhythm = "-x-x-x-x"

# ==> Bass drum.
# ==> Snare.
# ==> Cymbal.
```

Next, I present the code that actually plays these patterns.
I use a `live_loop` for each instrument. At the start of each live loops,
you will see lines like `amp = bd_amp[tick + offset]`.
Here, we get parameters like the volume of the instrument over the course of the track.
Section [Title structure](#title-structure) presents how this is actually implemented.

For the bass drum, I use the sample `:bd_haus`. It is played every quarter note,
with a low pass filter. The filter is set to a higher cutoff on every second beat.

```ruby
#- Bass drum
live_loop :bd, sync: :main do
  amp = bd_amp[tick + offset]
  8.times do
    sample :bd_haus, lpf: 90, amp: amp
    sleep 1
    sample :bd_haus, lpf: 110, amp: amp
    sleep 1
  end
end
```

As a snare replacement, I use the sample `:elec_twip`, and play the
pattern presented above. To make the sound more snappy, I cut off
the release part of the sample (with `finish: 0.1`)

```ruby
#- Snare
live_loop :drums, sync: :main do
  amp = drums_amp[tick + offset]
  4.times do
    use_sample_defaults finish: 0.1
    play_rhythm_sample :elec_twip, 0.5, drum_rhythm, amp: amp
  end
end
```

Finally, I used the closed cymbal sample `:drum_cymbal_closed` to play the
respective pattern (i.e. between beats). Again, I cut the release part for a
more snappy sound,. Further, I added a high pass filter.

```ruby
#- Cymbal
live_loop :cymbal, sync: :main do
  amp = cymbal_amp[tick + offset]
  4.times do
    use_sample_defaults hpf: 100, finish: 0.15, amp: amp
    play_rhythm_sample :drum_cymbal_closed, 0.5, cymbals_rhythm, amp: amp
  end
end
```

### Bass

After some playing with the F minor pentatonic scale, I came up with this base
melody for the bass line:

X: 1
M: 4/4
L: 1/4
E4|B4|d3B1|G2A2|\\
E4|B4|d3B1|A2G2|

Here, the melody is expressed in Sonic Pi notes and durations (in beats):

```ruby
#- Bass
bass_melody = [
  [[:e1, :b1, :d2, :b1, :g1, :a1], [4, 4, 3, 1, 2, 2]],
  [[:e1, :b1, :d2, :b1, :a1, :g1], [4, 4, 3, 1, 2, 2]]
]
```

```ruby
#- Bass
live_loop :bass, sync: :main do
  t = tick * 2 + offset
  amp = bass_amp[t]
  amp_end = bass_amp[t + 1]

  amp_min = bass_min_amp[t]
  shift = bass_shift[t]
  cutoff = bass_cutoff[t]

  with_fx :slicer, phase: 0.5, amp_min: amp_min do |sn|
    with_synth :tb303 do
      use_synth_defaults amp: amp

      syn = play :e1, cutoff: 80, res: 0.75, sustain: 32, release: 0
      at do
        for m in bass_melody
          slide_timed_synth syn, m[0], m[1], shift: shift
        end
      end

      control syn, cutoff: 92, cutoff_slide: 16, amp: amp_end, amp_slide: 32

      sleep 16

      control syn, cutoff: 80, cutoff_slide: 0
      control syn, cutoff: cutoff, cutoff_slide: 16

      sleep 8

      control sn, phase: 0.25
      sleep 6
      control sn, phase: 0.333
      sleep 2
    end
  end
end
```

X: 1
M: 4/4
L: 1/16
E2E2 E2E2 E2E2 E2E2|B2B2 B2B2 B2B2 B2B2|d2d2 d2d2 d2d2 B2B2|G2G2 G2G2 A2A2 A2A2|
E2E2 E2E2 E2E2 E2E2|B2B2 B2B2 B2B2 B2B2|dddd dddd dddd BBBB|AAAA AAAA ((3GGG) ((3GGG)|

### Bells

X: 1
M: 4/4
L: 1/16
e2eg ege2 e2ge e2d2|e2g2 ege2 e2ge e2d2|

```ruby
#- Bells
bell_melody = [
  [[:e5,  :e5,  :g5,  :e5,  :g5, :e5], [0.5, 0.25, 0.25, 0.25, 0.25, 0.5]],
  [[:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5]],
  [[:e5,  :g5,  :e5,  :g5,  :e5],      [0.5, 0.5, 0.25, 0.25, 0.5]],
  [[:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5]]
]
```

```ruby
#- Bells
live_loop :bell, sync: :main do
  amp = bell_amp[tick + offset]

  if amp > 0
    shift = bell_shift[look + offset]
    echo = bell_echo[look + offset]
    with_fx :echo, phase: 0.25, decay: 0.5, mix: echo, amp: 1 do |fx|
      with_synth :pretty_bell do
        use_synth_defaults amp: amp, release: 0.2
        2.times do |i|
          for m in bell_melody
            play_timed_synth m[0], m[1], shift: shift
          end
        end
      end
    end
  else
    sleep 16
  end
end
```

## Title structure

```ruby
#- Title structure
offset = 0

live_loop :main, delay: 0.01 do
  t = tick(:loop)
  puts t + offset
  sleep 4 * 4
end

##########################  0        8        16       24       32       40       48       56       64
bell_amp     =  str_scale("|33334343|----6655|----6666|----6688|XXXX8876|XXXX8876|88888876|X7X7X786|6666----|", max: 0.2 )
bell_shift   = str_select("|22111-1-|----11--|11111111|11111111|1111----|1111----|--------|1-1-1-1-|--------|", [0, -12, -24])
bell_echo    =  str_scale("|13375355|11111111|33333333|33333358|35353535|35353535|35355555|57575757|5688----|")

bd_amp       =  str_scale("|------11|XXXXXXX5|XXXXXXX7|--223456|XXXXXXX6|XXXXXXXX|XXXXXXXX|XXXX9988|--------|")
drums_amp    =  str_scale("|--112222|33333333|33333333|11111112|55555555|55555555|55555555|55555555|--------|")

cymbal_amp   =  str_scale("|----2233|44444444|44444443|------22|44444444|44444444|44444444|33333333|--------|")

bass_amp     =  str_scale("|----1111|33333333|88888886|55555555|99999999|99999999|99999999|77667765|41------|")
bass_cutoff  = str_select("|------11|------11|--------|------11|--------|------11|--11--11|--------|--------|", [92, 104])
bass_min_amp =  str_scale("|XXXXXXXX|99997777|33334477|99779977|22332244|22443377|22443377|88889999|XXXXXXXX|")
bass_shift   = str_select("|11112211|--------|--------|--11--12|--------|--------|1111----|--11--11|--------|", [12, 24, 36])
```

## File structure

```ruby
#- file:House/HouseBounce.rb
# ==> Setup.
# ==> Functions.
# ==> Title structure.
# ==> Drums.
# ==> Bass.
# ==> Bells.
```

## Functions

```ruby
#- Functions
# ==> play_rhythm_sample.
# ==> play_timed_synth.
# ==> slide_timed_synth.
# ==> str_scale.
# ==> str_select.
```

### play_rhythm_sample

```ruby
#- play_rhythm_sample
define :play_rhythm_sample do |samp, duration, rhythm, amp: 1|
  for i in 0..rhythm.length-1
    s = rhythm[i]
    if s == "|"
      # Bar line, do nothing
    elsif s == "-"
      sleep duration
    elsif (s == "x") or (s == "X")
      sample samp, amp: amp
      sleep duration
    else
      a = amp * Integer(s) / 10.0
      sample samp, amp: a
      sleep duration
    end
  end
end
```

### play_timed_synth

```ruby
#- play_timed_synth
define :play_timed_synth do |notes, times, shift: 0|
  for i in 0..notes.length-1
    play notes[i] + shift
    sleep times[i]
  end
end
```

### slide_timed_synth

```ruby
#- slide_timed_synth
define :slide_timed_synth do |syn, notes, times, shift: 0|
  for i in 0..notes.length-1
    control syn, note: notes[i] + shift
    sleep times[i]
  end
end
```

### str_scale

```ruby
#- str_scale
define :str_scale do |str, min: 0, max: 1|
  str.chars.filter_map{|s|
    if s == "|"
      # Bar line, do nothing
    elsif s == "-"
      min
    elsif (s == "x") or (s == "X")
      max
    else
      min + (max - min) * Integer(s) / 10.0
    end
  }.ring
end
```

### str_select

```ruby
#- str_select
define :str_select do |str, values|
  str.chars.filter_map{|s|
    if s == "|"
      # Do nothing
    elsif s == "-"
      values[0]
    else
      values[Integer(s)]
    end
  }.ring
end
```
