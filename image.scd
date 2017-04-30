//Christopher Carney
//Music 452 Final Project
//Synth Soundscape from landscapes

t.start;
t.stop;
(
//read the file
//change the name of the .csv file to test other csv's in the directory
var path = thisProcess.nowExecutingPath.dirname +/+ "analysis_volcano.csv";
x = CSVFileReader.read(path);

//create [R, G, B] arrays for different quadrants
~global_freq = 440;
~q1 = [x[0][0].asFloat, x[0][1].asFloat, x[0][2].asFloat];
~q2 = [x[0][3].asFloat, x[0][4].asFloat, x[0][5].asFloat];
~q3 = [x[0][6].asFloat, x[0][7].asFloat, x[0][8].asFloat];
~q4 = [x[0][9].asFloat, x[0][10].asFloat, x[0][11].asFloat];
~q5 = [x[0][12].asFloat, x[0][13].asFloat, x[0][14].asFloat];

if ((~q1[2] > ~q1[0]),
	{
		~q1_blue = 1;
	},
	{
		~q1_blue = 0;
	}
);

if ((~q2[2] > ~q2[0]),
	{
		~q2_blue = 1;
	},
	{
		~q2_blue = 0;
	}
);

if ((~q3[2] > ~q3[0]),
	{
		~q3_blue = 1;
	},
	{
		~q3_blue = 0;
	}
);

if ((~q4[2] > ~q4[0]),
	{
		~q4_blue = 1;
	},
	{
		~q4_blue = 0;
	}
);

if ((~q5[2] > ~q5[0]),
	{
		~q5_blue = 1;
	},
	{
		~q5_blue = 0;
	}
);

//Synth for quadrant one
SynthDef.new("q1_lead", {
	arg freq=440, cutoff=~q1[0], bandwidth=~q1[2], gate=1;
	var sig1, sig2, out, pan, filt, level;

	level=SinOsc.kr(~q1[2]/100).range(0, ~q1[1]/400);

	sig1 = Select.ar(~q1_blue, [Pulse.ar(freq, 0.5, level, 0), SinOsc.ar(freq, 0.2, level, 0)]);
	sig2 = Select.ar(~q1_blue, [LFTri.ar(freq*(~q1[1]/125), 0.2, level, 1), Saw.ar(freq*(~q1[1]/125), level)]);

	filt=Resonz.ar(sig1+sig2, ~q1[0]+~q1[1]+~q1[2], ~q1[2]/255, 0.15);
	out=Pan2.ar(filt, SinOsc.kr(~q1[0]/255));

	Out.ar(0, out);
	Out.ar(1, out);
}).add;

//Synth for quadrant two
SynthDef.new("q2_whistle", {
	arg freq=440;
	var synth, out, att1, att2, filter;
	att1=(~q2[2] / 255);
	att2=(~q2[1] / 255);

	synth=[ Resonz.ar(PinkNoise.ar, LFNoise2.kr(2, freq/4, freq), 0.002),
		Resonz.ar(WhiteNoise.ar, LFNoise2.kr(2, freq/2, 2*freq), 0.002)
	];

	a=Select.ar(~q2_blue, synth);
	filter=[CombC.ar(a,SinOsc.kr(2).range(0.008, 0.012)),
		LPF.ar(a, 22000);
	];
	o=Select.ar(~q2_blue, filter);

	b=RLPF.ar(Saw.ar(~q4[0]*2), ~q4[2]*2, 1);
	v=Decay2.ar(b, att2, 6, 0.05);

	out=(o*10 + v);
	out=out*0.10;

	Out.ar(0, out);
	Out.ar(1, out);
}).add;

//Synth for quadrant three
SynthDef("q3_ring", {
	arg freq=440, gate=1;
	var noise, filt, out, env, syn1, syn2;

	env=Env.adsr((~q3[0]/510), (~q3[1]/125), (~q3[2]/255), (~q3[0]+~q3[2]/510));

	noise=[Ringz.ar(WhiteNoise.ar(0.01), SinOsc.kr(~q3[0]/125).exprange(freq-4, freq+4), 2),
		Resonz.ar(GrayNoise.ar(0.02), SinOsc.kr(~q3[0]/125).exprange((freq*2)-8, (freq*2)+8), 2)
	];

	syn1=Select.ar(~q3_blue, noise);
	syn2=Ringz.ar(Impulse.ar(0), freq*2, 10);

	out = (syn1*0.75);
	filt = RLPF.ar(out, freq*1.15, 0.75);

	Out.ar(0, 0.12*filt*EnvGen.ar(env, gate:gate, doneAction:2));
	Out.ar(1, 0.12*filt*EnvGen.ar(env, gate:gate, doneAction:2));
}).add;

//Synth for quadrant four
SynthDef.new("q4_random", {
	arg freq=440;
	var mod1, mod2, pan1, pan2, osc2, out;

	mod1=LFNoise1.kr(~q4[1]/125).range(freq/2, freq);
	mod2=LFNoise0.kr(~q4[0]/125).range(freq/4, freq*2);

	pan1 = LFNoise2.kr(~q4[1]/255).range(-1*(~q4[2]/255), ~q4[2]/255);
	pan2 = Saw.kr(~q4[0]/255).range(-1*(~q4[0]/255), ~q4[0]/255);

	o = SinOsc.ar(mod1, 0, 0.3) + SinOsc.ar(mod1, 0, 0.3);
	osc2 = SinOsc.ar(mod2, 0, LFTri.kr(0.4).range(~q4[0]/500, ~q4[1]/500));
	out = Pan2.ar(o, pan1) + Pan2.ar(osc2, pan2);

	Out.ar(0, out*0.05);
	Out.ar(1, out*0.05);
}).add;

//Synth for quadrant five
SynthDef.new("q5_klank", {
	arg freq=440;

	p=Select.ar(~q5_blue, [Impulse.ar(~q5[1]/100), Impulse.ar(~q5[2]/255)]);
	k=Klank.ar(`[[freq+(~q5[0]/3), freq+(~q5[1]/3), freq+(~q5[2]/3)],[~q5[0]/255, ~q5[1]/255, ~q5[2]/255],[(~q5[0]/255)*2, (~q5[1]/255)*2, (~q5[2]/255)*2]], p);
	o=Pan2.ar(k, Select.ar(~q5_blue, [SinOsc(~q5[1]/510).range(-1*~q5[2]/255, ~q5[2]/255), SinOsc(~q5[1]/510).range(-1*~q5[2]/255, ~q5[2]/255)]));
	Out.ar(0, k*0.10);
	Out.ar(1, k*0.10)
}).add;

//play the constructed soundscape
(
t=Task({
	var synth1, synth2, synth3a, synth3b, synth3c, synth4, synth5;
	var i = 0;

	synth1=Synth("q1_lead", [\freq, ~global_freq]);
	synth2=Synth("q2_whistle", [\freq, ~global_freq]);
	synth4=Synth("q4_random", [\freq, ~global_freq]);
	synth5=Synth("q5_klank", [\freq, ~global_freq]);

	inf.do({arg count;

		var freq = [392.0, 440.0, 493.88, 524.25, 587.33, 659.26, 739.99].choose; //g major
		var oct = 3;

		// G C D
		if ((count % 4) == 0,
			{
				z = case
				{i == 0} {
							try{
								synth3a.set(\gate, 0);
								synth3b.set(\gate, 0);
								synth3c.set(\gate, 0);
							} { |error| };

							synth3a=Synth("q3_ring", [\freq, 98*oct]);
							synth3b=Synth("q3_ring", [\freq, 123.47*oct]);
							synth3c=Synth("q3_ring", [\freq, 146.83*oct]);
							i = i + 1;
				}
				{i == 1} {
							synth3a.set(\gate, 0);
							synth3b.set(\gate, 0);
							synth3c.set(\gate, 0);

							synth3a=Synth("q3_ring", [\freq, 65.41*oct]);
							synth3b=Synth("q3_ring", [\freq, 82.41*oct]);
							synth3c=Synth("q3_ring", [\freq, 98.00*oct]);
							i = i + 1;
						}
				{i == 2} {
					synth3a.set(\gate, 0);
					synth3b.set(\gate, 0);
					synth3c.set(\gate, 0);

					synth3a=Synth("q3_ring", [\freq, 72.42*oct]);
					synth3b=Synth("q3_ring", [\freq, 92.50*oct]);
					synth3c=Synth("q3_ring", [\freq, 110*oct]);
					i = 0;
				};
			}
		);

		1.wait;
	})
})
)
)

t.start;
t.stop;

//Test for each synth individually, for sound levels, etc
e=Synth("q1_lead", [\freq, ~global_freq]);
r=Synth("q2_whistle", [\freq, ~global_freq]);
u=Synth("q3_ring", [\freq, ~global_freq]);
t=Synth("q4_random", [\freq, ~global_freq]);
y=Synth("q5_klank", [\freq, ~global_freq]);

s.meter;
File.getcwd;

