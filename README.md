# LED Pattern Engine

A pattern engine that drives four LEDs with 4-bit patterns. It consists of a clock-enable generator, a debouncer, an edge detector and the main pattern generator.

The design was built to meet the following requirements:

|Requirement|What I Did|Status|
|---|---|:-:|
|BTN2 cycles through 4 patterns: binary counter (LD0 = LSB), Gray counter, bouncing light, 8-state Johnson counter|Implemented all four patterns; each BTN2 press switches to the next one.|✅|
|SW1:SW0 select the step rate: 1 / 2 / 4 / 10 Hz; dividers computed from `G_CLK_FREQ_HZ`, 10 Hz exact|Wrote `clk_enable_gen`, which produces enable pulses at the selected rate.|✅|
|SW2 reverses the direction of every pattern; SW3 halves the brightness with 50 % PWM|Added direction reversal for all patterns and brightness halving with a 50 % PWM mask.|✅|
|BTN0 pauses/resumes, BTN1 advances one step while paused, BTN3 resets the current pattern to its first state|BTN0 toggles pause and resume. While paused, each BTN1 press advances exactly one step. BTN3 returns the pattern to its first state.|✅|
|Buttons pass through a ≥ 20 ms debouncer and a rising-edge detector|Wrote a debouncer with a configurable debounce time, and an edge detector that detects both rising and falling edges.|✅|

**Physical Test:**