use_bpm 125
define :play_rhythm_sample do |samp, duration, rhythm, amp: 1|
  for i in 0..rhythm.length-1
    s = rhythm[i]
    if (s == "|") or (s == " ")
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
define :play_timed_synth do |notes, times, shift: 0|
  for i in 0..notes.length-1
    play notes[i] + shift
    sleep times[i]
  end
end
define :slide_timed_synth do |syn, notes, times, shift: 0|
  amp = (current_synth_defaults || {amp: 1})[:amp] || 1
  for i in 0..notes.length-1
    control syn, note: notes[i] + shift
    sleep times[i]
  end
end
define :str_scale do |str, min: 0, max: 1|
  str.chars.filter_map{|s|
    if (s == "|") or (s == " ")
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
    if (s == "|") or s == " "
      # Bar line, do nothing
    elsif s == "-"
      values[0]
    else
      values[Integer(s)]
    end
  }.ring
end
offset = 0

live_loop :main, delay: 0.01 do
  t = tick(:loop)
  puts t + offset
  sleep 4 * 4
end
##########################  0        8        16       24       32       40       48       56       64
bell_amp     =  str_scale("|33334343|----6655|----6666|----6688|XX668854|XXXX8876|8888XX76|X7X7X786|6666----|", max: 0.3 )
bell_shift   = str_select("|22111-11|----11--|11111111|11111111|1111----|1111----|----11--|1-1-1-1-|--------|", [0, -12, -24])
bell_echo    =  str_scale("|13375355|11111111|33333333|33333358|35353535|35353535|35355555|55555555|5688----|")
bell_melody  = str_select("|--------|-------1|-----1-1|-----1-1|-1-1-1-1|-1-1-1-1|-1-1-1-1|-------1|---1----|", [[0, 0], [0, 1]])

bd_amp       =  str_scale("|------11|XXXXXXX7|XXXXXXX7|--223456|XXXXXXX6|XXXXXXXX|XXXXXXXX|XXXX9988|--------|", max: 0.8)
drums_amp    =  str_scale("|--112222|33333333|33333333|11111112|55555555|55555555|55555555|55555555|--------|")

cymbal_amp   =  str_scale("|----2233|44444444|44444443|------22|44444444|44444444|44444444|33333333|--------|")

bass_amp     =  str_scale("|----1111|33333333|88888886|55555555|99999999|99999999|99999999|88667765|41------|", max: 0.7)
bass_cutoff  = str_select("|------11|------11|--------|------11|------11|------11|--11--11|--------|--------|", [92, 104])
bass_min_amp =  str_scale("|XXXXXXXX|99997777|33334477|XXXXXX77|22332244|22443377|22443377|88889999|XXXXXXXX|")
bass_shift   = str_select("|11112211|--------|--------|------12|--------|--------|----11--|--11--11|--------|", [12, 24, 36])
bass_melody  = str_select("|--------|------11|------22|--------|------11|--22--22|------22|--------|--------|", [0, 1, 2])
# bd_rhythm =    "x-x-x-x-"
drum_rhythm =    "--x---x-"
cymbals_rhythm = "-x-x-x-x"
bass_delay = 0.06
bass_notes = [
  [
    [[:e1, :b1, :d2, :b1, :g1, :a1],     [4 - bass_delay, 4, 3, 1, 2, 2]],
    [[:e1, :b1, :d2, :b1, :a1, :g1],     [4 - bass_delay, 4, 3, 1, 2, 2]]
  ],
  [
    [[:e1, :b1, :d2, :b1, :g1, :g2, :a1, :a2],     [4 - bass_delay, 4, 3, 1, 1, 1, 1, 1]],
    [[:e1, :b1, :d2, :b1, :a1, :a2, :g1, :g2],     [4 - bass_delay, 4, 3, 1, 1, 1, 1, 1]]
  ],
  [
    [[:e1, :e2, :b1, :b2, :d2, :b1, :g1, :g2, :a1, :a2],     [3 - bass_delay, 1, 3, 1, 3, 1, 1, 1, 1, 1]],
    [[:e1, :e2, :b1, :b2, :d2, :b1, :a1, :a2, :g1, :g2],     [3 - bass_delay, 1, 3, 1, 3, 1, 1, 1, 1, 1]]
  ]
]
bell_notes = [
  [
    [[:e5,  :e5,  :g5,  :e5,  :g5, :e5], [0.5, 0.25, 0.25, 0.25, 0.25, 0.5]],
    [[:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5]],
    [[:e5,  :g5,  :e5,  :g5,  :e5],      [0.5, 0.5, 0.25, 0.25, 0.5]],
    [[:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5]]
  ],
  [
    [[:e5,  :e5,  :g5,  :e5,  :g5, :e5], [0.5, 0.25, 0.25, 0.25, 0.25, 0.5]],
    [[:e5,  :g5,  :e5,  :e5,  :d5],      [0.5, 0.25, 0.25,  0.5,  0.5]],
    [[:e5,  :g5,  :e5,  :g5,  :e5],      [0.5, 0.5, 0.25, 0.25, 0.5]],
    [[:e5, :g5],      [1, 1]]
  ]
]
live_loop :bd, sync: :main do
  amp = bd_amp[tick + offset]
  8.times do
    sample :bd_haus, lpf: 90, hpf: 45, amp: amp
    sleep 1
    sample :bd_haus, lpf: 110, hpf: 45, amp: amp
    sleep 1
  end
