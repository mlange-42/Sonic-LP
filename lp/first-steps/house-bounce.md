# House bounce

[[_TOC_]]

## Tempo

```ruby
#- Setup
use_bpm 125
offset = 0
```

## Instruments

### Drums

X: 1
M: 4/4
L: 1/16
K: perc
U:n=!style=x!
V: BD name="Bass drum"
V: SN name="Snare"
V: CY name="Cymbal"
[V:BD] E4 E4 E4 E4|
[V:SN] z4 nG4 z4 nG4|
[V:CY] z2 nf2 z2 nf2 z2 nf2 z2 nf2|

```ruby
#- Drums
# bd_rhythm =    "x-x-x-x-"
drum_rhythm =    "--x---x-"
cymbals_rhythm = "-x-x-x-x"
```

```ruby
#- Drums
live_loop :bd, sync: :main do
  amp = bd_amp[tick + offset]
  8.times do
    sample :bd_haus, lpf: 90, amp: amp
    sleep 1
    sample :bd_haus, lpf: 110, amp: amp
    sleep 1
  end
end

live_loop :drums, sync: :main do
  amp = drums_amp[tick + offset]
  4.times do
    use_sample_defaults finish: 0.1
    play_rhythm_sample :elec_twip, 0.5, drum_rhythm, amp: amp
  end
end

live_loop :cymbals, sync: :main do
  amp = cymbal_amp[tick + offset]
  4.times do
    use_sample_defaults hpf: 100, finish: 0.15, amp: amp
    play_rhythm_sample :drum_cymbal_closed, 0.5, cymbals_rhythm, amp: amp
  end
end
```

### Bass

X: 1
M: 4/4
L: 1/4
E4|B4|d3B1|G2A2|\\
E4|B4|d3B1|A2G2|

Sonic Pi notes:

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

### Bells

X: 1
M: 4/4
L: 1/16
E2EG EGE2 E2GE E2D2|E2G2 EGE2 E2GE E2D2|

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

define :slide_timed_synth do |syn, notes, times, shift: 0|
  for i in 0..notes.length-1
    control syn, note: notes[i] + shift
    sleep times[i]
  end
end

define :play_timed_synth do |notes, times, shift: 0|
  for i in 0..notes.length-1
    play notes[i] + shift
    sleep times[i]
  end
end

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
