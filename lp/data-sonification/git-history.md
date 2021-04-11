# Git history sonification

This projects lets Git repositories play piano.

The idea is to produce a sound for each commit in the history of a local Git repository.

The code can be run for any Git repository. To give an impression of how it sounds like, here is an extract of the track produced by the history of [Sonic Pi](https://sonic-pi.net/), the software that is used to produce these tracks:

<iframe width="100%" height="165" scrolling="no" frameborder="no" allow="autoplay" src="https://thefuture.fm/track/914/git-history-to-audio-sonic-pi/embed"></iframe>

The extracted code for direct use in Sonic Pi can be found in the GitHub repository:
[code/DataSonification/GitHistory.rb](https://github.com/mlange-42/Sonic-LP/blob/main/code/DataSonification/GitHistory.rb).

**Contents**

[[_TOC_]]

## File structure

The code blocks of this document are arranged to a complete Sonic Pi program
by inserting them in the output file in this order:

```ruby
#- file:DataSonification/GitHistory.rb

```