end

live_loop :drums, sync: :main do
  amp = drums_amp[tick + offset]
  4.times do
    use_sample_defaults finish: 0.15
    play_rhythm_sample :elec_twip, 0.5, drum_rhythm, amp: amp
  end
end
live_loop :cymbal, sync: :main do
  amp = cymbal_amp[tick + offset]
  4.times do
    use_sample_defaults hpf: 100, finish: 0.15, amp: amp
    play_rhythm_sample :drum_cymbal_closed, 0.5, cymbals_rhythm, amp: amp
  end
end
live_loop :bass, sync: :main do
  t = tick * 2 + offset
  amp = bass_amp[t]
  amp_end = bass_amp[t + 1]

  amp_min = bass_min_amp[t]
  shift = bass_shift[t]
  cutoff = bass_cutoff[t]
  melody = bass_melody[t]

  with_fx :slicer, phase: 0.5, smooth_down: 0.05, amp_min: amp_min do |sn|
    with_synth :dsaw do
      use_synth_defaults amp: amp, detune: 12, cutoff_min: 45 #, attack: 0.02

      m = bass_notes[melody][0]
      syn = play m[0][0] + shift, cutoff: 80, res: 0.75, sustain: 16, release: 0
      at do
        sleep m[1][0]
        slide_timed_synth syn, m[0][1..], m[1][1..], shift: shift
      end

      sleep 0.25
      control syn, cutoff: 92, cutoff_slide: 16, amp: amp_end, amp_slide: 31.75
      sleep 15.75


      m = bass_notes[melody][1]
      syn = play m[0][0] + shift, cutoff: 80, res: 0.75, sustain: 16, release: 0
      at do
        sleep m[1][0]
        slide_timed_synth syn, m[0][1..], m[1][1..], shift: shift
      end

      sleep 0.25
      control syn, cutoff: 80, cutoff_slide: 0
      control syn, cutoff: cutoff, cutoff_slide: 16
      sleep 7.75

      control sn, phase: 0.25
      sleep 6
      control sn, phase: 0.333
      sleep 2
    end
  end
end
live_loop :bell, sync: :main do
  amp = bell_amp[tick + offset]

  if amp > 0
    shift = bell_shift[look + offset]
    echo = bell_echo[look + offset]
    melody = bell_melody[look + offset]
    with_fx :echo, phase: 0.25, decay: 0.5, mix: echo, amp: 1 do |fx|
      with_synth :pretty_bell do
        use_synth_defaults amp: amp, release: 0.2
        for idx in melody
          for m in bell_notes[idx]
            play_timed_synth m[0], m[1], shift: shift
          end
        end
      end
    end
  else
    sleep 16
  end
end
